---
id: content-manifest
title: content_manifest.py
aliases: [pool manifest]
kind: script
project: quizapp
status: active
location: QuizApp:tools/content_manifest.py
fed_by: [build-vocab]
feeds: [question-pack, quizapp-quality-gate]
sources: [QuizApp:tools/content_manifest.py]
reviewed: 2026-10-22T17:29Z
---

## What it is
`content_manifest.py` is the script that keeps the manifest of the question pool, `app/src/main/assets/content.json`, in step with the pool files. A manifest is a list that describes the files of a package and how to verify them.

## What it does
It writes the SHA-256 of every pool file (SHA-256, Secure Hash Algorithm 256, produces a short fingerprint of a file's content; if one byte changes, the fingerprint changes completely, see [SHA-2](https://en.wikipedia.org/wiki/SHA-2)) and raises `contentVersion` by one only if some file actually changed. The option `--check` exits with code 1 when the manifest does not match the files.

## How it does it
[Python](https://www.python.org/) using only its standard library. Its `SCHEMA = 1` must equal `CONTENT_SCHEMA` in the [[question-pack]] (both are raised together when the file format changes). It is run by [[build-vocab]]; the `--check` mode runs in the [[quizapp-quality-gate]].

## Where it sits in the pipeline
Right after [[build-vocab]] in the content pipeline.

## Who receives its output
The [[question-pack]] (the manifest built into the app) and the [[quizapp-quality-gate]].
