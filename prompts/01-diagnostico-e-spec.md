# Prompt 01 — Diagnóstico + SPEC de otimização de contexto (modo arquiteto)

| Item   | Valor                                                                                                    |
| ------ | -------------------------------------------------------------------------------------------------------- |
| Modelo | **{{MODELO_FORTE}}** — análise longa + redação de SPEC; não economize aqui                               |
| Modo   | sessão **nova**, modo padrão (não pule permissões). Aprove só leituras e a criação de `{{ARQUIVO_SPEC}}` |
| Saída  | **1 arquivo:** `{{ARQUIVO_SPEC}}`                                                                        |
| Prova  | delta do `git status` + manifestos `sha256sum` (o git pode não enxergar `.md`/`docs/`)                   |
| Depois | você lê a SPEC, ratifica as decisões D-n e responde **GO**                                               |

Troque todas as chaves entre chaves duplas (veja [00-variaveis.md](./00-variaveis.md)) e cole tudo a partir da linha abaixo.

---

# PAPEL

Você é um Arquiteto de Contexto de Agentes de IA. Vai projetar — **não executar** — a refatoração da documentação-contexto do repositório {{PROJETO}} (`{{REPO}}`, {{STACK}}), inspirada no padrão `affaan-m/ECC` (skills sob demanda, regra curta separada de conhecimento longo) e nos recursos nativos do Claude Code (rules com `paths:`, `@imports`, `permissions.deny`).

# ENTREGA ÚNICA

Criar `{{ARQUIVO_SPEC}}`, em pt-BR, no estilo das SPECs existentes (leia **só cabeçalho e títulos** de {{SPECS_MODELO}} — `sed -n '1,40p'` + `grep -n '^#'`). Ao terminar: resumo + **PARE** e aguarde "GO".

# TRAVAS INVIOLÁVEIS

1. **Única escrita no repo:** `{{ARQUIVO_SPEC}}`. Nada de `mkdir`, rascunho, script ou temporário dentro do repo.
2. **Scratch fora do repo, caminho absoluto POSIX** ({{SO_SHELL}}): `{{SCRATCH}}`. Confira com `ls "$SCR"` antes de gravar. Nunca passe um caminho `C:\...` cru para o Bash; nunca use `/tmp` no Git Bash.
3. **Bash somente leitura:** `wc ls find grep awk sed -n sha256sum file du git ls-files git log git status git diff git check-ignore -v git config --show-origin`. Proibido `git add/rm/commit/push/tag`, instalar, buildar, escrever. Única exceção: formatador **só** sobre `{{ARQUIVO_SPEC}}` (ver Fase 0 item i).
4. **Não leia segredos:** {{SEGREDOS}}. Para saber se existem: `test -f`. Nunca copie valor de segredo para a SPEC.
5. **Não use MCP de banco/produção** nesta tarefa — nem {{MCPS_DO_PROJETO}}, nem {{MCPS_PROIBIDOS}}.
6. Se já existir arquivo com o número `{{NUM_SPEC}}`, **pare e pergunte**. Confira antes com `ls {{PASTA_DOCS}} | grep -E '^(spec|prd)-{{NUM_SPEC}}'`.
7. Outras dúvidas: **não pergunte** — assuma, registre como D-n em §12 e siga.
8. **Snapshot de abertura (primeira ação):**
   - `git status --short > "$SCR/status-antes.txt"`
   - `sha256sum {{ARQUIVOS_RAIZ}} > "$SCR/raiz.sha"`
   - `find {{PASTA_DOCS}} .claude -type f <excluindo segredos> -print0 | sort -z | xargs -0 sha256sum > "$SCR/docs.sha"`
9. Em `find`/`grep -r`, exclua `node_modules`, `.next`, `.git`, `dist`, `build`, `.claude/worktrees`.
10. **Economia de contexto nesta sessão:** nunca leia uma SPEC/PRD/referência inteira; use `sed -n '1,40p'`, `grep -n '^#'`, `grep -n` dirigido. Varredura ampla → delegue a subagente e receba só a conclusão.
11. **Todo número da SPEC vem de medição desta sessão**, com o comando ao lado. Pistas deste prompt são para confirmar ou corrigir.

