---
id: quizweb-store
lang: pt-BR
source_hash: 9ae898a9446e
title: store.js do QuizWeb (localStorage)
---

## What it is
O armazenamento no navegador do [[quizweb]]: progresso, histórico de respostas, meta diária, tema e idioma no `localStorage`.

## What it does
Salva e carrega tudo; Configurações > Backup exporta e importa, porque só existe no navegador daquele aparelho.

## How it does it
Todo acesso é protegido: o modo privado do Safari pode dar erro, e aí o app continua com uma cópia em memória durante a sessão.

## Where it sits in the pipeline
Abaixo do [[quizweb-controller]].

## Who receives its output
O [[quizweb-controller]].
