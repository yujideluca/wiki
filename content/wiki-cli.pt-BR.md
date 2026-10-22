---
id: wiki-cli
lang: pt-BR
source_hash: 604a82d9280c
title: wiki (comando)
---

## What it is
O comando que o Claude usa para manter o wiki atualizado: um escript Elixir instalado como `~/.local/bin/wiki`.

## What it does
O `wiki publish` é o passo de fim de tarefa: roda o [[wiki-check]] em modo local e o [[wiki-build]], faz commit só do `content/` (trabalho alheio no repositório nunca vai junto), faz push para o repositório privado no [[github]] e registra a hora da publicação para o [[wiki-hook-stop]]. Recusa a qualquer falha.

## How it does it
Compilado com `mix escript.build` a partir do projeto do servidor; `WIKI_ROOT` aponta para o repositório (padrão `~/dev/wiki`). Nunca faz force-push.

## Where it sits in the pipeline
Chamado no [[end-of-task]], antes do `mem use`.

## Who receives its output
O [[github]] (o commit) e o site no ar (pelo [[wiki-site]]).

## Functions
- `wiki check [--local]`: validate the content
- `wiki build`: content → site/data, Elm → site/assets
- `wiki stale`: pages whose sources changed after the page
- `wiki publish -m "msg"`: check --local, build, commit only content/, push
- `wiki hook-stop`: the Claude Code Stop hook
