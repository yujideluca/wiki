---
id: tailscale-funnel
lang: pt-BR
source_hash: 2e96d8b2d9ad
title: Tailscale Funnel (endereço público)
---

## What it is
O [Tailscale Funnel](https://tailscale.com/kb/1223/funnel) é o recurso do Tailscale que torna uma porta do notebook acessível a toda a internet, no endereço `https://yuji-nitro.tailed3a22.ts.net`. Uma "porta" é uma entrada numerada de um computador onde um programa fica escutando. O Giovanni escolheu o Funnel em vez de comprar um nome de domínio.

## What it does
Recebe tráfego web seguro (HTTPS, Hypertext Transfer Protocol Secure) de qualquer lugar, cuida da criptografia (TLS, Transport Layer Security; o certificado é gerenciado pelo próprio Tailscale) e encaminha o pedido ao [[wiki-server]] no endereço 127.0.0.1, porta 4180. Nenhuma porta precisa ser aberta no roteador de casa.

## How it does it
O comando `tailscale funnel --bg 4180` configura tudo e a configuração persiste entre reinicializações. É gratuito e não exige domínio. O endereço só funciona enquanto o notebook estiver ligado e acordado.

## Where it sits in the pipeline
Entre a internet e o [[wiki-server]], sobre o [[tailscale]].

## Who receives its output
O [[wiki-server]].
