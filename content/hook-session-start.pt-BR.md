---
id: hook-session-start
lang: pt-BR
source_hash: e610c985eb91
title: Hook SessionStart (mem hook-session-start)
---

## What it is
O hook do Claude Code que roda quando uma conversa começa: `python3 ~/dev/workflow-memory/bin/mem hook-session-start` (limite de 40 s).

## What it does
Faz pull do repositório de memória, dobra os eventos e imprime o [[session-brief]] do projeto atual (o nome da pasta da conversa).

## How it does it
Nunca pode falhar de forma barulhenta: a saída vai para o contexto do modelo, então os erros vão para `~/.local/state/mem/hook.log`. Offline, usa o último estado baixado.

## Where it sits in the pipeline
O primeiro passo do [[chat-start]].

## Who receives its output
O [[session-brief]] → a sessão do Claude Code.
