---
id: retired-workflow-pipeline
lang: de
source_hash: 93de72edfc3a
title: Stillgelegt: claude-workflow-backup-Pipeline
aliases: [altes Protokoll]
---

## What it is
Die alte Art, wie die Claude-Instanzen Gedächtnis teilten und sich abstimmten: das Repo `claude-workflow-backup` mit gui-code-protocol (nummerierte Logbücher, „gesehen“-Zeiger, Besitzerordner), Sync-Skripten, einem Event-Memory-Projekt und täglichen/Rollback-Timern. Stillgelegt.

## What it does
Nichts mehr. Das Repo ist weg; der verwaiste Entwicklungs-Worktree wurde am 22.10.2026 nach `~/archive/claude-workflow-dev-2026-10-22.tar.gz` archiviert. Einziges Erbe: Es füllte einst `~/.claude/skills`.

## How it does it
Ersetzt durch [[workflow-memory]] (eine Schreiboperation und eine reine Funktion statt eines Protokolls), festgehalten dort in ADR-0002/0003. Seine Regeln (Logbücher, sync.sh, sandbox_check.sh) dürfen nie befolgt oder wieder aufgenommen werden.

## Where it sits in the pipeline
Nur Geschichte.

## Who receives its output
Niemand; wird die Geschichte gebraucht, das Tarball lesen.
