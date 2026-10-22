---
id: wiki-router
lang: pt-BR
source_hash: 6de46422dca8
title: Roteador do wiki (portão de login)
---

## What it is
A única porta do wiki (`Wiki.Web.Router`): nega por padrão.

## What it does
Sem uma sessão com o e-mail Google verificado do Giovanni, toda página responde com a [[decoy-page]] e todo caminho `/data` ou `/assets` responde 404. `/auth/google` inicia o login; o retorno aceita exatamente `yujideluca@gmail.com` com `email_verified: true` e um state igual ao do início do login neste navegador; `/logout` encerra a sessão.

## How it does it
Cookie de sessão criptografado e assinado, HttpOnly, Secure, SameSite=Lax (30 dias), renovado no login. Toda resposta é `no-store` com cabeçalhos de segurança; a Content-Security-Policy da isca proíbe qualquer requisição de rede. O login em si é feito pela biblioteca Assent, nunca feito à mão. Testes marcados AU-1…AU-6.

## Where it sits in the pipeline
Dentro do [[wiki-server]], atrás do [[tailscale-funnel]]; o centro do [[wiki-sign-in]].

## Who receives its output
Com login: o [[wiki-frontend]] e os dados do [[wiki-site]]. Qualquer outro: a [[decoy-page]].
