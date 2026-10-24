---
id: google-oauth-client
lang: pt-BR
source_hash: a2577a5f3b30
title: Chave de login do Google (cliente OAuth)
---

## What it is
Para permitir que pessoas entrem com a conta Google, um site precisa antes ser registrado no Google. O resultado desse registro é a "chave de login do Google" que o Giovanni criou no [Google Cloud Console](https://console.cloud.google.com/) (projeto `wiki`): um cliente OAuth para aplicação web (OAuth, Open Authorization, é o padrão pelo qual o Google informa a um site quem está entrando, veja [OAuth](https://en.wikipedia.org/wiki/OAuth)). Seu único endereço de redirecionamento (para onde o Google devolve o navegador depois do login) é `https://yuji-nitro.tailed3a22.ts.net/auth/google/callback`.

## What it does
Permite ao [[wiki-router]] perguntar ao Google quem está entrando. O público do projeto fica no modo "Testing" com `yujideluca@gmail.com` como único usuário de teste, o que é uma segunda trava: o próprio Google recusa outras contas.

## How it does it
O client id e o client secret (a "senha" do site perante o Google) ficam só em `~/.config/wiki/oauth.env` (legível só pelo dono, modo de arquivo 600) e são lidos pelo [[wiki-service]]. Nunca estão no git e nunca são mostrados no chat.

## Where it sits in the pipeline
Fora do notebook, no Google.

## Who receives its output
O [[wiki-router]], por meio do redirecionamento do login.
