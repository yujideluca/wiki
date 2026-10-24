---
id: gen-web-strings
title: gen_web_strings.py
aliases: [web strings generator]
kind: script
project: quizapp
status: active
location: QuizApp:tools/gen_web_strings.py
fed_by: []
feeds: [quizweb-i18n]
sources: [QuizApp:tools/gen_web_strings.py]
reviewed: 2026-10-22T16:33Z
---

## What it is
`gen_web_strings.py` generates the interface text of the web twin from the Android app's string resources. A string resource is a file in which an Android app keeps all its on-screen text, one file per language.

## What it does
It reads `res/values*/strings.xml` (English, German, Portuguese, Spanish) plus a few web-only texts, and writes `src/strings.js` of [[quizweb]], so both apps say the same thing in every language.

## How it does it
A [Python](https://www.python.org/) script. Placeholders such as `{0}` and `{1}` mark where a value is inserted into a sentence; English is the fallback for anything missing.

## Where it sits in the pipeline
From the resources of [[quizapp-app]] to [[quizweb-i18n]].

## Who receives its output
[[quizweb-i18n]].
