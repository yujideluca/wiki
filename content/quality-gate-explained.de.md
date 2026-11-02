---
id: quality-gate-explained
lang: de
source_hash: 46e8c1d13baa
title: Quality Gate, Anforderungen, Mutation und Fitness erklärt
---

## What it is
Ein Quality Gate ist ein einzelnes Skript, `tools/quality_gate.sh`, das entscheidet, ob ein Projekt „besteht“. Es endet mit 0, wenn alles in Ordnung ist, und mit einer anderen Zahl (einem Exit-Code), wenn etwas fehlschlägt. Es ist die einzige Definition von „bestanden“: Laptop, Veröffentlichungsskripte und [[ci-explained]] führen dieselbe Datei aus ([[template-quality-gate]] ist das leere Formular).

## What it does
Ein Gate hat meist drei Arten von Schritten, hier einmal erklärt:
- **Tests**: die eigene Testsuite des Projekts (Unit-, Property- und Konformitätstests).
- **Anforderungs-Rückverfolgbarkeit**: Jedes Versprechen in `docs/REQUIREMENTS.md` hat eine ID, und ein Test trägt das Tag `REQ <ID>` ([[check-traceability]]). Ein Versprechen ohne Test oder ein Tag für ein nicht existierendes Versprechen schlägt fehl.
- **Mutationsprüfung**: Das Skript pflanzt absichtlich einen kleinen Fehler in eine Kopie des Codes (zum Beispiel eine geänderte Zahl) und verlangt, dass mindestens ein Test fehlschlägt; ein überlebender Fehler bedeutet, dass ein Test fehlt ([[mutation-check]]).
- **Fitness-Funktionen**: automatische Limits für eine Entwurfsqualität, etwa die größte Datei, die Größe der App oder die Dauer des Gates. Eine Fitness-Funktion warnt ab 80 % ihres Limits und schlägt bei 100 % fehl ([[fitness-check]]).
- **Shell-Lint**: [ShellCheck](https://www.shellcheck.net/) liest die Shell-Skripte des Projekts auf Fehler.
- **DORA-Kennzahlen**: DORA (DevOps Research and Assessment), aus git berechnete Liefermetriken; sie werden berichtet, schlagen aber nie fehl ([[pipeline-check]]).

## How it does it
Das Gate ruft `tools/pipeline-check.sh --traceability` und `--measure-only` für die gemeinsamen Prüfungen auf. Der Wrapper `pipeline-check` führt das Gate einmal aus und ergänzt die Prüfungen, die nicht darin stecken (Architektur-Importe, GitHub-Zustand). Eine `falha` (Fehler) lässt das Programm mit 1 enden; ein `aviso` (Warnung) nie; eine Prüfung, die nicht laufen konnte, ist `pulado` (übersprungen), nie `ok`. Welche Schritte jedes Projekt hat, steht in [[checker-catalog]].

## Where it sits in the pipeline
Schritt 3 von [[code-security-pipeline]].

## Who receives its output
[[ci-explained]], der Pre-Push-Hook ([[branch-protection-explained]]) und, über `report.json`, der Skill [[skill-revisao-manutencao]].
