---
id: hook-stop
lang: pt-BR
source_hash: 12ac2c848f9a
title: Hook Stop (mem hook-stop)
---

## What it is
O hook do Claude Code da memória que roda quando o Claude termina uma rodada: `mem hook-stop` (limite de 40 s).

## What it does
Faz push dos eventos novos de memória para o GitHub, para o app do Claude e a próxima sessão verem.

## How it does it
Chama o `push` do [[mem-sync]]; offline faz commit local e push depois; falhas vão para o log do hook. Roda ao lado do hook Stop do próprio wiki ([[wiki-hook-stop]]).

## Where it sits in the pipeline
No fim de cada rodada.

## Who receives its output
O [[mem-sync]] → [[github]].
