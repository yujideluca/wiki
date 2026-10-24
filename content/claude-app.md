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
The Claude app is Claude as Giovanni uses it on claude.ai, on the phone and in the browser, including "projects" (saved chat spaces with their own instructions). It differs from [[claude-code]] in one important way: it cannot reach the laptop, so it cannot run programs or read project files there.

## What it does
It is used for conversation, writing and study: German practice ([[skill-alemao-goethe-fsp]]), clinical questions ([[skill-consulta-clinica]]) and applications to Germany ([[skill-candidatura-alemanha]]).

## How it does it
A short text pasted once into the claude.ai settings ([[claude-ai-settings-pointer]]) makes each chat read the file `views/BRIEF.md` of [[workflow-memory]] through the GitHub connector (an add-on that lets the app read and write files in GitHub). When Giovanni corrects it, it records the correction by creating one new event file ([[mem-github-connector]]). Its skills are the claude.ai copies listed in [[claude-ai-skills]].

## Where it sits in the pipeline
Outside the laptop. Its only shared interface with the other Claude instances is [[workflow-memory]] (decided in ADR-0003; an ADR, "architecture decision record", is a short note that records one decision and its reasons).

## Who receives its output
The memory log [[events-log]], through the GitHub connector.
