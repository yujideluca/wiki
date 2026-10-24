---
id: quizapp-quality-gate
lang: pt-BR
source_hash: 04f0d8531356
title: Portão de qualidade do QuizApp
---

## What it is
O `tools/quality_gate.sh` é a definição única de "aprovado" do [[quizapp]]. Um lançamento o executa, e a CI (integração contínua, as verificações automáticas no GitHub) executa exatamente o mesmo script. Se ele falhar, nada é lançado.

## What it does
Tem sete passos. (1) Testes unitários, de propriedade, de conformidade e de integração dos módulos `:core` e `:app`, com cobertura medida (testes de propriedade tentam muitas entradas aleatórias; testes de conformidade verificam que o app e o gêmeo web concordam). (2) Limites de cobertura. (3) Os testes do próprio gêmeo web. (4) Os vetores de conformidade compartilhados são idênticos no app e na web ([[quizweb-conformance]]). (5) Rastreabilidade de requisitos: todo requisito tem um teste ([[check-traceability]]). (6) Android lint (um verificador automático de qualidade de código). (7) `pipeline-check --measure-only` junto com os testes do seu código ([[pipeline-check]], com os limites descritos em [[fitness-check]]) e a verificação de que o manifesto do pacote de perguntas corresponde aos seus arquivos ([[content-manifest]] com `--check`). Com a opção `--mutation` executa também o [[mutation-check]]. Falha se demorar mais de 1200 segundos.

## How it does it
É um script [Bash](https://www.gnu.org/software/bash/) com `set -euo pipefail` (parar no primeiro erro); no notebook carrega `~/dev/env.sh` ([[android-toolchain]]), e cada passo é um comando que sai com código diferente de zero em caso de falha.

## Where it sits in the pipeline
Antes de cada publicação ([[publish-apk]]) e a cada push ([[quizapp-ci]]); é derivado do [[template-quality-gate]].

## Who receives its output
O [[publish-apk]] (vai ou não vai) e a [[quizapp-ci]].

## Functions
- `check_coverage.py`: pacotes de lógica com 90 % de cobertura de linhas, nenhum arquivo abaixo de 80 %
- `pipeline-check --traceability`: todo requisito tem um teste etiquetado
- `mutation_check.py`: falhas plantadas precisam ser pegas (só com `--mutation`)
- `metrics.py`: métricas de entrega no estilo DORA (DevOps Research and Assessment) para a revisão mensal (não faz parte do portão)
