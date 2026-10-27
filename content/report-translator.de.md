---
id: report-translator
lang: de
source_hash: 37604fb0312d
title: Befund-Übersetzer (translate.py)
---

## What it is
Ein Kommandozeilenprogramm, das die extrahierten Artikel von [[radiopaedia-crawler]] mit [[codex]] ins Deutsche und ins brasilianische Portugiesisch übersetzt und die Wortwahl mithilfe von zwei Fachlehrbüchern bestimmt, damit das Ergebnis so klingt, wie Radiologen im jeweiligen Land schreiben. Es ist Teil von [[radiology-report-matcher]].

## Architecture
### Context
person g: Giovanni — startet die Übersetzungsschleife und kann sie stoppen | [[giovanni]]
system s: translate.py — übersetzt Artikel mit Lehrbuch-Wortwahl
external a: Radiopaedia-Crawler — liefert die extrahierten Artikel | [[radiopaedia-crawler]]
external c: Codex — führt die Übersetzung aus | [[codex]]
external b: Referenzlehrbücher — deutsche und portugiesische Wortwahl

g -startet die Schleife von-> s
s -liest Artikel von-> a
s -bittet um Übersetzungen von-> c
s -übernimmt Wortwahl aus-> b

### Containers
person g: Giovanni | [[giovanni]]
container cm: Befehle — refindex, translate, loop, tstats
container pf: Passagenfinder — Kosinus-Ähnlichkeit von Vier-Buchstaben-Stücken
store ixf: Buchindex-Dateien — eine je Sprache
store art: Tabelle articles — der englische Text
store tr: Tabelle translations — die Ergebnisse
external c: Codex | [[codex]]

g -führt aus-> cm
cm -baut-> ixf
cm -sucht Passagen mit-> pf
pf -liest-> ixf
cm -liest Artikel aus-> art
cm -bittet um Übersetzungen von-> c
cm -speichert Ergebnisse in-> tr

## What it does
Es hat vier Befehle, ausgeführt als `python3 -I translate.py <Befehl>` in `~/dev/radiology-crawler`:

- `refindex` zerlegt jedes Referenzbuch in Passagen von 60 bis 160 Wörtern und baut dafür eine Suchtabelle.
- `translate --lang de|pt --limit N` übersetzt bis zu N Artikel, die noch keine Übersetzung haben.
- `loop` läuft dauerhaft im Hintergrund und übersetzt Artikel, sobald sie eintreffen, je Sprache fünf auf einmal, und schläft, wenn nichts zu tun ist. Optionen: `--worker I/K` (dieser Worker nimmt jeden K-ten Artikel, sodass mehrere Worker parallel laufen können), `--langs`, `--extract` (extrahiert auch neu heruntergeladene Seiten; nur ein Worker) und `--daily-cap N` (0, der Standard, heißt keine Grenze; UTC ist überall dieselbe Uhrzeit). Ein Artikel, der dreimal scheitert, wird in der Tabelle `translation_failures` vermerkt und übersprungen; scheitert in einer Runde jeder Versuch, wartet der Worker 15 Minuten. Das Anlegen der Datei `data/STOP_TRANSLATION` beendet alle Worker.
- `tstats` zeigt, wie viele Seiten übersetzt sind, und die durchschnittliche Dauer.

Die Ergebnisse stehen in der Tabelle `translations` (Seitenadresse, Sprache, Titel, Text, die verwendeten Lehrbuchpassagen, benötigte Sekunden, Modell).

## How it does it
- Die Referenzbücher sind Duale Reihe Radiologie (Deutsch, 816 Seiten, 3.258 Passagen) und Anatomia Radiológica Básica Ilustrada, Band 1 (Portugiesisch, 44 Seiten nur zum Thorax, 33 Passagen). Beide wurden mit `pdftotext` von PDF (einer Dokumentdatei mit festem Layout) in Text umgewandelt; sie bleiben auf dem Laptop und werden in kein Produkt kopiert.
- Um die zu einem Artikel passenden Passagen zu finden, wird jedes Wort in überlappende Stücke von vier Buchstaben zerlegt, und jede Passage wird zu einem Vektor (einer Zahlenliste), gewichtet danach, wie selten ihre Stücke sind (TF-IDF). Gewählt werden die Passagen, die Titel, Tags, Überschriften und den Anfang (1.500 Zeichen) des Artikels am nächsten kommen, gemessen mit der Kosinus-Ähnlichkeit (dem Winkel zwischen zwei Vektoren). Weil englische, deutsche und portugiesische medizinische Wörter lateinische und griechische Wurzeln teilen, funktioniert das ohne KI-Modell über Sprachen hinweg. Beispiel: Eine Anfrage zu pleural effusion und pneumothorax liefert deutsche Passagen zu *Pneumothorax* und *Pleura*.
- Die fünf besten Passagen kommen als Terminologie- und Stilleitfaden in den Prompt, mit Regeln: ihre Sätze nicht kopieren, die Struktur beibehalten, die Zahlenschreibweise des Landes verwenden (Dezimalkomma) und den Artikel als nicht vertrauenswürdigen Text behandeln, dessen Inhalt nie als Anweisung befolgt wird.
- Jeder Aufruf von [[codex]] ist eine neue, wegwerfbare Sitzung nur mit Leserechten (`--ephemeral`), sodass sich zwischen Seiten nichts ansammelt. Giovanni hat verlangt, dass ein Codex-Kontext unter 250.000 Tokens bleibt (ein Token ist ein kleines Textstück, etwa drei Zeichen): Ein Prompt hat etwa 6.000 Tokens, ein Artikel mit mehr als 24.000 Zeichen wird nach Abschnitten auf getrennte Aufrufe verteilt, und eine Prüfung lehnt jeden Prompt ab, der die Grenze überschreiten würde.
- Giovanni hat die Tagesgrenze am 2026-10-27 aufgehoben (alles zu übersetzen hat Vorrang) und das günstigere Codex-Modell `gpt-6-luna` gewählt, um Budget zu sparen; vier Worker laufen parallel. Gemessen an diesem Tag: etwa 9 bis 10 Sekunden pro Artikel und Sprache mit Luna, 12 bis 14 mit dem Standardmodell der ersten Übersetzungen (ihre Spalte `model` ist leer). Bei dieser Geschwindigkeit brauchen 17.359 Artikel in zwei Sprachen etwa ein bis zwei Tage, sofern die Nutzungsgrenzen von Codex es zulassen. Fälle werden noch nicht übersetzt.
- Das portugiesische Buch ist klein; außerhalb der Thorax-Anatomie stützt sich die portugiesische Wortwahl daher auf das eigene Wissen von Codex; weitere brasilianische Quellen werden gebraucht.

## Where it sits in the pipeline
Zweiter Schritt der Datenkette: nach [[radiopaedia-crawler]] und vor der geplanten Index-Erstellung von [[radiology-report-matcher]].

## Who receives its output
Die geplante Index-Erstellung und später die deutschen und portugiesischen Seiten der Website.
