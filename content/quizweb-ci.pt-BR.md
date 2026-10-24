---
id: quizweb-ci
lang: pt-BR
source_hash: 5c99d45dbbea
title: CI do QuizWeb (GitHub Actions)
---

## What it is
É o workflow do GitHub Actions do [[quizweb]] (arquivo `.github/workflows/test.yml`). O [GitHub Actions](https://docs.github.com/en/actions) executa tarefas automáticas nos computadores do GitHub; esta tarefa é a CI (integração contínua), as verificações automáticas a cada mudança.

## What it does
Executa toda a suíte de testes da web a cada push e pull request (uma proposta de incorporar uma mudança): domínio, vetores de conformidade compartilhados, conteúdo, i18n e regras de arquitetura.

## How it does it
Usa o executor de testes embutido no Node 22 (`npm test` = `node --test`), então não há dependências a instalar.

## Where it sits in the pipeline
Depois de cada push para o [[github]].

## Who receives its output
O [[github]].
