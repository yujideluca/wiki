---
id: processing-sketches
lang: de
source_hash: 5f212c792b50
title: Processing-Sketches
---

## What it is
Kleine Generative-Art-Programme (Kunst, die Code erzeugt), geschrieben in [Processing](https://processing.org/), einer auf Java basierenden Programmierumgebung zum Zeichnen. Sie liegen in `~/dev/processing-sketches`. Ein „Sketch“ nennt Processing ein Programm.

## What it does
Es zeichnet die Heighway-Drachenkurve in zwei Versionen: [[drachenkurve]] (als App exportiert; sie hat das Startsymbol von QuizApp gerendert) und [[drachenfraktal]].

## How it does it
Jeder Sketch ist eine `.pde`-Datei in einem eigenen Ordner; `drachenkurve` hat zusätzlich einen exportierten Build. Seit 2026-10-24 ist der Ordner ein privates GitHub-Repository (`yujideluca/processing-sketches`) mit Quality Gate, CI (Continuous Integration, automatische Prüfungen bei jedem Push) und der Prüfung [[pipeline-check]] vor dem Push; die Build-Ausgabe wird von Git ignoriert.

## Where it sits in the pipeline
Abseits der anderen Projekte; seine einzige Verbindung zu ihnen ist das Symbol von [[quizapp]].

## Who receives its output
[[quizapp]] (sein Startsymbol).
