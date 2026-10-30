# Templates

> ⚠️ **Por que os nomes terminam em `.template`:** o Claude Code carrega sob demanda qualquer arquivo chamado `CLAUDE.md` ou `AGENTS.md` numa subpasta quando o agente mexe ali. Se este repositório (ou uma cópia dele dentro do seu `docs/`) tivesse um `templates/CLAUDE.md`, ele viraria instrução — com `{{PLACEHOLDERS}}` e tudo. Ao copiar para o projeto, **renomeie** para o nome final.

| Template                                                     | Copie para                         | Orçamento       |
| ------------------------------------------------------------ | ---------------------------------- | --------------- |
| [CLAUDE.template.md](./CLAUDE.template.md)                   | `CLAUDE.md`                        | ≤ 15 linhas     |
| [AGENTS.template.md](./AGENTS.template.md)                   | `AGENTS.md`                        | ≤ 150 linhas    |
| [status.template.md](./status.template.md)                   | `docs/context/status.md`           | livre, datado   |
| [INDEX.template.md](./INDEX.template.md)                     | `docs/context/INDEX.md`            | ≤ 100 linhas    |
| [catalogo.template.md](./catalogo.template.md)               | `docs/context/catalogo-specs.md`   | livre           |
| [dominio.template.md](./dominio.template.md)                 | `docs/context/<dominio>.md`        | ≤ 120 L / ~6 KB |
| [rule.template.md](./rule.template.md)                       | `.claude/rules/<dominio>.md`       | ≤ 25 linhas     |
| [cursor-rule.template.mdc](./cursor-rule.template.mdc)       | `.cursor/rules/<dominio>.mdc`      | ≤ 25 linhas     |
| [SKILL.template.md](./SKILL.template.md)                     | `.claude/skills/<nome>/SKILL.md`   | ≤ 100 linhas    |
| [settings.deny.template.json](./settings.deny.template.json) | mesclar em `.claude/settings.json` | —               |

Linhas que começam com `<!--` nos templates são instruções para você; **apague** ao preencher (em `CLAUDE.md`/`AGENTS.md` elas não custam tokens, mas nos outros arquivos custam quando lidos).
