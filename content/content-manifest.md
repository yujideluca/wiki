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
---

## What it is
The script that keeps the question pool's manifest, `app/src/main/assets/content.json`, in step with the pool files.

## What it does
Writes the SHA-256 of every pool file and raises `contentVersion` by one only if a file changed. `--check` exits 1 when the manifest does not match the files.

## How it does it
Python standard library; `SCHEMA = 1` must equal `CONTENT_SCHEMA` in [[question-pack]] (raise both together when the file format changes). Run by [[build-vocab]]; `--check` runs in [[quizapp-quality-gate]].

## Where it sits in the pipeline
Right after [[build-vocab]] in the content pipeline.

## Who receives its output
[[question-pack]] (the built-in manifest) and [[quizapp-quality-gate]].
