---
id: card-factory
lang: pt-BR
source_hash: badb4960a1a6
title: CardFactory
aliases: [cartas]
---

## What it is
Transforma entradas de vocabulário em `Card`s, a unidade de estudo: `id`, `mode`, `prompt`, `context` opcional, `choices`, `correctChoice`, `explanation`.

## What it does
Uma função por modo ([[game-modes]]): artigo, preposição, plural, Präteritum (`preteriteCard`) e Fehler finden (`errorCard`, cujas opções são os pedaços da frase). Todos os modos produzem o mesmo formato, o que mantém o motor independente do modo.

## How it does it
Lê as entradas já interpretadas de [[vocab-assets]] e pede as opções erradas ao [[distractor-factory]].

## Where it sits in the pipeline
Primeiro passo do fluxo de conteúdo: vocabulário → cartas → fila.

## Who receives its output
O [[study-pipeline]] (pelo [[study-controller]]).
