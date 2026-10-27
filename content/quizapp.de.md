---
id: quizapp
lang: de
source_hash: 777c8903bb32
title: QuizApp (German Quiz, Android)
---

## What it is
QuizApp („German Quiz“) ist eine Android-App, mit der Giovanni Deutsch für das Niveau B2 der Goethe-Prüfung paukt. Sie funktioniert offline und nutzt Spaced Repetition im Stil von [Anki](https://apps.ankiweb.net/): ein Verfahren, bei dem gut beantwortete Fragen nach immer längeren Pausen wiederkommen und falsch beantwortete bald ([Spaced Repetition](https://en.wikipedia.org/wiki/Spaced_repetition)). Das Repository ist `yujideluca/german-quiz`, der Ordner `~/dev/QuizApp`, der Paketname der App `dev.yuji.quiz`. Sie ist außerdem das Referenzprojekt dafür, wie Giovannis Projekte gebaut werden.

## Flow
trigger t1: Giovanni öffnet die App auf dem Handy | [[phone]]
step s1: Wählt einen der fünf Lernmodi | [[game-modes]]
step s2: Der Planer wählt die nächste Frage aus dem Pool | [[spaced-repetition-scheduler]]
step s3: Giovanni antwortet; der Prüfer bewertet | [[answer-grader]]
decide d1: Richtig und schnell?
step s4: Die Karte rückt auf Tage, Wochen, Monate hinaus
step s5: Die Karte kommt bald wieder
step s6: Tagesziel und Serienkalender werden aktualisiert | [[daily-goal]], [[activity-calendar]]
trigger t2: Ein neues Fragenpaket wird veröffentlicht | [[question-pack]]
step s7: Die App holt das Paket, ohne neue App-Version
trigger t3: Giovanni bittet um eine Änderung | [[giovanni]]
step s8: Die Änderung nimmt den Release-Weg, erst Beta, dann stabil | [[quizapp-release]]
product p1: Lernfortschritt, auf Wunsch gesichert | [[progress-backup]]
product p2: Eine neue Beta- oder stabile App auf dem Handy | [[update-client]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -ja-> s4
d1 -nein-> s5
s4 -> s6
s5 -> s6
s6 -> p1
t2 -> s7
s7 -> s2
t3 -> s8
s8 -> p2

## Architecture
### Kontext
person p: Spieler — lernt deutsche Vokabeln | [[giovanni]]
system a: German-Quiz-App — Quiz mit Wiederholungsabständen für Android
external w: German Quiz Web — dasselbe Quiz im Browser | [[quizweb]]
external f: Release-Feed — neueste Version, signierte App-Datei, Fragenpaket | [[release-feed]]
external d: Handyspeicher oder Google Drive — hält die Sicherungsdatei | [[phone]]

p -lernt mit-> a
p -lernt mit-> w
a -teilt Fragen und Testvektoren mit-> w
a -lädt Updates und Fragen von-> f
a -speichert Sicherungen in-> d

### Container
person p: Spieler | [[giovanni]]
container ui: Bildschirme — was der Spieler sieht und antippt
container ct: Lernsteuerung — die eine Tür der Bildschirme | [[quizapp-app]]
container co: Kernmodul — Planer, Bewerter, Warteschlange; kein Android | [[quizapp-core]]
container da: Datenschicht — Fortschritt, Einstellungen, Aktualisierer
store v: Vokabeldateien — in die App eingebaut | [[vocab-assets]]
store dl: Heruntergeladenes Fragenpaket — neuere Fragen
external f: Release-Feed | [[release-feed]]

p -tippt-> ui
ui -ruft auf-> ct
ct -führt die Regeln aus in-> co
ct -speichert über-> da
da -liest-> v
da -liest und schreibt-> dl
da -lädt herunter von-> f

## What it does
Sie bietet fünf Lernmodi über einen kuratierten B2-Inhaltspool ([[game-modes]]): der/die/das, Präpositionen, Pluralformen, Präteritum und „Fehler finden“. Falsche oder langsame Antworten kommen bald wieder; bekannte Karten rücken auf Tage, Wochen und Monate hinaus ([[spaced-repetition-scheduler]]). Sie hat ein Tagesziel und einen Serienkalender ([[daily-goal]], [[activity-calendar]]), eine Sicherung des Fortschritts ([[progress-backup]]) und Updates aus der App heraus ([[update-client]]). Seit 2026-10-22 kann der Fragenpool ohne neue App-Version wachsen: Neue [[question-pack]]s kommen aus dem Update-Feed ([[question-pool-updater]], [[publish-content]]).

## How it does it
Sie ist in [Kotlin](https://kotlinlang.org/) mit [Jetpack Compose](https://developer.android.com/compose) (Androids moderne Art, Bildschirme zu zeichnen) geschrieben und in zwei Gradle-Module geteilt (getrennt gebaute Teile): [[quizapp-core]] (reine Kotlin-Logik: Scheduler, Bewerter, Warteschlange, Sitzung, Inhalt) und [[quizapp-app]] (Android-Bildschirme, Speicher, Updates). Der Inhalt wird von [[build-vocab]] aus tabulatorgetrennten Textdateien gebaut. Jede Änderung geht Anforderung → Test → Code, besteht das [[quizapp-quality-gate]] und erreicht das Handy zuerst über den Beta-Kanal ([[release-channels]], [[quizapp-release]]). Entwurf und Entscheidungen stehen in [[quizapp-design-doc]] und [[quizapp-adrs]].

## Where it sits in the pipeline
Sie ist Giovannis wichtigstes Lernwerkzeug. Ihr Web-Zwilling ist [[quizweb]], der sich genauso verhalten muss ([[check-web-sync]]). Releases gehen über den [[release-feed]] hinaus.

## Who receives its output
Giovanni, auf dem [[phone]]; [[quizweb]] erhält ihre Regeln, Testvektoren und Übersetzungen.

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Prinzipien
1. **Die Abstandsregeln kommen zuerst** (sie sind Anforderungen, durch Tests festgenagelt): die Tests der Abstandsregeln und der Simulation, die gemeinsamen Vektoren und die Prüfungen mit absichtlich eingebauten Fehlern.
2. **Logik ist frameworkfrei**: Planer, Bewerter, Warteschlange und Sitzung liegen im Kernmodul ohne Android; ein `import android.*` dort lässt sich nicht kompilieren.
3. **Anforderung, dann Test, dann Code**: geprüft vom Rückverfolgbarkeitsschritt des Gates.
4. **Nichts erreicht den Spieler ohne zuerst die Beta-App**, und eine Version darf befördert werden, wenn sie die für ihre Änderung aktualisierten automatischen Tests übersteht; dann entscheidet Giovanni.
5. **Der Web-Zwilling verhält sich wie die App**: gemeinsame Testvektoren, eine Synchronprüfung und beide Läufe der kontinuierlichen Integration.
6. **Entscheidungen stehen dort, wo der Code ist**: Entscheidungsprotokoll mit Art, Architekturentscheidungsprotokoll für Strukturelles, die C4-Diagramme in `DESIGN.md` ändern sich im selben Commit.

### Entscheidungen
13 Architekturentscheidungsprotokolle (kurze Notizen, die die Gründe einer Entscheidung bewahren) in `docs/adr/`, [[quizapp-adrs]]: Kotlin mit Jetpack Compose; ein reiner Planer mit eingespeister Uhr; ein Update-Feed mit Aktualisierer in der App; zwei Veröffentlichungskanäle (zuerst Beta); ein Web-Zwilling; Abstandsregeln als Anforderungen; Anforderungen zuerst; ein reines Kernmodul; Fortschrittssicherung als eine Datei; Beförderung nach aktualisierten Tests; ein herunterladbarer Fragenpool; ein Programm, das misst, und ein Skill, der urteilt. `DESIGN.md` enthält auch das Entscheidungsprotokoll.

### Anforderungen
33 Anforderungen in `docs/REQUIREMENTS.md` ([[quizapp-requirements]]), gruppiert nach Präfix (Abstandsregeln SP, Planung und Tagesziel DG, Fragenpool QP, Sicherung PE, Updates UP und weitere). Jede hat einen Test mit dem Tag `REQ <ID>`, und die Rückverfolgbarkeitsprüfung ([[check-traceability]]) schlägt fehl, wenn eine keinen hat.

### Quality Gate
[[quizapp-quality-gate]] ist ein Skript mit sieben Schritten: Kern- und App-Tests mit Abdeckung; Abdeckungsgrenzen für die Logikpakete; die Web-Tests; die Konformanzvektoren, in App und Web identisch; Rückverfolgbarkeit der Anforderungen; Android-Lint; die Fitnessfunktionen und das Manifest des Fragenpools. Vor einer Beförderung läuft zusätzlich eine Mutationsprüfung (absichtlich eingebaute Fehler müssen auffallen).

### Kontinuierliche Integration
Kontinuierliche Integration (CI) heißt automatische Prüfungen bei jedem Push. Der Workflow `quality-gate.yml` führt das Gate bei jedem Push auf GitHub aus ([[quizapp-ci]]); nach dem Push muss der Lauf grün sein.

### Wartung
Technische Schulden werden als GitHub-Issues mit dem Label `debt` (P1 bis P3) nach der [[maintenance-policy]] geführt. Die [[monthly-architecture-review]] prüft das Projekt jeden Monat; die nächste ist am 22.11.2026 fällig.
