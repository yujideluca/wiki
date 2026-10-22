---
id: google-oauth-client
lang: pt-BR
source_hash: 7d5a996047e7
title: Chave de login do Google (cliente OAuth)
---

## What it is
A "chave de login do Google" que o Giovanni criou no Google Cloud Console (projeto `wiki`): um cliente OAuth do tipo aplicativo web cuja única URI de redirecionamento é `https://yuji-nitro.tailed3a22.ts.net/auth/google/callback`.

## What it does
Deixa o [[wiki-router]] perguntar ao Google quem está entrando. O público fica em Teste com `yujideluca@gmail.com` como único usuário de teste, uma segunda trava: o próprio Google recusa outras contas.

## How it does it
O id e o segredo do cliente ficam só em `~/.config/wiki/oauth.env` (modo 600), lidos pelo [[wiki-service]]; nunca no git, nunca no chat.

## Where it sits in the pipeline
Fora do notebook, no Google.

## Who receives its output
O [[wiki-router]] (pelo redirecionamento do login).
