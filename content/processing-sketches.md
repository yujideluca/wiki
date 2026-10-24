---
id: processing-sketches
title: Processing sketches
aliases: [drachenkurve project]
kind: project
project: none
status: active
location: processing-sketches:
fed_by: []
feeds: []
sources: [processing-sketches:drachenkurve, processing-sketches:drachenfraktal]
reviewed: 2026-10-22T16:33Z
---

## What it is
Small generative-art programs (art made by code) written in [Processing](https://processing.org/), a programming environment for drawing based on Java. They are in `~/dev/processing-sketches`. A "sketch" is what Processing calls a program.

## What it does
It draws the Heighway dragon curve in two versions: [[drachenkurve]] (exported as an app; it rendered the QuizApp launcher icon) and [[drachenfraktal]].

## How it does it
Each sketch is a `.pde` file in its own folder; `drachenkurve` also has an exported build. Since 2026-10-24 the folder is a private GitHub repository (`yujideluca/processing-sketches`) with a quality gate, CI (continuous integration, automatic checks on every push) and the [[pipeline-check]] pre-push check; the build output is ignored by git.

## Where it sits in the pipeline
Off to the side of the other projects; its one link into them is the icon of [[quizapp]].

## Who receives its output
[[quizapp]] (its launcher icon).
