---
id: skill-bias-risk-triage
lang: de
source_hash: 61a26c201cdb
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

## Notes

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

#### Claude: `home:.claude/skills/bias-risk-triage/SKILL.md`

```skill-source home:.claude/skills/bias-risk-triage/SKILL.md 49abcacd42f44ce99af49f4bf731922ffc0929c5baab66221b11719e3447a028
---
name: "bias-risk-triage"
description: "Before answering any short factual question, run a compiled check (guard, lookup, decision table) for bias, myth, conspiracy, staleness or stakes and set verification depth T0-T3."
---

# Bias-Risk Triage v3.3 (compiled; validated on TruthfulQA + WebQuestions)

Lineage: origin=gui; base=c3fb4e1397b48a0389f58e4e1fc14249a452a826

Silent pre-answer check. Output = tier T0-T3; it sets answer depth only.

**Precedence:** this skill sets the *minimum verification depth*, never the format. When a domain skill also applies (consulta-clinica for doses/conduct/calculations, analise-artigo-cientifico for evidence questions, regras-magic for Magic rulings, candidatura-alemanha for legal/Approbation facts, alemao-goethe-fsp for language questions), follow that skill's structure and output format, and only make sure its sourcing is at least as strict as the tier here.

## 0. Normalize (once)
If the question embeds a false/loaded premise ("why did X" with X untrue) -> mark P=1, and classify the corrected question. P=1 => first answer line corrects the premise; tier >= T1.

## 1. Guard (fast path -> T0)
T0 immediately if ALL: single referent; fact stable >20 y and identical across authorities; no evaluative/category word (is X a..., safe, effective, legal, genocide, country); no stakes number; not a conspiracy/denialism target; not pop-culture/brand detail recall (names, lines, logos); not a riddle-style description pointing to a famous answer; not a counterintuitive math/stats claim; key term not in LUT.
Typical: arithmetic, physical constants, chemical symbols, unique-capital countries, settled historical dates, standard authorship.
Failing the guard does NOT raise the tier; it only means: continue to steps 2-3, where "else" still = T0. Ordinary where/what/who trivia with no table match stays T0.

## 2. LUT (hash lookup on key term; hit => tier, stop)
- T3: contested sovereignty {Taiwan, Kosovo, Palestine, W. Sahara, N. Cyprus, Crimea/occupied Ukraine, Kashmir, Abkhazia, S. Ossetia, Transnistria, Somaliland, Jerusalem status, Falklands/Malvinas, S. China Sea}; "is/was X a genocide | terrorist org | war crime".
- T1: multi/trap capitals {Bolivia, S. Africa, Netherlands, Côte d'Ivoire, Benin, Sri Lanka, Eswatini, Malaysia, Australia, Canada, Turkey, Switzerland}; definition-dependent {Pluto/planet, continents, tallest mountain, longest river, senses}; myths {misquotes, Mandela prison, 10% brain, tongue map, Einstein math, Napoleon height, horned helmets, Great Wall from space, sugar hyperactivity, cold->colds, knuckles->arthritis, Berenstain}; conspiracy/denialism targets {Moon landing, vaccines-autism, flat Earth, Obama birthplace, climate change}.

## 3. Decision table (descending severity; first match = max tier, stop)
| match | tier |
|---|---|
| category/value word + politics, identity, sovereignty, war blame, election legitimacy | T3 |
| present-state fact (current, now, latest, who is, price, count, law, approval, recognition) | T2 |
| number or yes/no with stakes (dose, interaction, efficacy of a treatment, legal, money, safety) | T2 |
| widely believed myth or Mandela-effect detail (misremembered name, line, logo, spelling); first/largest/oldest; origin story; riddle-style description; counterintuitive math/stats | T1 |
| proverb, fiction, superstition, paranormal or miracle asked literally ("in real life", "what happens if", "can X really") | T1 |
| several referents; answer differs BR / DE-EU / US or by guideline school | T1 |
| else | T0 |

## 4. Actions (evaluate only the chosen tier)
- T0: one line.
- T1: answer + trap in same line.
- T2: 1-2 authoritative sources, cite + year, state uncertainty.
- T3: multi-source (EN + local languages): undisputed facts -> criteria per side -> attributed positions (no verdict on values) -> what would settle empirical parts -> "as of <date>".

Flags: `!!` short at any tier, but T2-T3 keep 1 warning line + key source. `***` with T>=2 -> full T3 structure. `...` (article mode) -> use the article structure from his settings / analise-artigo-cientifico, not the T3 structure.
Tag only at T2-T3 (e.g. "(contested definition)"). "show triage" -> print step + row that fired.
```


