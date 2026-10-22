---
id: retired-workflow-pipeline
title: Retired: claude-workflow-backup pipeline
aliases: [claude-workflow-backup, gui-code-protocol, old protocol]
kind: decision
project: laptop-setup
status: retired
fed_by: []
feeds: []
until: 2026-10-22
reviewed: 2026-10-22
---

## What it is
The old way the Claude instances shared memory and coordinated: the repo `claude-workflow-backup` with gui-code-protocol (numbered logbooks, "seen" cursors, owner folders), sync scripts, an event-memory project and daily/rollback timers. Retired.

## What it does
Nothing any more. Its repo is gone; the orphaned dev worktree was archived on 2026-10-22 to `~/archive/claude-workflow-dev-2026-10-22.tar.gz`. Its only legacy is that it once filled `~/.claude/skills`.

## How it does it
Replaced by [[workflow-memory]] (one write primitive and one pure function instead of a protocol), as recorded in ADR-0002/0003 there. Its rules (logbooks, sync.sh, sandbox_check.sh) must never be followed or resumed.

## Where it sits in the pipeline
History only.

## Who receives its output
No one; if its history is needed, read the tarball.
