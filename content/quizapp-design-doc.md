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
reviewed: 2026-11-07T00:37Z
---

## What it is
`DESIGN.md` is the living design document of [[quizapp]]: what the app is, its design goals, its architecture (C4 diagrams, a way of drawing software at several zoom levels, written in Mermaid), spaced repetition, content, persistence, card management (suspending and removing cards), the user interface (UI), languages, debuggability, testing, the decision log and the known limitations. "Living" means it is kept up to date with the code.

## What it does
It explains how the app is built and why. Its last update is 2026-11-06: the mode table gained FSP-Fälle (58 simulated FSP exam cases; FSP is the Fachsprachprüfung, the German medical-language exam; [[fsp-case]]), the pack section says the pack has eight files and schema 2, and the decision log has a row for it.Since commit 3cabb51 the sentence above the mode table gives the pool sizes "as built into version 2.8.0 (pool 8)". Each row of the decision log has a Type taken from the maintenance categories of the standard ISO/IEC/IEEE 14764: corrective (fixing a fault), adaptive (adjusting to a changing environment), perfective (improving), preventive (preparing against future problems) or initial.

## How it does it
It is updated in the same commit as any change to the architecture, the modes, the scheduler or grader, the persistence or the UI flow; structural decisions also get an ADR (architecture decision record, [[quizapp-adrs]]). It is reviewed every month ([[monthly-architecture-review]]).

## Where it sits in the pipeline
Next to the code it describes. This wiki's QuizApp pages are drawn largely from it.

## Who receives its output
Claude (before changing the app) and Giovanni.
