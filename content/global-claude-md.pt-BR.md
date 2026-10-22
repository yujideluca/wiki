---
id: global-claude-md
lang: pt-BR
source_hash: 66237ee44f5f
title: CLAUDE.md global
aliases: [instruções globais]
---

## What it is
O `~/.claude/CLAUDE.md`: as instruções privadas do Giovanni para toda sessão do Claude Code no notebook.

## What it does
Aponta o [[workflow-memory]] como memória compartilhada; diz como registrar uma correção (`mem add`), informar o que guiou uma tarefa (`mem use`) e marcar uma entrada errada; proíbe editar `events/` ou `views/` à mão e guardar dados clínicos, secretos ou de contato de outras pessoas; e torna a atualização do wiki parte de terminar uma tarefa ([[end-of-task]]).

## How it does it
Carregado automaticamente no contexto de toda sessão, ao lado do resumo.

## Where it sits in the pipeline
Lido no [[chat-start]].

## Who receives its output
O [[claude-code]] e o [[remote-assistant]].
