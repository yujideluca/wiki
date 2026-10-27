---
id: tg-send
title: tg-send (Telegram sender)
aliases: [Telegram bot, Claude code bridge]
kind: program
project: laptop-setup
status: active
location: home:.local/bin/tg-send
fed_by: []
feeds: []
sources: [home:.local/bin/tg-send]
memory: [#c09dc8]
reviewed: 2026-10-27T01:45Z
---

## What it is
`tg-send` is a small script that sends a message or a file to Giovanni on [Telegram](https://en.wikipedia.org/wiki/Telegram_%28software%29) (a chat app), and only ever to one saved chat. Claude uses it when something should reach Giovanni's phone, for example a file that is too awkward to show in the terminal.

## Architecture
### Context
person c: Claude Code — sends what should reach the phone | [[claude-code]]
system s: tg-send — sends one message or file to one saved chat
external t: Telegram bot service — carries the message
person g: Giovanni — reads it in the chat Claude code bridge | [[giovanni]]

c -asks to send-> s
s -sends through-> t
t -delivers to-> g

### Containers
person c: Claude Code | [[claude-code]]
container sc: tg-send script — Bash, any argument is sent as text
store cf: ~/.config/telegram-bot — bot token and chat id, never shown
external t: Telegram bot service

c -runs-> sc
sc -reads-> cf
sc -sends through-> t

## What it does
`tg-send "text"` sends a message; `tg-send -f FILE [caption]` sends a file of up to 50 MB with an optional caption. The messages arrive in the chat called "Claude code bridge" with the bot, not in Telegram's "Saved Messages", so Giovanni must look in that chat.

## How it does it
It is a [Bash](https://www.gnu.org/software/bash/) script that calls the [Telegram Bot API](https://core.telegram.org/bots/api) (application programming interface: the web interface Telegram offers to programs). The bot's token (a secret password for the bot) and the chat id are stored in `~/.config/telegram-bot/` and are never displayed. The script has no `--help`: any argument you give it is sent as a message, so asking for help would send the word "--help" to Giovanni.

## Where it sits in the pipeline
It is used by Claude to hand Giovanni a file or a note on the phone.

## Who receives its output
Giovanni, in the Telegram chat "Claude code bridge".
