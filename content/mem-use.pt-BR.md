---
id: mem-use
lang: pt-BR
source_hash: a6e7acb3fc35
title: mem use (informar quais entradas guiaram a tarefa)
---

## What it is
O relatório de fim de tarefa: `mem use REF1,REF2 --note "como"`, citando as entradas de memória (pelo #código) que guiaram o trabalho.

## What it does
Cada uso estica a meia-vida da entrada por `1 + log2(1 + usos)`, então as regras usadas continuam no resumo; num item em aberto, registra quando e como foi verificado pela última vez. É também o gatilho da atualização do wiki ([[end-of-task]]).

## How it does it
Grava um evento `use` com `target: ref1, ref2` e uma linha curta (a nota tem limite de tamanho).

## Where it sits in the pipeline
O último passo de toda tarefa, logo depois do `wiki publish`.

## Who receives its output
O [[events-log]]; o [[memory-fold]] conta os usos ao ordenar o resumo.
