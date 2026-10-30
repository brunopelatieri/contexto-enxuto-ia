# Passo 7 — Manter

> **Objetivo:** que daqui a seis meses o `AGENTS.md` ainda tenha o mesmo tamanho.

## A regra de bolso

> **SPEC nova → `catalogo-specs.md`. Regra nova → rule do domínio. Número novo → `status.md`. Procedimento repetido → skill. `AGENTS.md` só muda se a regra for inegociável para qualquer tarefa.**

Cole essa frase no fim do seu `AGENTS.md` (ela vale o custo).

## Ritual mensal (15 min)

1. `bash medir-contexto.sh` — comparar com o último.
2. `bash checar-higiene.sh` — zero erros.
3. Sessão nova: `/context` e `/doctor prompt-audit`.
4. `status.md`: atualizar datas e números (ou confirmar que os comandos ainda batem).
5. Se algo passou do orçamento: [prompts/04-auditoria-periodica.md](../prompts/04-auditoria-periodica.md).

## Ao terminar cada feature

No prompt de fechamento da feature, peça (já está nos [modelos prontos](../engenharia-de-prompts/04-modelos-prontos.md)):

```
Ao concluir: diga se esta mudança exige atualizar docs/context/ (status, INDEX,
domínio, rule ou skill). Se sim, proponha o diff mínimo — não toque no AGENTS.md
a menos que seja um inegociável novo, e justifique.
```

Mais detalhes em [guia/06-manutencao.md](../guia/06-manutencao.md).

---

🎉 **Fim do tutorial.** Agora aprenda a tirar proveito disso: [engenharia-de-prompts/](../engenharia-de-prompts/README.md).
