---
id: drachenfraktal
lang: de
source_hash: 39fc739e41ef
title: drachenfraktal (Drachenfraktal)
---

## What it is
`drachenfraktal` ist ein zweiter [Processing](https://processing.org/)-Sketch (Processing ist eine auf Java basierende Programmierumgebung für Zeichnen und Kunst) des Drachenfraktals, mit einem gerenderten Bild `drachenfraktal.png`.

## Architecture
### Kontext
person g: Giovanni — zeichnet und startet die Skizze | [[giovanni]]
system d: drachenfraktal — eine Skizze, die das Drachenfraktal zeichnet
external p: Processing — das Werkzeug, das eine Skizze startet
external k: drachenkurve — die andere Fassung derselben Form | [[drachenkurve]]

g -startet-> d
d -läuft in-> p
d -ist eine Fassung derselben Form wie-> k

### Container
person g: Giovanni | [[giovanni]]
container pd: drachenfraktal.pde — der Code, der den Heighway-Drachen zeichnet
store pn: drachenfraktal.png — das gerenderte Bild

g -startet-> pd
pd -rendert-> pn

## What it does
Er zeichnet den Heighway-Drachen als [Fraktal](https://en.wikipedia.org/wiki/Fractal)-Bild; er ist eine frühere oder alternative Version von [[drachenkurve]].

## How it does it
Der Code liegt in der Datei `drachenfraktal.pde`.

## Where it sits in the pipeline
Innerhalb von [[processing-sketches]]; sonst nutzt ihn nichts.

## Who receives its output
Kein anderer Teil des Systems.
