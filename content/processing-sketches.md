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
reviewed: 2026-10-25T02:05Z
---

## What it is
Small generative-art programs (art made by code) written in [Processing](https://processing.org/), a programming environment for drawing based on Java. They are in `~/dev/processing-sketches`. A "sketch" is what Processing calls a program.

## Flow
trigger t1: Giovanni writes a sketch in Processing
step s1: Each sketch is a .pde file in its own folder
step s2: Running it draws the Heighway dragon curve
decide d1: Which version?
step s3: Exported as an app build, ignored by git | [[drachenkurve]]
step s4: Rendered as the QuizApp launcher icon | [[quizapp]]
trigger t2: A push to the repository | [[pipeline-check]]
step s5: The quality gate and the automatic checks run
product p1: The QuizApp launcher icon | [[quizapp]]
product p2: A second dragon-curve sketch, as a program only | [[drachenfraktal]]
product p3: Checked sketches on GitHub

t1 -> s1
s1 -> s2
s2 -> d1
d1 -drachenkurve-> s3
d1 -drachenfraktal-> p2
s3 -> s4
s4 -> p1
t2 -> s5
s5 -> p3

## What it does
It draws the Heighway dragon curve in two versions: [[drachenkurve]] (exported as an app; it rendered the QuizApp launcher icon) and [[drachenfraktal]].

## How it does it
Each sketch is a `.pde` file in its own folder; `drachenkurve` also has an exported build. Since 2026-10-24 the folder is a GitHub repository (`yujideluca/processing-sketches`, public since 2026-10-25) with a quality gate, CI (continuous integration, automatic checks on every push) and the [[pipeline-check]] pre-push check; the build output is ignored by git.

## Where it sits in the pipeline
Off to the side of the other projects; its one link into them is the icon of [[quizapp]].

## Who receives its output
[[quizapp]] (its launcher icon).
