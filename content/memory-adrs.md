---
id: memory-adrs
title: workflow-memory ADRs
aliases: [ADR-0003, roles and boundaries]
kind: decision
project: workflow-memory
status: active
location: workflow-memory:docs/adr
fed_by: []
feeds: []
sources: [workflow-memory:docs/adr]
reviewed: 2026-10-30T20:27Z
---

## What it is
ADRs ("architecture decision records") are short notes, one per important decision, that keep the reasons for a decision so nobody has to guess later. This page covers the ADRs of [[workflow-memory]]: 0001 record decisions in this way; 0002 the event log; 0003 the roles of Giovanni and the Claude instances; 0004 a program measures and a skill judges; 0006 an event can never be later than the moment it is read.

## What it does
ADR-0002 says that the memory is an append-only log (only new files are added, old ones never change) that one pure function turns into the current state, instead of a protocol between machines. ADR-0003 says that Giovanni decides and approves; [[claude-code]] builds; the [[remote-assistant]] does short tasks with the same rules; the [[claude-app]] converses and writes only memory events. The instances never talk to each other directly: workflow-memory is their only shared interface, and new projects start from [[project-template]]. ADR-0004 says that a deterministic program, [[pipeline-check]], measures and blocks, while the skill [[skill-revisao-manutencao]] reads its report and only proposes; the program lives in its own repository and each project pins a version of it instead of copying it ([[maintenance-pipeline]]). ADR-0005 (2026-10-26) trims the startup brief: the harvester ignores generated prompts, Codex uses its own scope `instance:codex`, and the brief is shorter after `/clear`. ADR-0006 (2026-10-30) fixes a clock problem: a writer without a trusted clock, such as the [[claude-app]], can stamp an event minutes in the future, and a test once picked that event as the "newest" one and failed. Code and tests now use the path that `mem add` prints instead of the sort order of the log, and when the log is read every event time is capped at the current time (the original stamp is kept as `ts_claimed`), so a skewed writer cannot reorder events. A stamp more than one day ahead is still quarantined.

## How it does it
Each principle is enforced by a test or a continuous-integration job named in the repository's CLAUDE.md, so the decisions are checked and not just written down.

## Where it sits in the pipeline
Behind every rule in this wiki about who may do what.

## Who receives its output
All the Claude instances and Giovanni.
