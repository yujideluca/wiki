---
id: card-factory
lang: pt-BR
source_hash: 03a61cd67d2d
title: CardFactory
---

## What it is
Uma "carta" (card) é a unidade de estudo do [[quizapp]]: uma pergunta com suas opções de resposta. A `CardFactory` transforma entradas de vocabulário em cartas. Uma carta tem um `id`, um `mode`, um `prompt` (a pergunta), um `context` opcional, as `choices`, a `correctChoice` e uma `explanation`.

## What it does
Há uma função por modo ([[game-modes]]): artigo, preposição, plural, Präteritum (`preteriteCard`) e Fehler finden (`errorCard`, cujas opções são os trechos da frase). Todo modo produz a mesma forma, o que mantém o resto do motor de estudo independente do modo.

## How it does it
Lê as entradas já interpretadas de [[vocab-assets]] e pede ao [[distractor-factory]] as opções erradas (um "distrator" é uma resposta plausível, porém errada).

## Where it sits in the pipeline
O primeiro passo do pipeline de conteúdo: vocabulário → cartas → fila.

## Who receives its output
O [[study-pipeline]], por meio do [[study-controller]].
