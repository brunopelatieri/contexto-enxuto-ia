# Super tutorial — otimização de contexto em 7 passos

> Do `AGENTS.md` de 30 KB ao roteador de 8 KB, sem perder uma regra. Cada passo diz **o que fazer**, **qual prompt usar**, **como saber que acabou** e **em que sessão** fazer.

## Antes de começar (10 minutos)

1. Leia [guia/01](../guia/01-por-que-contexto-custa.md) e [guia/04](../guia/04-arquitetura-alvo.md) — o resto do guia é consulta.
2. Copie a pasta `scripts/` deste repositório para um lugar **fora** do seu projeto (ex.: `~/ferramentas/contexto/`).
3. Preencha [prompts/00-variaveis.md](../prompts/00-variaveis.md) uma vez. Todos os prompts usam essas chaves.
4. Faça backup **fora do repo**:
   ```bash
   STAMP=$(date +%Y%m%d-%H%M)
   tar czf ~/backup-contexto-$STAMP.tgz CLAUDE.md AGENTS.md .claude docs 2>/dev/null
   ```

## Os 7 passos

| #   | Passo                                           | Quem faz      | Modelo sugerido¹             | Sessão     | Muda o repo?        |
| --- | ----------------------------------------------- | ------------- | ---------------------------- | ---------- | ------------------- |
| 1   | [Medir](./passo-1-medir.md)                     | você (script) | —                            | —          | não                 |
| 2   | [Classificar](./passo-2-classificar.md)         | agente        | o mais forte                 | A          | não                 |
| 3   | [Desenhar a SPEC](./passo-3-desenhar-a-spec.md) | agente        | o mais forte                 | A (mesma)  | 1 arquivo (a SPEC)  |
| —   | **Você ratifica as decisões e responde GO**     | você          | —                            | —          | —                   |
| 4   | [Construir (aditivo)](./passo-4-construir.md)   | agente        | médio, forte nas skills      | B, C, D    | só cria arquivos    |
| 5   | [Trocar o root](./passo-5-trocar-o-root.md)     | agente        | o mais forte                 | E          | **remove** conteúdo |
| 6   | [Validar](./passo-6-validar.md)                 | agente + você | médio + revisor independente | F (nova)   | não                 |
| 7   | [Manter](./passo-7-manter.md)                   | você          | —                            | recorrente | pouco               |

¹ Em 2026-10: "o mais forte" = Opus 5.5 ou Fable 5.1; "médio" = Sonnet 5.5; "rápido" = Haiku 5.5. Troque pelos atuais. Regra geral: **decisão e redação de regra → modelo forte; cópia, conferência e medição → modelo médio.**

> **Atalho:** os passos 2 e 3 são um único prompt pronto — [prompts/01-diagnostico-e-spec.md](../prompts/01-diagnostico-e-spec.md). Os passos 4–6 têm prompts de abertura em [prompts/02-execucao-de-fase.md](../prompts/02-execucao-de-fase.md).

## Checklist imprimível

```
PREPARAÇÃO
[ ] Backup fora do repo (CLAUDE.md, AGENTS.md, .claude/, docs/)
[ ] git check-ignore -v em CLAUDE.md, AGENTS.md, .claude/rules/x.md, docs/context/x.md
[ ] Decidi: versionar o conjunto todo  OU  manter tudo local
[ ] Variáveis preenchidas (prompts/00-variaveis.md)

PASSO 1 — MEDIR
[ ] medir-contexto.sh → baseline salvo
[ ] /context em sessão nova → número anotado
[ ] Validador testado num arquivo sabidamente errado (Prettier/ignore)

PASSOS 2–3 — SPEC (sessão A)
[ ] Prompt 01 colado em sessão nova, modo padrão
[ ] SPEC criada; nada mais mudou (manifesto confere)
[ ] Li a SPEC; ratifiquei cada D-n; respondi GO

PASSO 4 — CONSTRUIR (sessões B, C, D)
[ ] F1: status.md, INDEX.md, catalogo-specs.md
[ ] F2: arquivos de domínio + matriz de rastreabilidade 100%
[ ] F3: rules, todas com paths:, todos os globs casam arquivo
[ ] F4: skills com descrição curta e gatilhos
[ ] F0/F4: permissions.deny (se ratificado)

PASSO 5 — TROCAR O ROOT (sessão E)
[ ] AGENTS.md virou roteador (≤ 150 L), inegociáveis dentro
[ ] Blocos gerados por ferramenta idênticos (diff contra o backup)
[ ] CLAUDE.md = @AGENTS.md + extras

PASSO 6 — VALIDAR (sessão F, nova)
[ ] medir-contexto.sh depois: meta atingida
[ ] /context depois: anotado
[ ] checar-higiene.sh: zero erros
[ ] Testes de roteamento: todos passam
[ ] Manifesto: src/ e afins intocados

PASSO 7 — MANTER
[ ] Regra "SPEC nova → catálogo, nunca AGENTS.md" combinada com o time
[ ] Lembrete mensal de auditoria
```

## Quanto tempo leva

| Tamanho do projeto                  | Sessões | Tempo de relógio |
| ----------------------------------- | ------- | ---------------- |
| `AGENTS.md` < 10 KB                 | 1–2     | 1 h              |
| 10–30 KB, 10–15 domínios            | 5–6     | meio dia         |
| > 30 KB, monorepo, multi-ferramenta | 6–8     | 1–2 dias         |
