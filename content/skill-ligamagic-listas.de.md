---
id: skill-ligamagic-listas
lang: de
source_hash: 2a626c489bc2
title: Skill: ligamagic-listas
---

## What it is
Die Skill „ligamagic-listas“ behandelt Giovannis Arbeit mit der Einkaufsliste von LigaMagic („Lista de Compras“) und dem Sammelkauf-Formular („Compra por Lista“). [LigaMagic](https://www.ligamagic.com.br/) ist ein brasilianischer Marktplatz für Karten von [Magic: The Gathering](https://en.wikipedia.org/wiki/Magic:_The_Gathering). Die Skill ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: verwenden bei der Arbeit mit der Einkaufsliste oder dem Kauf-nach-Liste-Formular: Karten extrahieren, Listen mit Edition erzeugen, Einträge im Stapel entfernen oder bearbeiten. Um den Warenkorb pro Shop auf den eigenen Websites der Shops nachzubauen oder zu prüfen, [[skill-ligamagic-replicar-carrinho-nas-lojas]] verwenden.

## What it does
Sie extrahiert Karten, erzeugt Listen mit Edition und entfernt oder bearbeitet Einträge im Stapel. Ihre Rolle ist „Domäne“: Sie besitzt das Format des Kauf-nach-Liste-Formulars und den Umgang mit der Einkaufsliste; sie verweist auf [[skill-browser-automacao-segura]] (Stapelaktionen) und [[skill-ligamagic-replicar-carrinho-nas-lojas]] (Warenkörbe pro Shop und ihr Aufbau auf den Shop-Seiten); und sie beachtet die Sprache der Nachricht und die Tiefe-Flags `!!`, `***` und `...`.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/ligamagic-listas`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt. Vor Stapelaktionen im Browser folgt sie zusätzlich [[skill-browser-automacao-segura]].

## Where it sits in the pipeline
Giovannis Hobby Magic: The Gathering.

## Who receives its output
Giovannis LigaMagic-Listen und [[skill-ligamagic-replicar-carrinho-nas-lojas]] für die Warenkörbe pro Shop.

## Steps
1. **Format des Kauf-nach-Liste-Formulars** (`?view=cards/lista`): eine Karte pro Zeile als `[Menge] [Karte] [TAGS]`. Die akzeptierten Tags, auf der Seite bestätigt, sind: Edition `[EDICAO=PIP]` (das Kürzel der Edition, zum Beispiel M10, MH3, PIP); Mindestzustand `[QUALIDADE=NM]` (M mint, NM near mint, SP slightly played, MP moderately played, HP heavily played, D damaged); Sprache `[IDIOMA=PT]` oder `[idioma=en]` (für „jede Sprache“ weglassen); Extras `[EXTRAS=FOIL]` oder `[extras=textless, fnm]`.
2. **Beispiel und Regeln.** `1 Command Tower [EDICAO=PIP] [QUALIDADE=NM]`. Den englischen Kartennamen benutzen. Nummerierte Länder gehen so: `1 Forest (#0326) [EDICAO=PIP]`. Die Schreibweisen `[PIP]`, `(PIP)` oder `|PIP` funktionieren NICHT. Zum Prüfen die Liste einfügen und auf „Detalhar Características“ klicken: Die Spalte Edition muss gefüllt zurückkommen.
3. **Die Einkaufsliste** (`?view=mp/carrinho&open=1`). Dieselbe Seite hat zwei Strukturen: die Einkaufsliste (eine Tabelle, unten) und den Warenkorb pro Shop (Blöcke mit Zeilen und Mengenfeldern, ein Block pro Shop), der zu [[skill-ligamagic-replicar-carrinho-nas-lojas]] gehört. Die Artikeltabelle ist die erste Tabelle der Seite. Jede Zeile hat ein Zahlenfeld (Menge) und Auswahllisten (Edition, Zustand, Sprache, Extras); der Name steht in der ersten Zelle, mit dem englischen Namen in der letzten Zeile. Die erste Zeile mit Auswahllisten ist die Zeile „Aplicar Valores“ (Werte anwenden), keine Karte. Der Text der gewählten Edition hat die Form `KÜRZEL - Name` (zum Beispiel `PIP - Fallout`).
4. **Einträge entfernen.** Der Entfernen-Knopf ist `.btn-circle.remove`. Das Entfernen ist auf dem Server sofort (ein Hinweis erscheint, dass der Eintrag aus der Einkaufsliste entfernt wurde); während der Bearbeitung wird der Knopf zu einem Spinner. Der Warenkorb pro Shop nutzt dieselbe Klasse, also vor dem Klick prüfen, zu welcher Struktur der Knopf gehört.
5. **Fallen.** Zweimal auf ein gerade bearbeitetes Element zu klicken ergibt die Warnung „Ops! Não foi possível realizar a operação“, die den Browser einfriert: eines nach dem anderen entfernen und warten, bis die Zeile verschwindet. Das `javascript_tool` kann bei Selektoren mit bestimmten Zeichenfolgen oder langen Ausgaben scheitern: die erste Tabelle benutzen, Ergebnisse in `window.*`-Variablen speichern und in Blöcken von etwa 1.000 Zeichen lesen. Der Kopf zeigt „Total: N cards“, was die Mengen addiert.
