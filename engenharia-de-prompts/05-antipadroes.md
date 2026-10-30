# 5. Antipadrões — o que queima tokens e piora o resultado

| #   | Antipadrão                                               | Custo                                                         | Faça em vez disso                                      |
| --- | -------------------------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------ |
| 1   | Colar arquivos/SPECs inteiros no prompt                  | reenviado em toda requisição; dilui o objetivo                | caminho + seção                                        |
| 2   | Repetir os inegociáveis no prompt                        | duplicação, risco de versões divergentes                      | confie no `AGENTS.md`; repita só exceções              |
| 3   | "Leia todo o projeto para entender"                      | dezenas de leituras; compactação precoce                      | `INDEX.md` → domínio → arquivo                         |
| 4   | Pedido vago ("melhore X")                                | varredura ampla, resultado genérico                           | resultado observável + arquivo provável                |
| 5   | Sessão-maratona com várias features                      | contexto velho em toda mensagem; decisões vazam entre tarefas | `/clear` entre assuntos; uma fase por sessão           |
| 6   | Corrigir em loop na mesma sessão poluída                 | cada tentativa carrega as falhas anteriores                   | parar, escrever handoff, sessão nova com o diagnóstico |
| 7   | Sem condição de parada                                   | "melhorias" não pedidas que você paga e desfaz                | "Ao terminar: X, Y. PARE."                             |
| 8   | Sem critério de aceite                                   | rodada extra só para perguntar "terminou?"                    | comando que prova                                      |
| 9   | Modelo forte para tarefa mecânica                        | custo alto sem ganho                                          | médio/rápido para copiar, renomear, medir              |
| 10  | Modelo fraco para decisão de arquitetura                 | erro barato agora, caro em todas as fases                     | forte em PRD/SPEC/revisão                              |
| 11  | Pedir ao autor que revise o próprio trabalho             | confirmação, não revisão                                      | sessão/subagente sem histórico                         |
| 12  | Deixar o agente "lembrar" números                        | fato velho com autoridade de instrução                        | `status.md` datado ou comando de conferência           |
| 13  | Editar `AGENTS.md`/MCPs no meio da sessão                | pode invalidar o cache; a mudança nem carrega                 | mude entre sessões                                     |
| 14  | Saída verbosa na conversa principal (suíte inteira, log) | milhares de tokens que ficam até o fim                        | subagente ou filtro (`\| tail -50`, `grep FAIL`)       |
