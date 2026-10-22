---
id: tg-send
lang: pt-BR
source_hash: 76ef25373a37
title: tg-send (envio pelo Telegram)
aliases: [bot do Telegram]
---

## What it is
Um script pequeno que manda uma mensagem ou arquivo para o Giovanni no Telegram, sempre só para o único chat salvo.

## What it does
`tg-send "texto"` ou `tg-send -f ARQUIVO [legenda]` (arquivos até 50 MB). As mensagens chegam no chat "Claude code bridge" do bot, não nas Mensagens Salvas.

## How it does it
Bash chamando a API de bots do Telegram com o token e o id do chat guardados em `~/.config/telegram-bot/` (nunca exibidos). Não tem `--help`: qualquer argumento é enviado como mensagem.

## Where it sits in the pipeline
Usado pelo Claude para entregar ao Giovanni um arquivo ou recado no celular.

## Who receives its output
O Giovanni, no chat do Telegram "Claude code bridge".
