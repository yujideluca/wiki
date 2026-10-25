---
id: wiki-check
lang: de
source_hash: 097283d94376
title: wiki check (Inhaltsregeln)
---

## What it is
`wiki check` führt jede Regel aus, die eine Seite befolgen muss, bevor sie veröffentlicht werden kann. Im Code ist es das Elixir-Modul `Wiki.Content.Check`.

## What it does
Es prüft, dass: Kopffelder und Arten gültig sind; die fünf Pflichtabschnitte vorhanden und nicht leer sind; jeder `[[link]]`, `fed_by` und `feeds` auf eine echte Seite zeigt; `fed_by` und `feeds` in beide Richtungen übereinstimmen; es keine verwaisten Seiten gibt (Seiten, auf die nichts verlinkt), außer Akteuren und Dingen von außen; der Datenschutz-Scan keine Schlüssel, Tokens, Passwörter, Telefonnummern oder andere E-Mail-Adressen als Giovannis findet (die Muster sind die Datei `privacy-patterns.tsv` von workflow-memory, nach `server/priv/` kopiert und vom Gate verglichen); eine Funktion, die auf einer Seite aufgeführt und von zwei weiteren Seiten erwähnt wird, eine eigene Seite bekommt (die Beförderungsregel); jede Seite einen Prüfzeitpunkt hat, ein Datum oder Datum mit Minute in UTC (koordinierte Weltzeit, überall dieselbe Uhrzeit), der nicht in der Zukunft liegt und mit dem [[wiki-stale]] die Quellen vergleicht; eine Skill-Seite einen Abschnitt Steps mit der eigenen Definition der Skill hat; die erste Verwendung jedes gelisteten Akronyms mit seinem vollen Namen kommt; und die deutschen und portugiesischen Übersetzungen existieren und zum aktuellen Englisch passen. Mit `--local` prüft es auch, dass Quellen und Gedächtniseinträge existieren.

## How it does it
Es besteht aus reinen Funktionen über dem geladenen Inhalt und gibt eine sortierte Liste von Zeilen der Form `Datei: Problem` zurück. Die Continuous Integration (CI, automatische Prüfungen auf GitHub) führt es ohne `--local` aus, weil GitHub Giovannis andere private Repositories nicht sehen kann.

## Where it sits in the pipeline
Der erste Schritt von `wiki publish` und Teil des [[wiki-quality-gate]].

## Who receives its output
Die [[wiki-cli]] (das Veröffentlichen verweigert sich bei jedem Problem).
