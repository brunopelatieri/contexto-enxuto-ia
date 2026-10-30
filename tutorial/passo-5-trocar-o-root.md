# Passo 5 — Trocar o root

> **Objetivo:** transformar o `AGENTS.md` em roteador. É a **única** fase que remove conteúdo.
> **Quem:** o agente. **Modelo:** o mais forte. **Sessão:** nova, com o backup da F0 conferido.

## 5.1 Pré-condições

- [ ] Matriz de rastreabilidade 100% (F2)
- [ ] Todas as rules e skills criadas e testadas (F3/F4)
- [ ] Backup do `CLAUDE.md`/`AGENTS.md` **fora do repo**, com `sha256sum` anotado

## 5.2 O novo `AGENTS.md`

Use [templates/AGENTS.template.md](../templates/AGENTS.template.md). Estrutura:

```markdown
# {{PROJETO}} — {{UMA_LINHA}}

{{2–3 linhas: o que é, stack, quem mantém}}

## Inegociáveis

1. … (≤ ~80 linhas no total, cada item curto e verificável)

## Como achar o resto

- Roteamento por tarefa: `docs/context/INDEX.md`
- Estado atual (versões, última migração, projetos): `docs/context/status.md`
- Catálogo de SPECs/PRDs: `docs/context/catalogo-specs.md`

## Créditos

{{texto obrigatório, se houver}}

{{blocos gerados por ferramentas, byte a byte}}
```

## 5.3 O novo `CLAUDE.md`

```markdown
# {{PROJETO}}

{{1 linha + créditos curtos se exigido}}

@AGENTS.md
```

Mais nada, a menos que haja instrução **só do Claude** (ex.: "use a skill X para Y").

## 5.4 Verificações imediatas (mesma sessão)

```bash
wc -l -c CLAUDE.md AGENTS.md                 # dentro do orçamento?
# bloco gerado intacto:
# (no Git Bash: SCR="$(cygpath -u "$TEMP")/contexto" — nunca /tmp nem C:\ cru)
sed -n '/BEGIN:nextjs-agent-rules/,/END:nextjs-agent-rules/p' AGENTS.md > "$SCR/bloco-novo.txt"
sed -n '/BEGIN:nextjs-agent-rules/,/END:nextjs-agent-rules/p' "$SCR/backup/AGENTS.md" > "$SCR/bloco-velho.txt"
diff "$SCR/bloco-velho.txt" "$SCR/bloco-novo.txt" && echo "bloco idêntico"
```

## 5.5 Rollback

Se qualquer teste do passo 6 falhar de forma grave: restaure os dois arquivos do backup e abra sessão nova. Se o git não rastreia esses arquivos, **o backup é o único rollback**.

Próximo: [Passo 6 — Validar](./passo-6-validar.md).
