---
id: wiki-stale
lang: de
source_hash: daea1f943729
title: wiki stale (Seiten hinter ihren Quellen)
---

## What it is
`wiki stale` ist der Befehl, der die Wiki-Seiten auflistet, die veraltet sein könnten, weil sich eine Datei, die sie beschreiben, geändert hat, nachdem die Seite zuletzt mit ihr verglichen wurde. Er ist einer der Befehle von [[wiki-cli]] und teilt sich die Code-Datei mit dem Stop-Hook ([[wiki-hook-stop]]), stellt aber eine andere Frage.

## What it does
Jede Seite hält im Kopffeld `reviewed` fest, wann sie zuletzt mit ihren Quellen verglichen wurde: Datum und Minute in UTC (koordinierte Weltzeit, überall dieselbe Uhrzeit), etwa `2026-10-24T18:30Z`, oder nur ein Datum, das den Beginn dieses Tages bedeutet. Für jede Seite mit Quellen betrachtet der Befehl jede im Kopf `sources` genannte Datei oder jeden Ordner (geschrieben `repo:path`). Hat sich eine davon nach dem `reviewed`-Zeitpunkt geändert, wird die Seite mit der neuesten solchen Quelle und beiden Zeitpunkten aufgelistet, zum Beispiel `quizapp: QuizApp:DESIGN.md changed 2026-10-24 16:43 UTC, after the review of 2026-10-22 16:33 UTC`. Eine Seite mit Quellen und ohne brauchbares `reviewed` wird als nie verglichen aufgelistet. Gibt es nichts aufzulisten, druckt er „no stale pages“ und endet mit 0; sonst endet er mit 1, damit ein Skript das Ergebnis prüfen kann (Anforderungen ST-1, ST-2 und ST-3).

## How it does it
Bei einer Quelle in einem git-Repository (git ist das Werkzeug, das jede Änderung als Commit speichert) bedeutet „geändert“ den Zeitpunkt des letzten Commits, der die Datei oder den Ordner berührt. Bei einer Quelle außerhalb von git, etwa einem Skill oder einem Skript im Home-Ordner, bedeutet es die neueste Änderungszeit der Datei oder des Ordners samt allem darin. Die Commits der Seitendatei selbst werden nie benutzt: eine Überarbeitung vieler Seiten, eine korrigierte Übersetzung oder eine Veröffentlichung allein belegt keine Prüfung. Nur wer die Seite wirklich mit ihren Quellen verglichen hat, setzt einen neuen `reviewed`-Zeitpunkt, und das nimmt die Seite aus der Liste.

Die erste Fassung verglich die Zeit des letzten Commits der Quelle mit der des letzten Commits der Seitendatei. Am 2026-10-24 überarbeitete ein Commit alle 154 Seiten, daher listete diese Fassung nichts auf, obwohl bei 38 der 140 Seiten mit Quellen eine Quelländerung niemand geprüft hatte, und sie konnte die 34 Seiten, deren Quellen außerhalb von git liegen, nie auflisten. Die Entscheidungsakte `docs/adr/0006-review-time-in-the-page.md` erklärt die Änderung.

Der Befehl schaut auf die Zeit, nicht darauf, was die Seite sagt: Eine Änderung an einer Quelle, die die Seite nicht beschreibt, lässt die Seite trotzdem aufgelistet, bis jemand sie prüft. Eine Prüfung zu einer bestimmten Minute deckt diese ganze Minute ab, daher wird eine Änderung in dieser Minute nicht gesehen; ebenso wenig noch nicht committete Änderungen in einem Repository und eine neue Datei, die keine Seite nennt (auf neue Dateien achtet der Stop-Hook).

Seit dem 2026-11-01 (ADR-0009, ein Architekturentscheidungs-Eintrag: eine kurze Notiz, die die Gründe einer Entscheidung festhält) gelten drei genaue Regeln, ohne Kulanzfrist, für Quellen im eigenen Repository des Wikis. Eine Seite, die ihre eigene Datei als Quelle nennt, wird deswegen nicht aufgelistet. Eine Quelle, die selbst eine Wiki-Seite ist, gilt nur als geändert, wenn mehr als ihre Zeilen `reviewed` oder `since` geändert wurde. Und weil die Prüfzeit vor dem Commit getippt wird, der sie trägt, ist eine Quelle abgedeckt, deren Text von genau dem Commit geändert wurde, der die Zeile `reviewed` der Seite zuletzt gesetzt hat; eine Quelle, die ein anderer Commit geändert hat, auch eine Minute nach der Prüfung, hält die Seite in der Liste, bis sie wieder verglichen wird. `wiki publish` prüft außerdem jede Zeile `reviewed`, die es hochladen will: ist eine schon vorhandene Quelle neuer als die Prüfung, verweigert es, nennt Seite und Quelle und lädt nichts hoch (Anforderungen ST-4, ST-5 und ST-6).

## Where it sits in the pipeline
Eine manuelle Prüfung, die ein Assistent zu Beginn und am Ende der Arbeit von [[skill-wiki-page-writer]] ausführt, und immer dann, wenn Giovanni wissen will, wie weit das Wiki hinter dem Code liegt.

## Who receives its output
Wer ihn ausgeführt hat (ein Assistent oder Giovanni), über [[wiki-cli]].

## Notes
Die Prüfung vom 2026-11-01 fand sowohl versäumte Prüfungen als auch falsche Veraltungsanzeigen. Ein gemeinsamer Veröffentlichungszeitpunkt konnte offene Arbeit anderer Sitzungen verbergen; neue Prüfungsangaben wurden beim Veröffentlichen nicht geprüft. Eigene Quelldateien, reine Datumsänderungen, fehlender oder beschädigter Zustand, verknüpfte Arbeitskopien und Änderungen in derselben Sekunde brauchten getrennte Behandlung. Neun Seiten benötigten Textkorrekturen; sechs entsprachen ihren Quellen und benötigten eine verzeichnete Prüfung. Nachweise und Seitenabgleich stehen in `docs/2026-11-01-wiki-stale-audit.md`.

Die Quellenänderungen für Prüfer, Ablaufansicht, Gedächtnisvalidator und Fortschrittswerkzeuge nennen Claude Sonnet 5.5 als Mitautor (`3c12c76`, `12b5342`, `6a57d87`, `f2b0389` in den jeweiligen Repositories). Das belegt die Zuordnung der Quellen-Commits zum Assistenten, nicht jede spätere Sitzung. Diese Codex-Unterhaltung bestätigte außerdem ihre eigene fehlende Abschlussprüfung nach `5b3ff90`. Nicht versionierte Konfiguration erlaubt keine verlässliche Zuordnung zur genauen Sitzung; der konfigurierte Git-Autor beweist keine persönliche Handlung Giovannis.

In einer isolierten Arbeitskopie werden `wiki:`-Quellen über `WIKI_ROOT` aufgelöst, den geprüften und veröffentlichten Ordner. Andere Quellen nutzen weiterhin den angegebenen Entwicklungsordner. Neue Quelldateien sind so vor der Übernahme in die Hauptarbeitskopie prüfbar. Eine gültige Quellenangabe nur für eine bestandene Prüfung zu entfernen, ist keine Reparatur. Zustandsdateien verwenden vor der atomaren Umbenennung (dem Austausch des Ziels in einem Dateisystemschritt) temporäre Namen mit Prozessidentität und Laufzeitzähler; getrennte Assistentenprozesse kollidieren dadurch nicht.
