#!/usr/bin/env bash
# checar-higiene.sh — confere as regras de ouro da arquitetura de contexto.
#
# Uso:  bash checar-higiene.sh [pasta-do-projeto]
#       CONTEXT_DIR=docs/context bash checar-higiene.sh     (padrão: docs/context)
# Sai com código 1 se houver ERRO; AVISO não falha.
#
# Confere:
#  - toda .claude/rules/**/*.md tem frontmatter com paths:
#  - todo glob de paths: casa >= 1 arquivo hoje (pelo disco, inclui ignorados pelo git)
#  - nenhum @ fora de crases em rules, INDEX.md e arquivos de domínio
#  - links relativos resolvem (AGENTS.md, CLAUDE.md, docs de contexto, rules)
#  - orçamentos de tamanho
#  - corpo igual entre .claude/rules/x.md e .cursor/rules/x.mdc (se existirem)

set -u
ROOT="${1:-.}"
cd "$ROOT" || { echo "pasta não encontrada: $ROOT" >&2; exit 2; }
CTX="${CONTEXT_DIR:-docs/context}"
ERR=0; WARN=0
err()  { echo "ERRO   $*"; ERR=$((ERR+1)); }
warn() { echo "AVISO  $*"; WARN=$((WARN+1)); }
ok()   { echo "ok     $*"; }

shopt -s globstar nullglob extglob 2>/dev/null || {
  echo "este script precisa de bash >= 4 (globstar). No macOS: brew install bash" >&2; exit 2; }

frontmatter() { awk 'NR==1 && $0!="---" {exit} NR==1 {next} $0=="---" {exit} {print}' "$1"; }
body()        { awk 'NR==1 && $0=="---" {fm=1; next} fm && $0=="---" {fm=0; next} !fm {print}' "$1"; }

# globs de paths: (lista YAML ou string separada por vírgula)
paths_of() {
  frontmatter "$1" | awk '
    /^paths[[:space:]]*:/ {
      inlist = 1; v = $0; sub(/^paths[[:space:]]*:[[:space:]]*/, "", v)
      if (v != "") { n = split(v, a, ","); for (i = 1; i <= n; i++) print a[i]; inlist = 0 }
      next }
    inlist && /^[[:space:]]*-/ { v = $0; sub(/^[[:space:]]*-[[:space:]]*/, "", v); print v; next }
    inlist && /^[^[:space:]]/ { inlist = 0 }' |
  sed -E "s/^[[:space:]]*['\"]?//; s/['\"]?[[:space:]]*\$//" | grep -v '^$'
}

glob_count() { # padrão relativo à raiz; aceita {a,b}, **, \[ \]
  local p="$1" files=()
  eval "files=( $(printf '%s' "$p" | sed -E 's/([ ()|&;<>$`"'"'"'])/\\\1/g') )" 2>/dev/null
  echo "${#files[@]}"
}

at_outside_backticks() { # imprime linhas com @ solto
  awk '
    /^[[:space:]]*```/ { fence = !fence; next }
    fence { next }
    { line = $0; gsub(/`[^`]*`/, "", line)
      if (line ~ /(^|[[:space:]])@[A-Za-z0-9._~\/-]/) printf "%d: %s\n", NR, $0 }' "$1"
}

check_links() { # arquivo
  local f="$1" dir l target
  dir="$(dirname "$f")"
  while IFS= read -r l; do
    target="${l%%#*}"; [ -z "$target" ] && continue
    case "$target" in http*|mailto:*|/*) continue ;; esac
    [ -e "$dir/$target" ] || err "link quebrado em $f → $l"
  done < <(grep -oE '\]\([^)[:space:]]+\)' "$f" 2>/dev/null | sed -E 's/^\]\(//; s/\)$//')
}

size_check() { # arquivo max_linhas [max_bytes]
  local f="$1" ml="$2" mb="${3:-0}" l b
  [ -f "$f" ] || return
  l=$(wc -l < "$f" | tr -d ' '); b=$(wc -c < "$f" | tr -d ' ')
  if [ "$l" -gt "$ml" ] || { [ "$mb" -gt 0 ] && [ "$b" -gt "$mb" ]; }; then
    warn "$f: $l linhas / $b B (orçamento: $ml L${mb:+ / $mb B})"
  fi
}

echo "== rules (.claude/rules) =="
RULES=( .claude/rules/**/*.md )
[ "${#RULES[@]}" -eq 0 ] && echo "(nenhuma rule)"
for r in "${RULES[@]}"; do
  if ! frontmatter "$r" | grep -qE '^paths[[:space:]]*:'; then
    err "$r: sem paths: (ou frontmatter inválido) → carrega em TODA sessão"; continue
  fi
  before=$ERR
  if frontmatter "$r" | grep -qE '"[^"]*\\\['; then
    err "$r: \\[ dentro de aspas duplas é escape YAML inválido → use aspas simples"
  fi
  while IFS= read -r p; do
    n=$(glob_count "$p")
    [ "$n" -eq 0 ] && err "$r: glob não casa nenhum arquivo: $p"
  done < <(paths_of "$r")
  size_check "$r" 25
  while IFS= read -r hit; do err "$r: @ fora de crases (vira import?) → $hit"; done < <(at_outside_backticks "$r")
  check_links "$r"
  [ "$ERR" -eq "$before" ] && ok "$r"
done

echo; echo "== contexto ($CTX) =="
if [ -d "$CTX" ]; then
  for f in "$CTX"/*.md; do
    while IFS= read -r hit; do err "$f: @ fora de crases → $hit"; done < <(at_outside_backticks "$f")
    check_links "$f"
    case "$(basename "$f")" in
      INDEX.md) size_check "$f" 100 ;;
      status.md|catalogo*.md) ;;
      *) size_check "$f" 120 6144 ;;
    esac
  done
  ok "$CTX verificado"
else
  warn "$CTX não existe (defina CONTEXT_DIR)"
fi

echo; echo "== arquivos raiz =="
size_check CLAUDE.md 15
size_check AGENTS.md 150
for f in CLAUDE.md AGENTS.md; do [ -f "$f" ] && check_links "$f"; done
if [ -f AGENTS.md ] && grep -qE '^[^`]*(^|[[:space:]])@[A-Za-z]' AGENTS.md; then
  warn "AGENTS.md tem @ fora de crases — Cursor/Codex não expandem; o Claude expande (custo fixo)"
fi

echo; echo "== skills =="
for s in .claude/skills/*/SKILL.md; do
  frontmatter "$s" | grep -qE '^description[[:space:]]*:' || warn "$s: sem description (o Claude usa a 1ª linha do corpo)"
  size_check "$s" 100
done

echo; echo "== paridade Claude ↔ Cursor =="
for m in .cursor/rules/*.mdc; do
  c=".claude/rules/$(basename "${m%.mdc}").md"
  if [ -f "$c" ]; then
    diff -q <(body "$c" | sed '/^<!--/,/-->/d') <(body "$m") >/dev/null || err "corpo diverge: $c × $m"
  else
    warn "$m sem par em .claude/rules/"
  fi
  grep -qiE '^alwaysApply:[[:space:]]*true' "$m" && warn "$m: alwaysApply: true (sempre carregado no Cursor)"
done

echo; echo "resultado: $ERR erro(s), $WARN aviso(s)"
[ "$ERR" -eq 0 ]
