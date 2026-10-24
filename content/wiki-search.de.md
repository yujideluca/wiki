---
id: wiki-search
lang: de
source_hash: 92adc83dc419
title: Suche mit Autovervollständigung
---

## What it is
Das ist die Suchleiste oben auf jedem Bildschirm und ihre Vorschlagsliste (Autovervollständigung: die Liste, die beim Tippen erscheint).

## What it does
Beim Tippen werden bis zu 8 Seiten vorgeschlagen, die beste zuerst: genauer Name, dann Präfix, dann Wortanfang, dann irgendwo enthalten, dann Buchstaben in Reihenfolge. Titel und Aliasse (andere Namen, unter denen eine Seite bekannt ist) werden in der gewählten Sprache und auf Englisch verglichen, ohne Rücksicht auf Groß-/Kleinschreibung und Akzente. Die Pfeiltasten ↑ und ↓ wählen, Enter zentriert die Karte auf die Seite (oder öffnet sie aus einem Artikel), und Esc schließt die Liste.

## How it does it
Es ist eine reine Rangfolgefunktion und getestet (Anforderung MP-1).

## Where it sits in the pipeline
In der oberen Leiste des [[wiki-frontend]].

## Who receives its output
Das [[wiki-frontend]].
