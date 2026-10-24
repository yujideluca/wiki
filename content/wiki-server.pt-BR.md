---
id: wiki-server
lang: pt-BR
source_hash: 72a8ae50df78
title: Servidor do wiki (Elixir)
---

## What it is
O servidor é o back end do wiki: o programa que roda no notebook, responde às requisições do navegador e decide quem pode ver o quê. É escrito em [Elixir](https://elixir-lang.org/) (escolha do Giovanni) e é um único projeto Mix (Mix é a ferramenta de build do Elixir) que é ao mesmo tempo o servidor web e o comando `wiki`.

## What it does
Serve o site atrás do login do Google ([[wiki-router]]) e contém as ferramentas de conteúdo ([[wiki-check]], [[wiki-build]], [[wiki-hook-stop]], [[wiki-cli]]).

## How it does it
Roda em Elixir 1.18 e Erlang/OTP 27 (OTP é a Open Telecom Platform, as bibliotecas padrão e o ambiente de execução do Erlang). Usa Plug e [Bandit](https://github.com/mtrudel/bandit) (o servidor HTTP) escutando só em 127.0.0.1 porta 4180, o que significa que só o próprio notebook o alcança diretamente; o mundo externo o alcança pelo [[tailscale-funnel]]. A biblioteca [Assent](https://hexdocs.pm/assent) cuida do Google OpenID Connect (o protocolo de login). Os segredos vêm dos arquivos `~/.config/wiki/*.env` (legíveis só pelo dono), nunca do git. Roda como release (um build empacotado autossuficiente) sob o [[wiki-service]] e é testado com ExUnit (`mix test`).

## Where it sits in the pipeline
Entre o [[tailscale-funnel]] e o [[wiki-site]].

## Who receives its output
Navegadores, pelo [[tailscale-funnel]].
