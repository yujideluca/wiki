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
---

## What it is
Generates the web twin's interface text from the Android app's string resources.

## What it does
Reads `res/values*/strings.xml` (English, German, Portuguese, Spanish) plus a few web-only texts and writes `src/strings.js` of [[quizweb]], so both apps say the same thing in every language.

## How it does it
Python; `{0}`, `{1}`… placeholders; English is the fallback for anything missing.

## Where it sits in the pipeline
From [[quizapp-app]] resources to [[quizweb-i18n]].

## Who receives its output
[[quizweb-i18n]].
