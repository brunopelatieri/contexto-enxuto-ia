# Variáveis — preencha uma vez

> Copie esta tabela para um arquivo seu, preencha "Seu valor" e use em todos os prompts. Exemplos vêm de um projeto Next.js + Supabase real.

## Identidade

| Chave            | Significado                | Exemplo                             | Seu valor |
| ---------------- | -------------------------- | ----------------------------------- | --------- |
| `{{PROJETO}}`    | nome do produto            | `ZAP CRM BR`                        |           |
| `{{REPO}}`       | nome da pasta/repositório  | `zap-crm-br-client`                 |           |
| `{{STACK}}`      | stack em uma linha         | `Next.js 16 + Supabase + next-intl` |           |
| `{{DATA}}`       | data de hoje (AAAA-MM-DD)  | `2026-10-30`                        |           |
| `{{MANTENEDOR}}` | quem ratifica e faz commit | `Bruno Pelatieri`                   |           |

## Arquivos e numeração

| Chave                   | Significado                                           | Exemplo                                                    | Seu valor |
| ----------------------- | ----------------------------------------------------- | ---------------------------------------------------------- | --------- |
| `{{PASTA_DOCS}}`        | onde ficam SPECs                                      | `docs`                                                     |           |
| `{{NUM_SPEC}}`          | próximo número livre de SPEC                          | `079`                                                      |           |
| `{{ARQUIVO_SPEC}}`      | arquivo que o prompt 01 cria                          | `docs/spec-079-otimizacao-de-contexto.md`                  |           |
| `{{SPECS_MODELO}}`      | 2 SPECs para imitar o estilo (só cabeçalho)           | `docs/spec-078-*.md e docs/spec-075-*.md`                  |           |
| `{{PLANO_MODELO}}`      | plano de implantação com prompts por fase, se existir | `docs/plano-implantacao-spec-065.md` (ou `nenhum`)         |           |
| `{{ARQUIVOS_RAIZ}}`     | `.md` e configs da raiz a proteger                    | `CLAUDE.md AGENTS.md README.md CONTRIBUTING.md .gitignore` |           |
| `{{PASTAS_INTOCAVEIS}}` | código que nenhuma fase pode tocar                    | `src/ public/ messages/ supabase/ docker/`                 |           |

## Ambiente

| Chave              | Significado                                        | Exemplo                                                                                                | Seu valor |
| ------------------ | -------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | --------- |
| `{{SO_SHELL}}`     | sistema e shell                                    | `Windows + Git Bash`                                                                                   |           |
| `{{SCRATCH}}`      | comando para criar a pasta temporária fora do repo | `SCR="$(cygpath -u "$TEMP")/spec-079"; mkdir -p "$SCR"` (Windows) · `SCR="$(mktemp -d)"` (Linux/macOS) |           |
| `{{FERRAMENTAS}}`  | agentes de IA usados no projeto                    | `Claude Code` · `Claude Code + Cursor`                                                                 |           |
| `{{MODELO_FORTE}}` | modelo para arquitetura e redação de regra         | `Opus 5.5 (claude-opus-5-5)`                                                                           |           |
| `{{MODELO_MEDIO}}` | modelo para cópia, conferência, medição            | `Sonnet 5.5 (claude-sonnet-5-5)`                                                                       |           |

## Segurança

| Chave                 | Significado                                               | Exemplo                                                                                                            | Seu valor |
| --------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | --------- |
| `{{SEGREDOS}}`        | arquivos que nunca podem ser lidos                        | `.env*, .mcp.json, .claude/settings.local.json, docs/deploy/`                                                      |           |
| `{{MCPS_DO_PROJETO}}` | MCPs/conectores legítimos e qual é o padrão               | `Supabase vn (padrão), rs`                                                                                         |           |
| `{{MCPS_PROIBIDOS}}`  | MCPs/conectores que podem aparecer e não podem ser usados | `Supabase - ranch (outro produto), qualquer conector Supabase sem nome`                                            |           |
| `{{VALIDACAO}}`       | linha única de validação local                            | `npm run typecheck && npm run i18n:check && npm run lint && npm run test && npm run format:check && npm run build` |           |

## Conteúdo

| Chave                   | Significado                                                 | Exemplo                                                                                           |
| ----------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `{{INVARIANTES}}`       | lista numerada do que **nunca** pode sair do contexto fixo  | 1. Commit/push manuais · 2. `admin.ts` só no servidor · 3. i18n: `en.json` é fonte da verdade · … |
| `{{DOMINIOS_HIPOTESE}}` | primeira lista de domínios (o agente valida)                | `whatsapp`, `inbox`, `automacoes-cron`, `contatos`, `supabase-rls`, `i18n`, `api-publica`…        |
| `{{SKILLS_HIPOTESE}}`   | procedimentos que podem virar skill                         | `nova-migracao-supabase`, `endpoint-api-publica`, `integracao-n8n`                                |
| `{{PISTAS}}`            | fatos que você já sabe (o agente reconfirma) — ou `nenhuma` | "o `.gitignore` ignora `*.md` e `/docs`"; "o Prettier pula arquivos ignorados"                    |

## Usadas só nas fases e na auditoria

| Chave                       | Significado                                       | Exemplo                                            |
| --------------------------- | ------------------------------------------------- | -------------------------------------------------- |
| `{{FASE}}`                  | fase em execução                                  | `F2`                                               |
| `{{DATA_GO}}`               | data em que você ratificou a SPEC                 | `2026-11-02`                                       |
| `{{DECISOES_RATIFICADAS}}`  | resumo das D-n aceitas                            | `D-1 (a), D-2 versionar, D-3 deny, D-4 sem Cursor` |
| `{{PASTA_LIB}}`             | onde mora a lógica de negócio                     | `src/lib`                                          |
| `{{DATA_ULTIMA_AUDITORIA}}` | data da auditoria anterior                        | `2026-10-30`                                       |
| `{{ARQUIVO_ENV_EXEMPLO}}`   | arquivo de exemplo de variáveis (template AGENTS) | `.env.local.example`                               |

> **Dica:** se não sabe preencher `{{PISTAS}}`, deixe `nenhuma`. O prompt manda medir tudo. Pistas só aceleram e evitam que o agente gaste contexto redescobrindo.
