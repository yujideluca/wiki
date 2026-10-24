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
reviewed: 2026-10-22T16:33Z
---

## What it is
A dragon curve is a [fractal](https://en.wikipedia.org/wiki/Fractal): a shape made by folding a strip of paper in half again and again and unfolding it (the Heighway dragon, see [dragon curve](https://en.wikipedia.org/wiki/Dragon_curve)). `drachenkurve` ("dragon curve" in German) is a [Processing](https://processing.org/) sketch (Processing is a programming environment for drawing and art, based on Java) that draws it, exported as a standalone application.

## What it does
It rendered the launcher icon of [[quizapp]] (version 2.1): a dragon curve running from pastel pink to red on a dark background.

## How it does it
The code is in the file `drachenkurve.pde` and there is an exported `build/` folder.

## Where it sits in the pipeline
Its one output went into the icon resources of [[quizapp-app]].

## Who receives its output
[[quizapp-app]] (the icon).
