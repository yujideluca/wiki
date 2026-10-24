---
id: wiki-cli
lang: pt-BR
source_hash: 6477af02e256
title: wiki (comando)
---

## What it is
`wiki` é o comando que o Claude usa para manter o wiki em dia: um escript Elixir (um programa empacotado em um único arquivo executável) instalado como `~/.local/bin/wiki`.

## What it does
`wiki publish` é o passo do fim da tarefa. Executa o [[wiki-check]] em modo local, depois o [[wiki-build]], faz commit apenas da pasta `content/` (para que trabalho não relacionado no repositório nunca seja arrastado) e a envia ao repositório privado no [[github]], e por fim registra o momento da publicação para o [[wiki-hook-stop]]. Recusa diante de qualquer falha.

## How it does it
É construído com `mix escript.build` a partir do projeto do servidor; a variável `WIKI_ROOT` aponta para o repositório (padrão `~/dev/wiki`). Nunca faz force-push.

## Where it sits in the pipeline
Chamado em [[end-of-task]], antes de `mem use`.

## Who receives its output
O [[github]] (o commit) e o site no ar (pelo [[wiki-site]]).

## Functions
- `wiki check [--local]`: validar o conteúdo
- `wiki build`: conteúdo → site/data, Elm → site/assets
- `wiki stale`: páginas cujas fontes mudaram depois da página
- `wiki publish -m "msg"`: check --local, build, commit só de content/, push
- `wiki hook-stop`: o hook Stop do Claude Code
