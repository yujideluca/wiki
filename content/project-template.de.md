---
id: project-template
lang: de
source_hash: 9bd6f4175ec4
title: project-template (Golden Path)
---

## What it is
project-template ist der Ausgangspunkt für jedes neue Softwareprojekt von Giovanni. Es ist ein fertiger Ordner (`~/dev/project-template`, Repository `yujideluca/project-template`), der die guten Arbeitsgewohnheiten schon enthält, sodass der richtige Weg auch der schnellste ist. Er wurde im Wartungs- und Evolutions-Review vom 2026-10-22 gewählt, und [[quizapp]] war das Referenzprojekt, aus dem er herausgezogen wurde.

## Flow
trigger t1: Ein neues Projekt beginnt | [[new-project]]
step s1: Der Vorlagenordner wird in einen neuen Projektordner kopiert
step s2: Es bringt erzwungene Prinzipien, Entwurf, markierte Tests, Gate und Schuldenregeln mit | [[template-quality-gate]], [[maintenance-policy]]
step s3: Claude füllt CLAUDE.md, Entwurfsdatei, erste Anforderungen und Gate-Schritte aus
step s4: Das private Repository und seine Labels werden angelegt
step s5: Das Projekt hält eine pipeline-check-Version fest; das Programm selbst wird nicht kopiert | [[pipeline-check]]
trigger t2: Ein laufendes Projekt findet eine bessere Praxis | [[monthly-architecture-review]]
step s6: Die Verbesserung wird in die Vorlage übernommen
product p1: Ein neues Projekt, das mit den guten Gewohnheiten beginnt | [[wiki]]
product p2: Eine bessere Vorlage für das nächste Projekt

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> p1
t2 -> s6
s6 -> p2

## Architecture
### Kontext
person g: Giovanni — bestellt ein neues Projekt und wählt die Sprache | [[giovanni]]
person c: Claude Code — kopiert die Vorlage und füllt sie aus | [[claude-code]]
system t: project-template — der Startordner mit den guten Gewohnheiten
external n: Ein neues Projekt — eine Kopie, die mit den Gewohnheiten beginnt
external p: pipeline-check — das Messprogramm, nach Version geholt | [[pipeline-check]]
external h: GitHub — ein privates Repository für das neue Projekt | [[github]]

g -bestellt ein Projekt aus-> t
c -kopiert und füllt aus-> t
t -wird kopiert in-> n
n -legt eine Version fest von-> p
n -wird gepusht nach-> h

### Container
person c: Claude Code | [[claude-code]]
container cm: CLAUDE.md — Prinzipien und Arbeitsregeln
container ds: DESIGN.md — C4-Diagramme und Entscheidungsprotokoll
store ad: docs/adr — Entscheidungsprotokolle
store rq: REQUIREMENTS.md — Versprechen mit IDs | [[check-traceability]]
store mt: MAINTENANCE.md — Schuldenregeln und Prüfliste | [[maintenance-policy]]
container qg: quality_gate.sh — die eine Definition von „bestanden“ | [[template-quality-gate]]
container ru: pipeline-check.sh — holt und startet die festgelegte Version
container ci: Workflow der automatischen Prüfung — startet den Läufer bei jedem Push
external p: pipeline-check | [[pipeline-check]]

c -füllt aus-> cm
c -füllt aus-> ds
c -schreibt-> ad
c -schreibt-> rq
c -folgt-> mt
c -füllt die Schritte aus von-> qg
ci -startet-> ru
ru -führt aus-> qg
ru -holt-> p

