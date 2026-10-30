---
paths:
  - '{{glob/que/casa/arquivo/real/**}}'
  - '{{outro/glob/*.ts}}'
---

# {{Domínio}}

- {{Decisão curta e verificável 1.}}
- {{Decisão curta 2.}}
- {{Decisão curta 3.}}
- Detalhes, porquês e armadilhas: leia `docs/context/{{dominio}}.md`.

<!--
REGRAS DESTE ARQUIVO (apague este comentário ao preencher):
- `paths` é o ÚNICO campo lido. description/globs/alwaysApply aqui são ignorados.
- Sem `paths` (ou YAML inválido) = carrega em TODA sessão.
- Cada glob casa ≥ 1 arquivo hoje (git ls-files / find).
- Rota com [param]: aspas simples e escape — 'src/app/join/\[token\]/**'.
- ≤ 25 linhas. Nada de @ fora de crases. Não copie o arquivo de domínio.
-->
