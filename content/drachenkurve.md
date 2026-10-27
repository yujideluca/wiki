---
id: drachenkurve
title: drachenkurve (dragon curve)
aliases: [dragon curve, launcher icon]
kind: program
project: processing-sketches
status: active
location: processing-sketches:drachenkurve
fed_by: []
feeds: [quizapp-app]
sources: [processing-sketches:drachenkurve/drachenkurve.pde]
reviewed: 2026-10-27T01:45Z
---

## What it is
A dragon curve is a [fractal](https://en.wikipedia.org/wiki/Fractal): a shape made by folding a strip of paper in half again and again and unfolding it (the Heighway dragon, see [dragon curve](https://en.wikipedia.org/wiki/Dragon_curve)). `drachenkurve` ("dragon curve" in German) is a [Processing](https://processing.org/) sketch (Processing is a programming environment for drawing and art, based on Java) that draws it, exported as a standalone application.

## Architecture
### Context
person g: Giovanni — draws and runs the sketch | [[giovanni]]
system d: drachenkurve — a sketch that draws the dragon curve
external p: Processing — the tool that runs a sketch
external q: QuizApp — its launcher icon came from this sketch | [[quizapp]]

g -runs-> d
d -runs inside-> p
d -drew the launcher icon of-> q

### Containers
person g: Giovanni | [[giovanni]]
container pd: drachenkurve.pde — the code that folds the strip and draws it
store bd: build/ — the exported standalone application
store ic: Rendered icon — pink to red on dark
external q: QuizApp | [[quizapp-app]]

g -runs-> pd
pd -exports-> bd
pd -renders-> ic
ic -became the launcher icon of-> q

## What it does
It rendered the launcher icon of [[quizapp]] (version 2.1): a dragon curve running from pastel pink to red on a dark background.

## How it does it
The code is in the file `drachenkurve.pde` and there is an exported `build/` folder.

## Where it sits in the pipeline
Its one output went into the icon resources of [[quizapp-app]].

## Who receives its output
[[quizapp-app]] (the icon).
