---
id: tailscale-funnel
lang: pt-BR
source_hash: 4824d15fe304
title: Tailscale Funnel (endereço público)
---

## What it is
O recurso da Tailscale que publica uma porta do notebook na internet em `https://yuji-nitro.tailed3a22.ts.net`, escolhido pelo Giovanni em vez de comprar um domínio.

## What it does
Recebe HTTPS de qualquer lugar, encerra o TLS (o certificado é gerenciado pela Tailscale) e encaminha para o [[wiki-server]] em 127.0.0.1:4180. Nenhuma porta do roteador é aberta.

## How it does it
`tailscale funnel --bg 4180`, persistente entre reinicializações; grátis, sem precisar de domínio. Só fica no ar enquanto o notebook está ligado e acordado.

## Where it sits in the pipeline
Entre a internet e o [[wiki-server]], por cima do [[tailscale]].

## Who receives its output
O [[wiki-server]].
