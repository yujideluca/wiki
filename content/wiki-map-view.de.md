---
id: wiki-map-view
lang: de
source_hash: 3a5694c4adf4
title: Kartenansicht und Infokästen
---

## What it is
Die Karte ist der Startbildschirm des Wikis: Jede Seite ist ein nach ihrer Art gefärbter Punkt, mit Linien für die Beziehung „speist“ (Pfeile: was was speist) und die Beziehung „erwähnt“ (gestrichelt: eine Seite verlinkt auf eine andere), und vier Informationskästen darunter.

## What it does
Fährt man über einen Punkt, leuchten er und seine Nachbarn golden auf, der Rest wird abgedunkelt; die Kästen zeigen What it is, What it does, Fed by und Who receives its output (und behalten den letzten Punkt, wenn die Maus weggeht). Ein Klick auf einen Punkt öffnet seinen Artikel. Man zieht zum Verschieben und nutzt das Mausrad oder eine Zwei-Finger-Geste zum Zoomen; der Projektfilter und die Zeitleiste blenden aus, was nicht dazugehört. Die Hervorhebung ist schnell (jedes Ein- und Ausblenden dauert 0,07 Sekunden). In einem großen Fenster nimmt die Karte die gesamte Höhe, die die vier Kästen nicht brauchen, sodass die Seite beim Überfahren eines Punkts nie scrollt; ein Text, der länger als sein Kasten ist, scrollt darin.

Auf einem Handy (Fenster bis 760 Pixel Breite) füllt die Karte den ganzen Bildschirm, wie in Google Maps: Oben schwebt eine Suchleiste in Pillenform mit dem Menüknopf (Karte, Glossar, Sprache, Abmelden) darin, darunter eine Reihe von Filter-Chips. Auf einem Touchscreen gibt es kein Darüberfahren; stattdessen öffnet das Antippen eines Punkts unten eine Sprechblase mit denselben vier Texten, Knöpfen für die Seiten, die ihn speisen oder seine Ausgabe erhalten (ein Tipp springt zu diesem Punkt), und einem Knopf, der seinen Artikel öffnet; der Schließen-Knopf oder ein anderer Punkt ersetzt sie. Die vier Kästen entfallen dort (`MapView.sheet`).

## How it does it
Die Positionen werden einmal mit einer Kräftesimulation berechnet ([kräftebasiertes Layout](https://en.wikipedia.org/wiki/Force-directed_graph_drawing), mit der Bibliothek elm-visualization): Verbundene Seiten ziehen sich an, alle Seiten stoßen sich ab und halten einen Mindestabstand, Projekte beginnen in Gruppen, und ein Zug zu einer waagerechten Linie lässt die Wolke breit und flach zur Ruhe kommen. `Layout.matchAspect` formt sie dann auf die Form der Kartenfläche um (nur Dehnen, höchstens 3-mal, sodass sich keine zwei Punkte annähern), damit die Punkte die volle Breite nutzen. `MapSize` bestimmt die Höhen: In einem breiten, hohen Fenster erhalten die Kästen die Höhe, die ihr Text braucht (etwa 226 Pixel bei 1920 Pixel Breite), und die Karte den Rest; in einem kürzeren oder schmaleren Fenster behält die Karte ihren Anteil von 58 % und die Kästen passen sich selbst an. Filter sind reine Funktionen (`Filter.visible`). Zoomen und Verschieben kommen vom Modul `Zoom` von elm-visualization; die SVG (Scalable Vector Graphics, ein Format für aus Formen gebaute Zeichnungen) deklariert eine `viewBox` gleich ihrer Größe und beginnt links oben im Fenster (die Suchleiste schwebt darüber), sodass Mausrad, Ziehen und Zwei-Finger-Geste alle um den Zeiger herum zoomen.

## Where it sits in the pipeline
Im [[wiki-frontend]], unter der Adresse `/`.

## Who receives its output
Das [[wiki-frontend]] (und über es Giovanni).