# PISTAS (reconfirme)

{{PISTAS}}

# FASE 0 — DIAGNÓSTICO (antes de escrever a SPEC; resultados vão para §2, com comando ao lado)

a. **Conjunto sempre carregado:** `wc -l -c` de `CLAUDE.md`, `.claude/CLAUDE.md`, `CLAUDE.local.md`, `AGENTS.md`, imports `@` transitivos (até 4 saltos, ignorando `@` dentro de crases), `.claude/rules/**/*.md` **sem** `paths:`, `~/.claude/CLAUDE.md` e `~/.claude/rules/` (fora do escopo — só registrar), descrições de skills, `.cursor/rules/*.mdc` com `alwaysApply: true`. Procure também `CLAUDE.md`/`AGENTS.md` aninhados (`find . -name CLAUDE.md -o -name AGENTS.md`, com exclusões). Tokens em duas taxas (bytes ÷ 3,5 e ÷ 4), marcadas como estimativa. Peça ao mantenedor o `/context` real de uma sessão nova (você não roda `/context`) e registre o peso de MCPs e skills como achado.
b. **Raio-X do arquivo raiz por seção `##`:** linhas, bytes, % do total. Classifique **cada** parágrafo: `INEGOCIÁVEL`, `ROTEÁVEL`, `PROCEDIMENTO`, `CATÁLOGO`, `ENVELHECE`, `DUPLICADO`, `INCORRETO`, `MECÂNICO` (proibição que `permissions.deny` impõe melhor). Liste as 10 linhas mais longas em bytes (`LC_ALL=C awk '{print length, NR}'`).
c. **Fatos × disco:** para cada número/versão/contagem do arquivo raiz, rode o comando que confirma. Tabela "afirmação | comando | real | classe".
d. **Inventário de `{{PASTA_DOCS}}/`:** arquivos e bytes por tamanho; reconcilie o índice do arquivo raiz com o disco nos dois sentidos; lacunas reais de numeração (cruze `spec-` e `prd-`).
e. **Mapa real do código para os globs:** `ls` das pastas de código. Cada glob proposto casa ≥ 1 arquivo hoje. Pastas ignoradas pelo git: valide com `find` (`git ls-files` devolve zero). Rotas com `[param]` precisam de escape `\[` (aspas simples no YAML).
f. **Rules/skills/permissões atuais:** `ls -R .claude` (sem ler `settings.local.json`), `.cursor/`; leia `.claude/settings.json` se existir (não é segredo).
g. **Links e dependentes:** links relativos quebrados no arquivo raiz; `grep -rln "AGENTS.md\|CLAUDE.md"` em docs e READMEs — classifique cada citação em histórica × ponteiro que precisa de redirecionamento.
h. **Versionamento e ignore:** `git check-ignore -v --no-index` para `CLAUDE.md`, `AGENTS.md`, `{{PASTA_DOCS}}/context/x.md`, `.claude/rules/x.md`, `.claude/skills/x/SKILL.md`, `.claude/settings.json`, `.cursor/rules/x.mdc`. Para as opções "tudo local" × "versionar o conjunto", proponha o diff do `.gitignore` (sem aplicar) e prove regra a regra que nenhum segredo é reaberto. Verifique também se um `.ignore`/`.rgignore` esconde pastas das ferramentas Grep/Glob do Claude Code.
i. **Formatador:** baseline de falhas do projeto. **Teste se o formatador pula arquivos ignorados** (ex.: Prettier respeita `.gitignore` e responde "ok" sem checar; nesse caso use `--ignore-path .prettierignore`). Ao terminar a SPEC, formate e cheque **só** `{{ARQUIVO_SPEC}}` do jeito que de fato verifica.
j. **Créditos/licença:** se houver texto de crédito obrigatório, ele continua acessível a partir do root; `LICENSE` intacto.

# PREMISSAS (§4 da SPEC — confirme na doc oficial com URL, ou marque "não verificado — validar no GO")

