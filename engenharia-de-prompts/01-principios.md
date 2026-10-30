# 1. Princípios — a economia de tokens num prompt

Cada princípio tem o **porquê** em termos de tokens e qualidade.

### 1. Aponte, não cole

❌ Colar 300 linhas da SPEC no prompt.
✅ "Leia §7.F3 e o Anexo A (linhas da F3) de `docs/spec-079-x.md`. Não leia o resto."

**Por quê:** o que você cola entra na conversa e é reenviado em toda requisição. O que você aponta entra uma vez, e só a parte que importa.

### 2. Não repita o que o contexto fixo já diz

❌ "Lembre-se: não faça commit, use o cliente server, rode i18n:check…"
✅ Nada — ou "siga os inegociáveis do `AGENTS.md`".

**Por quê:** depois da otimização, os inegociáveis já estão carregados. Repeti-los gasta tokens e, pior, cria duas versões que podem divergir. Repita só o que for **exceção** nesta tarefa.

### 3. Diga o resultado observável, não a intenção vaga

❌ "Melhore o inbox."
✅ "No inbox, o filtro 'Não lidas' deve mostrar só conversas com `unread_count > 0`; hoje mostra todas. Arquivo provável: `src/lib/inbox/filters.ts`."

**Por quê:** pedido vago dispara varredura ampla (dezenas de leituras). Pedido específico vai direto ao arquivo. A doc oficial do Claude Code dá exatamente esse exemplo.

### 4. Feche o escopo de escrita

"Escreva só em `src/lib/inbox/` e no teste ao lado." Escopo fechado evita que o agente "aproveite" para refatorar o vizinho — e cada arquivo extra é leitura, edição e revisão a mais.

### 5. Dê o critério de aceite como comando

"Pronto quando `npm run test -- inbox` passa e o novo caso `unread-only.test.ts` existe." O agente se verifica sozinho em vez de pedir confirmação; você não precisa de uma rodada extra.

### 6. Diga quando parar

"Ao terminar, mostre o diff e PARE." Sem condição de parada, o agente segue para "melhorias" não pedidas, que você paga e depois desfaz.

### 7. Uma sessão, um objetivo

Feature em fases → uma fase por sessão. Assunto novo → `/clear`. Contexto velho é reenviado em toda mensagem e confunde: o agente "lembra" de decisões da tarefa anterior.

### 8. Passe estado por arquivo, não por conversa

SPEC, plano, nota de handoff em disco. A próxima sessão lê o arquivo (barato, exato) em vez de você recontar (caro, impreciso). É o "_Persist everything else_" do ECC.

### 9. Modelo certo para cada etapa

| Etapa                                   | Modelo       | Por quê                                   |
| --------------------------------------- | ------------ | ----------------------------------------- |
| PRD, SPEC, arquitetura, revisão crítica | o mais forte | erro aqui se multiplica em todas as fases |
| Implementação de fase bem especificada  | médio        | a SPEC já tomou as decisões               |
| Cópia, conferência, medição, renomear   | médio/rápido | mecânico                                  |
| Subagente de varredura/teste            | rápido       | só devolve resumo                         |

Ajuste também o esforço (`/effort`) — raciocínio é cobrado como saída.

### 10. Delegue o verboso a subagentes

Rodar a suíte, varrer 50 arquivos, ler logs: peça a um subagente e receba só a conclusão. A saída verbosa fica no contexto **dele**, não no seu.

### 11. Revise com olhos que não viram o trabalho

Quem escreveu tende a confirmar o próprio raciocínio. Revisão de coisa importante: sessão nova ou subagente **sem o histórico**, recebendo só o código/SPEC — não a sua conclusão.

### 12. Proteja o cache

O prefixo estável (sistema + instruções) é cacheado. Editar `CLAUDE.md`/`AGENTS.md`, ligar/desligar MCP ou trocar de modelo no meio da sessão pode invalidar o cache e reprocessar tudo. Faça essas mudanças **entre** sessões. Depois de uma pausa longa, a primeira mensagem paga o reprocessamento — numa sessão gigante, `/clear` + arquivo de handoff sai mais barato.

---

Próximo: [2. Anatomia do prompt](./02-anatomia-do-prompt.md).
