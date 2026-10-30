# 6. Manutenção — como não engordar de novo

A otimização se desfaz sozinha: cada SPEC nova quer "só uma linha" no `AGENTS.md`. Estas regras impedem isso.

## Onde vai cada coisa nova

| Aconteceu…                                          | Faça                                                                     |
| --------------------------------------------------- | ------------------------------------------------------------------------ |
| Nova SPEC/PRD                                       | 1 linha no `catalogo-specs.md`. **Nunca** no `AGENTS.md`.                |
| Nova regra para um domínio existente                | decisão curta na rule; porquê no `docs/context/<dominio>.md`             |
| Domínio novo (módulo novo em `src/lib/`)            | arquivo de domínio + rule com `paths:` + 1 linha no `INDEX.md`           |
| Procedimento que você explicou duas vezes           | skill                                                                    |
| Número que muda (última migração, versão, contagem) | `status.md` com data                                                     |
| O agente errou a mesma coisa duas vezes             | pergunte: é inegociável (vai ao `AGENTS.md`) ou de domínio (vai à rule)? |
| Proibição que o agente violou                       | considere `permissions.deny` antes de mais prosa                         |

## Gatilhos de revisão

- O conjunto sempre carregado passou da meta (ex.: 10 KB) → rode a [auditoria](../prompts/04-auditoria-periodica.md).
- `/usage` recomenda "_Trim CLAUDE.md_".
- Uma rule passou de 25 linhas → o excedente vai para o arquivo de domínio.
- Mais de ~15 skills → leia as descrições: quais nunca foram usadas?
- A cada release grande ou mensalmente: `/doctor prompt-audit` + [scripts/checar-higiene.sh](../scripts/checar-higiene.sh).

## Higiene contínua (5 minutos)

```bash
bash scripts/medir-contexto.sh      # compare com o último resultado
bash scripts/checar-higiene.sh      # rules sem paths, globs mortos, @ soltos, links quebrados
```

E, numa sessão nova, `/context` — anote o número no `status.md`.

## Sinal de que deu certo

- Você pede "ajuste o texto do botão X" e o `/context` mostra só o `AGENTS.md` + a rule de i18n.
- Você pede "crie uma migração" e o agente, sem você lembrar, aplica a convenção de privilégios e pede confirmação do projeto.
- O `AGENTS.md` não cresceu nos últimos três meses, mas o `catalogo-specs.md` sim.
