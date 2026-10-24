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
This is the old way in which the Claude instances shared memory and coordinated their work, and it is retired: it must not be used or resumed. It lived in a repository called `claude-workflow-backup` and consisted of a protocol called gui-code-protocol (numbered logbooks, "seen" markers and folders per owner), synchronisation scripts, an event-memory project and daily and rollback timers.

## What it does
Nothing any more. Its repository is gone; the leftover development copy was archived on 2026-10-22 as `~/archive/claude-workflow-dev-2026-10-22.tar.gz` (a compressed archive file). Its only legacy is that it once filled the folder `~/.claude/skills`.

## How it does it
It was replaced by [[workflow-memory]], which uses one way of writing (adding a new file) and one function that computes the current state, instead of a protocol between machines. The decision is recorded in ADR-0002 and ADR-0003 there (an ADR, "architecture decision record", is a short note recording one decision and its reasons). Its rules (logbooks, `sync.sh`, `sandbox_check.sh`) must never be followed or resumed.

## Where it sits in the pipeline
History only.

## Who receives its output
No one; if its history is ever needed, read the archive file.
