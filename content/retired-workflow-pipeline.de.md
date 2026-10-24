---
id: retired-workflow-pipeline
lang: de
source_hash: 72e43d3ac29d
title: Stillgelegt: Pipeline claude-workflow-backup
---

## What it is
Das ist die alte Art, wie die Claude-Instanzen Gedächtnis teilten und ihre Arbeit abstimmten, und sie ist stillgelegt: Sie darf nicht benutzt oder wieder aufgenommen werden. Sie lebte in einem Repository namens `claude-workflow-backup` und bestand aus einem Protokoll namens gui-code-protocol (nummerierte Logbücher, „gesehen“-Markierungen und Ordner pro Eigentümer), Synchronisationsskripten, einem Ereignisgedächtnis-Projekt und täglichen sowie Rollback-Timern.

## What it does
Nichts mehr. Ihr Repository ist weg; die übrig gebliebene Entwicklungskopie wurde am 2026-10-22 als `~/archive/claude-workflow-dev-2026-10-22.tar.gz` archiviert (eine komprimierte Archivdatei). Ihr einziges Erbe ist, dass sie einmal den Ordner `~/.claude/skills` gefüllt hat.

## How it does it
Sie wurde durch [[workflow-memory]] ersetzt, das eine einzige Schreibweise (eine neue Datei anlegen) und eine einzige Funktion zur Berechnung des aktuellen Stands nutzt statt eines Protokolls zwischen Maschinen. Die Entscheidung steht in ADR-0002 und ADR-0003 dort (ein ADR, „Architecture Decision Record“, ist eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält). Ihre Regeln (Logbücher, `sync.sh`, `sandbox_check.sh`) dürfen nie befolgt oder wieder aufgenommen werden.

## Where it sits in the pipeline
Nur noch Geschichte.

## Who receives its output
Niemand; falls ihre Geschichte je gebraucht wird, die Archivdatei lesen.
