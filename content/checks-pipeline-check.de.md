---
id: checks-pipeline-check
lang: de
source_hash: 5a8c20d8da09
title: pipeline-check: Prüfer und Regeln
---

## What it is
Dies sind die Prüfungen, die [[pipeline-check]] selbst bewachen, das Rust-Programm, das alle anderen Projekte misst (eigenes Repository, `yujideluca/pipeline-check`). Das Programm kann sich nicht auf eine festgelegte Kopie seiner selbst verlassen und hat daher die schlankste Verdrahtung.

## What it does
Das Gate hat drei Schritte: (1) `cargo test`, mit Testdateien für Ende-zu-Ende-Läufe, den Pre-Push-Modus, ShellCheck, Rückverfolgbarkeit und einen Bug-Jagd-Satz; (2) Anforderungs-Rückverfolgbarkeit durch Ausführen des eigenen `--traceability` über `src` und `tests` (die PC-Anforderungen) mit der committeten Matrix; (3) eine von Hand gebaute Mutationsprüfung: `mutants.py` pflanzt Fehler, und das Gate schlägt fehl, wenn einer überlebt. Prinzipien: Das Programm misst und ein Skill urteilt (ADR-0002, Architecture Decision Record), und ein Werkzeug, das mehrere Projekte nutzen, lebt einmal und wird in festgelegter Version genutzt (ADR-0003).

## How it does it
Der CI-Job (Continuous Integration) `gate` führt `tools/quality_gate.sh` direkt aus (höchstens 30 Minuten). Seine `pipeline-check.toml` setzt keine Fitness-Limits, keinen GitHub-Abschnitt und keinen Pre-Push-Wächter; sie hat die Abschnitte für Rückverfolgbarkeit und ShellCheck. Drei ADRs liegen in seinem `docs/adr`.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
