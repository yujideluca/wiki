---
id: fitness-check
lang: pt-BR
source_hash: 61038242b2e1
title: Funções de aptidão (fitness functions)
---

## What it is
Uma "função de aptidão" (fitness function) é uma verificação automática de que uma qualidade do design não se desviou com o tempo. A ideia vem da "arquitetura evolutiva" ([Building Evolutionary Architectures](https://www.thoughtworks.com/insights/books/building-evolutionary-architectures); veja também [fitness function](https://en.wikipedia.org/wiki/Fitness_function)) e está registrada na decisão ADR-0009 do QuizApp (uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). A configuração está no arquivo `pipeline-check.toml` do [[quizapp]].

## What it does
Verifica quatro limites: (1) o módulo `:core` continua sendo Kotlin puro, sem plugin ou dependência do Android; (2) nenhum arquivo Kotlin passa de 400 linhas; (3) o APK de lançamento (o pacote Android instalável) fica abaixo de 3 MB (a verificação é pulada quando nenhum APK de lançamento foi compilado); (4) o portão leva no máximo 1200 segundos. O programa também roda o `shellcheck`, um verificador de scripts de shell, nos scripts do projeto ([[pipeline-check]]).

## How it does it
Desde 2026-10-24 os limites ficam em `pipeline-check.toml`, e o [[pipeline-check]] os mede (ele substituiu o script `fitness_check.py`), com aviso a partir de 80 % de um limite. Um limite só é elevado de propósito, no mesmo commit de uma ADR ou linha do registro de decisões que explica o porquê. Assim um número não sobe sem ser notado.

## Where it sits in the pipeline
Passo 7 do [[quizapp-quality-gate]] (`pipeline-check --measure-only`) e da tarefa de integração contínua (CI); revisada na [[monthly-architecture-review]].

## Who receives its output
O [[quizapp-quality-gate]].
