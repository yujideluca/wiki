---
id: quizweb-content
lang: pt-BR
source_hash: ddd020679780
title: content.js e vocab/ do QuizWeb
---

## What it is
Vocabulário → cartas e distratores do gêmeo web, portado do pacote content do app, mais os arquivos JSON de `vocab/` (os mesmos do app Android; o `errors.json` vem do `errors.tsv` de lá).

## What it does
Monta o baralho: uma carta por palavra e modo, com os mesmos distratores determinísticos do [[distractor-factory]].

## How it does it
Módulo ES simples; o [[check-web-sync]] garante que `vocab/` é igual ao [[vocab-assets]] do app.

## Where it sits in the pipeline
Entre a saída do [[build-vocab]] e o [[quizweb-app]], que monta o baralho na abertura.

## Who receives its output
O [[quizweb-app]] (e por ele o [[quizweb-controller]]).
