---
id: quizweb-ci
lang: pt-BR
source_hash: 18f913bdb0c7
title: CI do QuizWeb (GitHub Actions)
---

## What it is
O workflow do GitHub Actions do [[quizweb]].

## What it does
Roda toda a suíte de testes web a cada push e pull request: domínio, vetores de conformidade compartilhados, conteúdo, i18n e regras de arquitetura.

## How it does it
O executor de testes embutido do Node 22 (`npm test` = `node --test`), sem dependências para instalar.

## Where it sits in the pipeline
Depois de cada push para o [[github]].

## Who receives its output
O [[github]].
