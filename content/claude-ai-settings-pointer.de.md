---
id: claude-ai-settings-pointer
lang: de
source_hash: 342b34c30f7d
title: Zeiger in den claude.ai-Einstellungen
---

## What it is
Ein „Zeiger“ (Pointer) ist ein kurzer Text, der auf etwas anderes verweist, statt den Inhalt selbst zu enthalten. Dieser hier ist ein kurzer portugiesischer Text, den Giovanni einmal in das Einstellungsfeld für Präferenzen von claude.ai eingefügt hat. Eine Kopie liegt in der Datei `docs/CLAUDE-AI.md` von [[workflow-memory]].

## What it does
Er weist jeden Chat der Claude-App an, die GitHub-Werkzeuge zu laden, die Datei `views/BRIEF.md` zu lesen und ihr zu folgen. Schlägt das fehl, befolgt der Chat trotzdem drei Grundregeln: in der Sprache der Nachricht antworten, einfach erklären und nie klinische, geheime oder Kontaktdaten über andere Personen speichern.

## How it does it
Nur Giovanni kann in dieses Einstellungsfeld schreiben, daher lässt sich dort nichts Langes ablegen. Deshalb ist es nur ein Zeiger: Der eigentliche Inhalt steht im Brief, den eine GitHub Action (ein automatischer Auftrag auf GitHub) neu erzeugt, sobald sich das Gedächtnis ändert. Der Zeiger ersetzte eine ältere Zeile, die Chats `code/CORE.md` des alten, stillgelegten Repositories lesen ließ.

## Where it sits in the pipeline
Ganz am Anfang jedes Chats in der [[claude-app]].

## Who receives its output
[[mem-github-connector]], der Ablauf, mit dem die App danach das Gedächtnis liest und schreibt.
