---
id: mem-add
lang: pt-BR
source_hash: f2f175d2603e
title: mem add (registrar preferência ou fato)
aliases: [adicionar entrada]
---

## What it is
O comando que registra uma entrada nova: preferência, fato, decisão, tarefa ou nota.

## What it does
`mem add --type pref --owner user --key tema "a regra"` grava um evento; uma entrada mais nova com a mesma chave substitui a antiga (marcada como `supersedes` automaticamente), então uma regra mudada pelo Giovanni é atualizada, não duplicada.

## How it does it
Validada pelo [[mem-validator]] antes de gravar; texto de no máximo 1200 caracteres; dono `user` significa palavras do próprio Giovanni, que o [[mem-harvester]] nunca pode sobrescrever.

## Where it sits in the pipeline
Sempre que o Giovanni corrige o Claude ou declara uma preferência duradoura (regra do CLAUDE.md global).

## Who receives its output
O [[events-log]].
