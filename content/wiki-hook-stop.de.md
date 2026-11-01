---
id: wiki-hook-stop
lang: de
source_hash: 18a701a63983
title: Wiki-Stop-Hook (Sicherheitsnetz)
---

## What it is
Ein „Stop-Hook“ ist ein kleines Programm, das ein Assistent am Ende einer Antwort automatisch ausführt ([Hooks erklärt](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Sowohl [[claude-code]] als auch [[codex]] rufen `wiki hook-stop` über ihre installierten Hooks auf. Er erkennt vergessene Wiki-Aktualisierungen in derselben Sitzung, solange der Assistent seine Änderungen noch kennt.

## What it does
Am Ende eines Durchgangs prüft der Assistent die Repositories unter `~/dev`, die Wiki-Seiten als Quellen nennen. Ungeprüfte Quellenänderungen oder neue Dateien ohne Seite blockieren das Beenden (Exit-Code 2) und benennen die zu prüfende Arbeit. Ein ungültiger Veröffentlichungszeitpunkt erzeugt immer einmal je Sitzung eine Diagnose. Ohne Veröffentlichungszeitpunkt leitet der Hook die Aufgaben aus noch veralteten Seiten ab; nur wenn keine zurückliegt, bleibt er still. Er blockiert nicht für nicht erfasste Repositories, nicht zweimal pro Sitzung für dieselben Änderungen und nicht bei bereits aktivem Stop-Hook. Ein Chat ohne Änderungen an erfasstem Code erzeugt keinen eigenen neuen Auslöser; frühere unveröffentlichte Änderungen können dennoch erinnern.

## How it does it
Er nutzt nur lesendes Git und hält seinen Zustand in `~/.local/state/wiki/` (Zeitpunkt der letzten Veröffentlichung und bereits blockierte Sitzungen). Datenordner, die sich ständig ändern (die Gedächtnisereignisse und -ansichten, Quiz-Sicherungen, der Release-Feed), stehen in `content/_ignore.txt` und werden nicht Datei für Datei überwacht. Die Meldung, die er ausgibt, sagt dem Assistenten, dass es eine Seite, die es geprüft und für richtig befunden hat, durch das Setzen ihres `reviewed`-Zeitpunkts festhalten soll (die Zeit erst nach dem Quellenvergleich festhalten, siehe [[wiki-stale]]), und `wiki publish -m "review: no page change"` nur auszuführen, wenn das Geänderte von keiner Seite beschrieben wird, zum Beispiel eine Datendatei. Außerdem sagt sie der Sitzung, `wiki publish` um `--co-author "Name <email>"` mit der Zuschreibungszeile zu ergänzen, die diese Sitzung erhalten hat, und sie wegzulassen, wenn es keine gibt ([[wiki-cli]]).

## Where it sits in the pipeline
Er läuft am Ende jedes Durchgangs, neben dem [[hook-stop]] des Gedächtnisses.

## Who receives its output
[[claude-code]] oder [[codex]], je nachdem, wer den Hook aufgerufen hat, erhält die Nachricht.

## Notes
Seit dem 2026-11-01 (ADR-0009, ein Architekturentscheidungs-Eintrag) wird der Zeitstempel, mit dem dieser Hook vergleicht, von allen Sitzungen geteilt; er rückt nach einem Publish nur vor, wenn seit dem vorigen Stempel keine Seite mehr hinter einer Änderung zurückliegt und keine neue Datei unabgedeckt bleibt. So kann der Publish einer Sitzung die ungeprüfte Arbeit einer anderen nicht mehr verstecken. Der Hook nennt eine Seite außerdem nur, wenn sie wirklich hinter ihren Quellen liegt, findet Repositories selbst über git (verknüpfte Worktrees zählen also) und bezieht Änderungen in derselben Sekunde wie der Stempel ein. Wurde die Stempeldatei nie geschrieben, listet der Hook die Seiten auf, die hinter ihren Quellen liegen, und schweigt nur, wenn es keine gibt. Ein leerer, abgeschnittener, nicht numerischer, null-, negativer oder in der Zukunft liegender Stempel (auch nur eine Minute voraus) wird immer einmal je Sitzung gemeldet, zusammen mit dieser Liste; ein Publish überschreibt einen fehlenden oder defekten Stempel nie, solange eine Seite hinter einer Quelle liegt, nur ein nachweislich sauberer Zustand setzt einen neuen. Beide Zustandsdateien werden per Umbenennen geschrieben, und eine nicht schreibbare Zustandsdatei verbirgt die Meldung nie (Anforderung UP-7).

`wiki stale` prüft jede Seite unabhängig von Veröffentlichungen. Der Hook prüft Änderungen seit der Veröffentlichungsmarke, filtert benannte Seiten durch dieselben Veraltungsregeln und erkennt zusätzlich neue Dateien ohne Seite. Er meldet eine Seite nicht allein wegen einer Änderung innerhalb ihrer abgedeckten Prüfminute. Die Erkennung derselben Sekunde bezieht sich auf die Veröffentlichungsmarke, nicht auf eine strengere Prüfuhr. Vor einer neuen Prüfungsangabe Quellenverlauf und Seitentext vergleichen. Vor dem 2026-10-24 wurden Quellen- und Seiten-Commits verglichen; Überarbeitungen konnten dadurch ältere Änderungen verbergen. Das eigene Feld `reviewed` ersetzte dieses Verhalten ([[wiki-stale]]).

Die Erinnerung verweist Skill-Seiten ausdrücklich auf die Regel für vollständige Quellen: die ganze `SKILL.md` suchen und lesen, die vollständige Beschreibung und alle Anweisungen mit einem Fingerabdruck (einem aus dem vollständigen Text berechneten Änderungsnachweis) in die englische Seite und beide Übersetzungen übernehmen und danach `wiki check --local` ausführen. Sie verweist auf `AGENTS.md` und [[skill-wiki-page-writer]]. Der Hook erinnert den Verfasser; er erzeugt den Seitentext nicht selbst.

Konfiguration: `home:` bezeichnet Dateien im Benutzerordner; andere Repository-Namen bezeichnen normalerweise Ordner unter `~/dev`, überschreibbar durch `WIKI_DEV_ROOT`. `WIKI_ROOT` wählt Wiki-Ordner und `wiki:`-Quellen; Standard ist `~/dev/wiki`. Claude Code ruft den Befehl aus `~/.claude/settings.json` auf, Codex aus `~/.codex/hooks.json`. `content/_ignore.txt` nimmt Datenpfade aus der Suche nach geänderten Dateien aus, nicht aus einer manuellen Quellenprüfung. Anforderung `UP-7` benennt das getestete Versprechen, dass Veröffentlichungen offene Aufgaben erhalten; ihr Wortlaut steht in `docs/REQUIREMENTS.md`.
