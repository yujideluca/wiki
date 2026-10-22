---
id: mem-task
lang: pt-BR
source_hash: 43266564fb16
title: mem task (itens em aberto)
aliases: [pendência, item em aberto]
---

## What it is
Como um objetivo inacabado ou problema conhecido fica na frente do Giovanni até ser resolvido: `mem task --check COMO [--category C] "texto"`.

## What it does
Cria um evento `task` (`o que está aberto | check: como conferir se ainda vale`). Ele aparece no início de toda conversa até o Giovanni decidir: resolvido (`mem done`), estacionado (`mem archive`, volta com `mem reopen`) ou apagado (`mem forget`). As regras estão em [[mem-pendency]].

## How it does it
A linha de comando recusa uma tarefa sem verificação. Antes de lembrar o Giovanni de uma, o Claude roda a verificação; se não vale mais, o Claude a fecha.

## Where it sits in the pipeline
Criado no fim de uma sessão para o que ainda está aberto.

## Who receives its output
O [[events-log]] e, depois, o [[session-brief]] de toda conversa.
