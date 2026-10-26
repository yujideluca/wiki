---
id: vocab-assets
lang: pt-BR
source_hash: 3a56ab2eb487
title: JSON de vocabulário embutido (assets)
---

## What it is
São os arquivos [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, um formato de dados em texto simples) dentro do APK (Android Package, o arquivo instalável do app): `assets/vocab/*.json`, construídos pelo [[build-vocab]], e `assets/i18n/<de|pt|es>.json`, as traduções dos textos explicativos em inglês. "Assets" são arquivos empacotados com um app que não são código. O arquivo `assets/content.json` é o manifesto deste pacote embutido: um número de esquema (o formato do arquivo), uma versão de conteúdo e a impressão digital SHA-256 (Secure Hash Algorithm 256) de cada arquivo ([[content-manifest]]).

## What it does
São o conjunto de perguntas embutido, então o app tem todo o conjunto offline desde a primeira abertura; um conjunto mais novo baixado do feed de atualização é usado no lugar quando é mais novo ([[question-pack]]). Também traduzem dicas, tipos de erro e regras para o idioma do app.

## How it does it
São lidos no início por `VocabularySource` e `ContentTranslationSource` e interpretados no [[quizapp-core]]. O teste `ContentTranslationsTest` falha se faltar uma tradução.

## Where it sits in the pipeline
Entre o [[build-vocab]] e o [[card-factory]].

## Who receives its output
O [[card-factory]]; os arquivos i18n (i18n significa "internacionalização", i seguido de 18 letras e n: texto em vários idiomas) também são copiados para o [[quizweb]].
