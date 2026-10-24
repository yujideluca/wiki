---
id: wiki-check
lang: de
source_hash: 25401c8d1e9e
title: wiki check (Inhaltsregeln)
---

## What it is
Jede Regel, der eine Seite folgen muss, bevor sie veröffentlicht werden kann (Elixir-Modul `Wiki.Content.Check`).

## What it does
Kopffelder und Arten gültig; die fünf Abschnitte vorhanden und nicht leer; jeder `[[Link]]`, `fed_by` und `feeds` löst auf; `fed_by`/`feeds` symmetrisch; keine verwaisten Seiten (außer Akteuren und Externem); Datenschutzprüfung (Schlüssel, Tokens, Passwörter, Telefonnummern, E-Mails außer Giovannis; die Muster sind die `privacy-patterns.tsv` von workflow-memory, nach `server/priv/` kopiert und vom Tor verglichen); Beförderung (eine auf einer Seite gelistete Funktion, die zwei andere Seiten erwähnen, braucht eine eigene Seite); eine Seite ohne Quellen braucht ein Prüfdatum; deutsche und portugiesische Übersetzungen existieren und passen zum aktuellen Englisch. `--local` prüft zusätzlich, dass Quellen und Gedächtnisverweise existieren.

## How it does it
Reine Funktionen über die geladenen Inhalte; liefert eine sortierte Liste `Datei: Problem`. Die CI führt es ohne `--local` aus, weil GitHub die anderen privaten Repos nicht sieht.

## Where it sits in the pipeline
Erster Schritt von `wiki publish` und Teil von [[wiki-quality-gate]].

## Who receives its output
[[wiki-cli]] (publish lehnt bei jedem Problem ab).
