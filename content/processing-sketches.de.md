---
id: processing-sketches
lang: de
source_hash: fcc5f904671a
title: Processing-Sketches
---

## What it is
Kleine Generative-Art-Programme (Kunst, die Code erzeugt), geschrieben in [Processing](https://processing.org/), einer auf Java basierenden Programmierumgebung zum Zeichnen. Sie liegen in `~/dev/processing-sketches`. Ein „Sketch“ nennt Processing ein Programm.

## Flow
trigger t1: Giovanni schreibt einen Sketch in Processing
step s1: Jeder Sketch ist eine .pde-Datei in einem eigenen Ordner
step s2: Beim Ausführen zeichnet er die Heighway-Drachenkurve
decide d1: Welche Version?
step s3: Als App exportiert, von git ignoriert | [[drachenkurve]]
step s4: Als Startsymbol der QuizApp gerendert | [[quizapp]]
trigger t2: Ein Push in das Repository | [[pipeline-check]]
step s5: Das Quality Gate und die automatischen Prüfungen laufen
product p1: Das Startsymbol der QuizApp | [[quizapp]]
product p2: Ein zweiter Drachenkurven-Sketch, nur als Programm | [[drachenfraktal]]
product p3: Geprüfte Sketche auf GitHub

t1 -> s1
s1 -> s2
s2 -> d1
d1 -drachenkurve-> s3
d1 -drachenfraktal-> p2
s3 -> s4
s4 -> p1
t2 -> s5
s5 -> p3

## What it does
Es zeichnet die Heighway-Drachenkurve in zwei Versionen: [[drachenkurve]] (als App exportiert; sie hat das Startsymbol von QuizApp gerendert) und [[drachenfraktal]].

## How it does it
Jeder Sketch ist eine `.pde`-Datei in einem eigenen Ordner; `drachenkurve` hat zusätzlich einen exportierten Build. Seit 2026-10-24 ist der Ordner ein GitHub-Repository (`yujideluca/processing-sketches`, seit 2026-10-25 öffentlich) mit Quality Gate, CI (Continuous Integration, automatische Prüfungen bei jedem Push) und der Prüfung [[pipeline-check]] vor dem Push; die Build-Ausgabe wird von Git ignoriert.

## Where it sits in the pipeline
Abseits der anderen Projekte; seine einzige Verbindung zu ihnen ist das Symbol von [[quizapp]].

## Who receives its output
[[quizapp]] (sein Startsymbol).
