# 4. Modelos prontos

> Copie, troque as `{{CHAVES}}`, apague o que não se aplica. Todos assumem que o `AGENTS.md` já carrega os inegociáveis — por isso não os repetem.

Índice: [1 PRD](#1-prd) · [2 Bug](#2-bug) · [3 Fase de SPEC](#3-fase-de-spec) · [4 Refactor](#4-refactor) · [5 Migração de banco](#5-migração-de-banco) · [6 Revisão independente](#6-revisão-independente) · [7 Investigação](#7-investigação) · [8 Fechamento](#8-fechamento) · [9 Handoff de sessão](#9-handoff-de-sessão)

---

## 1. PRD

**Modelo:** forte · **Sessão:** nova

```
# MODO
Arquiteto de produto. Escreva um PRD — não escreva código, não crie outros arquivos.

# OBJETIVO
{{PROBLEMA_EM_2_LINHAS}}. Quem usa: {{PERSONAS}}. Sucesso = {{METRICA_OU_COMPORTAMENTO}}.

# LEIA
- docs/context/INDEX.md (para achar os domínios envolvidos) e só os domínios que ele apontar
- {{NOTAS_OU_REFERENCIA}} (só títulos + trechos com grep)
Não leia código de implementação; use ls/grep para confirmar que algo existe.

# ENTREGÁVEL
docs/prd-{{NUM}}-{{SLUG}}.md, no estilo de {{PRD_MODELO}} (só o cabeçalho):
problema, personas, escopo/fora de escopo, fluxos, regras de negócio,
riscos (LGPD/segurança/custo), métricas, decisões D-1…D-n com recomendação.

# DÚVIDAS
Não pergunte; registre como D-n.

# AO TERMINAR
Resumo ≤ 15 linhas + lista de D-n que dependem de mim. PARE.
```

## 2. Bug

**Modelo:** médio (forte se for concorrência/segurança) · **Sessão:** nova

```
# MODO
Executor. Corrija um bug — sem refactor oportunista.

# SINTOMA
{{O_QUE_ACONTECE}} quando {{PASSOS}}. Esperado: {{O_QUE_DEVERIA}}.
Evidência: {{ERRO_LOG_OU_PRINT}}.

# PONTO DE PARTIDA
Provável: {{ARQUIVO_OU_MODULO}}. Se o sintoma bater com "Armadilhas" de algum
domínio em docs/context/, leia esse domínio primeiro.

# TRAVAS
Escreva só nos arquivos do defeito e no teste co-locado.

# PRONTO QUANDO
1. Um teste que reproduz o bug falha antes e passa depois.
2. {{COMANDO_DE_TESTE}} passa.

# AO TERMINAR
Causa-raiz em 2–3 linhas, diff resumido, comando de commit. PARE.
Se a causa estiver fora do escopo de escrita, PARE e explique antes de mexer.
```

## 3. Fase de SPEC

**Modelo:** médio · **Sessão:** nova por fase

```
# MODO
Executor da fase {{FASE}} da {{ARQUIVO_SPEC}}. Não replaneje.

# LEIA (e só isto)
{{ARQUIVO_SPEC}}: §5, §6, §7.{{FASE}} e as linhas do Anexo A desta fase.

# TRAVAS
Escreva só o que §7.{{FASE}} lista em "Saídas". Antes de começar, confira o
critério de saída da fase anterior; se falhar, PARE.

# PRONTO QUANDO
Critério de aceite de §7.{{FASE}}, item a item, com comando + saída.

# AO TERMINAR
Evidências, divergências da SPEC (com proposta), comando de commit. PARE.
A próxima fase é outra sessão.
```

## 4. Refactor

**Modelo:** forte para planejar, médio para executar · **Sessão:** nova

```
# MODO
Refactor sem mudança de comportamento.

# ALVO
{{O_QUE}} em {{ONDE}}, para {{MOTIVO_MENSURAVEL}} (ex.: remover duplicação
entre A e B; reduzir arquivo de 800 para < 300 linhas).

# REDE DE SEGURANÇA
Antes de editar: rode {{COMANDO_DE_TESTE}} e guarde a saída. Se a cobertura do
alvo for fraca, escreva primeiro testes de caracterização (comportamento atual).

# TRAVAS
Nenhuma mudança de API pública, schema, texto visível ou dependência.

# PRONTO QUANDO
Mesmos testes passam, {{VALIDACAO}} passa, e o objetivo mensurável foi atingido.

# AO TERMINAR
Antes/depois (linhas, arquivos), diff por arquivo, comando de commit. PARE.
```

## 5. Migração de banco

**Modelo:** forte · **Sessão:** nova

```
# MODO
Escreva a migração — NÃO aplique.

# OBJETIVO
{{MUDANCA_DE_SCHEMA}} para suportar {{FEATURE}} ({{ARQUIVO_SPEC}} §{{SECAO}}).

# TRAVAS
- Use a skill de nova migração, se existir; senão siga a rule do domínio de banco.
- Próximo número: confira com `ls {{PASTA_MIGRACOES}}`.
- Não use MCP para escrever. Leitura de schema por MCP só no projeto
  {{PROJETO_BANCO}}, conferido com get_project_url.

# ENTREGÁVEL
{{PASTA_MIGRACOES}}/NNN_{{SLUG}}.sql + consulta de verificação + o desfazer
comentado.

# AO TERMINAR
SQL resumido, riscos (lock, RLS, grants), o comando/ferramenta para EU aplicar
e o que rodar depois (advisor de segurança). PARE.
```

## 6. Revisão independente

**Modelo:** forte · **Sessão:** nova, **sem** o histórico de quem implementou

```
# MODO
Revisor. Você não escreveu este código. Não corrija — aponte.

# MATERIAL
- `git diff {{BASE}}...HEAD -- {{PASTAS}}`
- {{ARQUIVO_SPEC}} §6 (invariantes) e §7 (critérios de aceite)
Não leia relatórios ou conclusões de quem implementou.

# PROCURE
Violação de invariante; critério de aceite não atendido; bug de lógica, borda,
concorrência; segurança (RLS, service_role, SSRF, segredos); teste que não
testa de verdade; texto sem i18n.

# SAÍDA
Tabela: severidade (bloqueia/importante/menor) | arquivo:linha | problema |
cenário concreto que falha. Máximo 15 itens, mais graves primeiro. Lista vazia
é resposta válida. PARE.
```

## 7. Investigação

**Modelo:** médio (forte se a causa for obscura) · **Sessão:** nova

```
# MODO
Investigador. Somente leitura. A saída é um relatório na conversa.

# PERGUNTA
{{PERGUNTA_PRECISA}} (ex.: "por que o disparo agendado de ontem 18h não saiu?")

# COMO
Comece pelo INDEX.md para achar o domínio. Formule até 3 hipóteses; para cada
uma, o comando que a confirma ou descarta. Varredura ampla → subagente, e
receba só a conclusão.

# SAÍDA
Hipótese confirmada + evidência (comando + saída), hipóteses descartadas em 1
linha cada, próximo passo recomendado. ≤ 20 linhas. PARE.
```

## 8. Fechamento

**Modelo:** médio · **Sessão:** a da última fase, ou nova

```
# MODO
Fechamento da feature {{ARQUIVO_SPEC}}.

# FAÇA
1. Rode {{VALIDACAO}} e mostre o resultado.
2. Verifique se o contexto precisa mudar e proponha o diff MÍNIMO:
   - catalogo-specs.md: linha da SPEC (sempre)
   - status.md: números/estados que mudaram
   - domínio + rule: regra nova de domínio
   - skill: procedimento que vai se repetir
   - AGENTS.md: SÓ se for inegociável novo — justifique em 1 linha
3. Atualize o status da SPEC para "Implementada" com a data.
4. Entregue os comandos de commit (mensagem incluída). Não execute.
PARE.
```

## 9. Handoff de sessão

Quando a sessão ficou longa e você vai continuar em outra.

```
Escreva "$SCR/handoff-{{SLUG}}.md" (fora do repo), ≤ 40 linhas:
objetivo; o que está pronto (arquivos); o que falta (passos); decisões tomadas
nesta sessão e por quê; comandos para conferir o estado; armadilhas que achamos.
Não repita o que está na SPEC — aponte a seção. PARE.
```

Na sessão nova: "_Leia `<caminho>/handoff-x.md` e continue do item 'o que falta'._" — e `/clear` na antiga.
