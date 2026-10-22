---
id: user-space-tools
lang: pt-BR
source_hash: 010b8b5afe5c
title: Ferramentas no espaço do usuário (~/.local)
---

## What it is
As ferramentas extras instaladas sem sudo em `~/.local`: Node 22 e npm, uv, pyright, kotlin-lsp, rclone, um tmux no espaço do usuário, Elm 0.19.1 (com elm-test e elm-format) e os scripts `mem`, `tg-send`, `claude-assistant` e `wiki`.

## What it does
Dão ao Claude Code servidores de linguagem (pyright, kotlin-lsp para os plugins), ferramentas de build e utilitários. A exceção é o Elixir 1.18 / Erlang OTP 27, instalados com apt pelo Giovanni para o wiki.

## How it does it
Atalhos no `PATH` em `~/.local/bin`; o pyright fica em `~/.local/share/pyright-pkg` (não dá para usar venv) e o kotlin-lsp em `~/.local/opt/kotlin-lsp`. Caminhos e passos de atualização ficam na [[claude-auto-memory]].

## Where it sits in the pipeline
Por baixo do trabalho de todos os projetos.

## Who receives its output
O [[claude-code]], o [[claude-assistant]] e o build do wiki ([[wiki-build]]).
