---
id: skill-bias-risk-triage
title: Skill: bias-risk-triage
aliases: [bias-risk-triage]
kind: skill
project: skills
status: active
location: home:.claude/skills/bias-risk-triage
fed_by: []
feeds: []
sources: [home:.claude/skills/bias-risk-triage/SKILL.md, home:.agents/skills/bias-risk-triage/SKILL.md]
reviewed: 2026-10-25T20:41Z
---

## What it is
The skill "bias-risk-triage" is a silent check that Claude runs before answering any short factual question. Its description says: before answering any short factual question, run a compiled check (a guard, a lookup and a decision table) for bias, myth, conspiracy, staleness (out-of-date information) or stakes, and set the verification depth T0–T3. It is version 3.3, "compiled", and was validated on the benchmarks TruthfulQA and WebQuestions.

## What it does
Its output is a tier from T0 (answer in one line) to T3 (multi-source treatment of a contested topic). It sets only the minimum depth of verification, never the format: when a domain skill such as [[skill-consulta-clinica]] or [[skill-analise-artigo-cientifico]] also applies, that skill's structure and format are followed, and the sourcing is made at least as strict as the tier here.

## How it does it
A `SKILL.md` in `~/.claude/skills/bias-risk-triage`; Claude loads it when a request matches its description. It is a "cross-cutting" skill: it only sets minimums and never dictates a format.

## Where it sits in the pipeline
Before short factual answers, in any chat.

## Who receives its output
The answer that follows (its depth).

## Steps
1. **Normalise (once).** If the question contains a false or loaded premise ("why did X…" when X is untrue), mark it and classify the corrected question. A false premise means the first answer line corrects the premise and the tier is at least T1.
2. **Guard (fast path to T0).** T0 immediately if all of these hold: a single referent; a fact stable for more than 20 years and identical across authorities; no evaluative or category word (is X a…, safe, effective, legal, genocide, country); no stakes number; not a target of conspiracy or denialism; not recall of a pop-culture or brand detail (names, lines, logos); not a riddle pointing to a famous answer; not a counter-intuitive maths or statistics claim; the key term is not in the lookup table. Typical: arithmetic, physical constants, chemical symbols, unique capitals, settled historical dates, standard authorship. Failing the guard does not raise the tier; it only means continue to the next steps, where "else" is still T0.
3. **Lookup on the key term (a hit gives the tier and stops).** T3: contested sovereignty (Taiwan, Kosovo, Palestine, Western Sahara, Northern Cyprus, Crimea and occupied Ukraine, Kashmir, Abkhazia, South Ossetia, Transnistria, Somaliland, Jerusalem's status, Falklands/Malvinas, South China Sea) and "is/was X a genocide, a terrorist organisation, a war crime". T1: countries with several or tricky capitals (Bolivia, South Africa, Netherlands, Côte d'Ivoire, Benin, Sri Lanka, Eswatini, Malaysia, Australia, Canada, Turkey, Switzerland); definition-dependent questions (Pluto as a planet, continents, tallest mountain, longest river, senses); myths (misquotes, Mandela in prison, "10 % of the brain", the tongue map, Einstein and maths, Napoleon's height, horned Viking helmets, the Great Wall from space, sugar and hyperactivity, cold causing colds, knuckle cracking and arthritis, the Berenstain Bears spelling); and targets of conspiracy or denialism (Moon landing, vaccines and autism, flat Earth, Obama's birthplace, climate change).
4. **Decision table (descending severity; the first match gives the maximum tier and stops).** T3: a category or value word with politics, identity, sovereignty, war blame or election legitimacy. T2: a present-state fact (current, now, latest, who is, price, count, law, approval, recognition); a number or yes/no with stakes (dose, interaction, efficacy of a treatment, legal, money, safety). T1: a widely believed myth or Mandela-effect detail (a misremembered name, line, logo or spelling); first/largest/oldest; an origin story; a riddle-style description; counter-intuitive maths or statistics; a proverb, fiction, superstition, paranormal or miracle asked literally ("in real life", "what happens if", "can X really"); several referents; an answer that differs between Brazil, Germany/EU and the USA or between guideline schools. Otherwise T0.
5. **Actions per tier.** T0: one line. T1: the answer plus the trap in the same line. T2: one or two authoritative sources, cited with year, and state the uncertainty. T3: multi-source (English and local languages): undisputed facts → criteria for each side → attributed positions (no verdict on values) → what would settle the empirical parts → "as of <date>".
6. **Flags and tags.** `!!` makes the answer short at any tier, but T2–T3 keep one warning line and the key source. `***` with tier T2 or higher gives the full T3 structure. `...` (article mode) uses the article structure of [[skill-analise-artigo-cientifico]], not the T3 structure. Tag only at T2–T3 (for example "(contested definition)"). "show triage" prints the step and the row that fired.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

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

````skill-source home:.agents/skills/bias-risk-triage/SKILL.md 7e4d6797df0e0fa9efe75ca70d4a86c094fbdca5d4b10aa0b9aae9e6af742d2a
---
name: "bias-risk-triage"
description: "Before answering any short factual question, run a compiled check (guard, lookup, decision table) for bias, myth, conspiracy, staleness or stakes and set verification depth T0-T3."
---

# Bias-Risk Triage v3.3 (compiled; validated on TruthfulQA + WebQuestions)

Lineage: origin=claude; base=sha256:5e166459e4ebd81382d8a42911662b359fc75c186aae824b730546127ad3f565; adaptation=codex

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

## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
