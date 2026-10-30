# Prompt 02 — Execução de fase (F0–F6)

> Use **depois do GO**. Uma sessão nova por fase. Se a SPEC já trouxe prompts de abertura próprios (§10), prefira os dela; estes são o modelo genérico.

## Bloco comum — cole no início de toda fase

```
# CONTEXTO
Projeto {{PROJETO}} ({{REPO}}). Estamos executando a {{ARQUIVO_SPEC}}, ratificada
pelo mantenedor em {{DATA_GO}} com as decisões: {{DECISOES_RATIFICADAS}}.
Esta sessão executa SOMENTE a fase {{FASE}}. Leia da SPEC apenas: §5 (arquitetura),
§6 (invariantes), §7.{{FASE}} (esta fase) e as linhas do Anexo A desta fase.
Não leia o resto da SPEC.

# TRAVAS
- Escreva só os arquivos listados em §7.{{FASE}} "Saídas". Nada fora disso.
- Não leia {{SEGREDOS}}. Não use MCP de banco. Não faça git add/commit/push:
  ao final, entregue os comandos prontos para o mantenedor.
- Scratch: {{SCRATCH}} (fora do repo).
- Nunca leia SPEC/PRD/referência inteira: sed -n / grep -n dirigido.
- Antes de começar: confira o manifesto da F0 (sha256sum -c) e o critério de
  saída da fase anterior. Se falhar, PARE e reporte.

# AO TERMINAR
1. Mostre o critério de aceite de §7.{{FASE}}, item a item, com a evidência
   (comando + saída).
2. Mostre `git status --short` e o diff do manifesto: só os arquivos previstos.
3. Liste o que ficou pendente ou divergiu da SPEC (com proposta).
4. PARE. A próxima fase roda em sessão nova.
```

## Complemento por fase

### F0 — versionamento, permissões, baseline · {{MODELO_MEDIO}}

```
Nesta fase: (1) aplique o diff de .gitignore de §7.F0 SE a D-n de versionamento
foi ratificada; prove com `git check-ignore -v` que {{SEGREDOS}} continuam
ignorados. (2) Crie/mescle .claude/settings.json com o permissions.deny de §7.F0
SE ratificado — preserve as chaves existentes. (3) Grave manifesto sha256sum de
{{PASTAS_INTOCAVEIS}} e de {{PASTA_DOCS}}/ em "$SCR/f0-*.sha" e copie
CLAUDE.md e AGENTS.md para "$SCR/backup/". (4) Registre o baseline do formatador.
Informe ao mantenedor o caminho do backup — ele deve guardá-lo.
```

### F1 — fundações · {{MODELO_MEDIO}}

```
Crie {{PASTA_DOCS}}/context/status.md, INDEX.md e catalogo-specs.md conforme §7.F1.
status.md: cada fato com data {{DATA}} e o comando que o confere.
catalogo-specs.md: TODOS os documentos do disco (reconciliação de §2), um por
linha, com assunto em ≤ 15 palavras. INDEX.md: tabela tarefa → domínio → rule
→ skill, com os nomes de §5 (os arquivos ainda não existem; ok).
Nenhum `@` fora de crases. Nenhuma remoção.
```

### F2 — domínios · {{MODELO_FORTE}} (redação) / {{MODELO_MEDIO}} (conferência)

```
Crie os arquivos de domínio de §5, seguindo o Anexo A linha a linha:
copie o parágrafo de origem → corrija no destino o que era INCORRETO/ENVELHECE
(nunca copie o erro) → confira cada caminho citado com ls/git ls-files/find →
marque a linha do Anexo A como migrada. Não remova nada da origem.
Orçamento: ≤ 120 linhas / ~6 KB por arquivo. Ao final, a matriz deve estar 100%.
Se forem muitos domínios, faça em lotes e pare entre lotes se o contexto passar
de ~60%.
```

### F3 — rules · {{MODELO_MEDIO}}

```
Crie .claude/rules/<dominio>.md para cada domínio de §5: frontmatter com paths:
(SÓ globs que casam ≥ 1 arquivo hoje — prove com git ls-files ou find), ≤ 25
linhas, só decisões curtas + "Detalhes: leia `{{PASTA_DOCS}}/context/<dominio>.md`".
Rotas com [param]: aspas simples e \[ \]. Se a D-n do Cursor foi ratificada,
crie .cursor/rules/<dominio>.mdc com o MESMO corpo, globs e alwaysApply: false.
Rode a checagem de higiene da SPEC.
```

### F4 — skills · {{MODELO_FORTE}}

```
Crie .claude/skills/<nome>/SKILL.md para cada skill ratificada: description de
1 frase começando pelo gatilho; corpo ≤ 100 linhas com "Quando usar / Passos /
Verificação / Não faça"; material longo em arquivo ao lado ou ponteiro para
{{PASTA_DOCS}}/references/ (nunca copie). Procedimento com efeito colateral:
disable-model-invocation: true. Some o tamanho das descrições e compare com o
orçamento de §5.
```

### F5 — troca do root · {{MODELO_FORTE}}

```
Pré-condição: Anexo A 100% migrado e F3/F4 aceitas; backup em "$SCR/backup/"
conferido por sha256sum. Reescreva AGENTS.md conforme §5 (inegociáveis dentro,
texto puro, ponteiros para INDEX/status/catálogo, créditos, blocos gerados byte a
byte) e CLAUDE.md (@AGENTS.md + extras só do Claude). Prove: wc -l -c dentro do
orçamento; diff dos blocos gerados contra o backup = vazio; todo inegociável de
§6 presente (grep de cada um). Rollback: restaurar do backup.
```

### F6 — validação · {{MODELO_MEDIO}} + revisor independente

```
Rode a bateria de §9: medição antes/depois, higiene, escopo (delta esperado
escrito por opção de versionamento + sha256sum -c), e prepare os testes de
roteamento para o mantenedor rodar um por sessão. Gere a tabela meta × resultado.
Depois, peça a um subagente SEM este histórico: "compare o backup do AGENTS.md
com o novo AGENTS.md + INDEX.md + domínios e liste qualquer regra sem destino".
```
