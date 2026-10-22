---
id: memory-fold
lang: pt-BR
source_hash: b6b1c1d081e3
title: A dobra (core.py)
aliases: [dobra]
---

## What it is
A única função pura do [[workflow-memory]]: ela "dobra" o registro de eventos no estado atual.

## What it does
Vale a regra mais recente por (scope, key); a mesma regra de novo soma evidência; uma negação é uma mudança; `forget` e `done` fecham o alvo; feedback muda a importância (`wrong` tira a entrada do resumo e a lista para revisão); um evento do coletor nunca sobrescreve as palavras do próprio Giovanni; dois escritores com textos diferentes para a mesma chave em 24 h viram um conflito, não uma fusão. Depois ela ordena as entradas para o resumo: preferências nunca decaem, os outros tipos esmaecem com meias-vidas (decisão e fato 180 dias, nota 7 dias), esticadas a cada uso.

## How it does it
Independente da ordem e idempotente (testado): os eventos são ordenados por hora e depois id, e duplicatas contam uma vez. `brief()` cabe o resultado num orçamento de cerca de 2.900 caracteres (2,5 % de uma primeira rodada típica, calibrado pelo `scripts/calibrate.py`).

## Where it sits in the pipeline
Entre o [[events-log]] e tudo o que mostra memória.

## Who receives its output
O [[session-brief]] (pelo [[hook-session-start]]) e as [[memory-views]] (pela [[mem-action]]).
