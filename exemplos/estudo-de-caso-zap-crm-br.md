# Estudo de caso — ZAP CRM BR

> Projeto real: CRM para WhatsApp em Next.js 16 + Supabase, ~1.000 arquivos rastreados, 89 migrações, 3.550 chaves de i18n, ~70 SPECs/PRDs. Medições de 2026-10-30, **antes** da otimização (a execução segue a SPEC 079 do projeto).

## Ponto de partida

| Arquivo     | Linhas | Bytes  | Carrega                         |
| ----------- | ------ | ------ | ------------------------------- |
| `CLAUDE.md` | 7      | 713    | sempre                          |
| `AGENTS.md` | 234    | 27.155 | sempre (via `@`)                |
| **Total**   | 241    | 27.868 | ≈ 7–8 mil tokens por requisição |

### Raio-X do `AGENTS.md`

| Seção                                | Bytes  | %   | Classe dominante                   |
| ------------------------------------ | ------ | --- | ---------------------------------- |
| Índice da documentação               | 14.272 | 53% | `CATÁLOGO`                         |
| Mapa do repositório                  | 3.955  | 15% | `ROTEÁVEL` + `ENVELHECE`           |
| Convenções obrigatórias              | 3.859  | 14% | `INEGOCIÁVEL` + `ROTEÁVEL`         |
| Armadilhas conhecidas                | 1.324  | 5%  | `ROTEÁVEL`                         |
| Validação local                      | 1.226  | 5%  | `INEGOCIÁVEL` (1 linha) + catálogo |
| Stack                                | 1.010  | 4%  | `ENVELHECE`                        |
| Cabeçalho + créditos + bloco Next.js | ~1.500 | 5%  | `INEGOCIÁVEL`                      |

**Mais da metade do contexto fixo era um catálogo de links.**

## O que estava errado (e ninguém via)

| Afirmação no contexto fixo            | Disco                                                                                              | Classe            |
| ------------------------------------- | -------------------------------------------------------------------------------------------------- | ----------------- |
| "migrações 001 → 054"                 | última: 089                                                                                        | `INCORRETO`       |
| "~1.600 chaves" de i18n               | 3.550 folhas                                                                                       | `ENVELHECE`       |
| "três rotas dependem de cron"         | 7 rotas de cron                                                                                    | `INCORRETO`       |
| "três projetos Supabase (vn, rs, jh)" | `.mcp.json` declara 2                                                                              | a confirmar       |
| `scripts/` = `check-i18n-parity.mjs`  | 5 arquivos                                                                                         | `ENVELHECE`       |
| — (ausente)                           | convenção `REVOKE … FROM PUBLIC` + `FROM anon` em toda função nova (só em comentários de migração) | conhecimento novo |

## Armadilhas encontradas no caminho

1. **`.gitignore` de cliente** ignorava `*.md`, `/docs`, `/supabase`, `/scripts`, `/.claude`: o git rastreava 1.014 arquivos e **nenhum** do que a otimização toca. Prova de escopo virou manifesto `sha256sum`; rollback virou backup fora do repo. _No mesmo dia, o mantenedor passou a versionar `docs/**/*.md` (exceto `docs/deploy/`): `docs/context/` entrou no git, mas `CLAUDE.md`, `AGENTS.md` e `.claude/` continuaram de fora — a coerência do versionamento virou decisão explícita da SPEC._
2. **Prettier mentiroso:** `npx prettier --check AGENTS.md` → "ok"; com `--ignore-path .prettierignore` → falha. O validador pulava arquivos ignorados em silêncio. _Efeito colateral de versionar `docs/`: o `format:check` saltou de 1 para 50 falhas — o baseline precisa ser remedido sempre que o `.gitignore` muda._
3. **Lixo do Windows rastreado:** um arquivo `C:UsersBRUNOP~1AppDataLocalTemp…lint-full.txt` na raiz, criado por uma sessão anterior que passou caminho `C:\` cru ao Git Bash (removido depois em commit próprio).
4. **Busca cega:** o `.ignore` (ripgrep) reabria só `docs/`; as ferramentas Grep/Glob não enxergavam `supabase/`, `scripts/`, `n8n_automation/`.
5. **Conector de outro produto** (`Supabase - ranch`, do projeto derivado Valen Ranch) aparecendo na conta: risco de migração no banco errado → inegociável + `permissions.deny`.
6. **Convenção do projeto-irmão não serve:** o Valen Ranch recebeu uma migração que muda os privilégios padrão; o ZAP não. Copiar a rule de lá ensinaria um padrão inseguro aqui.

## Arquitetura proposta

```
CLAUDE.md (≤15 L) → @AGENTS.md (≤150 L, inegociáveis dentro)
docs/context/: status.md · INDEX.md · catalogo-specs.md · 15 domínios
  (whatsapp-cloud, canais-e-qrcode, inbox-atribuicao, automacoes-cron, flows,
   contatos-audiencia, supabase-rls-mcp, i18n, api-publica-webhooks,
   planos-quotas-admin, retencao-e-atividade, notificacoes-smtp, auth-e-conta,
   ia-agentes, deploy-docker)
.claude/rules/: 1 por domínio, com paths:
.claude/skills/: nova-migracao-supabase, endpoint-api-publica, integracao-n8n,
  webhooks-meta, evolution-go-qrcode
.claude/settings.json: deny para .env*, .mcp.json, docs/deploy/, git commit/push, MCP ranch
```

**Meta:** ≤ 9 KB sempre carregados (−68%).

## Lições

- **Meça bytes, não linhas.** Uma linha de tabela com links tinha 520 B.
- **O maior ganho é o catálogo.** Tirar o índice do contexto fixo sozinho economiza metade.
- **Teste o validador antes de confiar nele.**
- **Derive regras do disco deste repo**, não do vizinho.
- **Revisão independente compensa:** um segundo modelo, sem o histórico, achou a contradição no critério de aceite entre as opções de versionamento — e também errou uma premissa que só a medição no disco desmentiu. Revisor aponta; o disco decide.

O prompt usado está em [prompts/01-diagnostico-e-spec.md](../prompts/01-diagnostico-e-spec.md) (versão genérica).
