---
id: claude-ai-skills
title: Skills in the Claude app (claude.ai)
aliases: [anthropic-skills, app skills]
kind: data
project: skills
status: active
fed_by: []
feeds: []
reviewed: 2026-10-22
---

## What it is
A skill is a packaged set of instructions that Claude loads when a task of its kind comes up (see [[skills]]). This page is about the skills that exist inside the [[claude-app]]; [[claude-code]] sees them listed with the prefix `anthropic-skills:`. Most are the app's own versions of the local skills on the laptop, but some exist only in the app.

## What it does
The skills that exist only in the app are: docs, docx, pdf, pptx, xlsx and google-workspace (creating and editing documents and Google files), import-memory (bringing in a memory export from another assistant), morning (a morning brief), setup-writing-style (learning how Giovanni writes), skill-creator (making and testing skills), and deutsch-gespraech-memory (the memory of the German conversation project, [[deutsch-gespraech]]). A skill named gui-code-protocol is still listed there but belongs to the retired pipeline ([[retired-workflow-pipeline]]) and must be ignored.

## How it does it
They are managed inside the Claude app, and each side keeps its own version: the laptop copies are edited only by Claude Code, and the app keeps its own. Because Claude Code cannot see these skills change, this page carries a review date instead of a list of source files, and the wiki shows it as "may be stale" 30 days after that date.

## Where it sits in the pipeline
Off the laptop, inside the Claude app.

## Who receives its output
The [[claude-app]].
