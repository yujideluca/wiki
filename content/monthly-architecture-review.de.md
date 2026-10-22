---
id: monthly-architecture-review
lang: de
source_hash: 9babdd21a680
title: Monatliche Architekturüberprüfung
aliases: [Architekturüberprüfung]
---

## What it is
Eine Sitzung pro Monat in der Rolle, die in einer Firma ein Staff Engineer hat: Stimmigkeit über alle Projekte prüfen (workflow-memory ADR-0003). Sie ist ein offener Punkt im Gedächtnis, also zeigt jeder Chat sie, bis sie erledigt ist.

## What it does
Geht für jedes aktive Projekt in `~/dev` die Checkliste von [[maintenance-policy]] durch und hält das Ergebnis fest.

## How it does it
Nutzt Tor, Metriken (`tools/metrics.py`, wo vorhanden), Fitnessfunktionen, DESIGN.md, ADRs und Schuldenliste jedes Projekts.

## Where it sits in the pipeline
Monatlich, über [[quizapp]], [[quizweb]], [[workflow-memory]], [[wiki]] und die Vorlage.

## Who receives its output
Das Entscheidungslog jedes Projekts (eine Zeile Präventiv) und [[project-template]] (bessere Lösungen wandern hinein).

## Steps
1. Das Tor besteht lokal und die letzten CI-Läufe sind grün.
2. Metriken: Liefertakt, Durchlaufzeit, Nacharbeitsquote, Anteil Vorbeugung (Ziel etwa 20 %).
3. Fitnessfunktionen: Was ist am nächsten an seiner Grenze? Handeln, bevor sie überschritten wird ([[fitness-check]]).
4. DESIGN.md-Diagramme und ADRs passen noch zum Code; jede strukturelle Änderung hat ein ADR.
5. Adaptive Wartung: Updates von Werkzeugen, SDK und Abhängigkeiten, auf einem Branch und durch das Tor.
6. Schuldenliste: noch wahr, richtige Priorität; ein P1 älter als ein Monat wird jetzt eingeplant ([[maintenance-policy]]).
7. Projektübergreifend: dasselbe Problem zweimal verschieden gelöst? Die bessere Lösung in [[project-template]] übernehmen.
8. Gedächtnis: Einträge noch wahr (`mem search <Projekt>`); veraltete bekommen `mem feedback REF stale` ([[workflow-memory]]).
9. Pro Projekt eine präventive Zeile ins Entscheidungslog und mit [[mem-use]] melden.
