---
id: monthly-architecture-review
lang: de
source_hash: 7cb37dd5f3ea
title: Monatlicher Architektur-Review
---

## What it is
Einmal im Monat betrachtet eine Arbeitssitzung alle Projekte von Giovanni zusammen, in der Rolle, die in einem Unternehmen ein Staff Engineer hätte (ein erfahrener Ingenieur, der die Gesamtstimmigkeit im Blick hat). Die Idee stammt aus Entscheidung ADR-0003 von [[workflow-memory]] (ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält). Sie ist als offener Punkt im Gedächtnis hinterlegt, sodass jeder Chat sie zeigt, bis sie erledigt ist.

## Flow
trigger t1: Der offene Punkt der monatlichen Überprüfung wird fällig | [[maintenance-policy]]
step s1: Der Review-Skill führt pipeline-check aus und liest report.json | [[skill-revisao-manutencao]], [[pipeline-check]]
step s2: Prüft Gate, automatische Läufe, Lieferkennzahlen und Fitness-Funktionen | [[fitness-check]]
step s3: Beurteilt: Diagramme und ADRs passen zum Code, Tool-Updates auf einem Branch erprobt
decide d1: Ist eine P1-Schuld älter als ein Monat?
step s4: Plant sie jetzt ein
step s5: Blickt über Projekte: dasselbe Problem zweimal gelöst? | [[project-template]]
step s6: Prüft, ob Gedächtniseinträge noch stimmen, markiert veraltete | [[workflow-memory]]
step s7: Meldet, was die Überprüfung geprägt hat | [[mem-use]]
product p1: Eine Preventive-Zeile im Entscheidungsprotokoll je Projekt
product p2: Eine Schuldenliste, die stimmt und priorisiert ist
product p3: Die bessere Lösung in die Vorlage übernommen | [[project-template]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -ja-> s4
d1 -nein-> s5
s4 -> s5
s4 -> p2
s5 -> p3
s5 -> s6
s6 -> s7
s7 -> p1

## What it does
Er geht für jedes aktive Projekt in `~/dev` die Checkliste von [[maintenance-policy]] durch und hält das Ergebnis fest. Seit 2026-10-24 führt ihn die Skill [[skill-revisao-manutencao]] aus, auf Grundlage des Berichts von [[pipeline-check]] ([[maintenance-pipeline]]).

## How it does it
Er nutzt das Quality Gate jedes Projekts, Lieferkennzahlen (der Block `dora` im Bericht von [[pipeline-check]]), Fitnessfunktionen, die Entwurfsdatei (DESIGN.md), ADRs und die Schuldenliste. Die Skill [[skill-revisao-manutencao]] führt `tools/pipeline-check.sh` aus und liest `build/pipeline-check/report.json`; die Schritte 1 bis 3 unten hat das Programm schon gemessen, der Rest ist Urteil.

## Where it sits in the pipeline
Monatlich, quer über [[quizapp]], [[quizweb]], [[workflow-memory]], das [[wiki]] und die Vorlage.

## Who receives its output
Das Entscheidungsprotokoll jedes Projekts (eine Präventiv-Zeile) und [[project-template]] (bessere Lösungen werden dorthin übernommen).

## Steps
1. Das Gate besteht lokal, und die letzten CI-Läufe (Continuous Integration) sind grün.
2. Kennzahlen: wie oft Änderungen veröffentlicht werden, wie lange sie dauern, wie viel Arbeit wiederholt wird, und der Präventivanteil (Ziel etwa 20 %).
3. Fitnessfunktionen: Welche liegt am nächsten an ihrer Grenze? Handeln, bevor sie überschritten wird ([[fitness-check]]).
4. Die Diagramme in DESIGN.md und die ADRs passen noch zum Code; jede strukturelle Änderung hat ein ADR.
5. Adaptive Wartung: Updates von Werkzeugen, SDKs (Software Development Kits) und Abhängigkeiten werden auf einem Branch ausprobiert und durch das Gate geschickt.
6. Schuldenliste: noch zutreffend, richtige Priorität; ein P1, das älter als ein Monat ist, wird jetzt eingeplant ([[maintenance-policy]]).
7. Projektübergreifend: Wurde dasselbe Problem zweimal unterschiedlich gelöst? Die bessere Lösung in [[project-template]] übernehmen.
8. Gedächtnis: Stimmen die Einträge noch (`mem search <Projekt>`)? Veraltete bekommen `mem feedback REF stale` ([[workflow-memory]]).
9. Pro Projekt eine Präventiv-Zeile im Entscheidungsprotokoll festhalten und mit [[mem-use]] berichten.
