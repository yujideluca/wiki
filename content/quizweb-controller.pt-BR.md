---
id: quizweb-controller
lang: pt-BR
source_hash: f2504d98f561
title: controller.js do QuizWeb
---

## What it is
`controller.js` é o serviço de aplicação do gêmeo web: o equivalente do [[study-controller]] do app Android. Um serviço de aplicação é a camada que coordena armazenamento, lógica e relógio sem desenhar nada.

## What it does
Liga o baralho, o armazenamento e o relógio às funções puras de [[quizweb-domain]]: sessões, respostas, suspensão de cartas, busca, progresso diário e calendário.

## How it does it
Não tem DOM (Document Object Model, o modelo do navegador para uma página web). Aceita qualquer armazenamento com o formato certo: `createMemoryStore` nos testes e o [[quizweb-store]] no navegador. Por isso pode ser testado sem navegador.

## Where it sits in the pipeline
Entre o [[quizweb-app]] (as telas) e o [[quizweb-domain]].

## Who receives its output
O [[quizweb-app]].
