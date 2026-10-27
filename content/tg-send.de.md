---
id: tg-send
lang: de
source_hash: 296364a1ddc0
title: tg-send (Telegram-Sender)
---

## What it is
`tg-send` ist ein kleines Skript, das eine Nachricht oder eine Datei an Giovanni auf [Telegram](https://en.wikipedia.org/wiki/Telegram_%28software%29) (eine Chat-App) sendet, und zwar immer nur an einen gespeicherten Chat. Claude nutzt es, wenn etwas Giovannis Handy erreichen soll, zum Beispiel eine Datei, die sich im Terminal schlecht zeigen lässt.

## Architecture
### Kontext
person c: Claude Code — schickt, was aufs Handy soll | [[claude-code]]
system s: tg-send — schickt eine Nachricht oder Datei an einen gespeicherten Chat
external t: Telegram-Bot-Dienst — transportiert die Nachricht
person g: Giovanni — liest sie im Chat Claude code bridge | [[giovanni]]

c -bittet zu senden-> s
s -sendet über-> t
t -liefert an-> g

### Container
person c: Claude Code | [[claude-code]]
container sc: tg-send-Skript — Bash, jedes Argument wird als Text gesendet
store cf: ~/.config/telegram-bot — Bot-Token und Chat-ID, nie angezeigt
external t: Telegram-Bot-Dienst

c -führt aus-> sc
sc -liest-> cf
sc -sendet über-> t

## What it does
`tg-send "Text"` sendet eine Nachricht; `tg-send -f DATEI [Beschriftung]` sendet eine Datei bis 50 MB mit optionaler Beschriftung. Die Nachrichten kommen im Chat „Claude code bridge“ mit dem Bot an, nicht in Telegrams „Gespeicherten Nachrichten“; Giovanni muss also in diesem Chat nachsehen.

## How it does it
Es ist ein [Bash](https://www.gnu.org/software/bash/)-Skript, das die [Telegram Bot API](https://core.telegram.org/bots/api) aufruft (Application Programming Interface: die Webschnittstelle, die Telegram für Programme anbietet). Der Token des Bots (ein geheimes Passwort für den Bot) und die Chat-ID liegen in `~/.config/telegram-bot/` und werden nie angezeigt. Das Skript hat kein `--help`: Jedes Argument wird als Nachricht gesendet, die Bitte um Hilfe würde also das Wort „--help“ an Giovanni schicken.

## Where it sits in the pipeline
Claude nutzt es, um Giovanni eine Datei oder Notiz aufs Handy zu schicken.

## Who receives its output
Giovanni, im Telegram-Chat „Claude code bridge“.
