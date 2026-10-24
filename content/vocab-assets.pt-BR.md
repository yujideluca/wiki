---
id: vocab-assets
lang: pt-BR
source_hash: df99b7d0297a
title: JSON de vocabulário embutido (assets)
---

## What it is
São os arquivos [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, um formato de dados em texto simples) dentro do APK (Android Package, o arquivo instalável do app): `assets/vocab/*.json`, construídos pelo [[build-vocab]], e `assets/i18n/<de|pt|es>.json`, as traduções dos textos explicativos em inglês. "Assets" são arquivos empacotados com um app que não são código.

## What it does
Dão ao app todo o conjunto de perguntas offline e traduzem dicas, tipos de erro e regras para o idioma do app.

## How it does it
São lidos no início por `VocabularySource` e `ContentTranslationSource` e interpretados no [[quizapp-core]]. O teste `ContentTranslationsTest` falha se faltar uma tradução.

## Where it sits in the pipeline
Entre o [[build-vocab]] e o [[card-factory]].

## Who receives its output
O [[card-factory]]; os arquivos i18n (i18n significa "internacionalização", i seguido de 18 letras e n: texto em vários idiomas) também são copiados para o [[quizweb]].
