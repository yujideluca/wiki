---
id: skill-revisao-manutencao
lang: de
source_hash: 73409c783413
title: Skill: revisao-manutencao
aliases: [revisao-manutencao]
---

## What it is
Die urteilende Hälfte der [[maintenance-pipeline]]: ein Skill, der liest, was [[pipeline-check]] gemessen hat, und vorschlägt, was damit zu tun ist.

## What it does
Startet `tools/pipeline-check.sh`, liest `report.json` und misst nie neu. Für jedes `aviso` oder `falha` schlägt er ein `debt`-Issue mit Priorität P1 (Risiko für Daten oder falsche Ergebnisse), P2 (bremst jede Änderung) oder P3 (wünschenswert) vor. Dann prüft er, was eine Maschine nicht sieht: Passen `DESIGN.md` und ADRs zum Code, hat jede strukturelle Änderung ein ADR, wurde dasselbe Problem zweimal gelöst (die bessere Lösung nach [[project-template]] übernehmen). Er fügt dem Entscheidungslog jedes geprüften Projekts eine Zeile Präventiv hinzu, ruft [[skill-gerar-teste-automatizado]] auf (anlegen bei der ersten Überprüfung, danach aktualisieren) und endet mit `mem use`, `wiki publish` und „Verified by:“. Er prüft auch die Standards, die kein Werkzeug misst: Jeder Projektordner ist ein Git-Repository mit GitHub-Remote, die lokale Pre-Push-Prüfung ist aktiv, die festgelegte pipeline-check-Version ist die neueste, und kein Skript wird zwischen Projekten kopiert. Er schlägt vor; er schließt keine Issues, ändert keine Grenze, befördert keine Version und ändert den Branch-Schutz nicht.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/revisao-manutencao`. Ausgelöst vom Punkt der monatlichen Überprüfung in workflow-memory und am Ende einer Aufgabe in einem Softwareprojekt.

## Where it sits in the pipeline
Führt die [[monthly-architecture-review]] und die Überprüfung am Aufgabenende jedes Softwareprojekts durch.

## Who receives its output
Giovanni (Vorschläge und Entscheidungen) und das Entscheidungslog jedes Projekts.
