---
id: wiki-router
lang: pt-BR
source_hash: bbcf4cfc2c84
title: Roteador do wiki (portão de login)
---

## What it is
O roteador (módulo Elixir `Wiki.Web.Router`) é a única porta para o wiki e segue a regra "negar por padrão": nada é mostrado a menos que o visitante tenha provado quem é.

## What it does
Sem uma sessão com o e-mail Google verificado do Giovanni, toda página responde com a [[decoy-page]] e todo caminho `/data` ou `/assets` responde "404 não encontrado". O caminho `/auth/google` inicia o login; o callback aceita exatamente `yujideluca@gmail.com` com `email_verified: true` e um "state" igual ao que foi guardado quando este navegador iniciou o login; `/logout` encerra a sessão.

## How it does it
A sessão fica em um cookie ([cookie](https://en.wikipedia.org/wiki/HTTP_cookie): um pequeno dado que o navegador devolve a cada requisição) criptografado, assinado, HttpOnly (scripts da página não conseguem lê-lo), Secure (enviado só por HTTPS, Hypertext Transfer Protocol Secure, o protocolo web criptografado) e SameSite=Lax (não enviado em requisições iniciadas por outros sites); dura 30 dias e é renovado no login. Toda resposta é marcada `no-store` (não guardar em cache) e leva cabeçalhos de segurança; a CSP (Content Security Policy, uma regra que diz ao navegador o que uma página pode carregar) da isca proíbe qualquer requisição de rede. O login em si é feito pela biblioteca Assent e nunca foi escrito à mão. É coberto pelos testes AU-1 a AU-6.

## Where it sits in the pipeline
Dentro do [[wiki-server]], atrás do [[tailscale-funnel]]; é o núcleo de [[wiki-sign-in]].

## Who receives its output
Com login: o [[wiki-frontend]] e os dados do [[wiki-site]]. Qualquer outra pessoa: a [[decoy-page]].
