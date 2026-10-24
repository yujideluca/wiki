---
id: work-ask-language
title: Rule: ask which programming language
aliases: [ask language, language choice]
kind: decision
project: none
status: active
fed_by: []
feeds: []
memory: [#f1e117]
reviewed: 2026-10-22
---

## What it is
This is a standing rule from Giovanni (2026-10-22): before any project that involves coding, Claude must ask which programming language(s) to use for each part (front end = what the user sees, back end = the server behind it, tools) and never pick one alone.

## What it does
It puts the choice of language in Giovanni's hands at the start of the design, not after code exists. The rule came up when the wiki's front end (Elm) and back end (Elixir) were named only after the design had been drafted.

## How it does it
It is stored in the memory under the key `work.ask-language` and written into the "how it gets made" section of the brainstorming skill ([[skill-brainstorming]]), which is the place where the decision is taken.

## Where it sits in the pipeline
Step 2 of [[new-project]]; applied by [[skill-brainstorming]].

## Who receives its output
[[claude-code]] and the [[remote-assistant]].
