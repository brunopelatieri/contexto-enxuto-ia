#!/usr/bin/env bash
# medir-contexto.sh — mede o conjunto de instruções que o Claude Code carrega
# sozinho ao abrir uma sessão na pasta atual.
#
# Uso:   bash medir-contexto.sh [pasta-do-projeto]      (padrão: pasta atual)
# Saída: tabela em texto; redirecione com `| tee contexto-antes.txt`.
#
# Mede: CLAUDE.md, .claude/CLAUDE.md, CLAUDE.local.md (ou AGENTS.md quando não
# há CLAUDE.md), imports @ transitivos (até 4 saltos, ignorando @ em crases e
# blocos de código), .claude/rules sem paths:, descrições de skills,
# .cursor/rules com alwaysApply: true, e — à parte — ~/.claude/CLAUDE.md e
# ~/.claude/rules. Não mede MCP nem prompt de sistema: use /context para isso.
#
# Tokens são ESTIMATIVA (bytes/3,5 e bytes/4). Bash puro + awk; roda no Git Bash.

set -u
export LC_ALL=C   # awk length() em bytes, não em caracteres
ROOT="${1:-.}"
cd "$ROOT" || { echo "pasta não encontrada: $ROOT" >&2; exit 2; }
HOME_CLAUDE="${HOME}/.claude"

declare -a FILES=() ORIGIN=()
declare -A SEEN=()

add_file() { # caminho origem
  local f="$1" o="$2" key
  [ -f "$f" ] || return 1
  key="$(cd "$(dirname "$f")" && pwd -P)/$(basename "$f")"
  [ -n "${SEEN[$key]:-}" ] && return 1
  SEEN[$key]=1; FILES+=("$f"); ORIGIN+=("$o"); return 0
}

# Imports @ fora de crases e de blocos ``` ; um por linha.
list_imports() {
  awk '
    /^[[:space:]]*```/ { fence = !fence; next }
    fence { next }
    {
      line = $0
      gsub(/`[^`]*`/, "", line)                  # remove code spans
      while (match(line, /(^|[[:space:]])@[^[:space:]]+/)) {
        tok = substr(line, RSTART, RLENGTH); sub(/^[[:space:]]*@/, "", tok)
        sub(/[),.;:]+$/, "", tok)
        if (tok != "") print tok
        line = substr(line, RSTART + RLENGTH)
      }
    }' "$1"
}

expand_imports() { # arquivo profundidade origem
  local f="$1" depth="$2" o="$3" dir imp target
  [ "$depth" -ge 4 ] && return
  dir="$(dirname "$f")"
  while IFS= read -r imp; do
    case "$imp" in
      "~/"*) target="${HOME}/${imp#~/}" ;;
      /*)    target="$imp" ;;
      *)     target="$dir/$imp" ;;
    esac
    if add_file "$target" "import@$((depth+1)) ← $f"; then
      expand_imports "$target" $((depth+1)) "$o"
    elif [ ! -f "$target" ]; then
      echo "  ⚠ import não encontrado: @$imp (em $f)" >&2
    fi
  done < <(list_imports "$f")
}

has_paths() { # 0 se o frontmatter tem paths:
  awk 'NR==1 && $0!="---" {exit 1} NR==1 {next} $0=="---" {exit found?0:1} /^paths[[:space:]]*:/ {found=1}
       END {if (NR<2) exit 1}' "$1"
}

bytes()  { wc -c < "$1" | tr -d ' '; }
lines()  { wc -l < "$1" | tr -d ' '; }
# bytes sem comentários HTML em bloco (o Claude Code remove em CLAUDE.md e imports)
bytes_sem_html() {
  awk '
    /^[[:space:]]*```/ { fence = !fence }
    !fence && /^[[:space:]]*<!--/ { inc = 1 }
    !inc { n += length($0) + 1 }
    inc && /-->[[:space:]]*$/ { inc = 0 }
    END { print n + 0 }' "$1" | LC_ALL=C awk '{print $1}'
}

# ---------- 1. Instruções do projeto ----------
HAS_CLAUDE=0
for f in CLAUDE.md .claude/CLAUDE.md CLAUDE.local.md; do
  if add_file "$f" "projeto"; then HAS_CLAUDE=1; expand_imports "$f" 0 "$f"; fi
done
if [ "$HAS_CLAUDE" -eq 0 ] && [ -f AGENTS.md ]; then
  add_file AGENTS.md "AGENTS.md nativo (sem CLAUDE.md)"; expand_imports AGENTS.md 0 AGENTS.md
fi

# ---------- 2. Rules sem paths ----------
NRULES_ON_DEMAND=0
if [ -d .claude/rules ]; then
  while IFS= read -r -d '' r; do
    if has_paths "$r"; then NRULES_ON_DEMAND=$((NRULES_ON_DEMAND+1))
    else add_file "$r" "rule SEM paths: (sempre)"; fi
  done < <(find .claude/rules -name '*.md' -type f -print0 2>/dev/null | sort -z)
fi

# ---------- 3. Cursor alwaysApply ----------
if [ -d .cursor/rules ]; then
  while IFS= read -r -d '' r; do
    grep -qiE '^alwaysApply:[[:space:]]*true' "$r" && add_file "$r" "cursor alwaysApply: true (só Cursor)"
  done < <(find .cursor/rules -name '*.mdc' -type f -print0 2>/dev/null)
fi

# ---------- relatório ----------
printf '\n== CONJUNTO SEMPRE CARREGADO DO PROJETO (%s) ==\n' "$(pwd)"
printf '%-50s %6s %8s %8s  %s\n' "arquivo" "linhas" "bytes" "s/ html" "origem"
TL=0; TB=0; TBH=0
for i in "${!FILES[@]}"; do
  f="${FILES[$i]}"; l=$(lines "$f"); b=$(bytes "$f"); bh=$(bytes_sem_html "$f")
  case "${ORIGIN[$i]}" in cursor*) ;; *) TL=$((TL+l)); TB=$((TB+b)); TBH=$((TBH+bh)) ;; esac
  printf '%-50s %6s %8s %8s  %s\n' "$f" "$l" "$b" "$bh" "${ORIGIN[$i]}"
done
printf '%-50s %6s %8s %8s\n' "TOTAL (Claude Code)" "$TL" "$TB" "$TBH"
awk -v b="$TBH" 'BEGIN { printf "tokens estimados (sem comentários HTML): %d a %d  (bytes/4 .. bytes/3,5)\n", b/4, b/3.5 }'
printf 'rules com paths: (sob demanda, não somadas): %s\n' "$NRULES_ON_DEMAND"

# ---------- 4. Skills ----------
skill_desc_bytes() { # soma description + when_to_use, truncado em 1536
  awk 'NR==1 && $0!="---" {exit} NR==1 {next} $0=="---" {exit}
       /^(description|when_to_use)[[:space:]]*:/ { sub(/^[^:]*:[[:space:]]*/, ""); s = s $0 " " }
       END { n = length(s); if (n > 1536) n = 1536; print n + 0 }' "$1"
}
report_skills() { # pasta rótulo
  local dir="$1" label="$2" n=0 t=0 s b
  [ -d "$dir" ] || return
  while IFS= read -r -d '' s; do
    b=$(skill_desc_bytes "$s"); n=$((n+1)); t=$((t+b))
    printf '  %-48s %6s B de descrição  (%s linhas no corpo)\n' "$s" "$b" "$(lines "$s")"
  done < <(find "$dir" -mindepth 2 -maxdepth 2 -name SKILL.md -print0 2>/dev/null | sort -z)
  [ "$n" -gt 0 ] && printf '  %s: %d skills, %d B de descrições sempre no contexto\n' "$label" "$n" "$t"
}
printf '\n== SKILLS (descrição fica sempre no contexto; corpo só ao invocar) ==\n'
report_skills .claude/skills "projeto"
report_skills "$HOME_CLAUDE/skills" "usuário"

