---
id: quizweb
lang: de
source_hash: 31b9a69077cc
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

## Architecture
### Kontext
person p: Spieler — lernt auf dem iPhone oder in jedem Browser | [[giovanni]]
system w: German Quiz Web — Quiz mit fünf Modi, das offline funktioniert
external g: GitHub Pages — liefert die Seite aus | [[github-pages]]
external a: German-Quiz-Android-App — Quelle der Fragen und Testvektoren | [[quizapp]]
external b: Browser-Speicher auf dem Gerät — behält den Fortschritt

p -lernt in-> w
g -liefert aus-> w
a -teilt Fragen und Testvektoren mit-> w
w -behält den Fortschritt in-> b

### Container
person p: Spieler | [[giovanni]]
container ui: Bildschirme — Tasten, Karten, Kalender | [[quizweb-app]]
container ct: Steuerung — die eine Tür der Bildschirme | [[quizweb-controller]]
container dm: Domäne — Planer, Bewerter, Warteschlange; kein Browser | [[quizweb-domain]]
container ch: Inhalt — macht aus Wörtern Karten | [[quizweb-content]]
container i: Texte — die Oberfläche in drei Sprachen | [[quizweb-i18n]]
container sv: Speicher — sichert und lädt den Fortschritt | [[quizweb-store]]
store ls: Browser-Speicher — hier lebt der Fortschritt
store vw: Wortlisten — dieselben Dateien wie in der App | [[vocab-tsv]]
container sw: Service Worker — hält eine Offline-Kopie | [[quizweb-service-worker]]

p -tippt-> ui
ui -ruft auf-> ct
ui -liest Texte aus-> i
ct -wendet die Regeln an aus-> dm
ct -baut Karten mit-> ch
ct -speichert über-> sv
ch -liest-> vw
sv -schreibt in-> ls
sw -behält eine Kopie von-> ui

## What it does
Sie hat dieselben fünf Modi, denselben Scheduler, dasselbe Tagesziel und denselben Serienkalender wie [[quizapp]] und funktioniert offline. Der Fortschritt liegt im Browser des jeweiligen Geräts und ist von der Android-App getrennt; Einstellungen > Sicherung speichert und stellt ihn wieder her.

## How it does it
Sie ist schlichtes JavaScript in ES-Modulen (die Standardart, JavaScript in Dateien zu teilen), ohne Build-Schritt und ohne Abhängigkeiten. Die Teile sind: [[quizweb-domain]] (reine Logik), [[quizweb-content]], [[quizweb-controller]], [[quizweb-store]] und [[quizweb-app]] (die letzten beiden sind die einzigen Module, die den Browser berühren) sowie der Offline-Cache [[quizweb-service-worker]]. Der Test `tests/architecture.test.js` legt fest, wer wen importieren darf, und [[quizweb-ci]] führt bei jedem Push `npm test` und die Grenzen von [[pipeline-check]] aus.

## Where it sits in the pipeline
Sie ist der Zwilling von [[quizapp]] (Entscheidung ADR-0006 dort; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält): Sie liest dieselben Vokabeldateien und dieselben Konformitätsvektoren, und [[check-web-sync]] in QuizApp vergleicht sie. Eine Übertragung von Android-Funktionen, die noch in der Beta sind, wartet auf einem Zweig `web-<version>` und wird nach `main` gemergt, wenn die App befördert wird.

## Who receives its output
Giovannis iPhone oder jeder Browser, über [[github-pages]].

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Prinzipien
1. **Die Domäne bleibt rein**: Planer, Bewerter und Warteschlange wissen nichts vom Browser. Nur `app.js` und `store.js` dürfen ihn berühren, und `tests/architecture.test.js` hält diese Abhängigkeitsregeln fest.
2. **Das Web verhält sich wie die App**: Konformanzvektoren, die mit der Android-App geteilt werden, geprüft von `tests/conformance.test.js`.
3. **Das Gate entscheidet**: `tools/quality_gate.sh` führt die Tests und die Fitnessprüfungen aus, und die kontinuierliche Integration führt dasselbe Skript aus.
4. **Eine Portierung wartet auf die App**: Das Web übernimmt die neueste veröffentlichte App-Version; eine Version in der Beta wartet auf einem Branch.

### Entscheidungen
Es gibt noch keine Entwurfsdatei und keinen Ordner `docs/adr/`; die Entscheidungen stehen in `README.md` (kein Build-Schritt und keine Abhängigkeiten, reine ES-Module; der Service Worker fragt zuerst das Netz; eine eigenständige Wartungsversion darf Korrekturen ausliefern, ohne auf die App zu warten). Die monatliche Prüfung führt die fehlende Entwurfsdatei als offen. Die passenden Entscheidungen für die App stehen in [[quizapp-adrs]].

### Anforderungen
Es gibt noch keine Anforderungsliste. Das Verhalten wird durch die Testdateien in `tests/` (Domäne, Inhalt, Steuerung, Texte, Architekturregeln, Fehlersuch-Tests) und durch die mit der App geteilten Konformanzvektoren festgehalten ([[quizweb-conformance]]).

### Quality Gate
Das Gate `tools/quality_gate.sh` hat zwei Schritte: `npm test` (die gesamte Web-Testsuite) und die Fitnessprüfungen von `pipeline-check`, die einen Bericht nach `build/pipeline-check/report.json` schreiben.

### Kontinuierliche Integration
Kontinuierliche Integration (CI) heißt automatische Prüfungen bei jedem Push. Der Workflow `test.yml` führt das Gate bei jedem Push und Pull Request auf GitHub aus ([[quizweb-ci]]); Node 22 und sonst keine Abhängigkeiten.

### Wartung
Technische Schulden werden als GitHub-Issues mit dem Label `debt` (P1 bis P3) nach der [[maintenance-policy]] geführt. Die [[monthly-architecture-review]] prüft das Projekt jeden Monat; die nächste ist am 22.11.2026 fällig.

## Notes

Die eigenständige Wartungsveröffentlichung vom 2026-10-26 enthält die Suche mit scharfem S, die Fortschrittsberechnung bei Tagesziel null und Prüfungen beim Sicherungsimport. Ihr Offline-Cache-Schlüssel ist `v12`. Wartungskorrekturen können unabhängig von einer neuen Android-Version erscheinen; Übertragungen unveröffentlichter Android-Funktionen warten weiter auf deren App-Veröffentlichung. GitHub schützt `main` durch die erforderliche Prüfung `test`, auch für Administratoren, und verbietet erzwungenes Überschreiben und Löschen des Zweigs. Der Wartungscommit bestand alle 81 Tests und die Veröffentlichung über GitHub Pages.
