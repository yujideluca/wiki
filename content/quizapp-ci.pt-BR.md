---
id: quizapp-ci
lang: pt-BR
source_hash: 3bd1f673d3a7
title: CI do QuizApp (GitHub Actions)
---

## What it is
O workflow do GitHub Actions do [[quizapp]]: roda o [[quizapp-quality-gate]] nas máquinas do GitHub.

## What it does
A cada push e pull request: o portão inteiro sem mutação. Toda segunda-feira: com o teste de mutação, para um teste que deixou de proteger uma regra aparecer em até uma semana. Depois do push, a execução precisa ficar verde.

## How it does it
Prepara Java 21, Gradle e Node 22, baixa o branch web correspondente (`web-<versionName>` se existir, senão `main`) e roda o [[pipeline-check]], que executa uma vez o mesmo script do portão do notebook e acrescenta as verificações de arquitetura, fitness e relatório; uma `falha` derruba o job `gate`, que a proteção de branch deveria exigir.

## Where it sits in the pipeline
Depois de cada push para o [[github]].

## Who receives its output
O [[github]] (a marca verde ou vermelha) e o Claude, que precisa conferir.