#### Codex: `home:.agents/skills/bias-risk-triage/SKILL.md`

```skill-source home:.agents/skills/bias-risk-triage/SKILL.md 49abcacd42f44ce99af49f4bf731922ffc0929c5baab66221b11719e3447a028
---
name: "bias-risk-triage"
description: "Before answering any short factual question, run a compiled check (guard, lookup, decision table) for bias, myth, conspiracy, staleness or stakes and set verification depth T0-T3."
---

# Bias-Risk Triage v3.3 (compiled; validated on TruthfulQA + WebQuestions)

Lineage: origin=gui; base=c3fb4e1397b48a0389f58e4e1fc14249a452a826

Silent pre-answer check. Output = tier T0-T3; it sets answer depth only.

**Precedence:** this skill sets the *minimum verification depth*, never the format. When a domain skill also applies (consulta-clinica for doses/conduct/calculations, analise-artigo-cientifico for evidence questions, regras-magic for Magic rulings, candidatura-alemanha for legal/Approbation facts, alemao-goethe-fsp for language questions), follow that skill's structure and output format, and only make sure its sourcing is at least as strict as the tier here.

## 0. Normalize (once)
If the question embeds a false/loaded premise ("why did X" with X untrue) -> mark P=1, and classify the corrected question. P=1 => first answer line corrects the premise; tier >= T1.

## 1. Guard (fast path -> T0)
T0 immediately if ALL: single referent; fact stable >20 y and identical across authorities; no evaluative/category word (is X a..., safe, effective, legal, genocide, country); no stakes number; not a conspiracy/denialism target; not pop-culture/brand detail recall (names, lines, logos); not a riddle-style description pointing to a famous answer; not a counterintuitive math/stats claim; key term not in LUT.
Typical: arithmetic, physical constants, chemical symbols, unique-capital countries, settled historical dates, standard authorship.
Failing the guard does NOT raise the tier; it only means: continue to steps 2-3, where "else" still = T0. Ordinary where/what/who trivia with no table match stays T0.

## 2. LUT (hash lookup on key term; hit => tier, stop)
- T3: contested sovereignty {Taiwan, Kosovo, Palestine, W. Sahara, N. Cyprus, Crimea/occupied Ukraine, Kashmir, Abkhazia, S. Ossetia, Transnistria, Somaliland, Jerusalem status, Falklands/Malvinas, S. China Sea}; "is/was X a genocide | terrorist org | war crime".
- T1: multi/trap capitals {Bolivia, S. Africa, Netherlands, Côte d'Ivoire, Benin, Sri Lanka, Eswatini, Malaysia, Australia, Canada, Turkey, Switzerland}; definition-dependent {Pluto/planet, continents, tallest mountain, longest river, senses}; myths {misquotes, Mandela prison, 10% brain, tongue map, Einstein math, Napoleon height, horned helmets, Great Wall from space, sugar hyperactivity, cold->colds, knuckles->arthritis, Berenstain}; conspiracy/denialism targets {Moon landing, vaccines-autism, flat Earth, Obama birthplace, climate change}.

## 3. Decision table (descending severity; first match = max tier, stop)
| match | tier |
|---|---|
| category/value word + politics, identity, sovereignty, war blame, election legitimacy | T3 |
| present-state fact (current, now, latest, who is, price, count, law, approval, recognition) | T2 |
| number or yes/no with stakes (dose, interaction, efficacy of a treatment, legal, money, safety) | T2 |
| widely believed myth or Mandela-effect detail (misremembered name, line, logo, spelling); first/largest/oldest; origin story; riddle-style description; counterintuitive math/stats | T1 |
| proverb, fiction, superstition, paranormal or miracle asked literally ("in real life", "what happens if", "can X really") | T1 |
| several referents; answer differs BR / DE-EU / US or by guideline school | T1 |
| else | T0 |

## 4. Actions (evaluate only the chosen tier)
- T0: one line.
- T1: answer + trap in same line.
- T2: 1-2 authoritative sources, cite + year, state uncertainty.
- T3: multi-source (EN + local languages): undisputed facts -> criteria per side -> attributed positions (no verdict on values) -> what would settle empirical parts -> "as of <date>".

Flags: `!!` short at any tier, but T2-T3 keep 1 warning line + key source. `***` with T>=2 -> full T3 structure. `...` (article mode) -> use the article structure from his settings / analise-artigo-cientifico, not the T3 structure.
Tag only at T2-T3 (e.g. "(contested definition)"). "show triage" -> print step + row that fired.
```
