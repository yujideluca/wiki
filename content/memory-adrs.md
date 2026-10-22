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
---

## What it is
The recorded decisions of [[workflow-memory]]: 0001 record decisions, 0002 the event log, 0003 roles of Giovanni and the Claude instances.

## What it does
ADR-0002: the memory is an append-only log folded by one pure function, not a protocol between machines. ADR-0003: Giovanni decides and approves; [[claude-code]] builds; [[remote-assistant]] does short tasks with the same rules; [[claude-app]] converses and writes only memory events. The instances never talk directly; workflow-memory is their only shared interface, and new projects start from [[project-template]].

## How it does it
Each principle is enforced by a test or CI job named in the repo's CLAUDE.md.

## Where it sits in the pipeline
Behind every rule about who may do what in this wiki.

## Who receives its output
All Claude instances and Giovanni.
