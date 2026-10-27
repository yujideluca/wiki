---
id: drachenfraktal
title: drachenfraktal (dragon fractal)
aliases: [dragon fractal]
kind: program
project: processing-sketches
status: active
location: processing-sketches:drachenfraktal
fed_by: []
feeds: []
sources: [processing-sketches:drachenfraktal/drachenfraktal.pde]
reviewed: 2026-10-27T01:45Z
---

## What it is
`drachenfraktal` ("dragon fractal" in German) is a second [Processing](https://processing.org/) sketch (Processing is a programming environment for drawing and art, based on Java) of the dragon fractal, with a rendered picture `drachenfraktal.png`.

## Architecture
### Context
person g: Giovanni — draws and runs the sketch | [[giovanni]]
system d: drachenfraktal — a sketch that draws the dragon fractal
external p: Processing — the tool that runs a sketch
external k: drachenkurve — the other take on the same shape | [[drachenkurve]]

g -runs-> d
d -runs inside-> p
d -is a take on the same shape as-> k

### Containers
person g: Giovanni | [[giovanni]]
container pd: drachenfraktal.pde — the code that draws the Heighway dragon
store pn: drachenfraktal.png — the rendered picture

g -runs-> pd
pd -renders-> pn

## What it does
It draws the Heighway dragon as a [fractal](https://en.wikipedia.org/wiki/Fractal) image; it is an earlier or alternative take on [[drachenkurve]].

## How it does it
The code is in the file `drachenfraktal.pde`.

## Where it sits in the pipeline
Within [[processing-sketches]]; nothing else uses it.

## Who receives its output
No other part of the system.
