---
id: checker-catalog
lang: de
source_hash: 9121c9534379
title: Katalog aller Prüfer und welches Projekt sie nutzt
---

## What it is
Ein Prüfer ist jeder automatische Test, Scan oder jedes Limit, das eine Änderung zum Scheitern bringen kann. Diese Seite listet jeden gemeinsamen Prüfer einmal auf, sagt, wonach er sucht, und zeigt, welche der 13 Projekte ihn nutzen. Die Begriffe (Gate, Rückverfolgbarkeit, Mutation, Fitness-Funktion) stehen in [[quality-gate-explained]]. Regeln, die nur zu einem Projekt gehören, stehen auf dessen eigener Seite, erreichbar über [[code-security-pipeline]].

## What it does
Gemeinsame Prüfer (von [[pipeline-check]] ausgeführt):
- **Projekt-Gate**: führt `tools/quality_gate.sh` einmal aus (alle Projekte).
- **Anforderungs-Rückverfolgbarkeit** (`--traceability`, [[check-traceability]]): genutzt von [[checks-quizapp]], [[checks-wiki]], [[checks-pipeline-check]], [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-radiology-crawler]], [[checks-status-quo]] und [[checks-project-template]]. Nicht genutzt von [[checks-quizweb]] (seine Versprechen stehen in der Liste von QuizApp und werden aus den Web-Tests gelesen, siehe unten), [[checks-workflow-memory]], [[checks-remote-terminal]] oder [[checks-processing-sketches]].
- **Fitness-Limits** (`[[fitness]]` in `pipeline-check.toml`): eine Obergrenze für die Zeilen jeder Quelldatei (`max_file_lines`), für die Größe einer benannten Datei (`file_size`, genutzt für das APK, das Android-Paket, in [[checks-quizapp]]) oder für die Gate-Dauer (`gate_seconds`), mit Warnung ab 80 % und Fehler bei 100 %. Jedes Projekt außer [[checks-pipeline-check]] setzt mindestens die Obergrenze für die Gate-Dauer (300 s in [[checks-quizweb]], [[checks-workflow-memory]], [[checks-remote-terminal]] und [[checks-processing-sketches]]; sonst 1200 s).
- **Architektur-Importe** (`[architecture]`): verbotene Pakete in den reinen Ordnern. Nur aktiv in [[checks-quizapp]] (`core/src` darf `android` oder `androidx` nicht importieren) und [[checks-codex-pbar]] (`src/codex_pbar` darf `requests`, `urllib` oder `socket` nicht importieren).
- **ShellCheck** (`[shellcheck]`): 12 Projekte listen `tools/hooks/pre-push` ([[checks-pipeline-check]] listet stattdessen `consumer/pre-push`); jede von git verfolgte `.sh`-Datei wird ebenfalls geprüft.
- **GitHub-Zustand** (`[github]`, nur im lokalen Modus): letzter CI-Lauf grün und Branch-Schutz verlangt den Job ([[branch-protection-explained]]). Konfiguriert in [[checks-quizapp]], [[checks-quizweb]] (Job `test`), [[checks-wiki]], [[checks-workflow-memory]] und [[checks-codex-pbar]] (beide mit Ausnahme), [[checks-machine-bootstrap]], [[checks-remote-terminal]], [[checks-processing-sketches]] und [[checks-status-quo]] (ohne Ausnahme; das private Repository kann den Job im kostenlosen GitHub-Tarif nicht verlangen, die Schutzprüfung wird dort daher voraussichtlich weiter fehlschlagen, ihr genauer Berichtsstand ist nicht verifiziert); in den anderen nicht vorhanden.
- **DORA-Kennzahlen** (`[dora]`): Liefermetriken aus git, berichtet, aber nie fehlschlagend; in neun Projekten gesetzt.
- **Pre-Push-Wächter** (`[pre_push]`, [[branch-protection-explained]]): jedes Projekt außer [[checks-pipeline-check]].

Prüfer im eigenen Gate eines Projekts:
- **Mutationsprüfung**: [[mutation-check]] in [[checks-quizapp]] (`tools/mutation_check.py`, nur mit `tools/quality_gate.sh --mutation` und im wöchentlichen CI-Lauf), `mutants.py` in [[checks-pipeline-check]], `tools/mutation_check.py` in [[checks-codex-pbar]] und [[checks-codex-skills]].
- **Abdeckungsschwellen**: 90 % der Zeilen in den Logikpaketen und keine Datei unter 80 % in [[checks-quizapp]]; mindestens 85 % in [[checks-codex-pbar]].
- **Inhaltsregeln**: `wiki check` in [[checks-wiki]]; der Ereignis-Validator in [[checks-workflow-memory]]; `mb scan` in [[checks-machine-bootstrap]]; `skillsctl check` in [[checks-codex-skills]]; `content_manifest.py --check` im Gate von [[checks-quizapp]] (dessen Web-Sync-Prüfung läuft beim `promote`, nicht im Gate).
- **Deklarierte Abhängigkeiten**: `check_dependencies.py` in [[checks-radiology-crawler]].
- **Rust-Regeln und Desktop-Test**: [[checks-status-quo]] führt Formatierung, Clippy (den Rust-Linter) mit verbotenen Warnungen, die Workspace-Tests, den eigenen Grenzdetektor `tools/rust_architecture.rs` und den Ressourcenprüfer `tools/resource_check.rs` (je mit Selbsttest), die Rückverfolgbarkeit samt Prüfung, dass `docs/TRACEABILITY.md` aktuell committet ist, und das Fitness-Limit aus. Ein optionaler Schritt 6 führt den Desktop-End-to-End-Test `tools/ui_e2e.sh` aus, nur wenn `STATUS_QUO_E2E=1` gesetzt ist und der Bildschirm mit `STATUS_QUO_E2E_SCREEN_IS_FREE=1` als frei erklärt wird; sonst überspringt das Gate ihn.

## How it does it
`pipeline-check.toml` entscheidet, welche Abschnitte existieren; ein Projekt ohne Abschnitt bekommt diesen Prüfer einfach nicht. Eine `falha` lässt den Lauf fehlschlagen, ein `aviso` nicht, und eine Prüfung, die nicht laufen konnte, ist `pulado`. [[security-layers]] fasst die Prüfer zusammen, die vor Lecks schützen.

## Where it sits in the pipeline
Sie steht neben [[quality-gate-explained]] in Schritt 3 von [[code-security-pipeline]].

## Who receives its output
Leser, die wissen wollen „welche Prüfung schützt das?“, und der Skill [[skill-revisao-manutencao]], der dieselben Zahlen liest.
