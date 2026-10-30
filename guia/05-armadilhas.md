# 5. Armadilhas — erros reais que custaram caro

Cada item tem **sintoma**, **causa** e **como evitar**. Todos aconteceram (ou quase) em projetos reais.

---

### 5.1 "Tudo validado" — mas o validador nem olhou o arquivo

- **Sintoma:** `npx prettier --check docs/x.md` responde "_All matched files use Prettier code style!_" num arquivo claramente desalinhado.
- **Causa:** o Prettier respeita o `.gitignore`. Se `docs/` ou `*.md` estão ignorados, ele **pula o arquivo em silêncio**, mesmo passado pelo nome, e sai com código 0.
- **Evite:** `npx prettier --check --ignore-path .prettierignore <arquivo>`. Teste o validador num arquivo sabidamente errado antes de confiar nele.

### 5.2 `git status` limpo não prova nada

- **Sintoma:** "nenhuma mudança fora do escopo" — e o `AGENTS.md` foi editado.
- **Causa:** projetos-cliente costumam ignorar `*.md`, `docs/`, `.claude/`, `supabase/`. O git é cego exatamente para o que esta otimização mexe.
- **Evite:** antes de começar, rode `git check-ignore -v` em cada caminho-alvo e grave manifestos `sha256sum` das pastas que importam. Compare no fim. `git revert` também não é rollback: faça backup datado **fora do repo**.

### 5.3 Rules versionadas apontando para arquivos que não vêm no clone

- **Sintoma:** em outra máquina, a rule diz "leia `docs/context/supabase.md`" e o arquivo não existe.
- **Causa:** você reabriu `.claude/rules/` no `.gitignore`, mas `docs/` continua ignorado.
- **Evite:** decida o versionamento **como bloco**: `CLAUDE.md`, `AGENTS.md`, `.claude/rules`, `.claude/skills`, `docs/context` entram juntos ou ficam locais juntos.

### 5.4 Caminho do Windows criando lixo na raiz do repo

