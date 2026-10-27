---
id: quizweb
lang: de
source_hash: 54da115249d9
title: QuizWeb (German Quiz, Web)
---

## What it is
QuizWeb ist die Webversion des Deutsch-Quiz, gemacht, damit sie auf einem iPhone funktioniert. Sie ist eine PWA (Progressive Web App: eine Webseite, die sich wie eine App auf dem Handy installieren lässt und offline weiterläuft, siehe [PWA](https://en.wikipedia.org/wiki/Progressive_web_app)), ausgeliefert von [[github-pages]]. Das Repository ist `yujideluca/german-quiz-web`, der Ordner `~/dev/QuizWeb`. Sie ist der „Web-Zwilling“ von [[quizapp]].

## Flow
trigger t1: Giovanni öffnet QuizWeb in einem Browser, zum Beispiel auf dem iPhone | [[github-pages]]
step s1: Der Service Worker legt die App im Cache ab, damit sie offline läuft | [[quizweb-service-worker]]
step s2: Der Controller führt eine Lernsitzung mit der reinen Logik aus | [[quizweb-controller]], [[quizweb-domain]]
step s3: Fragen und Übersetzungen werden geladen | [[quizweb-content]]
step s4: Der Fortschritt wird im Browser dieses Geräts gespeichert | [[quizweb-store]]
product p1: Lernsitzungen, die offline laufen; Einstellungen > Backup sichert den Fortschritt
trigger t2: Die stabile Android-App ändert Fragen, Übersetzungen oder Modi | [[quizapp]]
step s5: check-web-sync vergleicht Dateien, Modi und den gepushten Stand des Web-Klons | [[check-web-sync]]
decide d1: Passt der Web-Zwilling?
step s6: Übernimmt die Änderung, erhöht die Cache-Version, testet, pusht
trigger t3: Ein Push in das Repository | [[quizweb-ci]]
step s7: Tests laufen, auch wer wen importieren darf, plus pipeline-check-Grenzen | [[pipeline-check]]
decide d2: Ist alles bestanden?
step s8: GitHub Pages veröffentlicht den Push in etwa einer Minute | [[github-pages]]
product p2: Die Zwillinge sind im Gleichschritt
product p3: Eine neue Version für jeden Browser
product p4: Nichts wird veröffentlicht

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> p1
t2 -> s5
s5 -> d1
d1 -ja-> p2
d1 -nein-> s6
s6 -> s7
t3 -> s7
s7 -> d2
d2 -ja-> s8
d2 -nein-> p4
s8 -> p3

## What it does
Sie hat dieselben fünf Modi, denselben Scheduler, dasselbe Tagesziel und denselben Serienkalender wie [[quizapp]] und funktioniert offline. Der Fortschritt liegt im Browser des jeweiligen Geräts und ist von der Android-App getrennt; Einstellungen > Sicherung speichert und stellt ihn wieder her.

## How it does it
Sie ist schlichtes JavaScript in ES-Modulen (die Standardart, JavaScript in Dateien zu teilen), ohne Build-Schritt und ohne Abhängigkeiten. Die Teile sind: [[quizweb-domain]] (reine Logik), [[quizweb-content]], [[quizweb-controller]], [[quizweb-store]] und [[quizweb-app]] (die letzten beiden sind die einzigen Module, die den Browser berühren) sowie der Offline-Cache [[quizweb-service-worker]]. Der Test `tests/architecture.test.js` legt fest, wer wen importieren darf, und [[quizweb-ci]] führt bei jedem Push `npm test` und die Grenzen von [[pipeline-check]] aus.

## Where it sits in the pipeline
Sie ist der Zwilling von [[quizapp]] (Entscheidung ADR-0006 dort; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält): Sie liest dieselben Vokabeldateien und dieselben Konformitätsvektoren, und [[check-web-sync]] in QuizApp vergleicht sie. Eine Übertragung von Android-Funktionen, die noch in der Beta sind, wartet auf einem Zweig `web-<version>` und wird nach `main` gemergt, wenn die App befördert wird.

## Who receives its output
Giovannis iPhone oder jeder Browser, über [[github-pages]].

## Notes

Die eigenständige Wartungsveröffentlichung vom 2026-10-26 enthält die Suche mit scharfem S, die Fortschrittsberechnung bei Tagesziel null und Prüfungen beim Sicherungsimport. Ihr Offline-Cache-Schlüssel ist `v12`. Wartungskorrekturen können unabhängig von einer neuen Android-Version erscheinen; Übertragungen unveröffentlichter Android-Funktionen warten weiter auf deren App-Veröffentlichung. GitHub schützt `main` durch die erforderliche Prüfung `test`, auch für Administratoren, und verbietet erzwungenes Überschreiben und Löschen des Zweigs. Der Wartungscommit bestand alle 81 Tests und die Veröffentlichung über GitHub Pages.
