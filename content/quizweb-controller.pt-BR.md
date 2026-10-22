---
id: quizweb-controller
lang: pt-BR
source_hash: 1de898c1d8ca
title: controller.js do QuizWeb
---

## What it is
O serviço de aplicação do gêmeo web: a contraparte web do [[study-controller]].

## What it does
Liga baralho, armazenamento e relógio às funções puras do [[quizweb-domain]]: sessões, respostas, suspensão, busca, progresso do dia, calendário.

## How it does it
Sem DOM; aceita qualquer armazenamento com o formato certo (`createMemoryStore` nos testes, [[quizweb-store]] no navegador).

## Where it sits in the pipeline
Entre o [[quizweb-app]] (interface) e o [[quizweb-domain]].

## Who receives its output
O [[quizweb-app]].
