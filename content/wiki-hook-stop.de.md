---
id: wiki-hook-stop
lang: de
source_hash: 889b2229c8fc
title: Wiki-Stop-Hook (Sicherheitsnetz)
---

## What it is
Ein „Stop-Hook“ ist ein kleines Programm, das [[claude-code]] automatisch ausführt, wenn es eine Antwort beendet ([Hooks erklärt](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Dieser, `wiki hook-stop`, ist das Sicherheitsnetz der Wiki-Aktualisierungskette: Er fängt eine vergessene Wiki-Aktualisierung in derselben Sitzung ab, solange Claude noch weiß, was es getan hat.

## What it does
Wenn Claude einen Durchgang beendet, schaut er in die Repositories unter `~/dev`, die eine Wiki-Seite als Quelle nennt. Gibt es seit dem letzten `wiki publish` Commits, die Quellen einer Seite berührten, oder neue Dateien, die keine Seite abdeckt, blockiert er das Beenden (Exit-Code 2) und sagt Claude, welche Seiten zu aktualisieren sind. Er blockiert nie vor der ersten Veröffentlichung, nie für Repositories, die das Wiki nicht abdeckt, nie zweimal in einer Sitzung für dieselben Änderungen und nie, wenn schon ein Stop-Hook aktiv ist, sodass er nicht in eine Schleife geraten kann. Bei deutschen, klinischen oder anderen Chats ohne Code feuert er nie.

## How it does it
Er nutzt nur lesendes Git und hält seinen Zustand in `~/.local/state/wiki/` (Zeitpunkt der letzten Veröffentlichung und bereits blockierte Sitzungen). Datenordner, die sich ständig ändern (die Gedächtnisereignisse und -ansichten, Quiz-Sicherungen, der Release-Feed), stehen in `content/_ignore.txt` und werden nicht Datei für Datei überwacht. Muss keine Seite geändert werden, führt Claude trotzdem `wiki publish -m "review: no page change"` aus, um festzuhalten, dass es geprüft hat.

## Where it sits in the pipeline
Er läuft am Ende jedes Durchgangs, neben dem [[hook-stop]] des Gedächtnisses.

## Who receives its output
[[claude-code]] (die Nachricht).
