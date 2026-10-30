# Passo 1 — Medir

> **Objetivo:** saber quanto o projeto paga hoje em contexto fixo, e garantir que você consegue provar depois que nada além do previsto mudou.
> **Quem:** você. **Tempo:** 15 min. **Muda o repo:** não.

## 1.1 Rode o medidor

Da raiz do projeto:

```bash
bash ~/ferramentas/contexto/medir-contexto.sh | tee ~/contexto-antes.txt
```

Ele lista cada arquivo que entra automaticamente (`CLAUDE.md`, `AGENTS.md`, imports `@` transitivos, rules sem `paths:`, `~/.claude/CLAUDE.md`, descrições de skills), com linhas, bytes e tokens estimados (÷3,5 e ÷4), e o raio-X por seção `##` do `AGENTS.md`.

## 1.2 Pegue o número real

Abra uma sessão **nova** do Claude Code na raiz e rode `/context`. Anote:

- total usado na abertura;
- quanto é "memory files" (instruções);
- quanto é MCP e skills.

> Se MCP pesa mais que o `AGENTS.md`, comece por `/mcp` (desligue o que não usa no projeto) — é o ganho mais barato.

## 1.3 Descubra o que o git enxerga

```bash
for f in CLAUDE.md AGENTS.md .claude/rules/x.md .claude/skills/x/SKILL.md \
         docs/context/x.md .cursor/rules/x.mdc; do
  printf '%-32s ' "$f"; git check-ignore -v --no-index "$f" || echo "(rastreável)"
done
```

Se aparecer `.gitignore:N:*.md` ou `/docs`, o git não vai ajudar você a provar nada. Grave um manifesto:

```bash
SCR="$HOME/contexto-$(date +%Y%m%d)"; mkdir -p "$SCR"     # Git Bash: $(cygpath -u "$TEMP")/contexto
git status --short > "$SCR/status-antes.txt"
find docs .claude -type f ! -path 'docs/deploy/*' ! -name 'settings.local.json' -print0 2>/dev/null \
  | sort -z | xargs -0 sha256sum > "$SCR/docs-antes.sha"
sha256sum CLAUDE.md AGENTS.md README.md .gitignore 2>/dev/null > "$SCR/raiz-antes.sha"
```

(Ajuste as exclusões para não ler pastas com segredo.)

## 1.4 Teste o validador

Se o projeto tem Prettier/markdownlint, teste num arquivo **sabidamente errado** antes de confiar:

```bash
npx prettier --check AGENTS.md                                   # pode dizer "ok" porque está ignorado
npx prettier --check --ignore-path .prettierignore AGENTS.md     # o resultado verdadeiro
```

Anote o baseline de falhas (`npx prettier --list-different .`).

## Pronto quando

- [ ] `~/contexto-antes.txt` salvo
- [ ] número do `/context` anotado
- [ ] você sabe se o git enxerga `CLAUDE.md`, `AGENTS.md`, `.claude/`, `docs/`
- [ ] manifestos gravados fora do repo
- [ ] validador testado

Próximo: [Passo 2 — Classificar](./passo-2-classificar.md).
