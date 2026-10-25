---
id: check-errors-languagetool
title: check_errors_languagetool.py
aliases: [LanguageTool check]
kind: script
project: quizapp
status: active
location: QuizApp:tools/check_errors_languagetool.py
fed_by: [build-vocab]
feeds: []
sources: [QuizApp:tools/check_errors_languagetool.py]
reviewed: 2026-10-25T08:08Z
---

## What it is
`check_errors_languagetool.py` is a grammar check of the "find the error" sentences, done with [LanguageTool](https://languagetool.org/), a grammar checker that runs locally on Java.

## What it does
It enforces two rules. (1) Every corrected sentence must be clean at the PICKY level (LanguageTool's strictest setting), so no sentence teaches German that LanguageTool rejects. (2) No warning may fall on a chunk other than the marked one, so the player never meets a second, unintended error.

## How it does it
A [Python](https://www.python.org/) script that calls the LanguageTool command-line program (a Java archive, Java 17 or newer; installed on the laptop in `~/.local/opt/languagetool-dl`, LanguageTool 6.6). LanguageTool recognises only about a quarter of the planted errors, so whether the marked chunk is really wrong is still reviewed by hand.

## Where it sits in the pipeline
After [[build-vocab]], whenever error sentences change.

## Who receives its output
Claude, as a pass or fail before the content is committed.
