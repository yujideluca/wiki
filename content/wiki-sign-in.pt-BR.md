---
id: wiki-sign-in
lang: pt-BR
source_hash: 70055bc714fd
title: Entrando no wiki
---

## What it is
Esta página acompanha o que acontece entre abrir o endereço do wiki e ver o mapa.

## Flow
trigger t1: Um navegador abre o endereço da wiki | [[tailscale-funnel]]
step s1: O funnel encaminha o pedido ao notebook | [[tailscale-funnel]]
step s2: O roteador procura uma sessão válida | [[wiki-router]]
decide d1: Existe uma sessão válida?
step s3: Responde com a página isca | [[decoy-page]]
step s4: Entrar com Google: guarda um valor aleatório e redireciona ao Google | [[google-oauth-client]]
decide d2: É exatamente o e-mail Google verificado do Giovanni?
step s5: Define um cookie de sessão novo e criptografado e volta ao início
step s6: O roteador serve o app Elm, que carrega seus dados | [[wiki-frontend]]
product p1: O mapa, no navegador do Giovanni | [[wiki-site]]
product p2: Recusado: só a isca é mostrada

t1 -> s1
s1 -> s2
s2 -> d1
d1 -sim-> s6
d1 -não-> s3
s3 -> s4
s4 -> d2
d2 -sim-> s5
d2 -não-> p2
s5 -> s6
s6 -> p1

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
