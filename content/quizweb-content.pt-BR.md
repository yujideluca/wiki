---
id: quizweb-content
lang: pt-BR
source_hash: 76699f06c312
title: content.js e vocab/ do QuizWeb
---

## What it is
`content.js` e a pasta `vocab/` do [[quizweb]]: o código que transforma vocabulário em cartas e opções erradas para o gêmeo web, portado do pacote de conteúdo do app, mais os arquivos JSON de `vocab/` (JSON, JavaScript Object Notation, é um formato de dados em texto simples). São os mesmos arquivos do app Android; `errors.json` é construído a partir de `errors.tsv`.

## What it does
Monta o baralho: uma carta por palavra e modo, com as mesmas opções erradas determinísticas do [[distractor-factory]].

## How it does it
É um módulo ES simples (o formato padrão de arquivo do JavaScript). O [[check-web-sync]] garante que `vocab/` seja igual ao [[vocab-assets]] do app.

## Where it sits in the pipeline
Entre a saída do [[build-vocab]] e o [[quizweb-app]], que monta o baralho ao iniciar.

## Who receives its output
O [[quizweb-app]] (e, por ele, o [[quizweb-controller]]).
