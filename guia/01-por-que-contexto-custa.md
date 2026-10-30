# 1. Por que contexto custa

> **Resumo:** o que está no contexto fixo é reenviado em toda requisição, compete pela atenção do modelo com o que importa na tarefa e envelhece sem ninguém ver. Otimizar contexto é decidir **quando** cada informação precisa estar lá.

## A conta

Cada mensagem que você manda — e cada vez que o agente usa uma ferramenta — gera uma requisição que leva:

```
[prompt de sistema + ferramentas]  ← fixo
[CLAUDE.md / AGENTS.md + imports]  ← fixo (o que este repositório otimiza)
[rules sem paths: + descrições de skills + memória]  ← fixo
[conversa até aqui + resultados de ferramentas]  ← cresce
[sua mensagem nova]
```

Uma tarefa média faz dezenas de requisições (ler arquivo, editar, rodar teste, ler de novo). O bloco fixo vai em **todas**.

### O cache ajuda, mas não resolve

O Claude Code usa _prompt caching_: o prefixo que não mudou é cobrado a uma taxa bem menor. Mesmo assim:

- **Cache tem validade.** Depois de uma pausa maior que o tempo de vida do cache, a primeira mensagem reprocessa tudo a preço cheio.
- **Cache não reduz a janela.** 30 KB de instruções ocupam espaço que a conversa precisaria; a compactação automática chega antes.
- **Cache não reduz a diluição.** O modelo lê tudo a cada vez. Um índice de 70 SPECs ao lado da regra "nunca use o cliente `admin` no browser" faz a regra competir com 70 linhas de catálogo.

> A documentação oficial do Claude Code recomenda manter cada `CLAUDE.md` **abaixo de 200 linhas**: "_Longer files consume more context and reduce adherence._" E lembra que `@imports` organizam, mas **não** reduzem custo — o arquivo importado carrega junto.

## Estimando tokens

Sem um tokenizador à mão, use duas taxas e reporte o intervalo:

| Taxa        | Quando usar                                                   |
| ----------- | ------------------------------------------------------------- |
| bytes ÷ 4   | texto em inglês, código                                       |
| bytes ÷ 3,5 | português com acentos (UTF-8 usa 2 bytes por letra acentuada) |

Um `AGENTS.md` de 27 KB ≈ **6,8 mil a 7,8 mil tokens** em cada requisição. Numa sessão de 80 requisições, isso é ~600 mil tokens de entrada só de instrução fixa (a maior parte em cache, mas não toda).

O número real vem do comando `/context` numa sessão nova — ele mostra o peso de cada parte, inclusive MCPs e skills, que nenhum script local enxerga.

## Os quatro custos escondidos

1. **Diluição de atenção.** Instrução importante no meio de catálogo perde aderência.
2. **Envelhecimento.** "Três rotas de cron", "migrações 001 → 054", "~1.600 chaves": fatos que eram verdade quando escritos e hoje enganam o agente — com autoridade de instrução.
3. **Contradição.** Dois lugares dizem coisas diferentes; o modelo escolhe um.
4. **Custo de oportunidade.** O espaço gasto com instrução irrelevante é espaço que falta para o código que importa, e a compactação chega mais cedo.

## O princípio

> **Cada informação deve entrar no contexto no momento em que é necessária — nem antes, nem depois — e existir em um só lugar.**

| Pergunta                                         | Se sim…                                      |
| ------------------------------------------------ | -------------------------------------------- |
| Esquecer isso causa dano em **qualquer** tarefa? | Sempre carregado (inegociável)               |
| Só importa quando mexo em certos arquivos?       | Rule com `paths:`                            |
| É um procedimento de vários passos?              | Skill                                        |
| É referência para consultar?                     | Arquivo em `docs/context/`, lido por caminho |
| É um fato que muda com o tempo?                  | `status.md` datado                           |
| Nunca pode depender da obediência do modelo?     | `permissions.deny` / hook                    |

Próximo: [2. Mecanismos do Claude Code](./02-mecanismos-do-claude-code.md).
