#!/usr/bin/env bash
# preencher-prompt.sh — troca {{CHAVE}} pelos valores de um arquivo de variáveis.
#
# Uso:  bash preencher-prompt.sh minhas-variaveis.env prompts/01-diagnostico-e-spec.md > meu-prompt.md
#
# minhas-variaveis.env: uma variável por linha, CHAVE=valor (sem aspas).
# Linhas vazias e começadas por # são ignoradas. Valor de uma linha só; para
# listas (INVARIANTES, PISTAS), use \n literal — vira quebra de linha.
# Substituição literal (&, /, \ e $ no valor são preservados).
# Chaves que sobrarem são listadas no stderr como "FALTA:".

set -u
[ $# -eq 2 ] || { echo "uso: $0 variaveis.env prompt.md" >&2; exit 2; }
awk '
  FNR == NR {
    if ($0 ~ /^[[:space:]]*(#|$)/) next
    i = index($0, "="); if (i == 0) next
    k = substr($0, 1, i - 1); v = substr($0, i + 1)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", k)
    gsub(/\\n/, "\n", v)
    key["{{" k "}}"] = v; next
  }
  {
    line = $0
    for (k in key) {
      out = ""
      while ((p = index(line, k)) > 0) { out = out substr(line, 1, p - 1) key[k]; line = substr(line, p + length(k)) }
      line = out line
    }
    print line
    while (match(line, /\{\{[A-Z0-9_]+\}\}/)) { falta[substr(line, RSTART, RLENGTH)] = 1; line = substr(line, RSTART + RLENGTH) }
  }
  END { for (f in falta) print "FALTA: " f > "/dev/stderr" }
' "$1" "$2"
