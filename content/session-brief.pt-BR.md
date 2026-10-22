---
id: session-brief
lang: pt-BR
source_hash: 2b6add466f4b
title: Resumo da sessão (memória no início da conversa)
aliases: [resumo]
---

## What it is
O bloco de texto que uma conversa do Claude Code vê primeiro: "Memory (workflow-memory)…" com as preferências permanentes do Giovanni (cada uma com seu #código), os itens em aberto e como registrar, informar e dar retorno.

## What it does
Define padrões para a sessão (nunca autoriza nada); a precedência é instrução atual > arquivo de regras do repositório > memória do projeto > perfil.

## How it does it
Impresso pelo [[hook-session-start]] a partir do [[memory-fold]] e do [[mem-pendency]], dentro dos orçamentos; diz "memory may be stale" quando o pull falhou.

## Where it sits in the pipeline
A primeira entrada de toda sessão do Claude Code ([[chat-start]]).

## Who receives its output
O [[claude-code]] e o [[remote-assistant]].