1. `.claude/rules/*.md` com `paths:` carrega só quando Read/Write/Edit (ou `cat`/`head` de um arquivo) toca arquivo casante; sem `paths:` carrega sempre. `paths` é o único campo lido; YAML inválido = carrega sempre. Funciona para arquivo ignorado pelo git?
2. Tarefa que cria arquivo novo sem casar glob não dispara rule → inegociáveis no contexto fixo.
3. `@arquivo` expande e sempre carrega (até 4 saltos); dentro de crases não expande. Logo: proibido `@` fora de crases em rule, `INDEX.md` e domínio.
4. Claude Code lê `AGENTS.md` nativamente **só se não houver `CLAUDE.md`**; com `CLAUDE.md` + `@AGENTS.md`, lê os dois sem duplicar. Cursor/Codex leem `AGENTS.md` sem expandir `@`.
5. Skills: descrição sempre no contexto (truncada em ~1.536 caracteres); corpo só ao invocar e fica na conversa; `SKILL.md` < 500 linhas.
6. Comentários HTML em bloco em `CLAUDE.md` são removidos antes de entrar no contexto.
7. `permissions.deny`: ordem deny → ask → allow; `Read(./x)` também cobre `cat`/`head`; `Bash(git commit *)`; `mcp__servidor` remove o servidor do contexto.
8. Cursor `.mdc`: `description`, `globs`, `alwaysApply` — confirme o formato de `globs`.
9. `CLAUDE.md` em subpasta carrega sob demanda; justifique em uma linha a escolha por rules com `paths:`.

# ECC — ADOTAR / NÃO ADOTAR (§3)

Adotar como ideia: skills como superfície de procedimento ("Quando usar / Como funciona / Exemplos"); regra curta separada de conhecimento longo; começar pelo mínimo. **Não** adotar: plugin, marketplace, hooks prontos, agentes/comandos do catálogo, cópias multi-harness. Diga explicitamente que, no ECC, as rules são sempre carregadas (a economia lá é escolher poucos pacotes) e que `paths:`, `INDEX.md` e `status.md` são adaptação nossa.

# ARQUITETURA-ALVO (§5 — valide contra o diagnóstico)

```
CLAUDE.md                        ≤ 15 L   @AGENTS.md + extras só do Claude
AGENTS.md                        ≤ 150 L  roteador cross-tool em texto puro: inegociáveis (≤ ~80 L),
                                          créditos, ponteiros para INDEX/status, blocos gerados intactos
{{PASTA_DOCS}}/context/status.md          único lugar de dado que envelhece, datado
{{PASTA_DOCS}}/context/INDEX.md  ≤ 100 L  tarefa → domínio → rule → skill
{{PASTA_DOCS}}/context/catalogo-specs.md  antigo índice da documentação
{{PASTA_DOCS}}/context/<dominio>.md       ≤ 120 L / ~6 KB cada
.claude/rules/<dominio>.md       ≤ 25 L, SEMPRE com paths:
.claude/skills/<nome>/SKILL.md   ≤ 100 L + arquivos ao lado
.claude/settings.json            permissions.deny (se ratificado)
.cursor/rules/<dominio>.mdc      só se {{FERRAMENTAS}} incluir Cursor
```

Orçamento inicial (ajuste após medir): sempre carregado do repo ≤ ~165 linhas e ≤ ~10 KB; redução ≥ 65% em bytes.

**Domínios — hipótese** (valide, una, divida; origem exata e globs reais): {{DOMINIOS_HIPOTESE}}

**Skills — hipótese:** {{SKILLS_HIPOTESE}}. Para cada: gatilhos da `description`, corpo, o que vai ao lado. Some o custo das descrições no orçamento.

# INVARIANTES (§6 — matriz: onde fica · como chega ao Cursor · qual teste prova · reforço mecânico)

Nada disto pode sair do contexto sempre carregado:

{{INVARIANTES}}

Inclua sempre: não ler/copiar segredos ({{SEGREDOS}}); MCPs permitidos ({{MCPS_DO_PROJETO}}) com confirmação do mantenedor antes de qualquer escrita, e proibidos ({{MCPS_PROIBIDOS}}); validação local `{{VALIDACAO}}`; blocos gerados por ferramenta intactos.

**Toda regra de domínio é derivada do disco deste repo** (código, comentários, migrações) — nunca de projeto-irmão. Conhecimento que hoje só existe no código e vai virar regra é D-n "conhecimento novo promovido", não migração de texto.

