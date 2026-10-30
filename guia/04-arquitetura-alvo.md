# 4. Arquitetura-alvo

## A árvore

```
CLAUDE.md                        ≤ 15 linhas    @AGENTS.md + extras só do Claude
AGENTS.md                        ≤ 150 linhas   roteador cross-tool em texto puro:
                                                 · identidade do projeto (3–5 linhas)
                                                 · INEGOCIÁVEIS (≤ ~80 linhas)
                                                 · créditos/licença (se houver obrigação)
                                                 · "como achar o resto" → INDEX.md, status.md
                                                 · blocos gerados por ferramentas, intactos
docs/context/
  status.md                      estado vivo e DATADO (único lugar de dado que envelhece)
  INDEX.md                       ≤ 100 linhas   tarefa → arquivo de domínio → rule/skill
  catalogo-specs.md              lista de SPECs/PRDs/guias (consulta eventual)
  <dominio>.md                   1 por domínio, ≤ 120 linhas / ~6 KB cada
.claude/rules/<dominio>.md       ≤ 25 linhas, SEMPRE com paths:
.claude/skills/<nome>/SKILL.md   ≤ 100 linhas (+ arquivos de referência ao lado)
.claude/settings.json            permissions.deny para o que nunca pode depender do modelo
.cursor/rules/<dominio>.mdc      (opcional) ≤ 25 linhas, globs:, alwaysApply: false
```

## Orçamento

| Peça                              | Meta                    | Por quê                                                      |
| --------------------------------- | ----------------------- | ------------------------------------------------------------ |
| Conjunto sempre carregado do repo | ≤ ~165 linhas, ≤ ~10 KB | ~2,5 mil tokens: cabe com folga ao lado do prompt de sistema |
| Inegociáveis                      | ≤ ~80 linhas            | quanto menor, maior a aderência                              |
| Rule                              | ≤ 25 linhas             | é um lembrete + ponteiro, não um manual                      |
| Arquivo de domínio                | ≤ 120 linhas / ~6 KB    | lido inteiro sem dor quando necessário                       |
| Skill (`SKILL.md`)                | ≤ 100 linhas            | o corpo fica na conversa até o fim depois de invocado        |
| Descrição de skill                | 1–2 frases com gatilhos | soma no contexto fixo × número de skills                     |
| Redução esperada                  | ≥ 65% em bytes          | típica em projetos com índice de documentação no root        |

**Métrica principal: bytes/tokens.** Linhas enganam: uma linha de tabela Markdown com links pode ter 500 B.

## Taxonomia — classifique cada parágrafo do arquivo atual

| Classe         | Definição                                                       | Destino                                                                 |
| -------------- | --------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `INEGOCIÁVEL`  | esquecer causa dano em qualquer tarefa                          | fica no `AGENTS.md`                                                     |
| `ROTEÁVEL`     | só importa ao mexer em certa parte do código                    | `docs/context/<dominio>.md` + rule                                      |
| `PROCEDIMENTO` | sequência de passos repetível                                   | skill                                                                   |
| `CATÁLOGO`     | lista para consulta (SPECs, guias, links)                       | `catalogo-specs.md`                                                     |
| `ENVELHECE`    | número/estado que muda (última migração, nº de chaves, versões) | `status.md` com data, ou vira comando ("rode `ls supabase/migrations`") |
| `DUPLICADO`    | já existe em README/docs                                        | vira ponteiro                                                           |
| `INCORRETO`    | o disco desmente                                                | corrigido no destino, nunca copiado                                     |
| `MECÂNICO`     | proibição que uma permissão impõe melhor que prosa              | `permissions.deny` + 1 linha no `AGENTS.md`                             |

## Onde cada coisa mora — tabela de decisão

| Exemplo real                                       | Classe                 | Mora em                                                                          |
| -------------------------------------------------- | ---------------------- | -------------------------------------------------------------------------------- |
| "Commits e push são manuais; entregue o comando"   | INEGOCIÁVEL + MECÂNICO | `AGENTS.md` (1 linha) + `deny: Bash(git commit *)`                               |
| "`admin.ts` usa service_role; nunca no browser"    | INEGOCIÁVEL            | `AGENTS.md`                                                                      |
| "Função nova em `public`: REVOKE de PUBLIC e anon" | ROTEÁVEL               | rule `supabase` (decisão curta) + `supabase-rls.md` (porquê)                     |
| "Toda mudança em `/api/v1` atualiza 3 arquivos"    | ROTEÁVEL               | rule `api-publica`                                                               |
| "Como criar uma migração do zero"                  | PROCEDIMENTO           | skill `nova-migracao`                                                            |
| Tabela com 70 SPECs                                | CATÁLOGO               | `catalogo-specs.md`                                                              |
| "Migrações 001 → 054"                              | ENVELHECE + INCORRETO  | some; `status.md` diz "última: 089 (2026-10-30)" e a rule diz "confira com `ls`" |
| Tabela "Stack" com versões                         | ENVELHECE              | `status.md` ou "fonte: `package.json`"                                           |
| "Armadilhas conhecidas" (sintoma → causa)          | ROTEÁVEL               | distribua pelos domínios; o `INDEX.md` aponta                                    |
| "Não leia `.env`"                                  | INEGOCIÁVEL + MECÂNICO | `AGENTS.md` (1 linha) + `deny: Read(./.env*)`                                    |

## Regras de ouro

1. **Inegociável nunca mora só em rule com `paths:`** — arquivo novo não dispara rule.
2. **Toda rule tem `paths:`.** Rule sem `paths:` é contexto fixo disfarçado.
3. **Nenhum `@` fora de crases** em rule, `INDEX.md` ou domínio. Referência é caminho em texto.
4. **Rule não copia conteúdo longo:** decisões curtas + "detalhes: leia `docs/context/x.md`".
5. **Um fato, um lugar.** Se aparece em dois, um deles vira ponteiro.
6. **Fato mutável tem data** e mora no `status.md` — ou vira um comando que o agente roda.
7. **Glob só de caminho que existe.** Cada padrão casa ≥ 1 arquivo hoje.
8. **Cross-tool em texto puro:** o `AGENTS.md` funciona sem `@` porque o Cursor/Codex não expandem.
9. **O que não pode depender do modelo vira permissão**, e a prosa encolhe para uma linha.

## Por que rules com `paths:` e não `CLAUDE.md` por pasta

`CLAUDE.md` em subpasta também carrega sob demanda, mas só por **diretório**. Uma rule escolhe arquivos por padrão fino (`src/app/api/**/cron/route.ts`, `public/openapi*.json`) que atravessam pastas, fica num lugar só (fácil de medir e espelhar no Cursor) e não se espalha pela árvore. Use `CLAUDE.md` aninhado só em monorepo com times diferentes por pasta.

## E o Cursor?

O Cursor lê `AGENTS.md` (os inegociáveis chegam) e `.cursor/rules/*.mdc`. Se o time usa Cursor, espelhe as rules em `.mdc` com `globs:` e `alwaysApply: false`, com **o mesmo corpo**. Para evitar divergência, gere um a partir do outro ou compare os corpos sem o frontmatter (o [checar-higiene.sh](../scripts/checar-higiene.sh) faz isso). Se ninguém usa Cursor, não crie `.cursor/` — é custo de manutenção sem ganho.

Próximo: [5. Armadilhas](./05-armadilhas.md).
