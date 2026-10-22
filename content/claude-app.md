---
id: claude-app
title: Claude app (claude.ai)
aliases: [claude.ai, Claude in the app]
kind: actor
project: none
status: active
fed_by: [giovanni, memory-views]
feeds: [mem-github-connector]
reviewed: 2026-10-22
---

## What it is
Claude in the app and on claude.ai (phone, browser, projects). It cannot reach the laptop.

## What it does
Conversation, writing and study: German practice ([[skill-alemao-goethe-fsp]]), clinical questions ([[skill-consulta-clinica]]), applications to Germany ([[skill-candidatura-alemanha]]).

## How it does it
A pointer pasted into claude.ai Settings ([[claude-ai-settings-pointer]]) makes each chat read `views/BRIEF.md` of [[workflow-memory]] through the GitHub connector; it records corrections by creating one event file ([[mem-github-connector]]). Its skills are the claude.ai copies listed in [[claude-ai-skills]].

## Where it sits in the pipeline
Outside the laptop. Its only shared interface with the other instances is [[workflow-memory]] (ADR-0003).

## Who receives its output
[[events-log]], through the GitHub connector.
