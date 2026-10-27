---
id: drachenkurve
lang: de
source_hash: b2557e7d3f94
title: drachenkurve (Drachenkurve)
---

## What it is
Eine Drachenkurve ist ein [Fraktal](https://en.wikipedia.org/wiki/Fractal): eine Form, die entsteht, wenn man einen Papierstreifen immer wieder in der Mitte faltet und entfaltet (der Heighway-Drache, siehe [Drachenkurve](https://en.wikipedia.org/wiki/Dragon_curve)). `drachenkurve` ist ein [Processing](https://processing.org/)-Sketch (Processing ist eine auf Java basierende Programmierumgebung für Zeichnen und Kunst), der sie zeichnet, exportiert als eigenständige Anwendung.

## Architecture
### Kontext
person g: Giovanni — zeichnet und startet die Skizze | [[giovanni]]
system d: drachenkurve — eine Skizze, die die Drachenkurve zeichnet
external p: Processing — das Werkzeug, das eine Skizze startet
external q: QuizApp — sein Startsymbol stammt aus dieser Skizze | [[quizapp]]

g -startet-> d
d -läuft in-> p
d -zeichnete das Startsymbol von-> q

### Container
person g: Giovanni | [[giovanni]]
container pd: drachenkurve.pde — der Code, der den Streifen faltet und zeichnet
store bd: build/ — die exportierte eigenständige Anwendung
store ic: Gerendertes Symbol — rosa bis rot auf dunkel
external q: QuizApp | [[quizapp-app]]

g -startet-> pd
pd -exportiert-> bd
pd -rendert-> ic
ic -wurde zum Startsymbol von-> q

## What it does
Sie hat das Startsymbol von [[quizapp]] (Version 2.1) gerendert: eine Drachenkurve von Pastellrosa bis Rot auf dunklem Hintergrund.

## How it does it
Der Code liegt in der Datei `drachenkurve.pde`, dazu gibt es einen exportierten Ordner `build/`.

## Where it sits in the pipeline
Ihre einzige Ausgabe floss in die Symbol-Ressourcen von [[quizapp-app]].

## Who receives its output
[[quizapp-app]] (das Symbol).
