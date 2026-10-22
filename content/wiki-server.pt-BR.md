---
id: wiki-server
lang: pt-BR
source_hash: bb3f6b6eea93
title: Servidor do wiki (Elixir)
---

## What it is
O back-end do wiki, escrito em Elixir (escolha do Giovanni): um projeto Mix que é ao mesmo tempo o servidor web e o comando `wiki`.

## What it does
Serve o site atrás do login Google ([[wiki-router]]) e contém as ferramentas de conteúdo ([[wiki-check]], [[wiki-build]], [[wiki-hook-stop]], [[wiki-cli]]).

## How it does it
Elixir 1.18 sobre Erlang/OTP 27; Plug + Bandit (servidor HTTP) ouvindo só em 127.0.0.1:4180; Assent para o OpenID Connect do Google. Os segredos vêm de `~/.config/wiki/*.env` (modo 600), nunca do git. Roda como release pelo [[wiki-service]]. Testado com ExUnit (`mix test`).

## Where it sits in the pipeline
Entre o [[tailscale-funnel]] e o [[wiki-site]].

## Who receives its output
Os navegadores, pelo [[tailscale-funnel]].
