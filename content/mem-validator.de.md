---
id: mem-validator
lang: de
source_hash: 298a4d08cb22
title: Prüfer und Quarantäne (validate.py)
aliases: [Datenschutzprüfung]
---

## What it is
Der Datenschutz- und Formatwächter des Gedächtnisses, egal wer schreibt.

## What it does
Lehnt Tokens und Schlüssel, E-Mail-Adressen, Telefonnummern, CPF-Nummern und fehlerhafte Ereignisse ab. Abgelehnte Dateien wandern mit einer `.reason`-Notiz nach `quarantine/` und erscheinen in REVIEW. Einen Filter für Gesundheitsbegriffe gibt es bewusst nicht (Giovannis Entscheidung, 19.10.2026); keine klinischen Daten über andere zu speichern ist eine feste Regel, keine automatische Prüfung.

## How it does it
`check_event` pro Ereignis; `load_checked` trennt gültig von ungültig; `quarantine` verschiebt die schlechten. Getestet durch `test_privacy_boundary`. Die Muster für Geheimnisse, Telefonnummern und CPF stehen in `mem/privacy-patterns.tsv`, der einen Liste, die auch die Datenschutzprüfung des Wikis ([[wiki-check]]) benutzt.

## Where it sits in the pipeline
Vor jedem Schreiben durch [[mem]] und auf GitHub in [[mem-action]].

## Who receives its output
[[memory-fold]] (nur gültige Ereignisse) und [[memory-views]] (REVIEW listet die Quarantäne).
