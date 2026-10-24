---
id: mem-validator
lang: de
source_hash: e43dcc2da722
title: Validator und Quarantäne (validate.py)
---

## What it is
Der Validator ist der Datenschutz- und Formatwächter des Gedächtnisses, egal wer schreibt. Seine Muster für Geheimnisse, Telefonnummern und CPF-Nummern (Cadastro de Pessoas Físicas, die brasilianische persönliche Steuernummer) liegen in `mem/privacy-patterns.tsv`, der einen Liste, die auch der Datenschutz-Scan des Wikis ([[wiki-check]]) benutzt.

## What it does
Er weist Tokens und Schlüssel, E-Mail-Adressen, Telefonnummern, CPF-Nummern und fehlerhafte Ereignisse zurück. Eine abgelehnte Datei wird mit einer `.reason`-Notiz in den Ordner `quarantine/` verschoben und erscheint in der Prüfdatei. Einen Filter für Gesundheitsvokabular gibt es bewusst nicht (Giovannis Entscheidung vom 2026-10-19); klinische Daten über andere Personen nicht zu speichern ist eine dauerhafte Regel, der Claude folgt, keine automatische Prüfung.

## How it does it
Die Funktion `check_event` prüft ein Ereignis, `load_checked` trennt gültige von ungültigen Ereignissen, und `quarantine` verschiebt die schlechten. Getestet wird er durch `test_privacy_boundary`.

## Where it sits in the pipeline
Vor jedem Schreiben durch [[mem]] und auf GitHub in [[mem-action]].

## Who receives its output
[[memory-fold]] (nur gültige Ereignisse) und [[memory-views]] (die Prüfdatei listet, was in Quarantäne ging).
