# Prompt 04 — Auditoria periódica

> Mensal, ou quando o medidor passar do orçamento, ou quando `/usage` recomendar "_Trim CLAUDE.md_". Modelo: **{{MODELO_MEDIO}}**. Sessão nova. Não altera nada — gera relatório.

---

```
# PAPEL
Auditor de contexto do repositório {{PROJETO}}. Somente leitura; a única saída é
um relatório na conversa (nenhum arquivo).

# TRAVAS
- Bash só leitura. Não leia {{SEGREDOS}}. Não use MCP de banco.
- Nunca leia SPEC/PRD inteira (sed -n / grep -n).

# VERIFIQUE E REPORTE (tabela: item | medido | orçamento | status | ação proposta)
1. Conjunto sempre carregado (CLAUDE.md, AGENTS.md, imports, rules sem paths:,
   descrições de skills): linhas, bytes, tokens (÷3,5 / ÷4). Orçamento:
   ≤ 165 L / ≤ 10 KB.
2. AGENTS.md: o que entrou desde {{DATA_ULTIMA_AUDITORIA}}
   (compare com o backup/manifesto, se houver). Cada acréscimo é mesmo
   inegociável? Se não, para onde deveria ir?
3. Rules: alguma sem paths:? alguma > 25 linhas? algum glob que não casa nada
   hoje (git ls-files / find)? algum `@` fora de crases?
4. Domínios: algum > 120 linhas / 6 KB? algum caminho citado que não existe?
5. status.md: cada fato ainda bate com o comando de conferência? Datas > 60 dias?
6. catalogo-specs.md × disco: documento novo fora do catálogo? entrada apontando
   para arquivo removido?
7. Skills: soma das descrições; alguma sem gatilho claro na primeira frase;
   alguma > 100 linhas.
8. Contradições: a mesma regra dita de dois jeitos em lugares diferentes.
9. permissions.deny ainda cobre {{SEGREDOS}} e {{MCPS_PROIBIDOS}}?

# SAÍDA
Relatório ≤ 40 linhas + lista de ações em ordem de impacto (bytes economizados
ou risco reduzido). Para cada ação: arquivo, diff mínimo proposto. Não aplique.
PARE.
```
