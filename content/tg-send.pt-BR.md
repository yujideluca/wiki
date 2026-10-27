---
id: tg-send
lang: pt-BR
source_hash: 296364a1ddc0
title: tg-send (enviador de Telegram)
---

## What it is
`tg-send` é um pequeno script que envia uma mensagem ou um arquivo ao Giovanni pelo [Telegram](https://en.wikipedia.org/wiki/Telegram_%28software%29) (um app de conversa), e sempre para uma única conversa salva. O Claude o usa quando algo deve chegar ao celular do Giovanni, por exemplo um arquivo difícil de mostrar no terminal.

## Architecture
### Contexto
person c: Claude Code — envia o que deve chegar ao celular | [[claude-code]]
system s: tg-send — envia uma mensagem ou arquivo para um chat salvo
external t: Serviço de bot do Telegram — leva a mensagem
person g: Giovanni — lê no chat Claude code bridge | [[giovanni]]

c -pede para enviar-> s
s -envia pelo-> t
t -entrega ao-> g

### Contêineres
person c: Claude Code | [[claude-code]]
container sc: Script tg-send — Bash, qualquer argumento é enviado como texto
store cf: ~/.config/telegram-bot — token do bot e id do chat, nunca exibidos
external t: Serviço de bot do Telegram

c -executa o-> sc
sc -lê-> cf
sc -envia pelo-> t

## What it does
`tg-send "texto"` envia uma mensagem; `tg-send -f ARQUIVO [legenda]` envia um arquivo de até 50 MB com legenda opcional. As mensagens chegam na conversa chamada "Claude code bridge" com o bot, e não nas "Mensagens salvas" do Telegram, então o Giovanni precisa olhar nessa conversa.

## How it does it
É um script [Bash](https://www.gnu.org/software/bash/) que chama a [Telegram Bot API](https://core.telegram.org/bots/api) (application programming interface: a interface web que o Telegram oferece a programas). O token do bot (uma senha secreta do bot) e o id da conversa ficam em `~/.config/telegram-bot/` e nunca são exibidos. O script não tem `--help`: qualquer argumento é enviado como mensagem, então pedir ajuda mandaria a palavra "--help" ao Giovanni.

## Where it sits in the pipeline
É usado pelo Claude para entregar ao Giovanni um arquivo ou uma nota no celular.

## Who receives its output
O Giovanni, na conversa do Telegram "Claude code bridge".
