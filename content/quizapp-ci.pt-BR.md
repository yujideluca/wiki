---
id: quizapp-ci
lang: pt-BR
source_hash: ce8cd806b16b
title: CI do QuizApp (GitHub Actions)
---

## What it is
É o workflow do GitHub Actions do [[quizapp]] (arquivo `.github/workflows/quality-gate.yml`). O [GitHub Actions](https://docs.github.com/en/actions) executa tarefas automáticas nos computadores do GitHub. Este workflow é a CI (integração contínua): executa o [[quizapp-quality-gate]] a cada mudança e mostra uma marca verde ou vermelha.

## What it does
A cada push e pull request (uma proposta de incorporar uma mudança) executa o portão completo sem a verificação de mutação. Toda segunda-feira executa com a verificação de mutação, para que um teste que deixou de proteger uma regra apareça em até uma semana. Depois do push, a execução precisa estar verde.

## How it does it
Prepara Java 21, Gradle e Node 22 (um ambiente de execução de JavaScript), faz checkout do branch correspondente do gêmeo web (`web-<versionName>` se existir, senão `main`) e então executa o [[pipeline-check]], que roda uma vez o mesmo script de portão do notebook e acrescenta as verificações de arquitetura, de aptidão e de relatório. Uma `falha` reprova a tarefa `gate`, que a proteção de branch do GitHub deveria exigir.

## Where it sits in the pipeline
Depois de cada push para o [[github]].

## Who receives its output
O [[github]] (a marca verde ou vermelha) e o Claude, que precisa conferi-la.
