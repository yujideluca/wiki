---
id: mem-use
lang: pt-BR
source_hash: 974978c215d4
title: mem use (informar quais entradas influenciaram uma tarefa)
---

## What it is
`mem use REF1,REF2 --note "como"` é o relatório do fim da tarefa. Nomeia as entradas da memória (pelo `#code` curto) que influenciaram o trabalho e diz em poucas palavras como.

## What it does
Cada uso informado faz a entrada desbotar mais devagar: sua "meia-vida" (o tempo após o qual seu peso no brief cai pela metade) é esticada pelo fator `1 + log2(1 + usos)`. Assim, regras realmente usadas permanecem no brief e as não usadas vão saindo aos poucos. Para uma pendência, registra também quando e como foi verificada pela última vez. É também o ponto em que a atualização do wiki é disparada ([[end-of-task]]).

## How it does it
Escreve um evento `use` listando as entradas como `target: ref1, ref2` e uma linha curta de nota (a nota tem limite de tamanho).

## Where it sits in the pipeline
O último passo de toda tarefa, logo depois de `wiki publish`.

## Who receives its output
O registro de memória [[events-log]]; o [[memory-fold]] conta os usos ao classificar as entradas para o brief.
