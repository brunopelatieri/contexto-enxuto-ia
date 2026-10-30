# {{Domínio}} — {{PROJETO}}

> Lido sob demanda (via `INDEX.md` ou pela rule `{{dominio}}`). Orçamento: ≤ 120 linhas / ~6 KB. Sem `@` fora de crases. Números que envelhecem vão para `status.md`.

## Onde fica

| O quê            | Caminho                              |
| ---------------- | ------------------------------------ |
| Regra de negócio | `src/lib/{{modulo}}/`                |
| UI               | `src/components/{{modulo}}/`         |
| Rotas            | `src/app/api/{{modulo}}/`            |
| SPECs            | {{SPEC NNN, PRD NNN}} (ver catálogo) |

## Regras (o porquê das decisões curtas da rule)

1. **{{Regra}}** — {{por quê, em 1–3 linhas; de onde vem (migração/SPEC/código)}}.
2. …

## Fluxos principais

{{3–8 linhas por fluxo: entrada → módulo → saída. Sem copiar código.}}

## Armadilhas

| Sintoma | Causa provável | Como confirmar |
| ------- | -------------- | -------------- |
| {{…}}   | {{…}}          | `{{comando}}`  |

## Referências longas (não leia inteiras)

- `docs/references/{{x}}.md` — use `grep -n '^#'` e leia só a seção necessária.