## What it does
Ein neues Projekt bekommt vom ersten Tag an: Prinzipien, die jeweils durch eine Prüfung durchgesetzt werden; eine Entwurfsdatei mit Diagrammen (im Stil des [C4-Modells](https://c4model.com/), gezeichnet mit [Mermaid](https://mermaid.js.org/)) und ein Entscheidungsprotokoll; ADRs (Architecture Decision Records, kurze Notizen, die die Gründe von Entscheidungen festhalten); eine Anforderungsliste mit zugeordneten getaggten Tests ([[check-traceability]]); ein Quality Gate (ein Skript, das „bestanden“ definiert, [[template-quality-gate]]); CI (Continuous Integration: automatische Prüfungen bei jedem Push) sowie die Richtlinie für technische Schulden und Reviews ([[maintenance-policy]]).

## How it does it
Der Ordner wird mit `cp -r` in einen neuen Projektordner kopiert. In der ersten Sitzung füllt Claude die CLAUDE.md des Projekts (seine Anweisungsdatei), Abschnitt 1 der Entwurfsdatei, die ersten Anforderungen, die Schritte des Gates und ADR-0002 für die gewählte Technik aus und legt dann das private GitHub-Repository mit seinen Labels an ([[new-project]]). Davor wählt Giovanni die Programmiersprache ([[work-ask-language]]). Das Wartungsprogramm [[pipeline-check]] wird nicht ins Projekt kopiert: Der Ordner enthält die Datei `pipeline-check.version` (am 2026-10-24 `v0.4.0`), das Startskript `tools/pipeline-check.sh`, das diese Version von `yujideluca/pipeline-check` einmal holt und baut (dafür braucht der Rechner Rust, `cargo` und git), die Grenzen in `pipeline-check.toml` und eine lokale Prüfung vor dem Push in `tools/hooks/pre-push`, die mit `git config core.hooksPath tools/hooks` eingeschaltet wird.

## Where it sits in the pipeline
Vor jedem neuen Projekt. Dieses [[wiki]] war das erste Projekt, das daraus gestartet wurde.

## Who receives its output
Neue Projekte wie das [[wiki]]; Verbesserungen aus laufenden Projekten fließen beim [[monthly-architecture-review]] in die Vorlage zurück.

## Engineering practices
### Prinzipien
1. **Anforderung, dann Test, dann Code**: Ein Verhalten wird zu einer Zeile in `docs/REQUIREMENTS.md`, dann zu einem Test mit dem Tag `REQ <ID>`; der Rückverfolgbarkeitsschritt des Gates prüft das.
2. **Logik ist frameworkfrei**: Jedes Projekt benennt sein reines Modul und was es durchsetzt (eine Modulgrenze oder ein Architekturtest).
3. **Das Gate entscheidet**: `tools/quality_gate.sh` ist die einzige Definition von „bestanden“, und die kontinuierliche Integration führt es über `pipeline-check` aus.
4. **Ein Werkzeug, das mehrere Projekte nutzen, lebt nur einmal**, in einem eigenen Repository, nach Version bezogen und nie kopiert.
5. **Entscheidungen stehen dort, wo der Code ist**: eine Zeile im Entscheidungsprotokoll von `DESIGN.md` mit ihrer Art und für Strukturelles ein Architekturentscheidungsprotokoll.

### Entscheidungen
Zwei Architekturentscheidungsprotokolle (kurze Notizen, die die Gründe einer Entscheidung bewahren) in `docs/adr/`: 0001 Entscheidungen als Protokolle festhalten und 0003 ein Programm misst und ein Skill urteilt (0002 bleibt für die Technikwahl jedes neuen Projekts frei). `DESIGN.md` enthält das Entscheidungsprotokoll mit der Wartungsart.

### Anforderungen
`docs/REQUIREMENTS.md` enthält eine Platzhalterzeile (`XX-1`), die das Format zeigt; ein neues Projekt ersetzt sie durch eigene Anforderungen, jede mit einem Test mit dem Tag `REQ <ID>` ([[check-traceability]]).

### Quality Gate
[[template-quality-gate]] ist ein Skript mit drei auszufüllenden Platzhalter-Schritten: Build und Tests, Rückverfolgbarkeit der Anforderungen und die Fitnessfunktionen (Grenzen in `pipeline-check.toml`).

### Kontinuierliche Integration
Kontinuierliche Integration (CI) heißt automatische Prüfungen bei jedem Push. Der Workflow `quality-gate.yml` führt den Läufer `tools/pipeline-check.sh` bei jedem Push auf GitHub aus; eine lokale Prüfung vor dem Push in `tools/hooks/pre-push` ersetzt den Branch-Schutz in einem privaten Repository.

### Wartung
Die Vorlage trägt die Regeln selbst: [[maintenance-policy]] (technische Schulden als GitHub-Issues mit dem Label `debt`, P1 bis P3, etwa jede fünfte Sitzung dafür) und die Checkliste der [[monthly-architecture-review]]. Eine in einem laufenden Projekt gefundene Verbesserung wandert hierher zurück; die nächste Prüfung ist am 22.11.2026 fällig.
