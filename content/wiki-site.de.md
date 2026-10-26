---
id: wiki-site
lang: de
source_hash: 8ce12632852a
title: site/ (gebautes Wiki)
---

## What it is
Der Ordner `site/` ist das gebaute Wiki, fertig zur Anzeige: `index.html`, `assets/` (die kompilierte Elm-App `app.js`, `boot.js` und `style.css`) und `data/` (die Graph- und Seitendateien in [JSON](https://en.wikipedia.org/wiki/JSON), JavaScript Object Notation, einem Klartext-Datenformat).

## What it does
Er ist alles, was der Browser nach der Anmeldung braucht. Seine `index.html` sagt dem Browser, dass er keine eigene Übersetzung der Seite anbieten soll. Nichts davon wird je vor der Anmeldung gesendet.

## How it does it
Er wird von [[wiki-build]] erzeugt und nicht in Git committet (er ist abgeleitet und lässt sich jederzeit neu erzeugen). Der [[wiki-router]] liefert ihn von der Festplatte aus. Welcher Ordner geliefert wird, steht in `WIKI_SITE_DIR`. Seit dem 26.10.2026 liest der Dienst einen Release-Ordner, `~/.local/share/wiki/releases/<Commit>`, den eine systemd-Drop-in-Datei (eine kleine Datei, die eine Einstellung von [[wiki-service]] überschreibt) festlegt. Eine Veröffentlichung erscheint also erst, wenn aus dem veröffentlichten Commit ein Release-Ordner gebaut und die Drop-in-Datei darauf gerichtet ist; ohne die Datei wird wieder `~/dev/wiki/site` geliefert.

## Where it sits in the pipeline
Zwischen [[wiki-build]] und dem [[wiki-router]].

## Who receives its output
Der [[wiki-router]].