# FASES (§7 — corrija se discordar, justificando). Ordem aditiva, root por último.

| Fase | Conteúdo                                                                                                                                                                        |
| ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| F0   | versionamento (se D-n), `permissions.deny` (se D-n), manifesto `sha256sum` de {{PASTAS_INTOCAVEIS}} e de `{{PASTA_DOCS}}/`, backup do root fora do repo, baseline do formatador |
| F1   | `status.md`, `INDEX.md`, `catalogo-specs.md` — só cria                                                                                                                          |
| F2   | domínios: copiar → corrigir no destino → conferir → marcar origem como migrada; matriz 100%                                                                                     |
| F3   | rules (todas com `paths:`), espelho Cursor se D-n                                                                                                                               |
| F4   | skills                                                                                                                                                                          |
| F5   | troca do root — **única fase que remove**; rollback = backup da F0                                                                                                              |
| F6   | validação: medição, higiene, escopo, testes de roteamento                                                                                                                       |

Cada fase: entradas, saídas, passos, **critério de aceite mensurável**, rollback, modelo recomendado ({{MODELO_FORTE}} × {{MODELO_MEDIO}}, com o porquê) e fronteira de sessão.

# F6 — VALIDAÇÃO (§9, comandos exatos)

- **Escopo em duas camadas:** delta de `git status` **escrito por opção de versionamento** (qualquer outra linha é falha) + `sha256sum -c` dos manifestos da F0 para o que o git não vê.
- **Medição** antes/depois (bytes, linhas, tokens) + `/context` real; tabela meta × resultado.
- **Higiene:** links resolvem; globs casam; toda rule tem `paths:`; nenhum `@` fora de crases em rule/INDEX/domínio; orçamentos; blocos gerados idênticos ao backup; LF; formatador passa de verdade; segredos continuam ignorados.
- **Testes de roteamento** (sessão nova, um por vez), com critério passa/falha. Mínimo: um por domínio crítico + (a) arquivo **novo** sem rule casante → ainda aplica inegociáveis e acha o domínio pelo `INDEX.md`; (b) "leia o arquivo de segredo" → recusa (mecânica, se `deny`); (c) "faça o commit" → entrega o comando; (d) "aplique no banco" → confirma o projeto e pede autorização; recusa MCP proibido.
- **Paridade Claude ↔ Cursor** (se aplicável): corpo das rules idêntico sem frontmatter.

# ESTRUTURA DA SPEC

0 Metadados · 1 Objetivo/não-objetivos/escopo ({{PASTAS_INTOCAVEIS}} intocáveis) · 2 Baseline medido · 3 ECC adotar/não adotar · 4 Premissas (com URL) · 5 Arquitetura e orçamento · 6 Matriz de invariantes · 7 Fases F0–F6 · 8 Anexo A: rastreabilidade origem → destino · 9 Testes de roteamento · 10 Plano por sessão (modelo, fronteira, **prompt de abertura pronto de cada fase**; modelo de estrutura, se existir: {{PLANO_MODELO}}) · 11 Riscos · 12 Decisões D-1…D-n com recomendação.

Decisões mínimas: inegociáveis no `AGENTS.md` × `core.md`; versionar o conjunto (como bloco) × tudo local; `permissions.deny` × só prosa; Cursor sim/não; catálogo separado do INDEX; prompts de sessão antigos no catálogo; README; script de medição versionado × inline; conhecimento novo promovido a regra; achados fora de escopo (registrar, não corrigir).

# AO TERMINAR

1. `git status --short` × `$SCR/status-antes.txt` (delta esperado); `sha256sum -c "$SCR/raiz.sha"` (tudo OK); regenerar o manifesto de `{{PASTA_DOCS}}/` e `diff` — única diferença: `{{ARQUIVO_SPEC}}`. Mostre as saídas.
2. Saída do formatador sobre a SPEC (do jeito que verifica de verdade).
3. Resumo ≤ 25 linhas: baseline, meta, árvore, fases, D-n que dependem do mantenedor, riscos, o que ficou não verificado.
4. **PARE.** Aguarde "GO".
