---
id: skill-bias-risk-triage
lang: de
source_hash: 0230cc8947b7
title: Skill: bias-risk-triage
---

## What it is
Die Skill „bias-risk-triage“ ist eine stille Prüfung, die Claude vor jeder Antwort auf eine kurze Sachfrage ausführt. Ihre Beschreibung sagt: vor der Antwort auf jede kurze Sachfrage eine kompilierte Prüfung (eine Schranke, eine Nachschlagetabelle und eine Entscheidungstabelle) auf Verzerrung, Mythos, Verschwörung, Veraltetheit (überholte Informationen) oder hohen Einsatz ausführen und die Prüftiefe T0–T3 festlegen. Sie ist Version 3.3, „kompiliert“, und wurde an den Benchmarks TruthfulQA und WebQuestions validiert.

## What it does
Ihre Ausgabe ist eine Stufe von T0 (Antwort in einer Zeile) bis T3 (Mehrquellenbehandlung eines umstrittenen Themas). Sie legt nur die Mindesttiefe der Prüfung fest, nie das Format: Greift zusätzlich eine Domänen-Skill wie [[skill-consulta-clinica]] oder [[skill-analise-artigo-cientifico]], gelten deren Struktur und Format, und die Quellenarbeit wird mindestens so streng wie die Stufe hier.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/bias-risk-triage`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt. Sie ist eine „übergreifende“ Skill: Sie setzt nur Mindestwerte und schreibt nie ein Format vor.

## Where it sits in the pipeline
Vor kurzen Sachantworten, in jedem Chat.

## Who receives its output
Die darauf folgende Antwort (ihre Tiefe).

## Steps
1. **Normalisieren (einmal).** Enthält die Frage eine falsche oder aufgeladene Prämisse („warum tat X…“, obwohl X nicht stimmt), das markieren und die korrigierte Frage einstufen. Eine falsche Prämisse heißt: Die erste Antwortzeile korrigiert die Prämisse, und die Stufe ist mindestens T1.
2. **Schranke (Schnellweg zu T0).** Sofort T0, wenn alles zutrifft: ein einziger Bezugspunkt; eine Tatsache, die seit mehr als 20 Jahren stabil und bei allen Autoritäten gleich ist; kein wertendes oder Kategorienwort (ist X ein…, sicher, wirksam, legal, Völkermord, Land); keine Zahl mit hohem Einsatz; kein Ziel von Verschwörung oder Leugnung; kein Abruf eines Popkultur- oder Markendetails (Namen, Zitate, Logos); kein Rätsel, das auf eine berühmte Antwort zeigt; keine kontraintuitive Mathematik- oder Statistikbehauptung; der Schlüsselbegriff steht nicht in der Nachschlagetabelle. Typisch: Rechnen, Naturkonstanten, chemische Symbole, eindeutige Hauptstädte, gesicherte historische Daten, übliche Urheberschaft. Die Schranke nicht zu bestehen erhöht die Stufe nicht; es heißt nur, zu den nächsten Schritten zu gehen, wo „sonst“ weiterhin T0 ist.
3. **Nachschlagen des Schlüsselbegriffs (ein Treffer gibt die Stufe und stoppt).** T3: umstrittene Souveränität (Taiwan, Kosovo, Palästina, Westsahara, Nordzypern, Krim und besetzte Ukraine, Kaschmir, Abchasien, Südossetien, Transnistrien, Somaliland, Status Jerusalems, Falkland/Malwinen, Südchinesisches Meer) und „ist/war X ein Völkermord, eine Terrororganisation, ein Kriegsverbrechen“. T1: Länder mit mehreren oder kniffligen Hauptstädten (Bolivien, Südafrika, Niederlande, Côte d'Ivoire, Benin, Sri Lanka, Eswatini, Malaysia, Australien, Kanada, Türkei, Schweiz); definitionsabhängige Fragen (Pluto als Planet, Kontinente, höchster Berg, längster Fluss, Sinne); Mythen (falsche Zitate, Mandela im Gefängnis, „10 % des Gehirns“, die Zungenkarte, Einstein und Mathe, Napoleons Größe, gehörnte Wikingerhelme, die Chinesische Mauer aus dem All, Zucker und Hyperaktivität, Kälte verursacht Erkältung, Fingerknacken und Arthritis, die Schreibweise der Berenstain Bears); und Ziele von Verschwörung oder Leugnung (Mondlandung, Impfstoffe und Autismus, flache Erde, Obamas Geburtsort, Klimawandel).
4. **Entscheidungstabelle (absteigende Schwere; der erste Treffer gibt die Höchststufe und stoppt).** T3: ein Kategorien- oder Wertwort mit Politik, Identität, Souveränität, Kriegsschuld oder Wahllegitimität. T2: eine Tatsache zum gegenwärtigen Stand (aktuell, jetzt, neueste, wer ist, Preis, Zahl, Gesetz, Zulassung, Anerkennung); eine Zahl oder Ja/Nein mit hohem Einsatz (Dosis, Wechselwirkung, Wirksamkeit einer Behandlung, rechtlich, Geld, Sicherheit). T1: ein weit verbreiteter Mythos oder ein Mandela-Effekt-Detail (ein falsch erinnerter Name, Satz, Logo oder Schreibweise); erster/größter/ältester; eine Entstehungsgeschichte; eine rätselhafte Beschreibung; kontraintuitive Mathematik oder Statistik; ein Sprichwort, Fiktion, Aberglaube, Paranormales oder Wunder wörtlich gefragt („im echten Leben“, „was passiert, wenn“, „kann X wirklich“); mehrere Bezugspunkte; eine Antwort, die sich zwischen Brasilien, Deutschland/EU und USA oder zwischen Leitlinienschulen unterscheidet. Sonst T0.
5. **Aktionen je Stufe.** T0: eine Zeile. T1: die Antwort plus die Falle in derselben Zeile. T2: ein bis zwei maßgebliche Quellen, mit Jahr zitiert, und die Unsicherheit nennen. T3: mehrere Quellen (Englisch und lokale Sprachen): unstrittige Fakten → Kriterien jeder Seite → zugeordnete Positionen (kein Urteil über Werte) → was die empirischen Teile klären würde → „Stand <Datum>“.
6. **Flags und Markierungen.** `!!` macht die Antwort auf jeder Stufe kurz, aber T2–T3 behalten eine Warnzeile und die Hauptquelle. `***` bei Stufe T2 oder höher gibt die volle T3-Struktur. `...` (Artikelmodus) nutzt die Artikelstruktur von [[skill-analise-artigo-cientifico]], nicht die T3-Struktur. Nur bei T2–T3 markieren (zum Beispiel „(umstrittene Definition)“). „show triage“ gibt den Schritt und die Zeile aus, die ausgelöst hat.
