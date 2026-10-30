# Contexto Enxuto

**O agente de IA lê só o que importa, em cada tarefa.**

🇧🇷 Português · [🇺🇸 English](./README.en.md)

> _Menos tokens. Mais aderência às regras. Zero regra perdida._
> _Fewer tokens. Better rule adherence. Zero rules lost._

Como fazer o Claude Code (e o Cursor/Codex) carregar **só o que importa** em cada tarefa — e como escrever prompts que aproveitam isso para entregar features melhores gastando menos tokens.

Inspirado no padrão do [ECC — Everything Claude Code](https://github.com/affaan-m/ECC) ("_Optimize the context window. Persist everything else._"), adaptado para projetos reais Next.js + Supabase ([ZAP CRM BR](https://github.com/brunopelatieri/zap-crm-br) e derivados). Prompts prontos onde você só troca os valores entre `{{CHAVES}}`.

---

## Para quem é

- Você usa Claude Code (ou Cursor/Codex) num projeto que já cresceu: o `CLAUDE.md`/`AGENTS.md` virou um documento de 20–40 KB, com índice de SPECs, mapa do repo, convenções e histórico.
- Toda sessão começa pagando esse arquivo inteiro — mesmo para trocar uma string de tradução.
- Você quer reduzir isso **sem perder nenhuma regra que não pode ser esquecida**.

## O que você ganha

| Antes                                                        | Depois                                                                      |
| ------------------------------------------------------------ | --------------------------------------------------------------------------- |
| Um arquivo raiz de 25–35 KB carregado em toda sessão         | Um roteador de ~6–10 KB com só os inegociáveis                              |
| Regra de migração carregada até quando você mexe em CSS      | Regra curta que aparece **só** quando o agente abre `supabase/migrations/…` |
| Índice de 70 SPECs no contexto fixo                          | Catálogo consultado sob demanda                                             |
| Fatos que envelhecem ("migrações 001 → 054") no texto fixo   | Um `status.md` datado, único lugar de dado mutável                          |
| Procedimentos longos (nova migração, novo endpoint) em prosa | Skills que só entram quando invocadas                                       |
| "Por favor, não leia o `.env`" escrito em prosa              | `permissions.deny` — bloqueio mecânico, custo zero de contexto              |

Meta do método: **−65% a −75% de bytes** no conjunto sempre carregado, com a mesma (ou melhor) aderência às regras. No estudo de caso ([exemplos/](./exemplos/estudo-de-caso-zap-crm-br.md)) a meta era −68%; confira o resultado medido lá antes de citar o número.

---

## Comece aqui (3 caminhos)

| Você quer…                                        | Vá para                                                                  | Tempo       |
| ------------------------------------------------- | ------------------------------------------------------------------------ | ----------- |
| **Aplicar agora** num projeto seu                 | [tutorial/README.md](./tutorial/README.md) — 7 passos com checklist      | 1–3 sessões |
| **Só copiar o prompt** e deixar o agente desenhar | [prompts/01-diagnostico-e-spec.md](./prompts/01-diagnostico-e-spec.md)   | 1 sessão    |
| **Entender o porquê** antes de mexer              | [guia/01-por-que-contexto-custa.md](./guia/01-por-que-contexto-custa.md) | 20 min      |
| **Escrever prompts melhores** depois de otimizar  | [engenharia-de-prompts/README.md](./engenharia-de-prompts/README.md)     | 30 min      |

---

## Mapa do repositório

```
.
├── README.md                       ← você está aqui
├── README.en.md                    English summary (entry point)
├── CREDITOS.md                     fontes, ECC, documentação oficial consultada
│
├── guia/                           CONCEITOS — leia uma vez
│   ├── 01-por-que-contexto-custa.md      sempre-carregado × sob demanda; a conta dos tokens
│   ├── 02-mecanismos-do-claude-code.md   referência verificada: CLAUDE.md, AGENTS.md, @import,
│   │                                     rules com paths:, skills, permissões, MCP, memória
│   ├── 03-o-padrao-ecc.md                o que o ECC propõe, o que adotar e o que não adotar
│   ├── 04-arquitetura-alvo.md            a árvore final, orçamentos e "onde cada coisa mora"
│   ├── 05-armadilhas.md                  erros reais que custaram caro (gitignore, Prettier, Windows…)
│   └── 06-manutencao.md                  como não engordar de novo
│
├── tutorial/                       PRÁTICA — siga na ordem
│   ├── README.md                   visão geral + checklist imprimível
│   ├── passo-1-medir.md
│   ├── passo-2-classificar.md
│   ├── passo-3-desenhar-a-spec.md
│   ├── passo-4-construir.md        status, INDEX, domínios, rules, skills (aditivo)
│   ├── passo-5-trocar-o-root.md    a única fase que remove conteúdo
│   ├── passo-6-validar.md
│   └── passo-7-manter.md
│
├── prompts/                        PROMPTS PRONTOS — troque os {{VALORES}}
│   ├── README.md                   como preencher, tabela de variáveis
│   ├── 00-variaveis.md             bloco único para preencher uma vez
│   ├── 01-diagnostico-e-spec.md    o prompt-mestre (modo arquiteto, não executa)
│   ├── 02-execucao-de-fase.md      prompt de abertura para cada fase F0–F6
│   ├── 03-testes-de-roteamento.md  bateria de testes em sessão nova
│   └── 04-auditoria-periodica.md   revisão mensal/trimestral
│
├── engenharia-de-prompts/          DEPOIS DA OTIMIZAÇÃO — como pedir features
│   ├── README.md
│   ├── 01-principios.md            a economia de tokens de um prompt
│   ├── 02-anatomia-do-prompt.md    as 8 partes de um prompt de feature
│   ├── 03-ciclo-de-uma-feature.md  PRD → SPEC → plano → fases → revisão, modelo por etapa
│   ├── 04-modelos-prontos.md       feature, bug, refactor, migração, revisão, investigação
│   ├── 05-antipadroes.md
│   └── 06-medir-e-melhorar.md      /context, /usage, cache, compactação
│
├── templates/                      ARQUIVOS-MODELO — copie para o seu projeto
│   ├── README.md                   ⚠️ por que os nomes terminam em .template
│   ├── CLAUDE.template.md
│   ├── AGENTS.template.md
│   ├── status.template.md
│   ├── INDEX.template.md
│   ├── catalogo.template.md
│   ├── dominio.template.md
│   ├── rule.template.md            → .claude/rules/<dominio>.md
│   ├── cursor-rule.template.mdc    → .cursor/rules/<dominio>.mdc
│   ├── SKILL.template.md           → .claude/skills/<nome>/SKILL.md
│   └── settings.deny.template.json → .claude/settings.json
│
├── scripts/                        FERRAMENTAS (bash puro, roda no Git Bash do Windows)
│   ├── README.md
│   ├── medir-contexto.sh           baseline/resultado do conjunto sempre carregado
│   ├── checar-higiene.sh           rules sem paths:, globs mortos, @ soltos, links quebrados
│   └── preencher-prompt.sh         troca os {{VALORES}} de um prompt a partir de um .env
│
└── exemplos/
    └── estudo-de-caso-zap-crm-br.md   números reais de um projeto de 1.000+ arquivos
```

---

## A ideia em 60 segundos

1. **Tudo que está no contexto fixo é cobrado em toda mensagem.** Cache barateia, mas não zera, e conteúdo irrelevante ainda dilui a atenção do modelo.
2. **Separe por quando é necessário:**
   - _Sempre_ → inegociáveis curtos (segurança, git, cliente de banco, validação). Ficam no `AGENTS.md`.
   - _Quando mexer em X_ → rule com `paths:` que só carrega ao abrir arquivo de X.
   - _Quando fizer o procedimento Y_ → skill, cujo corpo só entra ao ser invocada.
   - _Quando precisar consultar_ → arquivo em `docs/context/`, lido por caminho.
   - _Nunca deveria depender do modelo_ → `permissions.deny`.
3. **Mude de forma aditiva:** crie tudo primeiro, confira, e só no fim encolha o arquivo raiz.
4. **Prove:** meça antes/depois, rode testes de roteamento em sessão nova, compare manifestos `sha256sum`.

---

## Requisitos

- Claude Code recente (os comportamentos citados foram conferidos na documentação oficial em 2026-10; veja [CREDITOS.md](./CREDITOS.md)). Cursor/Codex são opcionais.
- Bash (Linux/macOS, ou Git Bash no Windows) para os scripts.
- Um projeto com `CLAUDE.md` e/ou `AGENTS.md` que você quer enxugar.

## Licença

Defina antes de publicar (sugestão: MIT, a mesma do ECC). O ECC é MIT; este material não copia código dele, só adapta ideias — veja [CREDITOS.md](./CREDITOS.md).

---

Mantido por [Bruno Pelatieri](https://github.com/brunopelatieri).
