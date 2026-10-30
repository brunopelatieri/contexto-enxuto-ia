# {{PROJETO}} — {{SUBTITULO}}

{{2–3 linhas: o que é o produto, stack principal, quem mantém.}}

<!-- Orçamento: este arquivo inteiro ≤ 150 linhas. Inegociáveis ≤ ~80 linhas.
     Texto puro: Cursor/Codex não expandem @. Nenhum número que envelhece aqui. -->

## Inegociáveis

<!-- Só o que causa dano se esquecido em QUALQUER tarefa. Uma linha cada, verificável. -->

1. **Git:** commit e push são manuais. Entregue o comando pronto; não execute.
2. **Segredos:** nunca leia nem copie {{SEGREDOS}}. Variáveis documentadas em `{{ARQUIVO_ENV_EXEMPLO}}`.
3. **Banco:** MCPs permitidos: {{MCPS_DO_PROJETO}}. Nunca {{MCPS_PROIBIDOS}}. Antes de qualquer escrita, confira o projeto com `get_project_url` e peça confirmação ao mantenedor.
4. **{{REGRA_DE_ARQUITETURA}}** (ex.: lógica de negócio em `src/lib/`, com `*.test.ts` ao lado).
5. **{{REGRA_DE_SEGURANCA}}** (ex.: `src/lib/supabase/admin.ts` é service_role — nunca em código que chega ao browser).
6. **{{REGRA_DE_I18N}}** (ex.: toda string visível em `messages/en.json` + `pt-BR.json`; sem prefixo de locale na URL).
7. **Validação local (sem CI):** `{{VALIDACAO}}`
8. {{…}}

## Como achar o resto

- **Por tarefa:** `docs/context/INDEX.md` diz qual arquivo de domínio ler.
- **Estado atual** (versões, última migração, projetos, contagens): `docs/context/status.md`.
- **SPECs, PRDs e guias:** `docs/context/catalogo-specs.md`.
- Regras de domínio carregam sozinhas quando você abre arquivos da área (`.claude/rules/`).

## Ao terminar uma tarefa

SPEC nova → catálogo. Número que mudou → `status.md`. Regra de domínio → rule + domínio. Procedimento repetido → skill. Este arquivo só muda para inegociável novo.

## Créditos

{{TEXTO_DE_CREDITOS_OBRIGATORIO — ou apague a seção}}

{{BLOCOS_GERADOS_POR_FERRAMENTAS — copie byte a byte, com os marcadores}}
