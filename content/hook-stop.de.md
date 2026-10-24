---
id: hook-stop
lang: de
source_hash: a02912aa4595
title: Stop-Hook (mem hook-stop)
---

## What it is
Ein Hook ist ein kleines Programm, das [[claude-code]] bei einem bestimmten Ereignis automatisch ausführt ([Hooks erklärt](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Das ist der „Stop“-Hook des Gedächtnisses: `mem hook-stop`, mit einem Zeitlimit von 40 Sekunden. Er läuft jedes Mal, wenn Claude eine Antwort beendet.

## What it does
Er lädt neue Gedächtnisereignisse nach GitHub hoch (Push), damit die Claude-App und die nächste Sitzung sie sehen können.

## How it does it
Er ruft die Push-Funktion von [[mem-sync]] auf. Ist der Laptop offline, speichert er die Ereignisse lokal (ein Git-„Commit“) und lädt sie später hoch. Fehler werden ins Hook-Log geschrieben. Er läuft direkt neben dem eigenen Stop-Hook des Wikis ([[wiki-hook-stop]]).

## Where it sits in the pipeline
Das Ende jedes Durchgangs (ein Durchgang ist eine Frage von Giovanni und Claudes Antwort darauf).

## Who receives its output
[[mem-sync]] und von dort [[github]].
