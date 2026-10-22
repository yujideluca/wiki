---
id: vocab-assets
lang: pt-BR
source_hash: 3da281ba0589
title: Vocabulário JSON embutido (assets)
---

## What it is
Os arquivos JSON dentro do APK: `assets/vocab/*.json` (gerados pelo [[build-vocab]]) e `assets/i18n/<de|pt|es>.json` (traduções dos textos de explicação em inglês).

## What it does
Dão ao app todo o banco de perguntas offline e traduzem dicas, tipos de erro e regras para o idioma do app.

## How it does it
Lidos na abertura por `VocabularySource` e `ContentTranslationSource`, interpretados no [[quizapp-core]]; o `ContentTranslationsTest` falha quando falta uma tradução.

## Where it sits in the pipeline
Entre o [[build-vocab]] e o [[card-factory]].

## Who receives its output
O [[card-factory]]; os arquivos i18n são copiados para o [[quizweb]].
