---
id: quizapp-adrs
title: QuizApp ADRs
aliases: [architecture decision records]
kind: decision
project: quizapp
status: active
location: QuizApp:docs/adr
fed_by: []
feeds: []
sources: [QuizApp:docs/adr]
---

## What it is
An ADR (architecture decision record) is a short note about one important decision: the context, the decision, the alternatives that were considered and the consequences. These are the ADRs of [[quizapp]], in the folder `docs/adr/`, one file per structural decision.

## What it does
They record: 0001 record decisions · 0002 Kotlin + Compose · 0003 pure deterministic scheduler · 0004 update feed · 0005 release channels · 0006 web twin · 0007 spacing rules · 0008 requirements-first quality assurance · 0009 pure core module · 0010 progress backup · 0011 promote after updated tests · 0012 downloadable question pool ([[question-pack]]).

## How it does it
They use the MADR format (Markdown Architectural Decision Records, in a trimmed form), starting from `docs/adr/0000-template.md`. A structural change gets its ADR in the same commit as the change, so the reason is never separated from the code.

## Where it sits in the pipeline
Beside the [[quizapp-design-doc]]; the pattern comes from [[project-template]].

## Who receives its output
Claude and Giovanni, whenever a decision is questioned.