- **Sintoma:** aparece um arquivo `C:UsersFULANO~1AppDataLocalTemp…scratch.txt` na raiz — às vezes até rastreado pelo git.
- **Causa:** um caminho `C:\Users\…` passado cru para o Git Bash. As barras invertidas viram escape, sobra um nome relativo.
- **Evite:** no prompt, mande usar `SCR="$(cygpath -u "$TEMP")/tarefa"; mkdir -p "$SCR"`. Nunca `/tmp` (não é garantido no Git Bash) e nunca `C:\` cru.

### 5.5 A rule "sob demanda" que carrega sempre

- **Sintoma:** depois da otimização, `/context` mostra quase o mesmo peso.
- **Causa:** YAML do frontmatter inválido (aspa faltando, `\[` em aspas duplas, tab). O Claude Code ignora o frontmatter e carrega a rule **como se não tivesse `paths:`**.
- **Evite:** `claude --debug` mostra o erro de parse; o [checar-higiene.sh](../scripts/checar-higiene.sh) acusa rule sem `paths:`. Para `[token]`, use aspas simples: `'src/app/join/\[token\]/**'`.

### 5.6 Glob que não casa nada

- **Sintoma:** a rule nunca aparece.
- **Causa:** pasta renomeada, glob escrito de memória, `src/app/api/**/route.ts` quando o código está em `app/` sem `src/`.
- **Evite:** cada glob casa ≥ 1 arquivo **hoje**. Para pastas ignoradas pelo git, valide com `find`; `git ls-files` devolve zero nelas.

### 5.7 `@` que transforma sob demanda em fixo

- **Sintoma:** o arquivo de domínio aparece no `/context` de toda sessão.
- **Causa:** alguém escreveu `@docs/context/supabase.md` numa rule ou no `INDEX.md` alcançado por import.
- **Evite:** referência a domínio é caminho entre crases: "leia `docs/context/supabase.md`". `@` só no `CLAUDE.md`, e só para `AGENTS.md`.

### 5.8 Falso positivo do check de `@`

- **Sintoma:** o validador acusa `@redocly/cli`, `@xyflow/react`.
- **Causa:** nomes de pacote npm começam com `@`. Dentro de crases, não são import.
- **Evite:** o check é "nenhum `@` **fora de crases**", não "nenhum `@`".

### 5.9 Inegociável que só existe no Claude

- **Sintoma:** no Cursor, o agente usa o cliente `admin` num componente React.
- **Causa:** os inegociáveis foram para `docs/context/core.md`, puxado por `@` só no `CLAUDE.md`. O Cursor não expande `@`.
- **Evite:** inegociáveis **dentro** do `AGENTS.md`, em texto puro.

### 5.10 `CLAUDE.local.md` que desliga o `AGENTS.md`

- **Sintoma:** depois de criar um `CLAUDE.local.md` pessoal, o agente "esquece" tudo.
- **Causa:** num projeto sem `CLAUDE.md` que dependia da leitura nativa do `AGENTS.md`, o `CLAUDE.local.md` conta como `CLAUDE.md` e o `AGENTS.md` deixa de ser lido.
- **Evite:** mantenha um `CLAUDE.md` com `@AGENTS.md`.

### 5.11 Template que vira instrução

- **Sintoma:** ao abrir um arquivo em `docs/templates/`, aparece no contexto um "CLAUDE.md" de exemplo cheio de `{{PLACEHOLDERS}}`.
- **Causa:** arquivo chamado `CLAUDE.md` ou `AGENTS.md` numa subpasta é carregado sob demanda quando o agente mexe ali.
- **Evite:** nomes de template terminam em `.template.md` (como neste repositório).

### 5.12 O conector errado no banco errado

- **Sintoma:** migração aplicada no projeto Supabase de **outro** produto.
- **Causa:** conectores do claude.ai aparecem no Claude Code; dois projetos derivados um do outro têm o mesmo schema.
- **Evite:** inegociável "confirme o projeto com `get_project_url` antes de qualquer escrita" **e** `deny: mcp__<servidor-do-outro-projeto>` no `.claude/settings.json`.

### 5.13 Convenção copiada do projeto-irmão

- **Sintoma:** a rule de migração ensina um padrão que o banco deste projeto não tem.
- **Causa:** o projeto B derivou do A, mas recebeu uma migração de segurança que o A não tem. A rule foi copiada de B.
- **Evite:** toda regra é derivada **do disco deste repo** (comentários de migração, código), nunca do vizinho.

### 5.14 Fato envelhecido promovido a instrução

- **Sintoma:** o agente diz "há três rotas de cron" e não investiga as outras quatro.
- **Causa:** número escrito no contexto fixo há meses.
- **Evite:** números vão para `status.md` com data — ou viram comando ("liste com `git ls-files 'src/app/api/**/cron/route.ts'`").

### 5.15 Ler SPEC inteira "para entender"

- **Sintoma:** a sessão de otimização estoura o contexto antes de escrever a SPEC.
- **Causa:** SPECs de 100–150 KB lidas inteiras.
- **Evite:** `sed -n '1,40p'`, `grep -n '^#'`, `grep -n` dirigido. Delegue varredura ampla a um subagente.

### 5.16 Encolher o root primeiro

- **Sintoma:** depois da F1, o agente perdeu uma regra que ainda não tinha destino.
- **Causa:** ordem destrutiva.
- **Evite:** ordem **aditiva**: cria destinos → confere → rules → skills → só então encolhe o root. Uma fase só remove conteúdo.

### 5.17 Testar na mesma sessão

- **Sintoma:** "os testes de roteamento passaram" — mas o contexto antigo ainda estava carregado.
- **Causa:** o contexto fixo só é relido ao abrir sessão.
- **Evite:** fronteira de sessão entre fases; testes de roteamento sempre em sessão **nova**.

Próximo: [6. Manutenção](./06-manutencao.md).
