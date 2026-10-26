---
id: wiki-hook-stop
lang: de
source_hash: 20472e3f5733
title: Wiki-Stop-Hook (Sicherheitsnetz)
---

## What it is
Ein „Stop-Hook“ ist ein kleines Programm, das [[claude-code]] automatisch ausführt, wenn es eine Antwort beendet ([Hooks erklärt](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Dieser, `wiki hook-stop`, ist das Sicherheitsnetz der Wiki-Aktualisierungskette: Er fängt eine vergessene Wiki-Aktualisierung in derselben Sitzung ab, solange Claude noch weiß, was es getan hat.

## What it does
Wenn Claude einen Durchgang beendet, schaut er in die Repositories unter `~/dev`, die eine Wiki-Seite als Quelle nennt. Gibt es seit dem letzten `wiki publish` Commits, die Quellen einer Seite berührten, oder neue Dateien, die keine Seite abdeckt, blockiert er das Beenden (Exit-Code 2) und sagt Claude, welche Seiten zu aktualisieren sind. Er blockiert nie vor der ersten Veröffentlichung, nie für Repositories, die das Wiki nicht abdeckt, nie zweimal in einer Sitzung für dieselben Änderungen und nie, wenn schon ein Stop-Hook aktiv ist, sodass er nicht in eine Schleife geraten kann. Ein Chat ohne Änderungen an erfasstem Code erzeugt selbst keinen neuen Auslöser; frühere unveröffentlichte Änderungen können die Erinnerung dennoch auslösen.

## How it does it
Er nutzt nur lesendes Git und hält seinen Zustand in `~/.local/state/wiki/` (Zeitpunkt der letzten Veröffentlichung und bereits blockierte Sitzungen). Datenordner, die sich ständig ändern (die Gedächtnisereignisse und -ansichten, Quiz-Sicherungen, der Release-Feed), stehen in `content/_ignore.txt` und werden nicht Datei für Datei überwacht. Die Meldung, die er ausgibt, sagt Claude, dass es eine Seite, die es geprüft und für richtig befunden hat, durch das Setzen ihres `reviewed`-Zeitpunkts festhalten soll (die Änderung ist die Prüfung, siehe [[wiki-stale]]), und `wiki publish -m "review: no page change"` nur auszuführen, wenn das Geänderte von keiner Seite beschrieben wird, zum Beispiel eine Datendatei. Außerdem sagt sie der Sitzung, `wiki publish` um `--co-author "Name <email>"` mit der Zuschreibungszeile zu ergänzen, die diese Sitzung erhalten hat, und sie wegzulassen, wenn es keine gibt ([[wiki-cli]]).

## Where it sits in the pipeline
Er läuft am Ende jedes Durchgangs, neben dem [[hook-stop]] des Gedächtnisses.

## Who receives its output
[[claude-code]] (die Nachricht).

## Notes
`wiki stale` und dieser Hook beantworten zwei verschiedene Fragen, deshalb kann eine Seite von dem einen aufgelistet werden und von dem anderen nicht. `wiki stale` fragt Seite für Seite: „Hat sich eine Quelle nach dem Zeitpunkt geändert, zu dem die Seite angibt, zuletzt geprüft worden zu sein (ihr Feld `reviewed`)?“ Es hängt nicht vom Veröffentlichen ab. Der Hook fragt: „Haben seit dem letzten `wiki publish` Projekte Commits bekommen, die die Quellen einer Seite berühren oder Dateien hinzufügen, die keine Seite abdeckt?“ Er ist das Sicherheitsnetz für das, was `wiki stale` nicht sehen kann: eine Änderung in derselben Minute wie eine Prüfung, eine neue Datei, die keine Seite nennt, und die Arbeit der aktuellen Sitzung. Meldet der Hook eine Seite, das `git log` des Quell-Repositorys lesen und mit dem Seitentext vergleichen; ist die Seite richtig, ihren `reviewed`-Zeitpunkt setzen. Vor dem 2026-10-24 verglich `wiki stale` die Commit-Zeit der Quelle mit der der Seitendatei, sodass eine Überarbeitung vieler Seiten jede frühere Änderung verbarg und dieser Hook das Einzige war, das sie noch sah (siehe [[wiki-stale]]).

Die Erinnerung verweist Skill-Seiten ausdrücklich auf die Regel für vollständige Quellen: die ganze `SKILL.md` suchen und lesen, die vollständige Beschreibung und alle Anweisungen mit einem Fingerabdruck in die englische Seite und beide Übersetzungen übernehmen und danach `wiki check --local` ausführen. Sie verweist auf `AGENTS.md` und [[skill-wiki-page-writer]]. Der Hook erinnert den Verfasser; er erzeugt den Seitentext nicht selbst.
