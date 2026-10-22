---
id: hook-prompt
lang: pt-BR
source_hash: 58369d16ec08
title: Hook UserPromptSubmit (mem hook-prompt)
---

## What it is
O hook do Claude Code que roda a cada mensagem que o Giovanni manda: `mem hook-prompt` (limite de 10 s).

## What it does
Passa o texto da mensagem ao [[mem-harvester]], que registra qualquer preferência declarada. Não imprime nada.

## How it does it
Os erros vão para o log do hook; sempre sai com 0, então nunca bloqueia uma mensagem.

## Where it sits in the pipeline
Entre a mensagem do Giovanni e o modelo.

## Who receives its output
O [[mem-harvester]].
