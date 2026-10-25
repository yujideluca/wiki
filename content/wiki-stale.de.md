---
id: wiki-stale
lang: de
source_hash: 61901bbb2fef
title: wiki stale (Seiten hinter ihren Quellen)
---

## What it is
`wiki stale` ist der Befehl, der die Wiki-Seiten auflistet, die veraltet sein könnten, weil sich eine Datei, die sie beschreiben, geändert hat, nachdem die Seite zuletzt mit ihr verglichen wurde. Er ist einer der Befehle von [[wiki-cli]] und teilt sich die Code-Datei mit dem Stop-Hook ([[wiki-hook-stop]]), stellt aber eine andere Frage.

## What it does
Jede Seite hält im Kopffeld `reviewed` fest, wann sie zuletzt mit ihren Quellen verglichen wurde: Datum und Minute in UTC (koordinierte Weltzeit, überall dieselbe Uhrzeit), etwa `2026-10-24T18:30Z`, oder nur ein Datum, das den Beginn dieses Tages bedeutet. Für jede Seite mit Quellen betrachtet der Befehl jede im Kopf `sources` genannte Datei oder jeden Ordner (geschrieben `repo:path`). Hat sich eine davon nach dem `reviewed`-Zeitpunkt geändert, wird die Seite mit der neuesten solchen Quelle und beiden Zeitpunkten aufgelistet, zum Beispiel `quizapp: QuizApp:DESIGN.md changed 2026-10-24 16:43 UTC, after the review of 2026-10-22 16:33 UTC`. Eine Seite mit Quellen und ohne brauchbares `reviewed` wird als nie verglichen aufgelistet. Gibt es nichts aufzulisten, druckt er „no stale pages“ und endet mit 0; sonst endet er mit 1, damit ein Skript das Ergebnis prüfen kann (Anforderungen ST-1, ST-2 und ST-3).

## How it does it
Bei einer Quelle in einem git-Repository (git ist das Werkzeug, das jede Änderung als Commit speichert) bedeutet „geändert“ den Zeitpunkt des letzten Commits, der die Datei oder den Ordner berührt. Bei einer Quelle außerhalb von git, etwa einem Skill oder einem Skript im Home-Ordner, bedeutet es die neueste Änderungszeit der Datei oder des Ordners samt allem darin. Die Commits der Seitendatei selbst werden nie benutzt: eine Überarbeitung vieler Seiten, eine korrigierte Übersetzung oder eine Veröffentlichung ist keine Prüfung. Nur wer die Seite wirklich mit ihren Quellen verglichen hat, setzt einen neuen `reviewed`-Zeitpunkt, und das nimmt die Seite aus der Liste.

Die erste Fassung verglich die Zeit des letzten Commits der Quelle mit der des letzten Commits der Seitendatei. Am 2026-10-24 überarbeitete ein Commit alle 154 Seiten, daher listete diese Fassung nichts auf, obwohl bei 38 der 140 Seiten mit Quellen eine Quelländerung niemand geprüft hatte, und sie konnte die 34 Seiten, deren Quellen außerhalb von git liegen, nie auflisten. Die Entscheidungsakte `docs/adr/0006-review-time-in-the-page.md` erklärt die Änderung.

Der Befehl schaut auf die Zeit, nicht darauf, was die Seite sagt: Eine Änderung an einer Quelle, die die Seite nicht beschreibt, lässt die Seite trotzdem aufgelistet, bis jemand sie prüft. Eine Prüfung zu einer bestimmten Minute deckt diese ganze Minute ab, daher wird eine Änderung in dieser Minute nicht gesehen; ebenso wenig noch nicht committete Änderungen in einem Repository und eine neue Datei, die keine Seite nennt (auf neue Dateien achtet der Stop-Hook).

## Where it sits in the pipeline
Eine manuelle Prüfung, die Claude zu Beginn und am Ende der Arbeit von [[skill-wiki-page-writer]] ausführt, und immer dann, wenn Giovanni wissen will, wie weit das Wiki hinter dem Code liegt.

## Who receives its output
Wer ihn ausgeführt hat (Claude oder Giovanni), über [[wiki-cli]].
