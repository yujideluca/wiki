---
id: vocab-tsv
lang: pt-BR
source_hash: b74a285eb51e
title: Arquivos-fonte de vocabulário (TSV)
---

## What it is
São os arquivos-fonte, editáveis por pessoas, de todo o conteúdo do quiz, no formato TSV (tab-separated values, valores separados por tabulação: uma tabela em texto simples cujas colunas são separadas por um caractere de tabulação, veja [TSV](https://en.wikipedia.org/wiki/Tab-separated_values)). São `nouns.tsv` (484 substantivos), `prepositions.tsv` (309 itens), `verbs.tsv` (253 verbos) e `errors.tsv` (121 frases para o modo "achar o erro").

## What it does
Guardam cada palavra, seu gênero, plural, preposição e dica, e cada frase com erro junto com sua correção, a regra por trás e a expressão que ela treina. Tudo o que o app pergunta vem daqui.

## How it does it
Os arquivos são editados à mão (pelo Claude, a partir das listas de palavras do Giovanni e de provas corrigidas). Uma linha com várias preposições possíveis precisa de uma coluna de dica. Uma frase com erro marca exatamente um trecho errado com `{{ }}`. Um script, o [[build-vocab]], verifica tudo isso antes de os dados chegarem ao app.

## Where it sits in the pipeline
O começo do pipeline de conteúdo: TSV → [[build-vocab]] → [[vocab-assets]] → [[card-factory]].

## Who receives its output
O [[build-vocab]].
