# 2. Mecanismos do Claude Code — referência verificada

> Conferido na documentação oficial em **2026-10-30** (links em [CREDITOS.md](../CREDITOS.md)). As versões mínimas citadas são as da doc; se a sua for mais antiga, atualize ou reconfira.

## 2.1 O que carrega ao abrir a sessão

| Arquivo                                                                 | Carrega                                    | Observação                                            |
| ----------------------------------------------------------------------- | ------------------------------------------ | ----------------------------------------------------- |
| `CLAUDE.md` gerenciado (política da organização)                        | sempre                                     | não pode ser excluído                                 |
| `~/.claude/CLAUDE.md`                                                   | sempre                                     | pessoal, vale para todo projeto                       |
| `CLAUDE.md` / `.claude/CLAUDE.md` da pasta atual **e das pastas acima** | sempre                                     | todos são concatenados, do mais alto ao mais próximo  |
| `CLAUDE.local.md`                                                       | sempre                                     | anexado depois do `CLAUDE.md` da mesma pasta          |
| `AGENTS.md`                                                             | **só se não houver `CLAUDE.md`** (ver 2.3) | lido nativamente a partir da v2.1.277                 |
| Tudo que esses arquivos importam com `@caminho`                         | sempre                                     | recursivo, até **4 saltos**                           |
| `.claude/rules/**/*.md` **sem** `paths:`                                | sempre                                     | mesma prioridade do `.claude/CLAUDE.md`               |
| `~/.claude/rules/**/*.md` sem `paths:`                                  | sempre                                     | regras pessoais                                       |
| Descrição de cada skill                                                 | sempre                                     | o corpo não; ver 2.6                                  |
| Memória automática (`MEMORY.md`)                                        | sempre                                     | primeiras **200 linhas ou 25 KB**                     |
| Nomes de ferramentas MCP + instruções dos servidores                    | sempre                                     | definições completas são adiadas por padrão (ver 2.8) |

## 2.2 O que carrega sob demanda

| Arquivo                                      | Quando entra                                                                                                 |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `CLAUDE.md` em **subpasta**                  | quando o Claude lê, escreve ou edita outro arquivo daquela subpasta                                          |
| `AGENTS.md` em subpasta                      | quando o Claude abre um arquivo ali com Read e a subpasta não tem `CLAUDE.md`                                |
| Rule com `paths:`                            | quando o Claude usa **Read, Write ou Edit** num arquivo que casa — ou o vê com `cat`/`head` de um arquivo só |
| Corpo de uma skill                           | quando você digita `/nome` ou o Claude decide invocá-la                                                      |
| Qualquer arquivo citado por caminho em texto | só se o Claude decidir abri-lo                                                                               |

> ⚠️ **Implicação de projeto:** uma tarefa que **cria** um arquivo novo numa pasta sem arquivos casantes, ou que só roda `grep -r`, pode não disparar nenhuma rule. Por isso os inegociáveis **nunca** podem morar só numa rule com `paths:`.

## 2.3 `CLAUDE.md` × `AGENTS.md`

| Situação no repositório                              | O que o Claude Code lê                                  |
| ---------------------------------------------------- | ------------------------------------------------------- |
| Só `AGENTS.md`                                       | o `AGENTS.md`                                           |
| `AGENTS.md` **e** `CLAUDE.md` (ou `CLAUDE.local.md`) | **só** os `CLAUDE.md`                                   |
| `CLAUDE.md` que contém `@AGENTS.md`                  | o `CLAUDE.md` com o `AGENTS.md` incluído (sem duplicar) |

- A configuração **Project instructions** (`/config`) muda isso: `claude-md-and-agents-md` lê os dois.
- Atenção: criar um `CLAUDE.local.md` pessoal num projeto que depende só de `AGENTS.md` **faz o Claude parar de ler o `AGENTS.md`**.
- Cursor e Codex leem `AGENTS.md` e **não** expandem `@`.
- No Windows, prefira `@AGENTS.md` dentro do `CLAUDE.md` a um symlink (symlink exige modo desenvolvedor e o git pode gravá-lo como texto).

**Padrão recomendado para projetos multi-ferramenta:** `AGENTS.md` é a fonte única, escrita em texto puro, com os inegociáveis dentro dele. `CLAUDE.md` tem `@AGENTS.md` e, no máximo, extras que só o Claude usa.

## 2.4 `@imports`

- Sintaxe: `@caminho/arquivo.md` em qualquer linha. Caminho relativo resolve a partir do arquivo que importa.
- Recursivo, **máximo 4 saltos**.
- **Ignorado dentro de code span e bloco de código**: `` `@README` `` fica literal; `@README` fora de crases importa. Logo `` `@redocly/cli` `` é seguro.
- Import que aponta para fora da pasta de trabalho pede aprovação na primeira vez.
- **Não reduz custo:** o importado carrega junto com quem importa. Nunca use `@` em rule, índice ou arquivo de domínio — isso transforma carga sob demanda em carga fixa.

## 2.5 `.claude/rules/`

```markdown
---
paths:
  - 'src/app/api/v1/**'
  - 'public/openapi*.json'
---

# API pública

- Toda mudança atualiza juntos `docs/public-api.md`, `public/openapi.json` e `public/openapi.pt-BR.json`.
- Detalhes: leia `docs/context/api-publica.md`.
```

