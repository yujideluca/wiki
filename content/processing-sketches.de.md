---
id: processing-sketches
lang: de
source_hash: a379c53d1133
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

## Architecture
### Kontext
person g: Giovanni — zeichnet und startet die Skizzen | [[giovanni]]
system s: processing-sketches — ein Ordner mit kleinen Processing-Skizzen
external p: Processing — das Werkzeug, das eine Skizze startet
external h: GitHub — bewahrt den Verlauf, privat | [[github]]

g -startet Skizzen mit-> p
g -hält die Skizzen in-> s
s -wird gepusht nach-> h

### Container
person g: Giovanni | [[giovanni]]
container dk: Drachenkurven-Skizze | [[drachenkurve]]
container df: Drachenfraktal-Skizze | [[drachenfraktal]]
store bo: build/ — beim Start entstehende Jars, nie committet
container qg: Quality Gate — jede Skizze hat ihre .pde-Datei, keine Build-Ausgabe ist erfasst

g -startet-> dk
g -startet-> df
dk -schreibt-> bo
df -schreibt-> bo
qg -prüft-> dk
qg -prüft-> df
qg -prüft, dass nichts committet ist in-> bo

## What it does
Es zeichnet die Heighway-Drachenkurve in zwei Versionen: [[drachenkurve]] (als App exportiert; sie hat das Startsymbol von QuizApp gerendert) und [[drachenfraktal]].

## How it does it
Jeder Sketch ist eine `.pde`-Datei in einem eigenen Ordner; `drachenkurve` hat zusätzlich einen exportierten Build. Seit 2026-10-24 ist der Ordner ein GitHub-Repository (`yujideluca/processing-sketches`, seit 2026-10-25 öffentlich) mit Quality Gate, CI (Continuous Integration, automatische Prüfungen bei jedem Push) und der Prüfung [[pipeline-check]] vor dem Push; die Build-Ausgabe wird von Git ignoriert.

## Where it sits in the pipeline
Abseits der anderen Projekte; seine einzige Verbindung zu ihnen ist das Symbol von [[quizapp]].

## Who receives its output
[[quizapp]] (sein Startsymbol).

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Prinzipien
1. **Ein Ordner pro Skizze**: Jeder enthält eine `.pde`-Datei gleichen Namens; das Gate scheitert, wenn eine fehlt.
2. **Build-Ausgaben werden nie committet**: Das Gate scheitert, wenn eine erfasste Datei unter einem Ordner `build/` liegt.
3. **Das Gate entscheidet**: `tools/quality_gate.sh` ist die einzige Definition von „bestanden“, und die kontinuierliche Integration führt es aus.
4. **Entscheidungen stehen in `DESIGN.md`.**

### Entscheidungen
Es gibt noch keine Architekturentscheidungsprotokolle; das Entscheidungsprotokoll in `DESIGN.md` hat drei Zeilen: das Projekt kam unter git auf GitHub (privat) mit Gate und CI, die erste Wartungsprüfung und die monatliche Prüfung vom 25.10.2026.

### Anforderungen
Es gibt noch keine Anforderungsliste, weil die Skizzen keine Verhaltenstests haben (technische Schuld P3: die Kurvengeometrie in eine getestete Funktion verlagern, wenn die Skizzen wachsen).

### Quality Gate
Das Gate `tools/quality_gate.sh` prüft, dass jeder Skizzenordner seine `.pde`-Datei enthält und dass git keine Build-Ausgabe erfasst. `tools/pipeline-check.sh` ergänzt die vollständige Messung.

### Kontinuierliche Integration
Kontinuierliche Integration (CI) heißt automatische Prüfungen bei jedem Push. Der Workflow `quality-gate.yml` führt das Gate bei jedem Push auf GitHub aus, über `pipeline-check`, festgelegt in `pipeline-check.version`.

### Wartung
Technische Schulden werden als GitHub-Issues mit dem Label `debt` (P1 bis P3) nach der [[maintenance-policy]] geführt. Die [[monthly-architecture-review]] prüft das Projekt jeden Monat; die nächste ist am 22.11.2026 fällig.
