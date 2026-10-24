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
reviewed: 2026-10-22T16:33Z
---

## What it is
ADRs ("architecture decision records") are short notes, one per important decision, that keep the reasons for a decision so nobody has to guess later. This page covers the ADRs of [[workflow-memory]]: 0001 record decisions in this way; 0002 the event log; 0003 the roles of Giovanni and the Claude instances.

## What it does
ADR-0002 says that the memory is an append-only log (only new files are added, old ones never change) that one pure function turns into the current state, instead of a protocol between machines. ADR-0003 says that Giovanni decides and approves; [[claude-code]] builds; the [[remote-assistant]] does short tasks with the same rules; the [[claude-app]] converses and writes only memory events. The instances never talk to each other directly: workflow-memory is their only shared interface, and new projects start from [[project-template]].

## How it does it
Each principle is enforced by a test or a continuous-integration job named in the repository's CLAUDE.md, so the decisions are checked and not just written down.

## Where it sits in the pipeline
Behind every rule in this wiki about who may do what.

## Who receives its output
All the Claude instances and Giovanni.
