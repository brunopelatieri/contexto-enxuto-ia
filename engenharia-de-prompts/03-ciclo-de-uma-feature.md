# 3. O ciclo de uma feature — da ideia ao commit

> Uma feature boa não sai de um prompt gigante. Sai de **etapas curtas**, cada uma deixando um arquivo para a próxima, cada uma com o modelo certo.

```
 ideia ─▶ PRD ─▶ SPEC ─▶ plano ─▶ F1 ─▶ F2 ─▶ … ─▶ revisão ─▶ fechamento
          forte  forte   forte/   médio  médio        forte      médio
                         médio    (1 sessão por fase)  (sessão   (atualiza
                                                        sem       contexto)
                                                        histórico)
```

## Etapa por etapa

| Etapa          | Entrada                         | Saída (arquivo)                                                      | Modelo         | Sessão                    | Gate (você)               |
| -------------- | ------------------------------- | -------------------------------------------------------------------- | -------------- | ------------------------- | ------------------------- |
| **PRD**        | sua ideia + notas               | `docs/prd-NNN-x.md` com D-n                                          | forte          | nova                      | ratifica D-n de produto   |
| **SPEC**       | PRD ratificado                  | `docs/spec-NNN-x.md` com fases, aceite, rastreabilidade              | forte          | nova                      | ratifica D-n técnicas, GO |
| **Plano**      | SPEC                            | `docs/plano-implantacao-spec-NNN.md` com prompt de abertura por fase | forte ou médio | nova                      | confere ordem e modelos   |
| **Fase Fk**    | §7.Fk da SPEC + prompt do plano | código + testes da fase                                              | médio          | **nova por fase**         | aceite da fase (comandos) |
| **Revisão**    | diff total + SPEC               | lista de achados                                                     | forte          | nova, **sem o histórico** | decide o que corrigir     |
| **Fechamento** | achados resolvidos              | atualização de `docs/context/` + comandos de commit                  | médio          | nova ou a da última fase  | commit manual             |

### Quando pular etapas

| Tamanho                                   | Caminho                                                                     |
| ----------------------------------------- | --------------------------------------------------------------------------- |
| Ajuste de 1 arquivo, sem decisão          | prompt executor direto (modelo [bug/ajuste](./04-modelos-prontos.md#2-bug)) |
| Feature pequena, 1–3 arquivos, sem schema | SPEC curta (sem PRD) → 1 fase → revisão rápida                              |
| Feature com schema, API ou segurança      | ciclo completo                                                              |
| Mudança de produto (quem acessa o quê)    | ciclo completo, PRD obrigatório                                             |

## Por que tantas sessões?

- **Contexto fresco carrega o contexto fixo novo** (rules/skills criadas na fase anterior) e nada da conversa velha.
- **Fase curta cabe no contexto sem compactação** — compactação perde detalhe.
- **Arquivo de saída é o handoff:** a próxima sessão lê 40 linhas da SPEC, não 400 mensagens.
- **Falha isolada:** se a F3 der errado, você refaz a F3, não a feature.

## Orçamento de referência (ordem de grandeza)

| Etapa   | Prompt   | Leituras típicas                       | Sinal de que estourou                            |
| ------- | -------- | -------------------------------------- | ------------------------------------------------ |
| PRD     | 30–60 L  | notas + 2–3 arquivos de domínio        | leu código de implementação                      |
| SPEC    | 60–150 L | PRD + domínios + `ls`/`grep` do código | leu SPECs antigas inteiras                       |
| Fase    | 15–35 L  | §7.Fk + arquivos que vai tocar         | contexto > 60% antes de terminar → divida a fase |
| Revisão | 15–25 L  | diff + SPEC §6/§7                      | começou a reescrever em vez de apontar           |

## O gate é seu

Entre etapas, **você** lê o arquivo e decide. É aí que se pega o erro barato (uma linha no PRD) antes de virar o erro caro (três fases de código). Não automatize o gate de PRD e SPEC.

## Fechamento: o passo que mantém o contexto enxuto

Toda feature termina perguntando se o contexto precisa mudar:

- SPEC nova → linha no `catalogo-specs.md`.
- Número que mudou (última migração) → `status.md`.
- Regra nova de domínio → rule + arquivo de domínio.
- Procedimento que vai se repetir → skill.
- **`AGENTS.md` só muda se for inegociável novo — justificado.**

O [modelo de fechamento](./04-modelos-prontos.md#8-fechamento) faz isso por você.

Próximo: [4. Modelos prontos](./04-modelos-prontos.md).
