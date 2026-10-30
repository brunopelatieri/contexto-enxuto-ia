# Passo 4 — Construir (sem remover nada)

> **Objetivo:** criar todos os destinos antes de encolher a origem.
> **Quem:** o agente, uma fase por sessão. **Muda o repo:** só cria arquivos (e, se ratificado, `.gitignore`/`settings.json`).

Use o prompt de abertura de cada fase em [prompts/02-execucao-de-fase.md](../prompts/02-execucao-de-fase.md). **Reinicie a sessão entre fases.**

---

## F0 — Versionamento, segurança e baseline · modelo médio

1. Se ratificado, aplique o diff de `.gitignore` e confirme com `git check-ignore -v` que segredos continuam ignorados.
2. Se ratificado, crie/atualize `.claude/settings.json` com `permissions.deny` — use [templates/settings.deny.template.json](../templates/settings.deny.template.json).
3. Grave o manifesto das pastas intocáveis (`src/`, `public/`, banco, scripts) e o backup do root fora do repo.

**Aceite:** `git check-ignore` confirma o plano; numa sessão nova, pedir "leia o `.env`" é negado pela permissão.

## F1 — Fundações em `docs/context/` · modelo médio

Crie a partir dos templates:

- `status.md` ([template](../templates/status.template.md)) — todo fato `ENVELHECE`, com data e comando de conferência.
- `INDEX.md` ([template](../templates/INDEX.template.md)) — tabela tarefa → arquivo de domínio → rule → skill.
- `catalogo-specs.md` ([template](../templates/catalogo.template.md)) — o antigo índice da documentação, completo e reconciliado com o disco.

**Aceite:** todo link resolve; o catálogo tem todo documento do disco (ou a exclusão ratificada).

## F2 — Domínios · modelo forte para redigir, médio para conferir

Para cada domínio da SPEC, crie `docs/context/<dominio>.md` ([template](../templates/dominio.template.md)):

1. **Copie** os parágrafos de origem (conforme a matriz de rastreabilidade).
2. **Corrija** no destino o que era `INCORRETO`/`ENVELHECE` — não copie o erro.
3. **Confira** cada caminho citado (`ls`/`git ls-files`).
4. Marque na matriz: origem → destino ✅.

**Não apague nada da origem ainda.**

**Aceite:** matriz 100%; cada arquivo ≤ 120 linhas/6 KB; nenhum `@` fora de crases.

## F3 — Rules · modelo médio

Para cada domínio, `.claude/rules/<dominio>.md` ([template](../templates/rule.template.md)):

```markdown
---
paths:
  - 'supabase/migrations/**'
  - 'supabase/setup/**'
---

# Supabase — migrações

- Confira o próximo número com `ls supabase/migrations/`.
- Função nova em `public`: `REVOKE ALL … FROM PUBLIC` **e** `FROM anon`; `GRANT EXECUTE … TO authenticated` se a sessão chama.
- Depois: `get_advisors` (security) **no projeto confirmado**.
- Script com URL/segredo do deploy vai em `supabase/setup/`, nunca em migração.
- Detalhes e porquês: leia `docs/context/supabase-rls.md`.
```

- ≤ 25 linhas; **sempre** `paths:`; só decisões + ponteiro.
- Cada glob casa ≥ 1 arquivo (`find` para pastas ignoradas pelo git).
- Se o time usa Cursor: o mesmo corpo em `.cursor/rules/<dominio>.mdc` ([template](../templates/cursor-rule.template.mdc)).

**Aceite:** `checar-higiene.sh` sem erro de rule.

## F4 — Skills · modelo forte

Para cada procedimento ratificado, `.claude/skills/<nome>/SKILL.md` ([template](../templates/SKILL.template.md)):

- `description`: **uma frase** com o gatilho ("Use ao criar uma migração Supabase nova…").
- Corpo ≤ 100 linhas: _Quando usar · Passos · Verificação · Não faça_.
- Material longo: arquivo ao lado ou ponteiro para `docs/references/` — **nunca** copie um pacote de 1 MB para dentro da skill.
- Procedimento com efeito colateral (deploy, aplicar migração): `disable-model-invocation: true`.

**Aceite:** soma das descrições ≤ ~1,5 KB; cada skill testada com `/nome` numa sessão nova.

---

Próximo: [Passo 5 — Trocar o root](./passo-5-trocar-o-root.md).
