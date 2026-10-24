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
---

## What it is
Small generative-art programs written in Processing (a Java-based language for drawing) in `~/dev/processing-sketches`.

## What it does
Draws the Heighway dragon curve in two versions: [[drachenkurve]] (exported as an app, rendered the QuizApp launcher icon) and [[drachenfraktal]].

## How it does it
Each sketch is a `.pde` file in its own folder; `drachenkurve` has an exported build. Since 2026-10-24 the folder is a private GitHub repository (`yujideluca/processing-sketches`) with a gate, CI and the [[pipeline-check]] pre-push check; build output is ignored.

## Where it sits in the pipeline
Off to the side of the other projects; its one link into them is the icon of [[quizapp]].

## Who receives its output
[[quizapp]] (its launcher icon).
