---
id: template-quality-gate
lang: pt-BR
source_hash: b42f9c573414
title: Portão de qualidade do modelo
---

## What it is
O esqueleto do `tools/quality_gate.sh` de cada projeto: a única definição de "passou", usada pelas publicações e pela CI.

## What it does
Três passos a preencher por projeto: build e testes; rastreabilidade de requisitos ([[check-traceability]]); funções de aptidão. Falha quando o portão leva mais de 1200 s, porque um portão lento acaba sendo pulado.

## How it does it
Bash, `set -euo pipefail`; cada passo é um comando que sai com erro quando falha. A CI (`.github/workflows/quality-gate.yml`) roda exatamente este script.

## Where it sits in the pipeline
Copiado para cada projeto novo ([[new-project]]).

## Who receives its output
O [[quizapp-quality-gate]] e o [[wiki-quality-gate]].
