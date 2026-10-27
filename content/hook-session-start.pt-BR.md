---
id: hook-session-start
lang: pt-BR
source_hash: 595edec48d32
title: Hook SessionStart (mem hook-session-start)
---

## What it is
Um hook é um pequeno programa que o [[claude-code]] executa automaticamente quando um certo evento acontece ([hooks explicados](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Este roda quando uma conversa começa: `python3 ~/dev/workflow-memory/bin/mem hook-session-start`, com limite de 40 segundos. Sua função é dar memória à nova conversa.

## What it does
Baixa do GitHub a versão mais recente da memória, combina os eventos guardados no estado atual e imprime o [[session-brief]] do projeto atual (o projeto vem do nome da pasta em que a conversa foi aberta). O que um hook imprime nesse momento é colocado diante do modelo, e é assim que o Claude "lembra" as preferências do Giovanni.

## How it does it
Ele nunca pode falhar de forma ruidosa, porque o que imprime vai direto para o contexto do modelo: uma mensagem de erro ali confundiria a conversa. Por isso os erros vão para um arquivo de log, `~/.local/state/mem/hook.log`. Se o notebook estiver offline, usa o último estado que baixou, e o resumo avisa que a memória pode estar desatualizada. O hook roda quando um chat começa, depois de `/clear` e depois de uma compactação (o Claude Code encolhe um chat longo num resumo). Depois de `/clear` ou de uma compactação, ele imprime cada regra cortada nos primeiros 110 caracteres, para economizar tokens (a unidade em que um modelo lê e é cobrado); o texto completo está a um `mem search` de distância. O Codex chama o mesmo comando como `mem --instance codex hook-session-start`; por isso regras com escopo `instance:codex` chegam só ao Codex, e regras só do Codex não carregam mais no Claude Code.

## Where it sits in the pipeline
É o primeiro passo de [[chat-start]].

## Who receives its output
O [[session-brief]] e, por meio dele, a sessão do Claude Code.
