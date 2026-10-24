---
id: chat-start
lang: pt-BR
source_hash: 13cb6baff016
title: O que acontece quando uma conversa começa
---

## What it is
Esta página descreve a sequência que dá memória a uma nova conversa do [[claude-code]], antes de a primeira mensagem do Giovanni ser respondida. Sem ela, toda conversa começaria do zero.

## What it does
Faz toda sessão começar com as mesmas preferências permanentes e a mesma lista de pendências, não importa em qual projeto a conversa seja aberta.

## How it does it
O Claude Code executa os hooks de "início de sessão" configurados em [[claude-code-settings]] (um hook é um pequeno programa executado automaticamente em um evento). O hook da memória imprime um resumo chamado brief; o que é impresso nesse momento passa a fazer parte do que o modelo lê primeiro.

## Where it sits in the pipeline
Antes de qualquer trabalho em qualquer projeto.

## Who receives its output
O [[claude-code]] (e o [[remote-assistant]], que começa do mesmo jeito).

## Steps
1. O Giovanni abre o Claude Code em uma pasta (ou o assistente reinicia) — [[claude-code]].
2. O Claude Code lê [[claude-code-settings]] e executa o hook SessionStart [[hook-session-start]].
3. O hook baixa o `workflow-memory` mais recente do GitHub ([[mem-sync]]).
4. O [[memory-fold]] combina os eventos guardados no estado atual e os ordena para caber em um orçamento de tamanho.
5. O [[mem-pendency]] acrescenta as pendências deste projeto, com a regra de verificá-las antes de mencioná-las.
6. O [[session-brief]] é impresso no contexto do modelo, junto com as instruções de [[global-claude-md]] e o índice da pequena memória própria do Claude Code ([[claude-auto-memory]]).
7. O Claude responde seguindo esses padrões; quando a tarefa termina, [[end-of-task]] fecha o ciclo.
