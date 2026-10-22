---
id: quizapp-design-doc
title: QuizApp DESIGN.md
aliases: [design document, decision log]
kind: data
project: quizapp
status: active
location: QuizApp:DESIGN.md
fed_by: []
feeds: []
sources: [QuizApp:DESIGN.md]
---

## What it is
The living design document of [[quizapp]]: what the app is, its architecture (C4 diagrams in Mermaid), spaced repetition, content, persistence, UI, languages, debuggability, testing, and the decision log.

## What it does
Explains how the app is built and why. Each decision-log row has a Type from ISO/IEC/IEEE 14764 (corrective, adaptive, perfective, preventive, initial).

## How it does it
Updated in the same commit as any change to architecture, modes, scheduler/grader, persistence or UI flow; structural decisions also get an ADR ([[quizapp-adrs]]). Reviewed monthly ([[monthly-architecture-review]]).

## Where it sits in the pipeline
Next to the code it describes; this wiki's QuizApp pages are drawn largely from it.

## Who receives its output
Claude (before changing the app) and Giovanni.
