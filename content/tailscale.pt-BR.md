---
id: tailscale
lang: pt-BR
source_hash: b0656788e52a
title: Tailscale
---

## What it is
Uma rede privada entre os aparelhos do Giovanni (uma "tailnet") que funciona através de qualquer roteador; nela o notebook é `yuji-nitro.tailed3a22.ts.net`.

## What it does
Deixa o celular acessar o notebook por SSH ([[remote-terminal]]) e, pelo [[tailscale-funnel]], publica este wiki na internet.

## How it does it
Instalado do repositório apt assinado da Tailscale pelo `setup-sudo.sh`; conectado com a conta do Giovanni.

## Where it sits in the pipeline
A camada de rede por baixo do acesso remoto e do wiki.

## Who receives its output
O [[tailscale-funnel]] e a conexão SSH do celular.
