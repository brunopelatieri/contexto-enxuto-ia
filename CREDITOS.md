# Créditos e fontes

## Inspiração

- **ECC — Everything Claude Code**, de [Affaan Mustafa](https://github.com/affaan-m) — <https://github.com/affaan-m/ECC> (licença MIT). Lema: "_Optimize the context window. Persist everything else._" Daqui vêm as ideias de rules segmentadas por stack, skills carregadas sob demanda como superfície principal de fluxo de trabalho, e a separação entre regra curta e conhecimento longo. Este repositório **não** copia arquivos do ECC; veja [guia/03-o-padrao-ecc.md](./guia/03-o-padrao-ecc.md) para o que foi adotado e o que foi deixado de fora.

## Documentação oficial consultada (2026-10-30)

Todo comportamento do Claude Code descrito em [guia/02-mecanismos-do-claude-code.md](./guia/02-mecanismos-do-claude-code.md) foi conferido nestas páginas. Comportamento de ferramenta muda com as versões — reconfira antes de confiar num detalhe fino.

| Assunto                                                        | Página                                        |
| -------------------------------------------------------------- | --------------------------------------------- |
| `CLAUDE.md`, `AGENTS.md`, `@import`, `.claude/rules/`, memória | <https://code.claude.com/docs/en/memory>      |
| Skills (`SKILL.md`, frontmatter, orçamento de descrição)       | <https://code.claude.com/docs/en/skills>      |
| Permissões (`deny`/`ask`/`allow`, sintaxe de padrões)          | <https://code.claude.com/docs/en/permissions> |
| Custos e redução de tokens                                     | <https://code.claude.com/docs/en/costs>       |
| Índice completo da documentação                                | <https://code.claude.com/docs/llms.txt>       |

Para o Cursor (`.cursor/rules/*.mdc`): <https://docs.cursor.com/context/rules> — confira o formato de `globs` na versão que você usa.

## Projetos onde o método foi aplicado

- [ZAP CRM BR](https://github.com/brunopelatieri/zap-crm-br) — CRM para WhatsApp (Next.js 16 + Supabase), derivado de [wacrm](https://github.com/ArnasDon/wacrm) de [ArnasDon](https://github.com/ArnasDon) (MIT).
- Valen Ranch — produto derivado do ZAP CRM BR.

Veja os números em [exemplos/estudo-de-caso-zap-crm-br.md](./exemplos/estudo-de-caso-zap-crm-br.md).
