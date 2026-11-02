---
id: checks-project-template
lang: de
source_hash: e4d01b793367
title: project-template: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer, die [[project-template]] jedem neuen Projekt mitgibt. Sie sind die Grundlinie, von der sich die anderen Projektseiten unterscheiden.

## What it does
Das Gate der Vorlage hat drei Schritte: einen Platzhalter für Build und Tests (`TODO`, auszufüllen), Anforderungs-Rückverfolgbarkeit mit der committeten Matrix (die Vorlage hat eine Beispielanforderung, `XX-1`) und die Fitness-Limits, abgeschlossen mit der Obergrenze von 1200 Sekunden für das Gate ([[template-quality-gate]]). Seine `pipeline-check.toml` enthält auskommentierte Beispiele für jeden optionalen Abschnitt (Dateigröße, GitHub, DORA, Pre-Push-Wächter, Rückverfolgbarkeits-Ordner, ShellCheck). DORA steht für DevOps Research and Assessment. Prinzipien: erst Anforderung, dann Test, dann Code; framework-freie Logik; das Gate entscheidet; gemeinsame Werkzeuge werden in festgelegter Version genutzt; Entscheidungen stehen dort, wo der Code ist.

## How it does it
Ein neues Projekt kopiert den Ordner, füllt die Platzhalter und legt in `pipeline-check.version` eine Version fest ([[new-project]]). Zwei ADRs (Architecture Decision Records) liegen bei: 0001 (Entscheidungen als ADRs festhalten) und 0003 (das Programm misst, ein Skill urteilt); 0002 bleibt der Technologiewahl vorbehalten ([[adr-explained]]).

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