- Descoberta recursiva: `.claude/rules/**/*.md`.
- **`paths` é o único campo de frontmatter lido.** Qualquer outro (`description`, `globs`, `alwaysApply`) é ignorado sem erro. O frontmatter é removido antes de entrar no contexto.
- `paths` aceita lista YAML ou string separada por vírgulas. Suporta `**`, `*`, chaves `{ts,tsx}` (com orçamento de 1.000 padrões expandidos por rule).
- `[` abre classe de caracteres: para rotas Next.js como `app/join/[token]/`, escape com barra invertida, de preferência entre **aspas simples** no YAML (em aspas duplas `\[` é escape inválido e quebra o frontmatter inteiro): `'src/app/join/\[token\]/**'`. Parênteses de _route groups_ (`(dashboard)`) não precisam de escape.
- **YAML inválido → a rule carrega como se não tivesse `paths`** (ou seja, sempre). Rode `claude --debug` para ver o erro. Isso faz uma rule "sob demanda" virar fixa sem você perceber.
- Padrões são relativos à pasta que contém o `.claude`.
- Symlinks são suportados (bom para compartilhar rules entre projetos); destino fora do projeto pede aprovação.

## 2.6 Skills

```
.claude/skills/nova-migracao/
├── SKILL.md          ← obrigatório, enxuto
├── referencia.md     ← carregado só se o SKILL.md mandar ler
└── scripts/
    └── proximo-numero.sh   ← executado, não carregado
```

- Frontmatter: `name` (padrão = nome da pasta) e `description` (recomendado). Outros: `when_to_use`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `disallowed-tools`, `model`, `effort`, `context: fork`, `paths`…
- **A descrição fica sempre no contexto**; `description` + `when_to_use` são truncados em **1.536 caracteres** na listagem. Ponha o gatilho principal na primeira frase.
- **O corpo entra quando invocado e fica na conversa** até o fim. Após a compactação automática, cada skill invocada é reanexada com até 5.000 tokens (25.000 no total).
- Doc oficial: mantenha `SKILL.md` **abaixo de 500 linhas**; material pesado em arquivos ao lado.
- `disable-model-invocation: true` impede o Claude de invocar sozinho (para procedimentos com efeito colateral, como deploy).
- Comandos em `.claude/commands/` viraram skills (continuam funcionando).

## 2.7 Comentários HTML

Comentários HTML **em bloco** (`<!-- nota -->`) em `CLAUDE.md` são **removidos** antes de entrar no contexto. Use-os para notas de manutenção sem custo. Dentro de bloco de código, são preservados. Ao abrir o arquivo com Read, aparecem.

> Consequência: marcadores como `<!-- BEGIN:nextjs-agent-rules -->` não custam tokens, mas **preserve-os** no arquivo — a ferramenta que os gerou depende deles.

## 2.8 MCP

- As definições de ferramentas MCP são **adiadas por padrão**: só nomes e instruções do servidor entram até o Claude usar uma ferramenta.
- Mesmo assim, cada servidor soma nomes e instruções. `/context` mostra o peso. Desligue em `/mcp` o que não usa no projeto.
- CLIs (`gh`, `aws`, `supabase`) custam menos contexto que MCP equivalente.
- Conectores do claude.ai podem aparecer no Claude Code. Num projeto com vários bancos, isso é **risco**, não só custo (ver 2.9).

## 2.9 Permissões — o mecanismo que não custa tokens

> "_Permission rules are enforced by Claude Code, not by the model._" Instrução em `CLAUDE.md` molda o que o Claude **tenta**; permissão decide o que ele **consegue**.

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./.mcp.json)",
      "Read(./docs/deploy/**)",
      "Bash(git commit *)",
      "Bash(git push *)",
      "mcp__supabase-producao"
    ]
  }
}
```

- Ordem de avaliação: **deny → ask → allow**. A primeira que casa decide; `allow` não abre exceção em `deny`.
- `Read`/`Edit` usam sintaxe de `.gitignore`: `./x` (relativo à pasta atual), `/x` (relativo à origem do arquivo de settings — **não** é absoluto), `//x` (absoluto), `~/x` (home). No Windows, `C:\` vira `/c/`.
- Deny de `Read` também cobre `cat`, `head`, `tail`, `sed`, `tee` e redirecionamentos — mas **não** um `grep -r` rodado na pasta. Para garantia forte, use sandbox ou hook.
- `Bash(git commit *)` e `Bash(git commit:*)` são equivalentes. A regra casa o texto do comando; `git -C . commit` passa. É uma barreira, não um cofre.
- `mcp__servidor` em `deny` remove o servidor inteiro do contexto (economiza tokens **e** evita uso).
- `.claude/settings.json` é do projeto (pode versionar); `.claude/settings.local.json` é pessoal (não versione).

## 2.10 Ferramentas de diagnóstico

| Comando                | Para quê                                                                                         |
| ---------------------- | ------------------------------------------------------------------------------------------------ |
| `/context`             | peso de cada parte do contexto agora (instruções, MCP, skills, conversa)                         |
| `/usage`               | tokens da sessão, cache, e recomendações ("Trim CLAUDE.md · 49k tokens")                         |
| `/doctor prompt-audit` | audita `CLAUDE.md`, `AGENTS.md`, rules e skills atrás de conflito e referência morta (v2.1.283+) |
| `/memory`              | abre os arquivos de memória carregados                                                           |
| `claude --debug`       | mostra erro de parse de frontmatter das rules                                                    |
| `/compact <foco>`      | compacta dizendo o que preservar                                                                 |
| `/clear`               | sessão limpa (custo zero; prefira a `/compact` quando muda de assunto)                           |

Próximo: [3. O padrão ECC](./03-o-padrao-ecc.md).
