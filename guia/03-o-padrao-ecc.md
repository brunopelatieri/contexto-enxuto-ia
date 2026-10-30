# 3. O padrão ECC — o que adotar e o que não adotar

## O que é o ECC

O [ECC (Everything Claude Code)](https://github.com/affaan-m/ECC) é um pacote MIT de agentes, skills, comandos, rules e hooks para Claude Code (e adaptadores para Codex, Cursor, Gemini e outros). Em 2026-10, versão 2.2.3: 71 agentes, ~311 skills, ~97 comandos, rules em `common/` + pacotes por linguagem.

Ideias centrais, nas palavras do próprio repositório:

- "_Optimize the context window. Persist everything else._"
- "_Rules are always-loaded context, so begin with `common` and one pack for the stack you actually use._"
- "_Skills are the primary workflow surface_" — carregadas sob demanda.
- "_Start with the workflow you need, not the full catalog._"
- Perfil de instalação `minimal` para quem quer pouco contexto; comando `/context-budget`; skills `strategic-compact` e `iterative-retrieval`.
- "_Do not stack install methods._"

## A nuance que muda tudo

**No ECC, as rules são sempre carregadas.** A economia vem de **escolher poucos pacotes** (common + o da sua stack), não de escopo por arquivo.

Este repositório leva a ideia um passo adiante usando um recurso nativo do Claude Code que o ECC não usa nas rules: **`paths:` no frontmatter**, que faz a rule carregar só quando um arquivo casante é aberto. Isso é adaptação nossa — não atribua ao ECC.

O mesmo vale para o `INDEX.md` de roteamento e o `status.md`: são criação nossa para projetos de produto (com SPECs, domínios e dados que envelhecem), não peças do ECC.

## Adotar como ideia

| Ideia do ECC                                                 | Como aplicamos                                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------------------- |
| Rules segmentadas por assunto                                | uma rule por domínio do **seu** produto, **com `paths:`**                 |
| Skills como superfície principal de procedimento             | "nova migração", "novo endpoint", "integração n8n" viram skills           |
| Estrutura da skill: _Quando usar / Como funciona / Exemplos_ | template em [templates/SKILL.template.md](../templates/SKILL.template.md) |
| Regra curta separada de conhecimento longo                   | rule ≤ 25 linhas + arquivo de domínio em `docs/context/`                  |
| Começar pelo mínimo                                          | cada artefato novo tem de justificar o próprio custo                      |
| Medir o orçamento de contexto                                | [scripts/medir-contexto.sh](../scripts/medir-contexto.sh) + `/context`    |

## Não adotar (para este objetivo)

| Peça do ECC                                   | Por que ficou de fora                                                                                  |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| Instalar o plugin / marketplace               | traz centenas de skills genéricas; cada descrição custa contexto fixo. O objetivo aqui é **encolher**. |
| Hooks prontos                                 | executam código a cada ferramenta; útil, mas é outra decisão (segurança, performance). Avalie à parte. |
| Agentes e comandos do catálogo                | genéricos; os do seu domínio rendem mais. Crie só os que o seu fluxo pede.                             |
| Cópias multi-harness (`.codex/`, `.gemini/`…) | duplicam conteúdo; aqui, `AGENTS.md` já é a ponte cross-tool.                                          |
| Rules de linguagem sempre carregadas          | o linter/formatter do projeto já impõe estilo; rule de estilo genérica é custo sem ganho.              |

Se mais tarde quiser algo do ECC (ex.: a skill `strategic-compact`), copie **uma** peça, leia, adapte e meça o custo da descrição — "_Do not stack install methods_".

## Onde o ECC e este método concordam

Os dois partem do mesmo diagnóstico: o contexto é o recurso escasso, e tudo que não precisa estar nele deve morar em arquivo, ser recuperado sob demanda ou ser executado por ferramenta.

Próximo: [4. Arquitetura-alvo](./04-arquitetura-alvo.md).
