---
id: system-overview
title: The whole system at a glance
aliases: [overview, big picture]
kind: reference
project: none
status: active
fed_by: []
feeds: []
reviewed: 2026-10-27T01:13Z
---

## What it is
This page is the big picture of Giovanni's systems: one chart that follows a request from the moment Giovanni asks until the work, the wiki and the memory are up to date. Every box links to the page that explains it, so the chart is also a table of contents for the wiki.

## Flow
trigger t1: Giovanni asks for something | [[giovanni]]
decide d1: Which assistant does Giovanni use?
step s1: Claude Code, in the laptop terminal | [[claude-code]]
step s2: Codex, in the laptop terminal | [[codex]]
step s3: The always-on assistant, from the phone | [[remote-assistant]]
step s4: The Claude app on claude.ai | [[claude-app]]
step s5: Every chat starts by reading the shared memory brief | [[chat-start]], [[workflow-memory]]
step s6: A skill loads when the request matches its description | [[skills]]
step s7: The work happens in a project: the quiz apps, the wiki, tools | [[quizapp]], [[wiki]]
step s8: A quality gate and the automatic checks must pass | [[maintenance-pipeline]], [[quizapp-quality-gate]]
decide d2: Is it a change to the Android app?
step s9: Beta first, stable only when Giovanni says so | [[quizapp-release]]
step s10: End of task: wiki pages updated in three languages | [[end-of-task]]
step s11: The memory entries that shaped the work are reported | [[mem]]
product p1: A working app on Giovanni's phone | [[phone]]
product p2: A wiki that explains how it all fits | [[wiki]]
product p3: Memory that every future chat reads first | [[events-log]]

t1 -> d1
d1 -Claude Code-> s1
d1 -Codex-> s2
d1 -phone-> s3
d1 -claude.ai-> s4
s1 -> s5
s2 -> s5
s3 -> s5
s4 -> s5
s5 -> s6
s6 -> s7
s7 -> s8
s8 -> d2
d2 -yes-> s9
d2 -no-> s10
s9 -> s10
s9 -> p1
s10 -> s11
s10 -> p2
s11 -> p3

## What it does
It shows, in order, which assistant takes the request ([[claude-code]], [[codex]], the [[remote-assistant]] or the [[claude-app]]), what each of them reads first ([[workflow-memory]]), how a skill joins in ([[skills]]), where the work happens (a project such as [[quizapp]] or the [[wiki]]), what must pass before it counts as done ([[maintenance-pipeline]]), and what is left behind. For the chain of one single concept, open its own page and read its Flow chart.

## How it does it
It is a hand-written Flow section like the one on every concept page ([[wiki-flow-view]]), kept short on purpose: it names the main stations and leaves the details to the linked pages. The map ([[wiki]]) shows the same pages as dots and connections; this page shows them as a path in time.

## Where it sits in the pipeline
It sits above all the other pages as a starting point for a reader who does not yet know which page to open.

## Who receives its output
[[giovanni]], and anyone new who needs to understand how the pieces fit.
