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
---

## What it is
A grammar check of the Fehler-finden sentences with LanguageTool (a grammar checker that runs locally on Java).

## What it does
1. Every corrected sentence must be clean at the PICKY level, so no sentence teaches German that LanguageTool rejects. 2. No warning may fall on a chunk other than the marked one, so the player never meets a second, unintended error.

## How it does it
Python calling the LanguageTool command-line jar (Java 17+). LanguageTool recognises only about a quarter of the planted errors, so whether the marked chunk is really wrong is reviewed by hand.

## Where it sits in the pipeline
After [[build-vocab]], whenever error sentences change.

## Who receives its output
Claude, as pass/fail before the content is committed.
