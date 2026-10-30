# Passo 6 — Validar

> **Objetivo:** provar com números e testes que (a) ficou menor, (b) nenhuma regra se perdeu, (c) nada fora do escopo mudou.
> **Quem:** o agente executa, **você** roda os testes de roteamento. **Sessão:** nova.

## 6.1 Medição

```bash
bash ~/ferramentas/contexto/medir-contexto.sh | tee ~/contexto-depois.txt
diff ~/contexto-antes.txt ~/contexto-depois.txt
```

E `/context` numa sessão nova. Monte a tabela:

| Métrica                   | Antes | Meta     | Depois | ✅/❌ |
| ------------------------- | ----- | -------- | ------ | ----- |
| Bytes sempre carregados   |       | ≤ 10 KB  |        |       |
| Linhas sempre carregadas  |       | ≤ 165    |        |       |
| Tokens estimados (÷3,5)   |       |          |        |       |
| `/context` — memory files |       |          |        |       |
| Descrições de skills      |       | ≤ 1,5 KB |        |       |

## 6.2 Higiene

```bash
bash ~/ferramentas/contexto/checar-higiene.sh
```

Zero erros em: rule sem `paths:`, glob que não casa nada, `@` fora de crases em rule/INDEX/domínio, link relativo quebrado, arquivo acima do orçamento, corpo de rule divergente entre `.claude` e `.cursor`.

## 6.3 Escopo

```bash
git status --short | diff "$SCR/status-antes.txt" -        # delta esperado, nada além
sha256sum -c "$SCR/intocaveis.sha" | grep -v ': OK$'       # vazio = nada mudou em src/ etc.
```

Escreva **antes** qual é o delta esperado (depende da decisão de versionamento). Qualquer outra linha é falha.

## 6.4 Testes de roteamento

Use [prompts/03-testes-de-roteamento.md](../prompts/03-testes-de-roteamento.md). Regras:

- **Uma sessão nova por teste** (ou `/clear` entre eles).
- Você só cola a frase do teste; não dê pistas.
- Passa se o agente **cita/aplica** a regra esperada sem você lembrar.
- O teste com **arquivo novo** é o mais importante: prova que os inegociáveis não dependem de rule.

## 6.5 Revisão independente (projetos críticos)

Peça a um segundo agente, **sem** o histórico da execução, que leia só o `AGENTS.md` novo, o `INDEX.md` e a matriz de rastreabilidade e responda: "que regra do arquivo antigo (backup) não tem destino?". Ele não pode estar ancorado no seu trabalho.

## Pronto quando

- [ ] metas atingidas (ou desvio justificado)
- [ ] higiene sem erro
- [ ] delta de escopo = o esperado
- [ ] todos os testes de roteamento passam

Próximo: [Passo 7 — Manter](./passo-7-manter.md).
