---
id: skill-regras-magic
lang: de
source_hash: 1d01fa6d0557
title: Skill: regras-magic (Magic-Regeln)
---

## What it is
Die Skill „regras-magic“ beantwortet Giovannis Regelfragen zu [Magic: The Gathering](https://en.wikipedia.org/wiki/Magic:_The_Gathering), dem Sammelkartenspiel. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: sie beantwortet Giovannis Magic-Regelfragen: Karteninteraktionen, der Stapel, Trigger, Ebenen, Kopien, Spielmarken, Commander; nicht für LigaMagic-Listen oder Käufe ([[skill-ligamagic-listas]]).

## What it does
Sie gibt Regelentscheidungen in einer festen Vorlage. Ihre Rolle ist „Domäne“: Sie besitzt das Format von Magic-Rulings; sie verweist auf [[skill-ligamagic-listas]] (Käufe) und [[skill-browser-automacao-segura]] (falls ein Browser benutzt wird); und sie beachtet die Sprache der Nachricht und die Tiefe-Flags `!!`, `***` und `...`.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/regras-magic`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Giovannis Hobby Magic: The Gathering.

## Who receives its output
Giovanni.

## Steps
1. **Diese Vorlage verwenden.** *Ruling* (das Ergebnis in einer Zeile); *Karten (Oracle)* (der relevante Text jeder Karte; „aus dem Gedächtnis“ markieren, wenn er nicht auf [Scryfall](https://scryfall.com/) oder Gatherer geprüft wurde); *Zeitablauf* (Schritt für Schritt: wirken → Stapel → Auflösung → zustandsbasierte Aktionen → Trigger); *Regeln* (Nummern aus den [Comprehensive Rules](https://magic.wizards.com/en/rules)); *Sicherheit* (hoch, oder mittel, wenn der Kartentext aus dem Gedächtnis stammt oder der Fall selten ist).
2. **Kommentiertes Beispiel.** Frage: „Kona, Rescue Beastie legt mit ihrem Trigger einen Brontodon auf das Schlachtfeld. Kann ich ihn mit Remove Soul kontern?“ Ruling: nein, es gibt keinen Zauber zu kontern. Karten: Remove Soul kontert einen Kreaturenzauber; Kona legt die Kreatur auf das Schlachtfeld (aus dem Gedächtnis, auf Scryfall prüfen). Zeitablauf: Konas Trigger löst sich auf → der Brontodon wird direkt auf das Schlachtfeld gelegt, ohne gewirkt zu werden → er war nie ein Zauber auf dem Stapel. Regeln: 601.2a (Wirken beginnt damit, die Karte auf den Stapel zu legen; das Legen auf das Schlachtfeld überspringt das). Sicherheit: hoch.
