---
id: tailscale
lang: pt-BR
source_hash: d41f39d9fb2b
title: Tailscale
---

## What it is
O [Tailscale](https://tailscale.com/) cria uma rede privada entre os dispositivos do próprio Giovanni, chamada "tailnet" (um tipo de [rede privada virtual](https://en.wikipedia.org/wiki/Virtual_private_network), VPN: um link criptografado que faz dispositivos distantes se comportarem como se estivessem na mesma rede local). Funciona atrás de qualquer roteador doméstico, sem configurações especiais. Nela, o notebook é alcançável como `yuji-nitro.tailed3a22.ts.net`.

## What it does
Permite ao celular alcançar o notebook por SSH (Secure Shell, um login remoto criptografado; veja [[remote-terminal]]) e, pelo recurso Funnel ([[tailscale-funnel]]), publica este wiki na internet.

## How it does it
Foi instalado do repositório apt assinado do Tailscale pelo script `setup-sudo.sh`, e o notebook está conectado com a conta do Giovanni.

## Where it sits in the pipeline
A camada de rede sob o acesso remoto e o wiki.

## Who receives its output
O [[tailscale-funnel]] e a conexão SSH vinda do celular.
