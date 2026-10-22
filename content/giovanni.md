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
The owner of every system in this wiki: a pre-hospital emergency physician in Brazil preparing the Goethe B2 exam (Nov 2026) and the FSP to work as a doctor in Germany.

## What it does
Decides what gets built and approves anything outward-facing or destructive. Gives corrections and preferences, which become [[mem]] entries. Uses [[quizapp]] and [[quizweb]] to study German, and reads this [[wiki]] to answer architecture questions.

## How it does it
Talks to [[claude-code]] in the laptop terminal, to the [[remote-assistant]] from the phone, and to the [[claude-app]] on claude.ai. Standing rules (reply in the language of the message, plain language, ask before outward actions) live in [[workflow-memory]].

## Where it sits in the pipeline
At the start and the end of every pipeline: the source of requirements and the final approver (see ADR-0003 in [[workflow-memory]]).

## Who receives its output
The Claude instances receive Giovanni's instructions; the memory system receives Giovanni's corrections.
