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
sources: [workflow-memory:docs/adr, workflow-memory:docs/adr/0008-router-rules-as-modules.md, workflow-memory:tools/migrations/2026-11-07-router-cleanup.sh]
reviewed: 2026-11-07T22:09Z
---

## What it is
ADRs ("architecture decision records") are short notes, one per important decision, that keep the reasons for a decision so nobody has to guess later. This page covers the ADRs of [[workflow-memory]]: 0001 record decisions in this way; 0002 the event log; 0003 the roles of Giovanni and the Claude instances; 0004 a program measures and a skill judges; 0005 trim the startup brief and split memory by tool; 0006 an event can never be later than the moment it is read; 0007 rules are fetched by the kind of task; 0008 rules are modules, and the one standing order is to route each message to its tags.

## What it does
ADR-0002 says that the memory is an append-only log (only new files are added, old ones never change) that one pure function turns into the current state, instead of a protocol between machines. ADR-0003 says that Giovanni decides and approves; [[claude-code]] builds; the [[remote-assistant]] does short tasks with the same rules; the [[claude-app]] converses and writes only memory events. The instances never talk to each other directly: workflow-memory is their only shared interface, and new projects start from [[project-template]]. ADR-0004 says that a deterministic program, [[pipeline-check]], measures and blocks, while the skill [[skill-revisao-manutencao]] reads its report and only proposes; the program lives in its own repository and each project pins a version of it instead of copying it ([[maintenance-pipeline]]). ADR-0005 (2026-10-26) trims the startup brief: the harvester ignores generated prompts, Codex uses its own scope `instance:codex`, and the brief was shorter after `/clear` (ADR-0007 later made the whole brief short). ADR-0006 (2026-10-30) fixes a clock problem: a writer without a trusted clock, such as the [[claude-app]], can stamp an event minutes in the future, and a test once picked that event as the "newest" one and failed. Code and tests now use the path that `mem add` prints instead of the sort order of the log, and when the log is read every event time is capped at the current time (the original stamp is kept as `ts_claimed`), so a skewed writer cannot reorder events. A stamp more than one day ahead is still quarantined. ADR-0007 (2026-11-05) answers a failure of 2026-11-04: an automatic guard program locked Giovanni's sessions, and the rules that would have stopped it existed but never reached the chats, because the start-up brief was about 17 KB (kilobytes) and a chat sees only the first 2 KB. Now every rule carries tags (the kinds of task it matters for); the brief prints only the few `always` rules and an index of the tags, and [[mem-rules]] prints the full rules of a kind of task when Claude starts one. ADR-0008 (2026-11-07) goes further, at Giovanni's request: no rule is printed at start-up any more (the `always` tag is retired), the start-up text and a one-line reminder on every message tell the model to classify each request into tags and load those rules first, and a new tag `outward` covers acts others see or that cannot be undone. The same change cleaned the rules from 95 entries to 75 (empty, expired and contradicting entries removed, overlapping ones merged). The cleanup was done by the shell script `tools/migrations/2026-11-07-router-cleanup.sh`, which takes the code folder and the memory folder as its two arguments and only writes new events through `mem forget`, `mem add --supersedes` and `mem tag`, so the log keeps its history. It ran first on a copy of the memory for the test and then once on the real memory. Before rollout, 15 sample requests ran through 7 Claude and Codex models in copies of the memory: the right rules were loaded before acting in 50% of the runs with the old text and 96% with the new one.

## How it does it
Each principle is enforced by a test or a continuous-integration job named in the repository's CLAUDE.md, so the decisions are checked and not just written down.

## Where it sits in the pipeline
Behind every rule in this wiki about who may do what.

## Who receives its output
All the Claude instances and Giovanni.
