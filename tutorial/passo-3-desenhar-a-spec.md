# Passo 3 — Desenhar a SPEC

> **Objetivo:** um documento que diga **exatamente** o que vai ser criado, de onde vem cada parágrafo, como provar que funcionou e quais decisões dependem de você.
> **Quem:** o agente, em modo arquiteto (não executa). **Modelo:** o mais forte. **Muda o repo:** só cria a SPEC.

## 3.1 Use o prompt-mestre

1. Preencha [prompts/00-variaveis.md](../prompts/00-variaveis.md).
2. Copie [prompts/01-diagnostico-e-spec.md](../prompts/01-diagnostico-e-spec.md), troque as `{{CHAVES}}`.
3. Sessão **nova**, modo padrão (não pule permissões), modelo mais forte.
4. Cole. Aprove só leituras e a criação do arquivo da SPEC.

O prompt já traz as travas (só uma escrita, sem segredos, sem MCP de banco, scratch fora do repo) e a estrutura da SPEC.

## 3.2 O que a SPEC tem de conter

| §   | Seção                     | Você confere se…                                                                |
| --- | ------------------------- | ------------------------------------------------------------------------------- |
| 2   | Baseline medido           | cada número tem o comando ao lado                                               |
| 4   | Premissas verificadas     | cada uma tem URL ou "não verificado — validar no GO"                            |
| 5   | Arquitetura e orçamento   | árvore bate com [guia/04](../guia/04-arquitetura-alvo.md); orçamento é realista |
| 6   | Matriz de invariantes     | cada inegociável diz onde fica, como chega ao Cursor e qual teste prova         |
| 7   | Fases F0–F6               | cada fase tem critério de aceite **mensurável** e rollback                      |
| 8   | Matriz de rastreabilidade | todo parágrafo de origem tem destino (nenhum órfão)                             |
| 9   | Testes de roteamento      | ≥ 8 testes com critério passa/falha                                             |
| 10  | Plano por sessão          | prompt de abertura pronto para cada fase                                        |
| 12  | Decisões D-1…D-n          | cada uma tem recomendação e consequência                                        |

## 3.3 Decisões que quase todo projeto precisa ratificar

- **Inegociáveis no `AGENTS.md` × `core.md` separado.** Recomendação: no `AGENTS.md` (o Cursor não expande `@`).
- **Versionar ou não** o conjunto (`CLAUDE.md`, `AGENTS.md`, `.claude/rules`, `.claude/skills`, `docs/context`). Sempre como bloco.
- **`permissions.deny`** para segredos, git e MCPs proibidos. Recomendação: adotar.
- **Cursor é usado?** Se não, nada de `.cursor/`.
- **Catálogo separado do `INDEX.md`?** Recomendação: sim — `INDEX` roteia tarefa, catálogo lista documentos.
- **Prompts de sessão antigos** entram no catálogo? Normalmente não.
- **Conhecimento que só existe no código** (ex.: convenção documentada só em comentário de migração) vira regra? É conhecimento **novo**, não mudança de lugar — decida explicitamente.

## 3.4 Prove que o modo arquiteto foi respeitado

Peça (o prompt já pede) a comparação com os manifestos do passo 1: o único delta é a SPEC.

## Pronto quando

- [ ] SPEC lida
- [ ] cada D-n respondida por escrito (aceito / aceito com ajuste / recuso)
- [ ] `/context` e `claude mcp list` colados, se a SPEC pediu
- [ ] você respondeu **GO**

Próximo: [Passo 4 — Construir](./passo-4-construir.md).
