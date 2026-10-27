---
id: giovanni
title: Giovanni
aliases: [owner, yuji]
kind: actor
project: none
status: active
fed_by: [memory-views, wiki-frontend]
feeds: [claude-app, claude-code, codex, mem, remote-assistant]
reviewed: 2026-10-22
---

## What it is
Giovanni is the owner of every system described in this wiki, and the person all of it is built for. Giovanni is a pre-hospital emergency physician in Brazil (a doctor who treats emergencies outside the hospital, for example in ambulances), who is preparing the Goethe B2 German exam (November 2026) and then the FSP (Fachsprachprüfung, the German medical-language exam) in order to work as a doctor in Germany.

## Flow
trigger t1: Giovanni wants something built, answered or studied
decide d1: Where is Giovanni?
step s1: Types in the laptop terminal | [[claude-code]]
step s2: Messages the always-on assistant from the phone | [[remote-assistant]]
step s3: Chats on claude.ai (phone or browser) | [[claude-app]]
step s4: Claude does the work; Giovanni approves anything outward-facing or irreversible
step s5: A correction or lasting preference becomes a memory entry | [[mem]]
product p1: Finished work and answers
product p2: Rules every future chat reads first | [[workflow-memory]]
trigger t2: Giovanni wants to practise German
step s6: Studies with the quiz apps | [[quizapp]], [[quizweb]]
product p3: Learning progress kept by the apps
trigger t3: Giovanni wonders how the pieces fit together
step s7: Reads this wiki | [[wiki]]
product p4: An answer to the architecture question

t1 -> d1
d1 -laptop-> s1
d1 -phone-> s2
d1 -claude.ai-> s3
s1 -> s4
s2 -> s4
s3 -> s4
s4 -> p1
s4 -> s5
s5 -> p2
t2 -> s6
s6 -> p3
t3 -> s7
s7 -> p4

## What it does
Giovanni decides what gets built and approves anything that reaches the outside world or cannot be undone. Corrections and preferences that Giovanni states become entries in the shared memory ([[mem]]). Giovanni studies German with [[quizapp]] and [[quizweb]], and reads this [[wiki]] to understand how the pieces fit together.

## How it does it
Giovanni talks to [[claude-code]] in the laptop terminal, to the [[remote-assistant]] from the phone, and to the [[claude-app]] on claude.ai. Standing rules (answer in the language of the message, explain in plain language, ask before outward-facing actions) live in [[workflow-memory]], not in this wiki.

## Where it sits in the pipeline
At the start and the end of every chain of work: Giovanni is the source of requirements (what must be built) and the final approver. The decision that gives this role its shape is ADR-0003 in [[workflow-memory]] (an ADR, "architecture decision record", is a short note that records one important decision and its reasons).

## Who receives its output
The Claude instances receive Giovanni's instructions; the memory system receives Giovanni's corrections.
