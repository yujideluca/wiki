---
id: build-vocab
lang: pt-BR
source_hash: b59116847dc2
title: build_vocab.py
---

## What it is
`build_vocab.py` é o script que verifica as tabelas de vocabulário ([[vocab-tsv]]) e as transforma nos arquivos [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, um formato de dados em texto simples) que o app leva dentro de si.

## What it does
Verifica a estrutura, duplicatas, artigos e casos permitidos, dicas para preposições ambíguas e a regra de que cada frase com erro tem exatamente um trecho errado. Escreve `assets/vocab/*.json` e atualiza o manifesto do conjunto de perguntas por meio do [[content-manifest]]. Sai com código diferente de zero diante de qualquer problema, então dados ruins não chegam ao app. A opção `--verify-nouns` confere gêneros e plurais com o Wiktionary alemão (de.wiktionary.org).

## How it does it
É um script [Python](https://www.python.org/). Lê o [[vocab-tsv]]; as frases com erro corrigidas são verificadas também pelo [[check-errors-languagetool]].

## Where it sits in the pipeline
Entre o [[vocab-tsv]] e o [[vocab-assets]]; seu JSON é copiado também para o [[quizweb]].

## Who receives its output
O [[vocab-assets]] (o app) e o [[quizweb-content]] (a pasta `vocab/` do gêmeo web).
