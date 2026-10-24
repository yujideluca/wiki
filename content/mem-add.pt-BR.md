---
id: mem-add
lang: pt-BR
source_hash: 9c81f1250714
title: mem add (registrar uma preferência ou fato)
---

## What it is
`mem add` é o comando que registra uma nova entrada na memória: uma preferência, um fato, uma decisão, uma tarefa ou uma nota. É o que o Claude executa quando o Giovanni o corrige ou declara uma preferência duradoura.

## What it does
`mem add --type pref --owner user --key topic "a regra"` escreve um arquivo de evento. Cada entrada tem uma `key`, um nome curto para o assunto. Uma entrada mais nova com a mesma key substitui a mais antiga: a nova é marcada automaticamente como substituta da antiga, de modo que uma regra que o Giovanni muda é atualizada em vez de duplicada.

## How it does it
A entrada é verificada pelo [[mem-validator]] antes de ser escrita, e o texto pode ter no máximo 1200 caracteres. O campo `owner` importa: `user` significa que as palavras são do próprio Giovanni, e o [[mem-harvester]] automático nunca pode sobrescrevê-las.

## Where it sits in the pipeline
Usado sempre que o Giovanni corrige o Claude ou declara uma preferência duradoura (uma regra das instruções globais, [[global-claude-md]]).

## Who receives its output
[[events-log]].
