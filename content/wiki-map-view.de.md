---
id: wiki-map-view
lang: de
source_hash: 2e1f5eee1345
title: Kartenansicht und Infokästen
---

## What it is
Die Karte ist der Startbildschirm des Wikis: Jede Seite ist ein nach ihrer Art gefärbter Punkt, mit Linien für die Beziehung „speist“ (Pfeile: was was speist) und die Beziehung „erwähnt“ (gestrichelt: eine Seite verlinkt auf eine andere), und vier Informationskästen darunter.

## What it does
Fährt man über einen Punkt, leuchten er und seine Nachbarn golden auf, der Rest wird abgedunkelt; die Kästen zeigen What it is, What it does, Fed by und Who receives its output (und behalten den letzten Punkt, wenn die Maus weggeht). Ein Klick auf einen Punkt öffnet seinen Artikel. Man zieht zum Verschieben und nutzt das Mausrad oder eine Zwei-Finger-Geste zum Zoomen; der Projektfilter und die Zeitleiste blenden aus, was nicht dazugehört. Die Hervorhebung ist schnell (jedes Ein- und Ausblenden dauert 0,07 Sekunden). In einem großen Fenster nimmt die Karte die gesamte Höhe, die die vier Kästen nicht brauchen, sodass die Seite beim Überfahren eines Punkts nie scrollt; ein Text, der länger als sein Kasten ist, scrollt darin.

Die Karte lebt. Jeder Punkt ruht dort, wo ihn das Layout hinsetzt, kann aber von diesem Platz weggeschoben werden und federt dann mit etwas Nachschwingen zurück, wie ein Gewicht an einem Gummiband: Drückt man auf einen Punkt und bewegt die Maus, wird er gezogen, seine Nachbarn werden hinter ihm gedehnt und ziehen sich beim Loslassen wieder zusammen (ein Klick ohne Bewegung öffnet weiter die Seite, ein Ziehen nie). Fährt man über einen Punkt, werden seine Nachbarn um ein Fünftel des Wegs zu ihm hingezogen. Beim ersten Laden springen die Punkte aus der Mitte auf, und nach einer Größenänderung des Fensters gleiten sie von ihrer alten Stelle an die neue, statt zu springen.

Auf einem Desktop wird die Karte außerdem durch eine Linse (ein Fischauge) gesehen: Punkte in der Mitte des Bereichs sind größer, weiter auseinander und beschriftet, Punkte am Rand kleiner, enger beieinander und ohne Beschriftung, und die gestrichelten „erwähnt“-Linien entfallen dort. Wegen der Linse verlässt kein Punkt das Fenster, und beim Verschieben oder Zoomen wandern die Punkte durch die Linse. Auf einem Handy ist die Linse aus.

Auf einem Handy (Fenster bis 760 Pixel Breite) füllt die Karte den ganzen Bildschirm, wie in Google Maps: Oben schwebt eine Suchleiste in Pillenform mit dem Menüknopf (Karte, Glossar, Sprache, Abmelden) darin, darunter eine Reihe von Filter-Chips. Auf einem Touchscreen gibt es kein Darüberfahren; stattdessen öffnet das Antippen eines Punkts unten eine Sprechblase mit denselben vier Texten, Knöpfen für die Seiten, die ihn speisen oder seine Ausgabe erhalten (ein Tipp springt zu diesem Punkt), und einem Knopf, der seinen Artikel öffnet; der Schließen-Knopf oder ein anderer Punkt ersetzt sie. Ein Handy zeichnet langsam, deshalb hat die Karte dort kein Ein- und Ausblenden und keine gestrichelten Linien und bewegt sich beim Verschieben oder Zoomen als ein Block (auf dem Handy gemessen: 17 bis 19 Millisekunden pro Bild, etwa 60 Bilder pro Sekunde); die Seite sagt dem Browser außerdem, dass er keine eigene Übersetzung anbieten soll, und die Wahl eines Suchergebnisses schließt die Tastatur, damit sie die Sprechblase nicht verdeckt. Die vier Kästen entfallen dort (`MapView.sheet`).

## How it does it
Die Positionen werden einmal mit einer Kräftesimulation berechnet ([kräftebasiertes Layout](https://en.wikipedia.org/wiki/Force-directed_graph_drawing), mit der Bibliothek elm-visualization): Verbundene Seiten ziehen sich an, alle Seiten stoßen sich ab und halten einen Mindestabstand, Projekte beginnen in Gruppen, und ein Zug zu einer waagerechten Linie lässt die Wolke breit und flach zur Ruhe kommen. `Layout.matchAspect` formt sie dann auf die Form der Kartenfläche um (nur Dehnen, höchstens 3-mal, sodass sich keine zwei Punkte annähern), damit die Punkte die volle Breite nutzen. `MapSize` bestimmt die Höhen: In einem breiten, hohen Fenster erhalten die Kästen die Höhe, die ihr Text braucht (etwa 226 Pixel bei 1920 Pixel Breite), und die Karte den Rest; in einem kürzeren oder schmaleren Fenster behält die Karte ihren Anteil von 58 % und die Kästen passen sich selbst an. Filter sind reine Funktionen (`Filter.visible`). Zoomen und Verschieben kommen vom Modul `Zoom` von elm-visualization; die SVG (Scalable Vector Graphics, ein Format für aus Formen gebaute Zeichnungen) deklariert eine `viewBox` gleich ihrer Größe und beginnt links oben im Fenster (die Suchleiste schwebt darüber), sodass Mausrad, Ziehen und Zwei-Finger-Geste alle um den Zeiger herum zoomen.

## Where it sits in the pipeline
Im [[wiki-frontend]], unter der Adresse `/`.

## Who receives its output
Das [[wiki-frontend]] (und über es Giovanni).
