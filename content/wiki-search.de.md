---
id: wiki-search
lang: de
source_hash: 85c137f5c4e6
title: Suche mit Autovervollständigung
aliases: [Autovervollständigung]
---

## What it is
Die Suchleiste oben auf jedem Bildschirm und ihre Vorschlagsliste.

## What it does
Beim Tippen werden bis zu 8 Seiten vorgeschlagen, die beste zuerst: exakter Name, dann Anfang, dann Wortanfang, dann irgendwo enthalten, dann Buchstaben in Reihenfolge. Titel und Alias werden in der gewählten Sprache und auf Englisch verglichen, ohne Groß-/Kleinschreibung und Akzente. ↑↓ wählen, Enter zentriert die Karte auf die Seite (oder öffnet sie aus einem Artikel), Esc schließt.

## How it does it
Eine reine, getestete Ranking-Funktion (MP-1).

## Where it sits in the pipeline
In der oberen Leiste von [[wiki-frontend]].

## Who receives its output
[[wiki-frontend]].
