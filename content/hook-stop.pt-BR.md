---
id: hook-stop
lang: pt-BR
source_hash: a02912aa4595
title: Hook Stop (mem hook-stop)
---

## What it is
Um hook é um pequeno programa que o [[claude-code]] executa automaticamente em um certo evento ([hooks explicados](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Este é o hook "Stop" da memória: `mem hook-stop`, com limite de 40 segundos. Roda toda vez que o Claude termina uma resposta.

## What it does
Envia (push) os novos eventos de memória para o GitHub, para que o app Claude e a próxima sessão possam vê-los.

## How it does it
Chama a função de envio do [[mem-sync]]. Se o notebook estiver offline, salva os eventos localmente (um "commit" do git) e envia depois. Falhas vão para o log do hook. Roda ao lado do hook Stop do próprio wiki ([[wiki-hook-stop]]).

## Where it sits in the pipeline
O fim de cada rodada (uma rodada é uma pergunta do Giovanni e a resposta do Claude).

## Who receives its output
O [[mem-sync]] e, a partir dele, o [[github]].
