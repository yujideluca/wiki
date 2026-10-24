---
id: quizweb-store
lang: pt-BR
source_hash: f58cb4471767
title: store.js do QuizWeb (localStorage)
---

## What it is
`store.js` é o armazenamento do navegador do [[quizweb]]. Guarda progresso, histórico de respostas, meta diária, tema e idioma no `localStorage` ([localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) é um pequeno armazenamento chave-valor que todo navegador oferece a uma página web).

## What it does
Salva e carrega tudo. Como os dados ficam só no navegador daquele aparelho, Configurações > Backup os exporta e importa.

## How it does it
Todo acesso é protegido: o modo privado do Safari pode gerar erro ao guardar, e então o app continua funcionando nessa sessão com uma cópia na memória em vez de travar.

## Where it sits in the pipeline
Sob o [[quizweb-controller]].

## Who receives its output
O [[quizweb-controller]].
