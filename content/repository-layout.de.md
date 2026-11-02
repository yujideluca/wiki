---
id: repository-layout
lang: de
source_hash: 192e5c0ecc59
title: Repository-Layout (der goldene Pfad)
---

## What it is
Ein Repository ist ein Projektordner, der von [Git](https://git-scm.com/) verfolgt wird, einem Werkzeug, das jede Änderung aufzeichnet. Jedes Softwareprojekt von Giovanni beginnt mit [[project-template]] und hat deshalb dasselbe Gerüst. Wer ein Projekt kennt, findet dieselben Dinge in einem anderen wieder.

## What it does
Das Gerüst hat diese Teile:
- `CLAUDE.md` (und `AGENTS.md` für Codex): die Prinzipien und Arbeitsregeln für den Assistenten, jedes Prinzip gepaart mit der Prüfung, die es durchsetzt.
- `DESIGN.md`: Diagramme des Systems und das Entscheidungslog, eine Tabelle mit einer Zeile pro Entscheidung und ihrem Wartungstyp.
- `docs/adr/`: eine Datei pro struktureller Entscheidung ([[adr-explained]]).
- `docs/REQUIREMENTS.md`: die Versprechen des Programms, jedes mit einer ID wie `PC-3`; `docs/TRACEABILITY.md` ist die erzeugte Tabelle, die jede ID ihren Tests zuordnet ([[check-traceability]]).
- `docs/MAINTENANCE.md`: die Schuldenpolitik ([[maintenance-policy]]).
- `tools/quality_gate.sh`: die eine Definition von „bestanden“ ([[quality-gate-explained]]).
- `tools/pipeline-check.sh`, `pipeline-check.version` und `pipeline-check.toml`: das Skript, das das festgelegte [[pipeline-check]] holt, die festgelegte Version und die Limits, die es durchsetzt.
- `tools/hooks/pre-push`: der lokale Ersatz für den Branch-Schutz ([[branch-protection-explained]]).
- `.github/workflows/quality-gate.yml`: die automatischen Prüfungen auf GitHub ([[ci-explained]]).

## How it does it
Neue Projekte kopieren den Vorlagenordner; die Wiki-Seite [[new-project]] beschreibt die Schritte. Nicht jedes ältere Projekt hat alle Teile: [[checks-remote-terminal]] und [[checks-processing-sketches]] haben ein schlankeres Gate, und [[checks-status-quo]] trägt noch Platzhalter-Schritte im Gate.

## Where it sits in the pipeline
Es ist die gemeinsame Form, auf die sich die Projektseiten in [[code-security-pipeline]] beziehen.

## Who receives its output
Neue Projekte und die Prüfungen in [[checker-catalog]], die nach diesen Dateien anhand ihres Namens suchen.
