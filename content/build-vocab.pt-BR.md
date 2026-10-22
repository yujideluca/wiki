---
id: build-vocab
lang: pt-BR
source_hash: 9c5cdd6168eb
title: build_vocab.py
aliases: [build do vocabulário]
---

## What it is
O script que valida o vocabulário em TSV e escreve o JSON que vai dentro do app.

## What it does
Confere estrutura, duplicatas, artigos e casos permitidos, dicas nas preposições ambíguas e a regra de um único pedaço errado nas frases com erro; escreve `assets/vocab/*.json` e atualiza o manifesto do banco pelo [[content-manifest]]. Sai com erro a qualquer problema, então dado ruim nunca chega ao app. `--verify-nouns` confere gênero e plural no de.wiktionary.org.

## How it does it
Python; lê o [[vocab-tsv]]; as frases corrigidas também passam pelo [[check-errors-languagetool]].

## Where it sits in the pipeline
Entre o [[vocab-tsv]] e o [[vocab-assets]]; o JSON também é copiado para o [[quizweb]].

## Who receives its output
O [[vocab-assets]] (app) e o [[quizweb-content]] (o `vocab/` do gêmeo web).
