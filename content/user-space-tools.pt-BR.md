---
id: user-space-tools
lang: pt-BR
source_hash: 03106cc61294
title: Ferramentas em espaço de usuário (~/.local)
---

## What it is
"Espaço de usuário" significa instalado nas pastas do próprio usuário em vez das pastas do sistema, de modo que não são necessários direitos de administrador. Esta página trata das ferramentas extras que o notebook do Giovanni tem em `~/.local`: [Node.js](https://nodejs.org/) 22 com npm (ambiente de execução de JavaScript e seu instalador de pacotes), [uv](https://docs.astral.sh/uv/) (uma ferramenta rápida de pacotes Python), pyright (verificador de tipos de Python), kotlin-lsp (um auxiliar que explica código Kotlin para editores), rclone (copia arquivos para armazenamento em nuvem), uma cópia do tmux (um terminal que continua rodando sem janela), shellcheck 0.11.0 (um verificador de scripts de shell, usado pelo [[pipeline-check]]), [Elm](https://elm-lang.org/) 0.19.1 com elm-test e elm-format, e os scripts `mem`, `tg-send`, `claude-assistant` e `wiki`.

## What it does
Dão ao Claude Code servidores de linguagem (programas que informam erros e definições de código pelo Language Server Protocol, LSP), ferramentas de build e auxiliares. A exceção é o [Elixir](https://elixir-lang.org/) 1.18 com Erlang/OTP 27 (OTP é a Open Telecom Platform, as bibliotecas padrão do Erlang): esses foram instalados pelo Giovanni com o gerenciador de pacotes do sistema, o `apt`, para o wiki.

## How it does it
Pequenos scripts de apoio no `PATH` (a lista de pastas onde se procuram comandos) em `~/.local/bin`. O pyright fica em `~/.local/share/pyright-pkg` porque não foi possível usar um ambiente virtual, e o kotlin-lsp em `~/.local/opt/kotlin-lsp`. Os caminhos exatos e os passos de atualização ficam em [[claude-auto-memory]].

## Where it sits in the pipeline
Por baixo do trabalho de todos os projetos.

## Who receives its output
O [[claude-code]], o [[claude-assistant]] e o build do wiki ([[wiki-build]]).

O iniciador instalado `codex` e o comando `codex-task-progress` fornecem a linha fixa de progresso separada ([[codex-pbar]]). A exibição de uso do Codex tem configuração própria ([[codex-status-line]]).
