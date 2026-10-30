# Índice de roteamento — {{PROJETO}}

> Tarefa → o que ler. Leia **só** a linha da sua tarefa. Caminhos em texto (sem `@`) de propósito: nada aqui carrega sozinho.

| Se a tarefa é…                          | Leia                              | Rule que carrega ao abrir arquivos  | Skill                   |
| --------------------------------------- | --------------------------------- | ----------------------------------- | ----------------------- |
| {{criar/alterar migração, RLS, grants}} | `docs/context/supabase-rls.md`    | `supabase` (`supabase/**`)          | `/nova-migracao`        |
| {{endpoint da API pública}}             | `docs/context/api-publica.md`     | `api-publica` (`src/app/api/v1/**`) | `/endpoint-api-publica` |
| {{texto visível, tradução}}             | `docs/context/i18n.md`            | `i18n` (`messages/**`)              | —                       |
| {{agendamento que não dispara, cron}}   | `docs/context/automacoes-cron.md` | `automacoes-cron`                   | —                       |
| {{…}}                                   |                                   |                                     |                         |

## Por sintoma

| Sintoma                           | Leia                                      |
| --------------------------------- | ----------------------------------------- |
| {{tela quebrada só em um idioma}} | `docs/context/i18n.md` § Armadilhas       |
| {{query volta vazia sem erro}}    | `docs/context/supabase-rls.md` § Clientes |
| {{…}}                             |                                           |

## Módulo novo (nenhuma rule casa ainda)

Siga os inegociáveis do `AGENTS.md`, escolha o domínio mais próximo acima e, ao terminar, proponha a rule e a linha deste índice para o módulo novo.
