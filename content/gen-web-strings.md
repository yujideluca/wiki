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
reviewed: 2026-11-06T23:20Z
---

## What it is
`gen_web_strings.py` generates the interface text of the web twin from the Android app's string resources. A string resource is a file in which an Android app keeps all its on-screen text, one file per language.

## What it does
It reads `res/values*/strings.xml` (English, German, Portuguese, Spanish) plus a few web-only texts, and writes `src/strings.js` of [[quizweb]], so both apps say the same thing in every language.

## How it does it
A [Python](https://www.python.org/) script. Placeholders such as `{0}` and `{1}` mark where a value is inserted into a sentence (Android's `%1$s` becomes `{0}`); since 2026-11-06 Android's `%%`, its way to write a literal percent sign in a formatted text, becomes a single `%`, so a result such as "Passed: 85% right at the first try" of the FSP-Fälle mode (FSP: Fachsprachprüfung, the German medical-language exam; [[fsp-case]]) shows one percent sign; English is the fallback for anything missing. Plurals become two keys, `<name>_one` and `<name>_other`. Texts only the Android app shows are left out, picked by their name: the update popup and update texts (`update_`, `prompt_`), the question-pool texts (`pool_`, `common_ok`, added with ADR-0012, the app's architecture decision record 12) and the backup texts except `backup_title`.

Run it as `python3 tools/gen_web_strings.py [output path]`; without a path it writes `~/dev/QuizWeb/src/strings.js`. A first argument that starts with `-` (for example `--help`) prints the usage and exits with code 1 without writing anything; before 2026-11-06 it was taken as the output path and wrote a file named `--help`.

## Where it sits in the pipeline
From the resources of [[quizapp-app]] to [[quizweb-i18n]].

## Who receives its output
[[quizweb-i18n]].
