# Prompts prontos

Todos os prompts usam **chaves entre chaves duplas** — `{{PROJETO}}`, `{{ARQUIVO_SPEC}}` — para você trocar com localizar-e-substituir.

## Como usar (3 minutos)

1. Abra [00-variaveis.md](./00-variaveis.md) e preencha a coluna "Seu valor".
2. Copie o prompt que vai usar para um arquivo de rascunho.
3. Para cada linha da tabela, localize `{{CHAVE}}` e substitua pelo valor. No VS Code: `Ctrl+H`, ou rode o script abaixo.
4. Confira que não sobrou chave: procure por `{{`.
5. Cole numa sessão **nova** do Claude Code, na raiz do projeto, com o modelo indicado no topo do prompt.

### Substituição automática

Salve suas variáveis como `minhas-variaveis.env` (formato `CHAVE=valor`, uma por linha, sem aspas; para listas use `\n` literal) e rode:

```bash
bash scripts/preencher-prompt.sh minhas-variaveis.env prompts/01-diagnostico-e-spec.md > meu-prompt.md
```

A substituição é literal (`&&`, `/`, `$` no valor ficam como estão). As chaves que sobraram aparecem como `FALTA: {{CHAVE}}` no terminal.

Exemplo de `minhas-variaveis.env`:

```ini
PROJETO=ZAP CRM BR
REPO=zap-crm-br-client
NUM_SPEC=079
ARQUIVO_SPEC=docs/spec-079-otimizacao-de-contexto.md
VALIDACAO=npm run typecheck && npm run lint && npm run test && npm run build
INVARIANTES=1. Commit e push manuais.\n2. `admin.ts` só no servidor.\n3. i18n: `en.json` é a fonte da verdade.
```

## Os prompts

| Arquivo                                                    | Quando                                | Modelo         | Escreve no repo?   |
| ---------------------------------------------------------- | ------------------------------------- | -------------- | ------------------ |
| [01-diagnostico-e-spec.md](./01-diagnostico-e-spec.md)     | uma vez, para desenhar tudo           | o mais forte   | só a SPEC          |
| [02-execucao-de-fase.md](./02-execucao-de-fase.md)         | depois do GO, um bloco por fase       | varia          | o que a fase prevê |
| [03-testes-de-roteamento.md](./03-testes-de-roteamento.md) | depois da F5, sessão nova por teste   | o do dia a dia | não                |
| [04-auditoria-periodica.md](./04-auditoria-periodica.md)   | mensal, ou quando passar do orçamento | médio          | só o relatório     |

## Por que os prompts são longos

Um prompt de arquitetura bem amarrado custa ~10–15 mil tokens **uma vez** e evita sessões de retrabalho que custam centenas de milhares. As travas ("única escrita permitida", "não leia segredos", "não use MCP de banco") existem porque cada uma já falhou em algum projeto. Corte o que não se aplica ao seu, mas leia antes de cortar.
