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
A standing rule from Giovanni (2026-10-22): before any project that involves coding, Claude asks which programming language(s) to use for each part — front end, back end, tools — and never picks it alone.

## What it does
Puts the language choice in Giovanni's hands at the start of the design, not after code exists. It came up when the wiki's front end (Elm) and back end (Elixir) were named only after the design was drafted.

## How it does it
Stored in memory (key `work.ask-language`) and written into the brainstorming skill's "how it gets made" section, where the decision is taken.

## Where it sits in the pipeline
Step 2 of [[new-project]]; applied by [[skill-brainstorming]].

## Who receives its output
[[claude-code]] and [[remote-assistant]].
