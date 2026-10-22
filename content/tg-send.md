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
---

## What it is
A small script that sends a message or a file to Giovanni on Telegram, only ever to the one saved chat.

## What it does
`tg-send "text"` or `tg-send -f FILE [caption]` (files up to 50 MB). Messages arrive in the "Claude code bridge" chat of the bot, not in Saved Messages.

## How it does it
Bash calling the Telegram Bot API with the token and chat id stored in `~/.config/telegram-bot/` (never shown). It has no `--help`: any argument is sent as a message.

## Where it sits in the pipeline
Used by Claude to hand Giovanni a file or note on the phone.

## Who receives its output
Giovanni, in the Telegram chat "Claude code bridge".
