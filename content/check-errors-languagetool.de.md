---
id: check-errors-languagetool
lang: de
source_hash: 2e2f92aa7e84
title: check_errors_languagetool.py
aliases: [LanguageTool-Prüfung]
---

## What it is
Eine Grammatikprüfung der Fehler-finden-Sätze mit LanguageTool (ein Grammatikprüfer, der lokal unter Java läuft).

## What it does
1. Jeder korrigierte Satz muss auf der Stufe PICKY fehlerfrei sein, damit kein Satz Deutsch lehrt, das LanguageTool ablehnt. 2. Keine Warnung darf auf einen anderen als den markierten Teil fallen, damit der Spieler nie einem zweiten, ungewollten Fehler begegnet.

## How it does it
Python ruft das Kommandozeilen-Jar von LanguageTool auf (Java 17+). LanguageTool erkennt nur etwa ein Viertel der eingebauten Fehler, ob der markierte Teil wirklich falsch ist, wird daher von Hand geprüft.

## Where it sits in the pipeline
Nach [[build-vocab]], immer wenn sich Fehlersätze ändern.

## Who receives its output
Claude, als bestanden/nicht bestanden, bevor der Inhalt committet wird.
