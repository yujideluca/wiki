---
id: quizapp-quality-gate
lang: pt-BR
source_hash: b81f57a5a3ea
title: Portão de qualidade do QuizApp
aliases: [portão]
---

## What it is
`tools/quality_gate.sh`: a única definição de "passou" do [[quizapp]]. Uma publicação roda ele, e a CI roda exatamente o mesmo script.

## What it does
Sete passos: testes unitários, de propriedade, de conformidade e de integração do core e do app com cobertura; limites de cobertura; os testes do gêmeo web; vetores de conformidade idênticos no app e na web ([[quizweb-conformance]]); rastreabilidade de requisitos ([[check-traceability]]); lint do Android; funções de aptidão ([[fitness-check]]); o manifesto do pacote de perguntas bate com os arquivos ([[content-manifest]] `--check`). Com `--mutation` também roda o [[mutation-check]]. Falha se demorar mais de 1200 s.

## How it does it
Bash, `set -euo pipefail`, carrega `~/dev/env.sh` ([[android-toolchain]]) no notebook; cada passo é um comando que sai com erro quando falha.

## Where it sits in the pipeline
Antes de toda publicação ([[publish-apk]]) e a cada push ([[quizapp-ci]]); derivado do [[template-quality-gate]].

## Who receives its output
O [[publish-apk]] (pode / não pode) e a [[quizapp-ci]].

## Functions
- `check_coverage.py`: logic packages at 90 % line coverage, no file below 80 %
- `check_traceability.py`: every requirement has a tagged test
- `fitness_check.py`: architecture limits
- `mutation_check.py`: planted faults must be caught (`--mutation` only)
- `metrics.py`: DORA-style delivery metrics for the monthly review (not part of the gate)
