---
id: chat-start
lang: pt-BR
source_hash: 2055347cc02e
title: O que acontece quando uma conversa começa
aliases: [início da sessão]
---

## What it is
A sequência que dá a uma conversa nova do Claude Code a sua memória antes de a primeira mensagem do Giovanni ser respondida.

## What it does
Faz toda sessão começar com as mesmas preferências permanentes e itens em aberto, em qualquer projeto.

## How it does it
O Claude Code roda os hooks SessionStart configurados no [[claude-code-settings]]; o da memória imprime o resumo.

## Where it sits in the pipeline
Antes de qualquer trabalho em qualquer projeto.

## Who receives its output
O [[claude-code]] (e o [[remote-assistant]]).

## Steps
1. O Giovanni abre o Claude Code numa pasta (ou o assistente reinicia) — [[claude-code]].
2. O Claude Code lê o [[claude-code-settings]] e roda o hook SessionStart [[hook-session-start]].
3. O hook faz pull do `workflow-memory` no GitHub ([[mem-sync]]).
4. O [[memory-fold]] dobra o [[events-log]] no estado atual e o ordena dentro do orçamento.
5. O [[mem-pendency]] acrescenta os itens em aberto deste projeto, com a regra de verificação.
6. O [[session-brief]] é impresso no contexto do modelo, junto com o [[global-claude-md]] e o índice da memória automática ([[claude-auto-memory]]).
7. O Claude responde seguindo esses padrões; quando a tarefa termina, o [[end-of-task]] fecha o ciclo.
