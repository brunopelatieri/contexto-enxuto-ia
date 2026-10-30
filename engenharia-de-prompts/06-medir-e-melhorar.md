# 6. Medir e melhorar

## O painel

| Comando / recurso        | Olhe para                                                                       | Quando                               |
| ------------------------ | ------------------------------------------------------------------------------- | ------------------------------------ |
| `/context`               | memory files, MCP, skills, conversa — quanto cada um ocupa                      | início de sessão; quando ficar lento |
| `/usage`                 | tokens da sessão, % de entrada servida do cache, falhas de cache, recomendações | fim de tarefa grande                 |
| Status line com contexto | % da janela usada em tempo real                                                 | sempre (configure uma vez)           |
| `/doctor prompt-audit`   | instruções conflitantes, referências mortas                                     | mensal                               |
| `/insights`              | padrões de uso e atrito (pedidos mal entendidos)                                | trimestral                           |

## Sinais de inchaço e o que fazer

| Sinal                                             | Provável causa                                                 | Ação                                                        |
| ------------------------------------------------- | -------------------------------------------------------------- | ----------------------------------------------------------- |
| `/context` de abertura alto antes de você digitar | contexto fixo ou MCP                                           | medidor + `/mcp` (desligue o que não usa)                   |
| Compactação automática em tarefa média            | fase grande demais ou leituras inúteis                         | divida a fase; aponte em vez de explorar                    |
| Cache baixo em `/usage` (< ~70%)                  | pausas longas, mudanças no prefixo                             | não edite instruções no meio; `/clear` + handoff após pausa |
| O agente ignora uma regra                         | regra diluída, contraditória, ou só numa rule que não disparou | `/doctor prompt-audit`; inegociável? → `AGENTS.md`          |
| `/usage` recomenda "Trim CLAUDE.md"               | contexto fixo passou do orçamento                              | [auditoria](../prompts/04-auditoria-periodica.md)           |

## `/compact` × `/clear`

| Use               | Quando                                                                                                                  |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `/clear`          | mudou de assunto; vai começar outra fase; depois de escrever handoff. **Custo zero.**                                   |
| `/compact <foco>` | precisa continuar o mesmo trabalho e o detalhe da conversa importa. Custa uma requisição grande (lê tudo para resumir). |

Instrução permanente de compactação (1–3 linhas, vale o custo) no `AGENTS.md` ou `CLAUDE.md`:

```markdown
## Compactação

Ao compactar, preserve: arquivos alterados, comandos de verificação e resultado,
decisões D-n tomadas na sessão. Descarte saídas de teste já resolvidas.
```

## Experimento de 10 minutos

1. Sessão nova, `/context`, anote.
2. Peça uma tarefa pequena típica ("adicione um texto na tela X").
3. `/context` de novo: quais rules entraram? Alguma que não devia? Faltou alguma?
4. `/usage`: tokens, cache.
5. Ajuste uma coisa (um glob, uma descrição de skill) e repita.

Faça isso com 3–4 tarefas típicas do seu dia. É o melhor teste de que o roteamento funciona para **o seu** jeito de trabalhar.
