---
id: giovanni
title: Giovanni
aliases: [owner, yuji]
kind: actor
project: none
status: active
fed_by: [memory-views, wiki-frontend]
feeds: [claude-app, claude-code, mem, remote-assistant]
reviewed: 2026-10-22
---

## What it is
Giovanni is the owner of every system described in this wiki, and the person all of it is built for. Giovanni is a pre-hospital emergency physician in Brazil (a doctor who treats emergencies outside the hospital, for example in ambulances), who is preparing the Goethe B2 German exam (November 2026) and then the FSP (Fachsprachprüfung, the German medical-language exam) in order to work as a doctor in Germany.

## What it does
Giovanni decides what gets built and approves anything that reaches the outside world or cannot be undone. Corrections and preferences that Giovanni states become entries in the shared memory ([[mem]]). Giovanni studies German with [[quizapp]] and [[quizweb]], and reads this [[wiki]] to understand how the pieces fit together.

## How it does it
Giovanni talks to [[claude-code]] in the laptop terminal, to the [[remote-assistant]] from the phone, and to the [[claude-app]] on claude.ai. Standing rules (answer in the language of the message, explain in plain language, ask before outward-facing actions) live in [[workflow-memory]], not in this wiki.

## Where it sits in the pipeline
At the start and the end of every chain of work: Giovanni is the source of requirements (what must be built) and the final approver. The decision that gives this role its shape is ADR-0003 in [[workflow-memory]] (an ADR, "architecture decision record", is a short note that records one important decision and its reasons).

## Who receives its output
The Claude instances receive Giovanni's instructions; the memory system receives Giovanni's corrections.
