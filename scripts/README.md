# Scripts

Bash puro + `awk`/`find`/`grep`. Rodam em Linux, macOS (bash ≥ 4 para o `checar-higiene.sh`: `brew install bash`) e Git Bash no Windows. **Somente leitura** — nenhum deles altera o projeto.

| Script                                       | O que faz                                                                                                                                                                                                   | Quando                      |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| [medir-contexto.sh](./medir-contexto.sh)     | mede o que carrega sozinho: `CLAUDE.md`/`AGENTS.md`, imports `@` (até 4 saltos), rules sem `paths:`, descrições de skills, arquivos do usuário, `CLAUDE.md` aninhados, raio-X por seção, linhas mais longas | antes e depois; mensal      |
| [checar-higiene.sh](./checar-higiene.sh)     | rule sem `paths:`, glob que não casa nada, `\[` em aspas duplas, `@` fora de crases, links quebrados, orçamentos, paridade `.claude` ↔ `.cursor`                                                            | depois de cada fase; mensal |
| [preencher-prompt.sh](./preencher-prompt.sh) | troca `{{CHAVE}}` pelos valores de um `.env` e lista o que faltou                                                                                                                                           | ao preparar um prompt       |

## Uso

```bash
# da raiz do SEU projeto (mantenha os scripts fora dele, ex.: ~/ferramentas/contexto/)
bash ~/ferramentas/contexto/medir-contexto.sh | tee ~/contexto-antes.txt
CONTEXT_DIR=docs/context bash ~/ferramentas/contexto/checar-higiene.sh
```

## Limites conhecidos

- **Tokens são estimativa** (bytes ÷ 4 e ÷ 3,5). O número real é o `/context` numa sessão nova, que também mostra MCP, prompt de sistema e memória automática — invisíveis para um script.
- O medidor só olha a pasta atual, não as pastas acima dela (o Claude Code também carrega `CLAUDE.md` de pastas-pai). Em monorepo, rode também na raiz.
- Imports são resolvidos **relativos ao arquivo que importa**, como no Claude Code. Um aviso "import não encontrado" quase sempre é caminho escrito relativo à raiz por engano.
- O check de glob usa a expansão do bash (`globstar`), que se comporta como o matcher do Claude Code nos casos comuns (`**`, `*`, `{a,b}`, `\[`). Padrões exóticos: confira com `claude --debug`.
- Comentários HTML em bloco são descontados na coluna "s/ html" (o Claude Code os remove de `CLAUDE.md` e imports). Em rules, conte o valor bruto.
