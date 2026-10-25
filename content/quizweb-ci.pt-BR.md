---
id: quizweb-ci
lang: pt-BR
source_hash: c75b158fcffa
title: CI do QuizWeb (GitHub Actions)
---

## What it is
É o workflow do GitHub Actions do [[quizweb]] (arquivo `.github/workflows/test.yml`). O [GitHub Actions](https://docs.github.com/en/actions) executa tarefas automáticas nos computadores do GitHub; esta tarefa é a CI (integração contínua), as verificações automáticas a cada mudança.

## What it does
Executa toda a suíte de testes da web a cada push e pull request (uma proposta de incorporar uma mudança): domínio, vetores de conformidade compartilhados, conteúdo, i18n e regras de arquitetura. Em seguida o [[pipeline-check]] confere os limites do projeto: nenhum arquivo-fonte com mais de 600 linhas, o portão abaixo de 300 segundos e `shellcheck` nos scripts; uma `falha` faz a tarefa falhar.

## How it does it
Configura o Node 22 e o Rust (com um cache do programa compilado) e roda `tools/pipeline-check.sh --mode ci`, que executa `tools/quality_gate.sh` uma vez e depois acrescenta as verificações de aptidão. O portão usa o executor de testes embutido no Node 22 (`npm test` = `node --test`), então o código web não tem dependências a instalar; o Rust só é necessário para compilar o [[pipeline-check]]. A tarefa se chama `test`, e a proteção de branch do GitHub deveria exigi-la.

## Where it sits in the pipeline
Depois de cada push para o [[github]].

## Who receives its output
O [[github]].
