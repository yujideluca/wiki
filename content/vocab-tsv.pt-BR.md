---
id: vocab-tsv
lang: pt-BR
source_hash: 1b16226fa2d8
title: Arquivos-fonte de vocabulário (TSV)
---

## What it is
São os arquivos-fonte, editáveis por pessoas, de todo o conteúdo do quiz, como tabelas de texto simples. Apesar da extensão `.tsv`, suas colunas são separadas por uma barra vertical (`|`). São `nouns.tsv` (484 substantivos), `prepositions.tsv` (309 itens), `verbs.tsv` (253 verbos) e `errors.tsv` (155 frases para o modo "achar o erro").

## What it does
Guardam cada palavra, seu gênero, plural, preposição e dica, e cada frase com erro junto com sua correção, a regra por trás e a expressão que ela treina. Tudo o que o app pergunta vem daqui.

## How it does it
Os arquivos são editados à mão (pelo Claude, a partir das listas de palavras do Giovanni e de provas corrigidas). Uma linha com várias preposições possíveis precisa de uma coluna de dica. Uma frase com erro marca exatamente um trecho errado com `{{ }}`. Um script, o [[build-vocab]], verifica tudo isso antes de os dados chegarem ao app.

## Where it sits in the pipeline
O começo do pipeline de conteúdo: TSV → [[build-vocab]] → [[vocab-assets]] → [[card-factory]].

## Who receives its output
O [[build-vocab]].
