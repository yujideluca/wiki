---
id: check-errors-languagetool
lang: de
source_hash: 9aebd9a95f23
title: check_errors_languagetool.py
---

## What it is
`check_errors_languagetool.py` ist eine Grammatikprüfung der „Fehler finden“-Sätze mit [LanguageTool](https://languagetool.org/), einem Grammatikprüfer, der lokal auf Java läuft.

## What it does
Es erzwingt zwei Regeln. (1) Jeder korrigierte Satz muss auf der Stufe PICKY (der strengsten Einstellung von LanguageTool) sauber sein, damit kein Satz Deutsch lehrt, das LanguageTool ablehnt. (2) Keine Warnung darf auf einen anderen als den markierten Teil fallen, damit der Spieler nie einem zweiten, unbeabsichtigten Fehler begegnet.

## How it does it
Ein [Python](https://www.python.org/)-Skript, das das Kommandozeilenprogramm von LanguageTool aufruft (ein Java-Archiv, Java 17 oder neuer; auf dem Laptop in `~/.local/opt/languagetool-dl` installiert, LanguageTool 6.6). LanguageTool erkennt nur etwa ein Viertel der eingebauten Fehler, daher wird, ob der markierte Teil wirklich falsch ist, weiterhin von Hand geprüft.

## Where it sits in the pipeline
Nach [[build-vocab]], wenn sich Fehlersätze ändern.

## Who receives its output
Claude, als Bestanden oder Durchgefallen, bevor der Inhalt committet wird.
