# 2. Anatomia de um prompt de feature

## As 8 partes

| #   | Parte                     | Pergunta que responde                           | Tamanho típico |
| --- | ------------------------- | ----------------------------------------------- | -------------- |
| 1   | **Modo**                  | arquiteto (projeta) ou executor (faz)?          | 1 linha        |
| 2   | **Objetivo**              | qual resultado observável?                      | 1–3 linhas     |
| 3   | **Contexto por ponteiro** | o que ler (arquivo + seção) e o que **não** ler | 2–6 linhas     |
| 4   | **Travas**                | onde pode escrever; exceções aos inegociáveis   | 2–5 linhas     |
| 5   | **Entregáveis**           | quais arquivos, exatamente                      | 1–5 linhas     |
| 6   | **Critério de aceite**    | que comando prova que acabou                    | 1–4 linhas     |
| 7   | **Dúvidas**               | pergunta ou assume e registra?                  | 1 linha        |
| 8   | **Saída e parada**        | o que mostrar no fim; PARE                      | 2–4 linhas     |

Total: **15–35 linhas**. Se passou de 60, provavelmente você está colando o que deveria apontar.

## Exemplo anotado

```text
# MODO
Executor. Implementar a fase F2 da SPEC 081 — não replanejar.          ← (1)

# OBJETIVO
O contato entra com telefone + senha e cai em /area-do-contato,          ← (2)
vendo só as próprias conversas.

# LEIA (e só isto)
- docs/spec-081-area-do-contato.md: §5 (modelo), §7.F2, Anexo B          ← (3)
- docs/context/auth-e-conta.md
Não leia outras SPECs. Não explore src/app/(dashboard)/.

# TRAVAS
- Escreva só em src/app/(contato)/, src/lib/contact-auth/ e nos            ← (4)
  testes co-locados, e em messages/*.json.
- Sem migração nesta fase (o schema é da F1, já aplicada).

# ENTREGÁVEIS
Os 6 arquivos listados em §7.F2 "Saídas".                                  ← (5)

# PRONTO QUANDO
npm run typecheck && npm run i18n:check && npm run test -- contact-auth    ← (6)
passam, e o teste "contato não vê conversa de outro contato" existe.

# DÚVIDAS
Assuma, registre como D-n no fim do relatório e siga.                      ← (7)

# AO TERMINAR
Diff resumido por arquivo (≤ 20 linhas), saída dos comandos, D-n novas,    ← (8)
comando de commit pronto. PARE.
```

**O que não está ali, de propósito:** as regras de i18n, de cliente Supabase, de commit manual — já vêm do `AGENTS.md`, e a rule de i18n carrega sozinha ao tocar `messages/`.

## Variações por modo

| Modo         | Muda o quê                                                                                              |
| ------------ | ------------------------------------------------------------------------------------------------------- |
| Arquiteto    | (5) é **um** documento (PRD/SPEC); (4) "única escrita permitida"; (8) inclui decisões D-n e PARE até GO |
| Executor     | (3) aponta para a seção da SPEC; (6) é a bateria de testes da fase                                      |
| Investigador | (5) é um relatório na conversa; (4) "somente leitura"; (6) "hipótese confirmada por comando"            |
| Revisor      | (3) recebe o diff/código, **não** a conclusão de quem fez; (5) lista de achados com severidade          |

## Checklist rápido antes de enviar

- [ ] Dá para entender o objetivo lendo só a parte 2?
- [ ] Toda referência é caminho + seção (não colagem)?
- [ ] Estou repetindo algo do `AGENTS.md`? (apague)
- [ ] Há um comando que prova que acabou?
- [ ] Há um PARE?
- [ ] Modelo e sessão certos para esta etapa?

Próximo: [3. Ciclo de uma feature](./03-ciclo-de-uma-feature.md).
