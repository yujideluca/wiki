---
id: wiki-map-view
lang: de
source_hash: 97feea1545ea
title: Kartenansicht und Infokästen
aliases: [Systemkarte]
---

## What it is
Die Karte des Startbildschirms: jede Seite als Punkt in der Farbe ihrer Art, Linien für speist (Pfeile) und erwähnt (gestrichelt), darunter die vier Kästen.

## What it does
Über einem Punkt leuchten er und seine Nachbarn golden, der Rest wird blass; die Kästen zeigen Was es ist, Was es tut, Gespeist von und Wer seine Ausgabe erhält (und behalten den letzten Punkt, wenn die Maus geht). Ein Klick öffnet den Artikel. Ziehen verschiebt, Mausrad oder Zwei-Finger-Geste zoomt; Projektfilter und Zeitleiste blenden aus, was nicht dazugehört. Die Hervorhebung ist schnell (jede Überblendung dauert 0,07 s). In einem großen Fenster nimmt die Karte die ganze Höhe, die die vier Kästen nicht brauchen, sodass die Seite beim Überfahren eines Punkts nie scrollt; ein Text, der länger ist als sein Kasten, scrollt im Kasten.

## How it does it
Die Positionen werden einmal mit einer Kräftesimulation berechnet (elm-visualization): verbundene Seiten ziehen sich an, alle stoßen sich ab und halten einen Mindestabstand, Projekte starten als Gruppen, und ein Zug zu einer waagerechten Linie lässt die Wolke breit und flach zur Ruhe kommen. `Layout.matchAspect` formt sie dann auf die Form der Kartenfläche um (nur Strecken, höchstens um das Dreifache, damit sich nie zwei Punkte annähern), sodass die Punkte die ganze Breite nutzen. `MapSize` bestimmt die Höhen: In einem breiten, hohen Fenster bekommen die Kästen die Höhe, die ihr Text braucht (etwa 226 px bei 1920 px Breite), und die Karte den Rest; in einem niedrigeren oder schmaleren Fenster behält die Karte ihre 58 % und die Kästen richten sich nach ihrem Text. Filter sind reine Funktionen (`Filter.visible`). Zoom und Verschieben kommen aus `Zoom` von elm-visualization; das SVG gibt eine viewBox in seiner Größe an und beginnt oben links im Fenster (die Suchleiste schwebt darüber), sodass Mausrad, Ziehen und Zwei-Finger-Geste um den Zeiger herum zoomen.

## Where it sits in the pipeline
In [[wiki-frontend]], unter `/`.

## Who receives its output
[[wiki-frontend]] (und darüber Giovanni).
