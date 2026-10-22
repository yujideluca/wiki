---
id: vocab-tsv
lang: pt-BR
source_hash: 9de6b1547255
title: Arquivos-fonte do vocabulário (TSV)
---

## What it is
A fonte editável à mão do conteúdo do quiz: `nouns.tsv` (484 substantivos), `prepositions.tsv` (309 itens), `verbs.tsv` (253 verbos) e `errors.tsv` (121 frases do Fehler finden).

## What it does
Guardam cada palavra com gênero, plural, preposição e dica, e cada frase com erro com a correção, a regra e a expressão que treina.

## How it does it
Editados à mão (pelo Claude, a partir das listas do Giovanni e de provas corrigidas); uma linha com várias preposições precisa da coluna de dica; uma frase com erro marca exatamente um pedaço errado com `{{ }}`.

## Where it sits in the pipeline
O começo do fluxo de conteúdo: TSV → [[build-vocab]] → [[vocab-assets]] → [[card-factory]].

## Who receives its output
O [[build-vocab]].
