# Status — {{PROJETO}}

> **Único lugar de dado que envelhece.** Cada linha tem data e o comando que a confere. Se o comando discordar da tabela, o comando vence — atualize a linha.

| Fato                      | Valor               | Conferido em | Como conferir                                            |
| ------------------------- | ------------------- | ------------ | -------------------------------------------------------- |
| Última migração           | `{{NNN_nome}}`      | {{DATA}}     | `ls supabase/migrations \| tail -1`                      |
| Framework                 | `{{next 16.x}}`     | {{DATA}}     | `grep '"next"' package.json`                             |
| Chaves de i18n (folhas)   | {{N}}               | {{DATA}}     | `node -e "…"` (contagem de folhas de `messages/en.json`) |
| Rotas de cron             | {{N}}: {{lista}}    | {{DATA}}     | `git ls-files 'src/app/api/**/cron/route.ts'`            |
| Projetos de banco         | {{vn (padrão), rs}} | {{DATA}}     | `claude mcp list` (o mantenedor roda)                    |
| `/context` na abertura    | {{N}} tokens        | {{DATA}}     | sessão nova → `/context`                                 |
| Conjunto sempre carregado | {{N}} B / {{N}} L   | {{DATA}}     | `bash scripts/medir-contexto.sh`                         |

## Em andamento

| Item         | Estado      | Referência              |
| ------------ | ----------- | ----------------------- |
| {{SPEC NNN}} | {{fase Fk}} | `docs/spec-NNN-x.md` §7 |
