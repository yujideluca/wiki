---
id: b2-vorlagen
lang: de
source_hash: 1fe4f89b73a1
title: Website mit Schreibvorlagen für B2
---

## What it is
Eine einzelne Webseite, „Goethe B2 Schreiben: texts that score 10“, für Giovannis Übung des Schreibens (Schreiben) im Goethe-Zertifikat B2, einer Prüfung für Deutsch als Fremdsprache. Sie wird aus dem Ordner `~/dev/b2-vorlagen` erzeugt. Eine „Vorlage“ ist ein Text, dessen Sätze feststehen und dessen Lücken (Slots genannt) Giovanni selbst füllt.

## Flow
trigger t1: Giovanni startet build/site.py
step s1: Aufgabentexte und Slot-Werte werden aus den Dateien in data/ gelesen
step s2: Jede Aufgabe wird in die Vorlage für Forumsbeitrag oder E-Mail eingesetzt
step s3: Die Seite index.html wird geschrieben und nach public/ kopiert
product p1: Seite mit den 20 korrigierten Texten und den 40 neuen Übungsthemen

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> p1

## Architecture
### Context
person g: Giovanni — übt die Schreiben-Aufgaben | [[giovanni]]
system s: b2-vorlagen — erzeugt eine Übungsseite

g -reads the page from-> s

### Containers
person g: Giovanni | [[giovanni]]
container bs: build/site.py — schreibt die Seite
container tp: build/templates.py — die beiden Vorlagen
store dt: data/ — Aufgaben, Slot-Werte und Korrekturen
store ev: eval/ — Blindbewertungen
store pg: index.html und public/index.html — die Seite

bs -reads-> tp
bs -reads-> dt
bs -reads-> ev
bs -writes-> pg
g -reads-> pg

## What it does
Die Seite hat vier Teile: die beiden Vorlagen (Forumsbeitrag und formelle E-Mail) mit einer Erklärung jedes Slots; eine Tabelle mit den Punktzahlen; die 20 Aufgaben, die Giovanni schon geschrieben hat, jeweils mit Aufgabe, seinem Text, einer Korrektur Zeile für Zeile und einer Vorlagenversion; und, seit dem 31.10.2026, 20 neue Themen für den Forumsbeitrag und 20 neue Themen für die E-Mail (Abschnitt 4). Die neuen Themen haben die Aufgabe und einen Mustertext aus der Vorlage, aber keinen Text von Giovanni, also weder Korrektur noch Punktzahl.

Die Punktzahlen sind „Blindbewertungen“: Eine getrennte Modellsitzung sah nur die Kriterien, die Aufgabe und den Text. Der Build gibt die Mittelwerte aus: 4,45 für Giovannis Originale und 9,31 für die Vorlagenversionen. Sie sind das Urteil eines Modells, keine offizielle Goethe-Note. Die neuen Themen wurden nicht bewertet.

## How it does it
`python3 build/site.py` liest `data/` und `eval/` und schreibt `index.html`; `public/index.html` ist eine Kopie. `build/templates.py` enthält jede Vorlage als Sätze, die als Kern (immer verwendet) oder Zusatz (nur bei Bedarf der Aufgabe) markiert sind; ein Satz entfällt, wenn ein Slot keinen Wert hat. Beispiel: `Ehrlich gesagt bin ich der Ansicht, dass {MEINUNG_N}.` wird zu einem Satz, sobald `MEINUNG_N` gegeben ist. Der Slot-Name zeigt die Grammatik: `_N` ist ein Nebensatz mit Verb am Ende, `_H` ein Hauptsatz mit Verb an zweiter Stelle, `_Z` ein `zu` plus Infinitiv.

Die neuen Themen stehen in `data/new_forum.py` und `data/new_mail.py`. Jede Aufgabe folgt der Form einer Prüfungsaufgabe: vier Punkte, eine Mindestwortzahl, Anrede und Gruß. Die Links der Seite sind petrolgrün (CSS-Variable `--lk`, Kontrast etwa 7:1 im hellen und 10:1 im dunklen Modus).

## Where it sits in the pipeline
Abseits der anderen Teile. Sie unterstützt die Deutschübung aus [[skill-alemao-goethe-fsp]]. Sonst liest niemand ihre Ausgabe.

## Who receives its output
Giovanni, der die Seite im Browser liest.

## Engineering practices
Wie dieses Projekt dem goldenen Weg von [[project-template]] folgt.

### Principles
Noch nicht erfüllt: Der Ordner hat kein Git-Repository, kein Qualitätstor und keine Tests (geprüft am 31.10.2026).

### Decisions
Keine Entscheidungsdokumente.

### Requirements
Keine Anforderungsliste.

### Quality gate
Noch keines.

### Continuous integration
Noch keine.

### Maintenance
Wird von der [[monthly-architecture-review]] nicht erfasst. Es gibt noch kein Repository.

## Notes
Die Mustertexte der neuen Themen wurden in einer Sitzung geschrieben und nur auf Vollständigkeit (jeder Slot gefüllt) und Länge geprüft (mindestens 125 Wörter bei einer E-Mail und 224 bei einem Forumsbeitrag, mit den Zusatzsätzen). Eine Muttersprachlerin oder ein Muttersprachler hat das Deutsch nicht geprüft.
