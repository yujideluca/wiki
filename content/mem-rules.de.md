---
id: mem-rules
lang: de
source_hash: c9cb39517fb5
title: mem rules und mem tag (Regeln nach Art der Aufgabe)
---

## What it is
Ein Tag ist ein kurzes Wort, das sagt, für welche Art von Aufgabe eine Regel wichtig ist, zum Beispiel `deploy` (etwas installieren oder ändern) oder `git`. `mem rules` gibt die vollständigen Regeln aus, die einen Tag tragen, und `mem tag` ändert die Tags einer Regel. Es gibt sie, weil der Text, den ein Chat zu Beginn erhält, nach 2 KB (Kilobyte, ein Maß für Textgröße) abgeschnitten wird und nicht alle Regeln fassen kann: Er enthält stattdessen einen Index der Tags, und Claude liest die Regeln einer Aufgabenart, wenn es eine solche Aufgabe beginnt ([[session-brief]]).

## What it does
`mem rules deploy git` gibt jede aktive Regel mit dem Tag `deploy` oder `git` aus, jede einmal, im vollen aktuellen Wortlaut. Eine Zeile sieht so aus: `- [git.no-force-push] Never force-push. (#d6931b)`: der Key, der Text und der kurze `#code`, den `mem use` und `mem feedback` annehmen. Gezeigt werden nur die Regeln des aktuellen Projekts und des aktuellen Werkzeugs (eine Regel für ein anderes Projekt oder nur für Codex fehlt), und eine als falsch markierte Regel fehlt ebenfalls. Ein unbekannter Tag wird abgelehnt, und die bekannten Tags werden aufgelistet.

`mem tag KEY deploy,git` ersetzt die Tags der Regel mit diesem Key (`--scope`, wenn derselbe Key in mehreren Geltungsbereichen existiert, oder statt des Keys den `#code`); `mem tag KEY -` entfernt sie. Es schreibt ein neues Ereignis, das das alte ersetzt, sodass das Log seine Geschichte behält. `mem add --tags` setzt die Tags einer neuen Regel ([[mem-add]]).

## How it does it
Die bekannten Tags und ihr einzeiliger „use when“-Text stehen in `mem/tags.toml` (TOML ist ein einfaches Textformat aus Zeilen der Form `name = "text"`). Die Prüfung ([[mem-validator]]) lehnt ein Ereignis ab, dessen Tag nicht in dieser Datei steht oder das mehr als sechs Tags hat, und `mem check` gibt für jede von Giovanni geschriebene Regel ohne Tag eine Warnung aus, weil keine Tag-Abfrage eine solche Regel erreichen würde. Die Tags gehören in [[memory-fold]] zur Regel: Dieselben Worte mit anderen Tags ersetzen das ältere Ereignis. Der Tag `always` markiert die wenigen Regeln, die der Start-Brief vollständig ausgibt. Dieselben Listen werden für Chats, die keine Befehle ausführen können, nach `views/rules/TAG.md` geschrieben ([[memory-views]]).

## Where it sits in the pipeline
Claude führt `mem rules TAG` vor einer Aufgabe dieser Art aus; der Start-Brief weist es dazu an ([[hook-session-start]]). Giovanni kann es auch selbst ausführen.

## Who receives its output
Der [[session-brief]] (der Index und die `always`-Regeln) und der Chat, der gefragt hat.

## Functions
- `mem rules TAG [TAG ...] [--project NAME]`: die vollständigen Regeln mit einem der Tags ausgeben
- `mem tag KEY|#code TAG[,TAG] [--scope S]`: die Tags einer Regel setzen; `-` löscht sie
- `mem add ... --tags TAG[,TAG]`: eine neue Regel mit Tags versehen; eine Regel, die eine andere ersetzt, behält deren Tags, wenn `--tags` nichts anderes sagt
