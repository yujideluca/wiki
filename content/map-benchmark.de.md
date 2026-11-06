---
id: map-benchmark
lang: de
source_hash: 567a528f7e82
title: Benchmark-Werkzeuge für die Karte (wiki-bench)
---

## What it is
Eine Sammlung von Python-Skripten in `~/dev/wiki-bench`, die messen, wie viel Arbeit ein Browser leistet, um die Karte des Wikis zu zeichnen, während jemand die Maus bewegt, und die die Codezeilen der Karte benennen, die diese Arbeit verursachen. Sie existieren, damit eine Aussage über die Geschwindigkeit der Karte mit einer Zahl, einer Streuung zwischen wiederholten Läufen und dem betroffenen Code belegt ist statt mit einem Eindruck.

## What it does
`map_bench.py` lädt eine Version des Wikis in einem Headless-Chrome (Chrome ohne Fenster), spielt eine Geste ab und zeichnet einen Browser-Trace auf: für jeden Animationsframe die Zeit in JavaScript, Style, Layout, Paint und Commit im Hauptthread sowie die Raster-Arbeit (Umwandlung von Formen in Pixel) in den anderen Threads. Die Gesten sind `pan` (den Globus ziehen), `pan-fast` (ein schnelles Wischen), `sweep` (der Cursor bewegt sich ohne gedrückte Taste über den Globus), `zoom` (Mausrad), `idle` (nichts passiert), `hover` und `drag` (zieht einen Punkt, nicht den Globus).

`compare.py` lässt mehrere Versionen unter mehreren Gesten über mehrere Runden laufen. Es wechselt die Reihenfolge der Versionen von Runde zu Runde und misst am Ende jeder Runde die erste Version noch einmal; der Abstand zwischen ihren beiden Läufen (beobachtet wurde eine Drift der Maschine zwischen -17 % und +18 %) zeigt, wie groß ein Unterschied sein muss, damit er als Ergebnis zählt. Es gibt Median und Minimum-Maximum für gezeichnete Frames, mittlere und 95.-Perzentil-Framezeit, Busy-Zeit des Hauptthreads und Rasterzeit aus.

`callprof.py` findet den Code. Für eine Version und eine Geste lässt es die Seite dreimal laufen: unter Chromes CPU-Sampler, unter exakter Aufrufzählung und mit einem `MutationObserver` (eine Browser-Funktion, die jede Änderung am DOM, dem Document Object Model, dem Elementbaum der Seite, meldet), der die pro Mausereignis geschriebenen Attribute zählt. `elmmap.py` übersetzt einen kompilierten Namen wie `$author$project$Motion$step` in `src/Motion.elm:89`. `callcmp.py` stellt die Profile mehrerer Versionen nebeneinander, pro Mausereignis und pro Frame, mit den Seitenschreibvorgängen, den heißesten kompilierten Zeilen und einer Rangliste dessen, was zuerst zu optimieren ist. `framelog.py` zeigt, wann eine Version Animationsframes anfordert und welche Ereignisse die Seite erhielt.

## How it does it
Es steuert Chrome über das DevTools-Protokoll (die Fernsteuerungsschnittstelle von Chrome) mit der Bibliothek `websockets`. Die Mauseingabe ist offen (open loop): `play()` in `map_bench.py` sendet jedes Ereignis zum geplanten Zeitpunkt und wartet nicht auf die Antwort der Seite. Das wurde ergänzt, nachdem `framelog.py` gezeigt hatte, dass dasselbe Wischen in einer Version 179 ms und in einer anderen 826 ms dauerte, wenn jedes Ereignis auf die Antwort der Seite wartete: Eine langsamere Version bekam dann eine längere Geste, und der Vergleich begünstigte die falsche Version. Der Elm-Compiler behält Funktionsnamen in `--optimize`-Builds, schreibt aber keine Source-Map; eine Zeile unterhalb der Funktionsebene wird daher als kompilierte Zeile unter ihrer Elm-Funktion angegeben. Die Builds kommen aus `~/dev/wiki-globe-sandbox` (ein Worktree des Wiki-Repositorys mit Varianten des Koordinatencodes der Karte); `build.sh` löscht und erstellt einen Build-Ordner neu, deshalb muss jeder `http.server`, der ihn ausliefert, neu gestartet werden.

Was die Werkzeuge bisher gefunden haben, steht in `globe/RESULTS.md` (Runden 3 bis 5). In der letzten Runde, mit offener Eingabe: Variante v2 (eine leichtere Kartenansicht) zeichnete bei einem Pan 273 Frames mit 12,2 ms, wo die aktuelle Karte 82 mit 27,2 ms zeichnete; eine Variante, die zwischen exakten Neuzeichnungen ein Bild mit einer CSS-Transformation verschiebt, brachte gegenüber v2 keinen messbaren Unterschied; `will-change: transform` am SVG (Scalable Vector Graphics, dem Zeichenformat der Karte) senkte die Rasterzeit um etwa 30 %; und die Feder-Schicht `Motion.step` (etwa 1,3 ms pro Frame, nur solange ein Punkt überfahren wird) sowie die Schreibvorgänge in die Seite (55-60 % eines Frames sind native Browser-Arbeit) sind die Teile, die noch zu optimieren bleiben. Nicht geprüft: eine zweite Maschine, ein Telefon und ein Blick auf das Bild während einer Geste.

## Where it sits in the pipeline
Von Hand von [[claude-code]] oder Giovanni nach einer Änderung an der Karte ausgeführt; die Ergebnisse sind der Beleg für die Geschwindigkeitshinweise von [[wiki-map-view]].

## Who receives its output
Dateien in `~/dev/wiki-bench/globe/results` (rohe json- und Markdown-Tabellen) und `globe/RESULTS.md`; [[wiki-map-view]] beschreibt die Karte, die gemessen wird.
