# Engenharia de prompts depois da otimização de contexto

> O contexto enxuto é o terreno. O prompt é o que você constrói em cima. Esta seção ensina a escrever prompts que **aproveitam** o roteamento (rules, skills, `INDEX.md`) em vez de repetir o que ele já entrega — e a organizar uma feature inteira em sessões curtas, cada uma com o modelo certo.

| Arquivo                                                    | O que você aprende                                                                               |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [01-principios.md](./01-principios.md)                     | as 12 regras da economia de tokens num prompt                                                    |
| [02-anatomia-do-prompt.md](./02-anatomia-do-prompt.md)     | as 8 partes de um prompt de feature, com exemplo anotado                                         |
| [03-ciclo-de-uma-feature.md](./03-ciclo-de-uma-feature.md) | PRD → SPEC → plano → fases → revisão → fechamento, modelo por etapa                              |
| [04-modelos-prontos.md](./04-modelos-prontos.md)           | 8 prompts para copiar: fase, bug, refactor, migração, revisão, investigação, handoff, fechamento |
| [05-antipadroes.md](./05-antipadroes.md)                   | 14 hábitos que queimam tokens e pioram o resultado                                               |
| [06-medir-e-melhorar.md](./06-medir-e-melhorar.md)         | `/context`, `/usage`, cache, `/compact` × `/clear`, sinais de inchaço                            |

## A tese em uma frase

> **O prompt aponta; o repositório explica.** Depois da otimização, tudo que é regra está num arquivo que o agente carrega quando precisa. O prompt só diz _o quê_, _onde olhar_, _o que não tocar_, _como provar_ e _quando parar_.
