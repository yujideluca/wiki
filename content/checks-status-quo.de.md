---
id: checks-status-quo
lang: de
source_hash: 594e6c5821e5
title: status-quo: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer des Repositorys `status-quo` (siehe [[status-quo-design]] und [[status-quo-layout]]), eines Rust-Workspaces, der aus [[project-template]] gestartet wurde. Es liegt im privaten GitHub-Repository `yujideluca/status-quo`. Der Lauf der kontinuierlichen Integration beim ersten Commit bestand am 2026-11-02; Branch-Schutz lässt sich bei einem privaten Repository im kostenlosen Tarif nicht aktivieren, daher schlägt die Prüfung `protecao-de-branch` weiter fehl.

## What it does
Das Gate (`tools/quality_gate.sh`) führt fünf Schritte nacheinander aus: Rust-Formatierung (`cargo fmt --check`), Compiler-Diagnose ohne zugelassene Warnungen (clippy) samt der gesamten Testsuite, eine projekteigene Grenzprüfung (`tools/rust_architecture.rs`), Anforderungs-Rückverfolgbarkeit und die Fitness-Obergrenze für die Gate-Dauer (1200 Sekunden). Am 2026-11-02 bestanden alle fünf.

Die Grenzprüfung existiert, weil der gemeinsame Prüfer (`pipeline-check` v0.4.0) nur Java und Kotlin untersucht. Sie weist grafische, Datei-, Prozess- oder Netzwerkabhängigkeiten in den drei portablen Paketen zurück, erlaubt im wiederverwendbaren Tray nur die Oberflächenbibliothek egui und hat eigene Selbsttests, die Fehler einpflanzen und deren Zurückweisung verlangen. Alle 29 Anforderungen (Gruppe SQ; SQ-29 liegt zum Zeitpunkt der Prüfung im nicht committeten Arbeitsverzeichnis) in `docs/REQUIREMENTS.md` haben einen Test mit einem eigenständigen Kommentar `// REQ SQ-n`; die Suche deckt `.rs`-Dateien unter `crates` und `tools` ab. Ein Tag belegt, dass ein Test existiert, nicht dass sich der echte Desktop richtig verhält; Fensterstapelung, Start beim Login und die Ressourcengrenzen brauchen daher eigene Beobachtung (die Leerlauf-CPU liegt derzeit bei 2,05 % eines Kerns bei einem Ziel von 1 %).

## How it does it
CI (Continuous Integration) nutzt den Standard-Workflow (`pipeline-check --mode ci`, höchstens 60 Minuten) und ergänzt einen Browser-Build für das Ziel `wasm32`. `pipeline-check.toml` nennt das Projekt, verweist auf das Repository `yujideluca/status-quo`, verlangt die Prüfung `gate` auf `main` und führt `tools/hooks/pre-push` für den Shell-Prüfer auf. Vier ADRs (Architecture Decision Records) existieren, dazu eine leere Vorlage `docs/adr/0000-template.md`: 0001 (Entscheidungen festhalten), 0002 (portable Rust-Widgets), 0003 (das Programm misst, der Skill urteilt) und 0004 (Host-Kompatibilitätsschicht).

Drei Dokumente in `docs/` stützen die Prüfungen. `TRACEABILITY.md` wird von `pipeline-check --traceability` erzeugt: eine Zeile je Anforderung mit den Testdateien, die ihre Markierung tragen (SQ-8 nennt zum Beispiel `lifecycle.rs`, `models.rs`, `workers.rs`). `TESTES-AUTOMATIZADOS.md`, auf Portugiesisch geschrieben, ist die Aufzeichnung der fehlerfindenden Tests: eine Tabelle von Risiken (Konfiguration, Vertrag, Ansichtsmodelle in `crates/widgets/tests/models.rs`, Persistenz, Quellen, Transport, Tray, Grenzprüfung, Browser-Wiederverwendung) gegen Testdatei und erwartetes Verhalten, danach die ersten Fünf-Minuten-Ressourcenläufe (2,05 % eines Kerns, 115 MiB) und die Beobachtungen zur Host-Kompatibilitätsschicht. Sie hält fest, dass weder ein Abdeckungsprozentsatz noch ein Mutationswert erfasst wurde; der einzige mutationsartige Beleg ist ein Lauf der Grenzprüfung mit eingepflanzten Fehlern. `MAINTENANCE.md` enthält die Methode der Vorlage für Schulden, die monatliche Prüfung und `pipeline-check`.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
