# Passo 2 — Classificar

> **Objetivo:** etiquetar cada parágrafo do arquivo raiz com uma das 8 classes e descobrir o que está errado ou velho.
> **Quem:** o agente (você revisa). **Modelo:** o mais forte. **Muda o repo:** não.

Este passo e o próximo rodam juntos com o [prompt 01](../prompts/01-diagnostico-e-spec.md). Aqui está o que ele faz — útil para revisar o resultado ou fazer à mão num projeto pequeno.

## 2.1 As 8 classes

| Classe         | Pergunta-teste                                   |
| -------------- | ------------------------------------------------ |
| `INEGOCIÁVEL`  | Esquecer isso numa tarefa qualquer causa dano?   |
| `ROTEÁVEL`     | Só importa quando mexo em certos arquivos?       |
| `PROCEDIMENTO` | É uma sequência de passos que repito?            |
| `CATÁLOGO`     | É lista para consultar?                          |
| `ENVELHECE`    | Tem número, versão, contagem ou estado que muda? |
| `DUPLICADO`    | Já está escrito em outro arquivo?                |
| `INCORRETO`    | O disco desmente?                                |
| `MECÂNICO`     | Uma permissão impõe isso melhor que um pedido?   |

Um parágrafo pode ter duas (ex.: `INEGOCIÁVEL` + `MECÂNICO`).

## 2.2 Caça aos fatos velhos

Para cada número do arquivo raiz, rode o comando que o confirma. Exemplos:

| Afirmação no arquivo    | Comando de conferência                                 |
| ----------------------- | ------------------------------------------------------ |
| "migrações 001 → 054"   | `ls supabase/migrations \| tail -1`                    |
| "~1.600 chaves de i18n" | `node -e "…conta folhas de messages/en.json…"`         |
| "três rotas de cron"    | `git ls-files 'src/app/api/**/cron/route.ts' \| wc -l` |
| versões na tabela Stack | `grep -E '"(next\|react\|typescript)"' package.json`   |
| "N projetos Supabase"   | `claude mcp list` (você roda e cola)                   |

## 2.3 Índice × disco

Compare a lista de documentos do arquivo raiz com o disco nos dois sentidos:

```bash
for f in $(ls docs); do grep -q "docs/$f" AGENTS.md || echo "fora do índice: $f"; done
grep -oE '\]\(\./[^)#]+' AGENTS.md | sed 's/.*](\.\///' | sort -u \
  | while read p; do [ -e "$p" ] || echo "link quebrado: $p"; done
```

## 2.4 Quem depende do arquivo raiz

```bash
grep -rln "AGENTS.md" docs README.md CONTRIBUTING.md --exclude-dir=node_modules
```

Classifique cada citação: **histórica** (não muda) × **ponteiro para seção que vai mudar de lugar** (precisa de nota de redirecionamento ou âncora estável).

## Pronto quando

- [ ] cada seção/parágrafo tem classe, linhas, bytes e % do total
- [ ] lista de `INCORRETO`/`ENVELHECE` com o comando que prova
- [ ] lista de documentos fora do índice e de links quebrados
- [ ] lista de quem cita o arquivo raiz

Próximo: [Passo 3 — Desenhar a SPEC](./passo-3-desenhar-a-spec.md).
