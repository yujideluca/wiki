---
id: wiki-sign-in
lang: pt-BR
source_hash: c3dabaf9143a
title: Entrando no wiki
---

## What it is
Esta página acompanha o que acontece entre abrir o endereço do wiki e ver o mapa.

## What it does
Deixa entrar exatamente uma conta Google e mostra a isca a todos os outros.

## How it does it
Usa o Google OpenID Connect (OIDC, uma forma padrão de entrar com uma conta já existente; veja [como funciona](https://openid.net/developers/how-connect-works/)) por meio do [[google-oauth-client]], e a verificação é feita pelo [[wiki-router]].

## Where it sits in the pipeline
Na frente de tudo no [[wiki]].

## Who receives its output
O [[giovanni]] (o mapa) ou um visitante (a isca).

## Steps
1. O navegador abre `https://yuji-nitro.tailed3a22.ts.net`; o [[tailscale-funnel]] encaminha a requisição ao notebook.
2. O [[wiki-router]] não encontra sessão e responde com a [[decoy-page]].
3. "Entrar com o Google" vai para `/auth/google`, que guarda um "state" aleatório na sessão e redireciona ao Google ([[google-oauth-client]]).
4. O Google pede a conta; só o usuário de teste pode continuar.
5. O Google devolve o navegador a `/auth/google/callback`; o roteador confere o state, a assinatura da resposta do Google, o `email_verified` e que o e-mail é exatamente yujideluca@gmail.com.
6. Um novo cookie de sessão criptografado é definido e o navegador vai para `/`.
7. O roteador agora serve o app Elm ([[wiki-frontend]]), que carrega seus dados do [[wiki-site]].
