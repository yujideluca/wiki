---
id: wiki-sign-in
lang: pt-BR
source_hash: 62f6f45a7908
title: Entrando no wiki
aliases: [fluxo de login]
---

## What it is
O que acontece entre abrir o endereço do wiki e ver o mapa.

## What it does
Deixa entrar exatamente uma conta Google e mostra a isca para todos os outros.

## How it does it
OpenID Connect do Google pelo [[google-oauth-client]], conferido pelo [[wiki-router]].

## Where it sits in the pipeline
Na frente de tudo no [[wiki]].

## Who receives its output
O [[giovanni]] (o mapa) ou um visitante (a isca).

## Steps
1. O navegador abre `https://yuji-nitro.tailed3a22.ts.net`; o [[tailscale-funnel]] encaminha para o notebook.
2. O [[wiki-router]] não encontra sessão e responde com a [[decoy-page]].
3. "Sign in with Google" vai para `/auth/google`, que guarda um state aleatório na sessão e redireciona para o Google ([[google-oauth-client]]).
4. O Google pede a conta; só o usuário de teste pode seguir.
5. O Google manda o navegador de volta a `/auth/google/callback`; o roteador confere o state, a assinatura da resposta do Google, o `email_verified` e se o e-mail é exatamente yujideluca@gmail.com.
6. Um cookie de sessão criptografado novo é criado e o navegador vai para `/`.
7. O roteador agora serve o app em Elm ([[wiki-frontend]]), que carrega os dados do [[wiki-site]].