# ---------- 5. Fora do projeto ----------
printf '\n== FORA DO PROJETO (também carregado; registre, não otimize aqui) ==\n'
[ -f "$HOME_CLAUDE/CLAUDE.md" ] && printf '  %-48s %6s L %8s B\n' "~/.claude/CLAUDE.md" "$(lines "$HOME_CLAUDE/CLAUDE.md")" "$(bytes "$HOME_CLAUDE/CLAUDE.md")"
if [ -d "$HOME_CLAUDE/rules" ]; then
  while IFS= read -r -d '' r; do
    has_paths "$r" || printf '  %-48s %6s L %8s B  (sem paths:)\n' "${r/#$HOME/~}" "$(lines "$r")" "$(bytes "$r")"
  done < <(find "$HOME_CLAUDE/rules" -name '*.md' -print0 2>/dev/null)
fi
printf '  (memória automática MEMORY.md: até 200 linhas/25 KB — veja em /memory)\n'

# ---------- 6. Aninhados ----------
printf '\n== CLAUDE.md / AGENTS.md EM SUBPASTAS (carregam sob demanda) ==\n'
find . \( -name node_modules -o -name .git -o -name .next -o -name dist -o -name build -o -path ./.claude/worktrees \) -prune \
  -o -type f \( -name CLAUDE.md -o -name CLAUDE.local.md -o -name AGENTS.md \) -print 2>/dev/null \
  | grep -vE '^\./(CLAUDE|CLAUDE\.local|AGENTS)\.md$|^\./\.claude/CLAUDE\.md$' | sed 's/^/  /' || true

# ---------- 7. Raio-X por seção do arquivo raiz ----------
MAIN=""
for f in AGENTS.md CLAUDE.md; do [ -f "$f" ] && { MAIN="$f"; break; }; done
if [ -n "$MAIN" ]; then
  printf '\n== RAIO-X DE %s POR SEÇÃO ## ==\n' "$MAIN"
  awk -v total="$(bytes "$MAIN")" '
    function out() { if (name != "") printf "  %5d L %7d B %5.1f%%  %s\n", n, b, 100*b/total, name }
    /^## / { out(); name = $0; n = 0; b = 0 }
    NR == 1 && !/^## / { name = "(cabeçalho)" }
    { n++; b += length($0) + 1 }
    END { out() }' "$MAIN"
  printf '\n== 10 LINHAS MAIS LONGAS DE %s (bytes) ==\n' "$MAIN"
  awk '{ printf "%6d B  L%-4d %s\n", length($0), NR, substr($0, 1, 70) }' "$MAIN" | sort -rn | head -10
fi
printf '\nNúmero real: abra uma sessão NOVA e rode /context.\n'
