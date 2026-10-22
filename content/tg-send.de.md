---
id: tg-send
lang: de
source_hash: 76ef25373a37
title: tg-send (Telegram-Sender)
aliases: [Telegram-Bot]
---

## What it is
Ein kleines Skript, das eine Nachricht oder Datei per Telegram an Giovanni schickt, immer nur an den einen gespeicherten Chat.

## What it does
`tg-send "Text"` oder `tg-send -f DATEI [Beschriftung]` (Dateien bis 50 MB). Nachrichten kommen im Chat „Claude code bridge“ des Bots an, nicht in den gespeicherten Nachrichten.

## How it does it
Bash ruft die Telegram-Bot-API mit Token und Chat-ID aus `~/.config/telegram-bot/` auf (nie angezeigt). Es hat kein `--help`: Jedes Argument wird als Nachricht gesendet.

## Where it sits in the pipeline
Von Claude genutzt, um Giovanni eine Datei oder Notiz aufs Handy zu schicken.

## Who receives its output
Giovanni, im Telegram-Chat „Claude code bridge“.
