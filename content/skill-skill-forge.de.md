---
id: skill-skill-forge
lang: de
source_hash: 31e8bea46470
title: Skill: skill-forge
---

## What it is
Die Skill „skill-forge“ ist die vollständige Pipeline, um für Giovanni eine Skill zu erstellen oder neu zu bauen. Ihre Beschreibung sagt: drei konkurrierende Fassungen, Tests, Verträglichkeitsprüfungen mit seinen anderen Skills, dann Validierung und Verpackung über skill-creator; verwenden, wenn er bittet, eine Skill zu erstellen, neu zu bauen, zu optimieren oder zu „schmieden“, eine Regel oder einen Ablauf in eine neue Skill zu verwandeln, oder getestete oder verglichene Fassungen will; für kleine Änderungen an einer Skill (eine Zeile korrigieren, umbenennen, die Beschreibung ändern, ein Beispiel ergänzen) oder nur das Verpacken einer Skill-Datei genügt skill-creator allein. Ihre Philosophie: Eine Skill ist kodifiziertes Expertenwissen, also die Domäne und den Nutzer tief verstehen, eine explizite Architektur entwerfen und dann das Ergebnis an den Anforderungen messen (bauen → bewerten → verfeinern, wie in der Design-Science-Forschung).

## What it does
Sie erzeugt eine getestete Skill, die nicht mit Giovannis anderen Skills, Einstellungen oder geplanten Aufgaben kollidiert, und schlägt Aktualisierungen für jede Skill vor, die sie berührt.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/skill-forge`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt. Die fertige Skill wird in `~/.claude/skills/<Name>/` gespeichert, mit der Wiki-Seite [[skills]] als aktualisiertem Register.

## Where it sits in the pipeline
So wird jede neue oder neu gebaute Skill gemacht.

## Who receives its output
Der Ordner [[skills]] (und die Kopien der Claude-App, [[claude-ai-skills]]).

## Steps
0. **Zuerst den Modus wählen.** Eine neue Skill, ein Neubau, „optimieren“, „schmieden“, „Fassungen testen oder vergleichen“ oder eine Änderung, die Auslöser oder das Zusammenspiel mit anderen Skills verändert → die *volle Pipeline* (hier die Schritte 1–6, dann skill-creator für Validierung und Verpackung). Eine kleine Änderung an einer Skill (eine Zeile, ein Beispiel, Formulierung, Umbenennung), „schreib es einfach“ oder das Verpacken einer vorhandenen SKILL.md → *nur skill-creator*, unverändert, gefolgt von einem kleinen Verträglichkeitscheck (den Interop-Kopf neu lesen; die Schritte 3 und 6 der Verträglichkeitsschicht nur ausführen, wenn die Änderung Auslöser, Format oder Querverweise berührt). Giovannis ausdrückliche Wortwahl gewinnt („full forge“ oder „quick“); ist man unsicher, den angenommenen Modus in einer Zeile nennen und weitermachen.
1. **Anforderungsanalyse.** Zweck, Nutzer, Auslösesituationen, Eingaben, Ausgaben und die wichtigsten Fehlerarten (nach Kosten des Fehlers gereiht). Vorhandene Bestände: die gespeicherten Vorlieben des Nutzers, Gedächtnisnotizen, überlappende Skills (Duplikate vermeiden; entscheiden, was in die Einstellungen und was in eine Skill gehört). Domänenwissen: das Expertenverfahren als Schrittliste, die darin enthaltenen Entscheidungen und die benötigten Fakten oder Tabellen.
2. **Architektur.** Die Struktur nach der Art des Wissens wählen: ein Verfahren mit fragilen Schritten → genaue Schritte oder ein Skript; Urteilsvermögen → eine Entscheidungstabelle oder eine geordnete Checkliste; Referenzwissen → eine kompakte Nachschlagetabelle; Stil oder Format → eine Vorlage plus ein Beispiel. Eine kurze Entwurfsnotiz schreiben: Module, Reihenfolge, was in SKILL.md und was in Referenzen steht.
3. **Drei Fassungen.** V1 und V2 sind zwei verschiedene, für das Problem relevante Entwurfsphilosophien (jede und warum sie passt nennen). V3 ist eine Literaturrecherche zur Domäne und zum Skill- und Prompt-Design, geschrieben als evidenzbasierte Fassung, einschließlich jeder mathematischen oder algorithmischen Optimierung ihrer Logik (Reihenfolge der Prüfungen, Kurzschlussauswertung, Nachschlagestrukturen, minimaler Token-Verbrauch).
4. **Zwei Bewertungen.** Eine selbstgebaute: ein Szenario-Set, das die Anforderungen und die gereihten Fehlerarten abdeckt, bewertet mit einem Raster (Korrektheit, Einhaltung der Schritte, Ausgabeformat, Token-Kosten). Und eine vorhandene: durch Recherche einen veröffentlichten Benchmark oder eine Standard-Checkliste finden, die zum Zweck passt, und sie unverändert anwenden.
5. **Nicht reproduzierbare Ergebnisse (Lückenauflösung).** Stimmt eine Ausgabe nicht mit einer erwarteten Antwort, einem Label, einem Prüfer oder Giovannis eigenem Beispiel überein und lässt sich der Grund nicht erklären, dann nicht sofort als „bekannte Lücke“ verbuchen. (i) Die Lücke festnageln: genau sagen, was abweicht, und 2–3 Hypothesen für die fehlende Information auflisten. (ii) Dem Nutzer gezielte Fragen stellen, eine Runde mit höchstens 3, mit den Hypothesen als Optionen; nur fragen, was er plausibel wissen kann. (iii) Parallel nach der Quelle der erwarteten Antwort recherchieren und versuchen, sie zu reproduzieren. (iv) Auflösen: die Erklärung kodieren, die das Ergebnis reproduziert, mit ihrer Quelle gekennzeichnet („laut Nutzer“, „laut <Dokument, Jahr>“ oder „reproduziert eine Eigenheit oder einen Fehler in <Referenz>“); widerspricht seine Erklärung der Evidenz, beides zeigen und ihn entscheiden lassen. (v) Bleibt es ungelöst, das vertretbarste Verhalten beibehalten, die Lücke in der Skill und im Bericht kennzeichnen und die offene Frage für ihn auflisten.
6. **Verträglichkeitsschicht (an der siegreichen Fassung, vor der Auslieferung).** (a) *Inventar*: die Skill-Tabelle in der Wiki-Seite [[skills]] lesen, dann jede seiner Skills vollständig, seine gespeicherten Vorlieben und die geplanten Aufgaben, die eine Skill aufrufen; auch noch nicht aktive Arbeit (offene Punkte, wartende Skill-Vorschläge). Eine ausstehende Skill zählt als vorhanden: erweitern statt eine parallele zu bauen. (b) *Interop-Kopf*: eine Zeile unter dem Titel, `Interop: role = domain | cross-cutting; owns = <Format / Ablauf / Fakten>; defers to = <Skills>; honors = language rule, flags !! *** ...`. Domänen-Skills besitzen das Format ihrer Antworten; übergreifende Skills setzen nur Mindestwerte oder Sicherheitsregeln. (c) *Konfliktmatrix* gegen jede überlappende Skill nach: Überlappung der Auslöser, Antwort- und Dokumentsprache, Tiefe-Flags und Antwortlänge, Ausgabeformat, Tiefe von Belegen und Datumsprüfung, Werkzeuge und Umgebung, Sicherheit und zerstörerische Aktionen, Querverweise (Skill-Namen müssen genau existieren) und Duplikate von Dauerregeln, die in die Einstellungen gehören. (d) *Nach Vorrang auflösen, nicht durch Kopieren von Regeln*: Domänen-Skill schlägt übergreifende Skill beim Format; die strengere Regel gewinnt bei Sicherheit und Quellen; das ausdrückliche Flag oder die Nachricht des Nutzers schlägt jeden Skill-Standard. (e) *Routing-Regression*: eine Routing-Prüfung mit der vollständigen aktuellen Skill-Liste einschließlich eingebauter erneut ausführen: etwa 10 Prompts, die die neue Skill auslösen sollen, 10, die Nachbarn auslösen sollen, 5, die keine auslösen sollen; Beschreibungen anpassen, bis jeder Prompt bei genau einer beabsichtigten Skill landet. (f) *Auswirkungsvorschläge*: für jede vorhandene Skill, die die Änderung berührt, eine vollständige aktualisierte SKILL.md vorbereiten (zuerst die ganze aktuelle Datei lesen), die wichtigsten zuerst abliefern und den Rest als ausstehend auflisten, jede nach `~/.claude/skills/<Name>/SKILL.md` geschrieben; die Skills unter `~/.claude/skills/synced/` stammen aus der Claude-App und werden hier nie bearbeitet; eingebaute Skills lassen sich nicht bearbeiten, also die Vorrangzeile in seine eigene Skill setzen oder ihm einen einzeiligen Einstellungstext zum Einfügen geben; Änderungen an Einstellungen oder Prompts geplanter Aufgaben werden als genauer Text vorgeschlagen, nie stillschweigend angewandt. (g) *Register*: die Skill-Tabelle in der Wiki-Seite [[skills]] (und ihren Übersetzungen) aktualisieren: eine Zeile pro Skill mit Name, Rolle, besitzt, verweist auf, Auslöser-Zusammenfassung, zuletzt geändert und gelöste bekannte Konflikte.
7. **Synthese.** Die Fassungen je Anforderung vergleichen, die beste wählen, eindeutig überlegene Elemente der anderen einfließen lassen, wenn sie nicht kollidieren, die verschmolzene Fassung erneut an den selbstgebauten Szenarien prüfen und dann die Verträglichkeitsschicht ausführen.
8. **Abliefern (Übergabe an skill-creator).** Validieren: Ist skill-creator verfügbar, jeden fertigen Skill-Ordner in einen Arbeitspfad kopieren und dessen Schnellvalidierung ausführen, jeden Fehler beheben und bei Aktualisierungen den ursprünglichen Skill-Namen behalten. Speichern (der Claude-Code-Weg): die vollständige SKILL.md nach `~/.claude/skills/<Name>/` schreiben (plus die Auswirkungsupdates), dann `wiki publish` und `mem use` ausführen; die Wiki-Seite des Skills schreibt oder aktualisiert [[skill-wiki-page-writer]]; Claude Code kann die Skill-Karten der Claude-App nicht speichern. Unterlagen: eine Entwurfsnotiz, die Bewertungsergebnisse und den Verträglichkeitsbericht auf der Wiki-Seite der Skill ablegen und Einschränkungen, offene Lücken und ausstehende Auswirkungsvorschläge auflisten. Optional den Beschreibungs-Optimierer von skill-creator auf die endgültige Beschreibung anwenden, nachdem Giovanni die Skill genehmigt hat, aber nur isoliert, sonst ist sein Ergebnis ungültig: auf einer angepassten Kopie seiner Skripte, mit der verschachtelten `claude -p`-Sitzung beschränkt auf die Werkzeuge `Skill` und `Read` und auf die eigenen Einstellungen des Projekts (damit sie nichts bearbeiten, veröffentlichen oder Giovannis Hooks starten kann), mit der zu testenden Skill nicht im Projekt installiert (die installierte Kopie würde statt des temporären Befehls aufgerufen) und seinen anderen Skills hineinkopiert, wobei der Aufruf irgendeines temporären Befehls dieser Skill als Auslösung zählt (parallele Arbeiter legen identische Befehle an und das Modell wählt zufällig einen), und mit einem Vergleich der alten und der neuen Beschreibung an frischen Anfragen, wenn die zurückgehaltenen Werte gleich sind.

## Notes

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

#### Claude: `home:.claude/skills/skill-forge/SKILL.md`

```skill-source home:.claude/skills/skill-forge/SKILL.md 7b21118be3e20f1e006bb4b541ab0d8a165e853b80e2ec75da804faf665ed5b0
---
name: "skill-forge"
description: "Full skill pipeline for Giovanni: three competing versions, tests, compatibility checks with his other skills, then validation and packaging through skill-creator. Use when he asks to create, rebuild, optimize or forge a skill, turn a rule or workflow into a new skill, or wants tested or compared versions. For small changes to one skill (fix a line, rename, change the description, add an example) or just packaging a skill file, skill-creator alone is enough."
---


# Skill Forge (knowledge engineering / design science)

Philosophy: a skill is codified expert knowledge. Understand the domain and the user deeply, design an explicit architecture, then evaluate the artifact against requirements (build -> evaluate -> refine, as in design-science research).

## 0. Mode (pick before anything else)
| Request | Mode |
|---|---|
| New skill, rebuild, "optimize", "forge", "test/compare versions", a change that alters triggers or interop with other skills | **Full pipeline:** steps 1-6 here, then skill-creator for validation and packaging (step 6) |
| Small edit to one skill (a line, an example, wording, rename), "just write it", packaging an existing SKILL.md | **skill-creator only**, unchanged; then the compatibility mini-check: re-read the interop header and run 4c steps 3 and 6 only if the edit touches triggers, format or cross-references |
His explicit wording wins ("full forge" or "quick" decides). If unsure, state the assumed mode in one line and proceed.

## 1. Requirements analysis
- Purpose, user, trigger situations, inputs, outputs, failure modes that matter most (rank by cost of error).
- Existing assets: the user's saved preferences, memory notes, other skills that overlap (avoid duplicates; decide what belongs in settings vs skill).
- Domain knowledge: the expert procedure as a step list; the decisions in it; the facts or tables it needs.

## 2. Architecture
Choose the structure from the knowledge type:
- procedure with fragile steps -> exact steps or script;
- judgment -> decision table or ordered checklist;
- reference knowledge -> compact lookup table;
- style/format -> template plus one example.
Write a short design note: modules, order, what is in SKILL.md vs references.

## 3. Three versions
- **V1, V2:** two different design philosophies relevant to this problem (state each and why it fits).
- **V3:** literature review of the domain and of skill/prompt design; write the evidence-based version, including any mathematical or algorithmic optimization of its logic (ordering of checks, short-circuiting, lookup structures, minimal token use).

## 4. Two evaluations
- **Self-built:** a scenario set covering the requirements and the ranked failure modes, scored with a rubric (correctness, adherence to steps, output format, token cost).
- **Pre-existing:** find through research a published benchmark or standard checklist that fits the purpose; apply it unchanged.

## 4b. Unreproducible results (gap resolution)
When an output disagrees with an expected answer, label, verifier or the user's own example and you cannot explain why, do not record it as a "known gap" yet:
1. **Pin the gap:** state exactly what differs (your value vs expected, which case, which step) and list 2-3 hypotheses for the missing information (a definition, filter, convention, data source, version, or an error in the reference).
2. **Ask for complementary explanations:** ask the user targeted questions with AskUserQuestion, one round, at most 3 questions, offering your hypotheses as options (e.g. "Is 'stock' meant to exclude ADRs and class B shares?"; "Where did the expected value come from?"; "Which guideline or version defines this?"). Ask only what the user can plausibly know; never ask him to do the research for you.
3. **Research in parallel:** while waiting, search for the source of the expected answer (reference code, dataset documentation, guideline text, benchmark repository) and try to reproduce it.
4. **Resolve:** encode the explanation that reproduces the result, labelled with its source ("per user", "per <doc, year>", or "reproduces a quirk/bug in <reference>"). If the user's explanation conflicts with the evidence, show both and let him decide.
5. **If still unresolved** (or the session is unattended): keep the most defensible behavior, flag the gap explicitly in the skill and the report, and list the open question for him.

## 4c. Compatibility layer (run on the winning version, before delivery)
Goal: a new or changed skill must not collide with his other skills, settings or scheduled tasks, and every affected skill gets an update proposal.

1. **Inventory.** Read the skills table in the wiki page `skills` (`~/dev/wiki/content/skills.md`). Then read every one of his skills in full (`~/.claude/skills/<name>/SKILL.md`), his saved preferences/settings rules, and scheduled tasks that invoke a skill (CronList, `crontab -l`, `systemctl --user list-timers`). Also read work that is not live yet: open items (`mem search skill`) and skill proposals waiting under `~/.claude/`. A pending skill or a project instruction set counts as existing: extend it instead of building a parallel one.
2. **Interop header.** Give the new skill one line under its title: `Interop: role = domain | cross-cutting; owns = <format / workflow / facts>; defers to = <skills>; honors = language rule, flags !! *** ...`. Domain skills own the format of their answers; cross-cutting skills (e.g. bias-risk-triage, browser-automacao-segura) only set minimums or safety rules and never dictate format.
3. **Conflict matrix.** Compare the new skill against each overlapping skill on these axes and record any clash:
   - trigger overlap (would both load for the same prompt?);
   - reply language and document language;
   - depth flags `!!` `***` `...` and answer length;
   - output format and structure;
   - evidence/sourcing depth and date-checking;
   - tools and environment (built-in browser vs Claude in Chrome, connectors, file locations);
   - safety and destructive actions;
   - cross-references (skills named inside other skills must exist with the exact name);
   - duplication of always-on rules that belong in settings.
4. **Resolve by precedence, not by copying rules:** domain skill > cross-cutting skill for format; stricter rule wins for safety and sourcing; the user's explicit flag or message beats any skill default. Write the precedence line into whichever skill needs it.
5. **Routing regression.** Re-run a routing check with the full, current skill list (including Anthropic's built-in skills such as skill-creator, docs, pdf): about 10 prompts that should trigger the new skill, 10 that should trigger neighbours, 5 that should trigger none. Fix descriptions until each prompt lands on exactly one intended skill.
6. **Impact proposals.** For every existing skill the change affects, prepare a complete updated SKILL.md (read the whole current file first). Deliver them the most critical first and list the rest as pending. Write each complete file to `~/.claude/skills/<name>/SKILL.md`. Skills under `~/.claude/skills/synced/` come from the claude.ai app and are never edited here. Built-in Anthropic skills cannot be edited: add the precedence line to his own skill instead, or give him a one-line settings text to paste. Changes to settings or scheduled-task prompts are suggested as exact text, never applied silently.
7. **Registry.** Update the skills table in the wiki page `skills` (and its `.de` and `.pt-BR` versions): one row per skill (name, role, owns, defers to, trigger summary, last changed, known conflicts resolved). The next forge run starts from it.

## 5. Synthesis
Compare versions per requirement. Pick the best; merge clearly superior elements from the others if they do not conflict. Re-check the merged version against the self-built scenarios, then run 4c.

## 6. Deliver (hand-off to skill-creator)
1. **Validate:** if skill-creator is available, copy each final skill folder to a scratch path and run its `scripts/quick_validate.py` on it; fix every error. Keep the original skill name for updates.
2. **Save (Claude Code route):** write the complete SKILL.md to `~/.claude/skills/<name>/` (plus the impact updates from 4c), then write or update the skill's wiki page with the skill `wiki-page-writer` (its `## Steps` section holds the skill's own rules; `wiki check` fails without it) and run `wiki publish` and `mem use`. Claude Code cannot save claude.ai skill cards.
3. **Records:** save a design note, the evaluation results and the compatibility report in the wiki page of the skill; list limitations, open gaps from 4b and pending impact proposals from 4c.
4. **Optional:** skill-creator's description optimizer (`run_loop.py`, needs `claude -p`) on the final description after he approves the skill. Run it only in isolation, or its score is invalid (found 2026-10-24): on a patched copy of the scripts (never edit the installed skill-creator), the nested `claude -p` runs with `--setting-sources project --tools Skill,Read --strict-mcp-config` so it cannot edit, publish or fire his hooks; the skill under test is NOT installed in that project (the installed copy would be called instead of the temporary command) while his other skills are copied in as project skills; a call to any `<name>-skill-*` command counts as a trigger (parallel workers plant identical commands side by side and the model picks one at random); and when the held-out scores tie, compare the old and the new description on fresh queries before installing either.
```


#### Codex: `home:.agents/skills/skill-forge/SKILL.md`

```skill-source home:.agents/skills/skill-forge/SKILL.md 6d0de4fdaf505022d5d1ff447b0ceab1a81fe5b3a028427d458675453b7ce529
---
name: "skill-forge"
description: "Full skill pipeline for Giovanni: three competing versions, tests, compatibility checks with his other skills, then validation and packaging through skill-creator. Use when he asks to create, rebuild, optimize or forge a skill, turn a rule or workflow into a new skill, or wants tested or compared versions. For small changes to one skill (fix a line, rename, change the description, add an example) or just packaging a skill file, skill-creator alone is enough."
---


# Skill Forge (knowledge engineering / design science)

Philosophy: a skill is codified expert knowledge. Understand the domain and the user deeply, design an explicit architecture, then evaluate the artifact against requirements (build -> evaluate -> refine, as in design-science research).

## 0. Mode (pick before anything else)
| Request | Mode |
|---|---|
| New skill, rebuild, "optimize", "forge", "test/compare versions", a change that alters triggers or interop with other skills | **Full pipeline:** steps 1-6 here, then skill-creator for validation and packaging (step 6) |
| Small edit to one skill (a line, an example, wording, rename), "just write it", packaging an existing SKILL.md | **skill-creator only**, unchanged; then the compatibility mini-check: re-read the interop header and run 4c steps 3 and 6 only if the edit touches triggers, format or cross-references |
His explicit wording wins ("full forge" or "quick" decides). If unsure, state the assumed mode in one line and proceed.

## 1. Requirements analysis
- Purpose, user, trigger situations, inputs, outputs, failure modes that matter most (rank by cost of error).
- Existing assets: the user's saved preferences, memory notes, other skills that overlap (avoid duplicates; decide what belongs in settings vs skill).
- Domain knowledge: the expert procedure as a step list; the decisions in it; the facts or tables it needs.

## 2. Architecture
Choose the structure from the knowledge type:
- procedure with fragile steps -> exact steps or script;
- judgment -> decision table or ordered checklist;
- reference knowledge -> compact lookup table;
- style/format -> template plus one example.
Write a short design note: modules, order, what is in SKILL.md vs references.

## 3. Three versions
- **V1, V2:** two different design philosophies relevant to this problem (state each and why it fits).
- **V3:** literature review of the domain and of skill/prompt design; write the evidence-based version, including any mathematical or algorithmic optimization of its logic (ordering of checks, short-circuiting, lookup structures, minimal token use).

## 4. Two evaluations
- **Self-built:** a scenario set covering the requirements and the ranked failure modes, scored with a rubric (correctness, adherence to steps, output format, token cost).
- **Pre-existing:** find through research a published benchmark or standard checklist that fits the purpose; apply it unchanged.

## 4b. Unreproducible results (gap resolution)
When an output disagrees with an expected answer, label, verifier or the user's own example and you cannot explain why, do not record it as a "known gap" yet:
1. **Pin the gap:** state exactly what differs (your value vs expected, which case, which step) and list 2-3 hypotheses for the missing information (a definition, filter, convention, data source, version, or an error in the reference).
2. **Ask for complementary explanations:** ask the user targeted questions with AskUserQuestion, one round, at most 3 questions, offering your hypotheses as options (e.g. "Is 'stock' meant to exclude ADRs and class B shares?"; "Where did the expected value come from?"; "Which guideline or version defines this?"). Ask only what the user can plausibly know; never ask him to do the research for you.
3. **Research in parallel:** while waiting, search for the source of the expected answer (reference code, dataset documentation, guideline text, benchmark repository) and try to reproduce it.
4. **Resolve:** encode the explanation that reproduces the result, labelled with its source ("per user", "per <doc, year>", or "reproduces a quirk/bug in <reference>"). If the user's explanation conflicts with the evidence, show both and let him decide.
5. **If still unresolved** (or the session is unattended): keep the most defensible behavior, flag the gap explicitly in the skill and the report, and list the open question for him.

## 4c. Compatibility layer (run on the winning version, before delivery)
Goal: a new or changed skill must not collide with his other skills, settings or scheduled tasks, and every affected skill gets an update proposal.

1. **Inventory.** Read the skills table in the wiki page `skills` (`~/dev/wiki/content/skills.md`). Then read every one of his skills in full (`~/.Codex/skills/<name>/SKILL.md`), his saved preferences/settings rules, and scheduled tasks that invoke a skill (CronList, `crontab -l`, `systemctl --user list-timers`). Also read work that is not live yet: open items (`mem search skill`) and skill proposals waiting under `~/.Codex/`. A pending skill or a project instruction set counts as existing: extend it instead of building a parallel one.
2. **Interop header.** Give the new skill one line under its title: `Interop: role = domain | cross-cutting; owns = <format / workflow / facts>; defers to = <skills>; honors = language rule, flags !! *** ...`. Domain skills own the format of their answers; cross-cutting skills (e.g. bias-risk-triage, browser-automacao-segura) only set minimums or safety rules and never dictate format.
3. **Conflict matrix.** Compare the new skill against each overlapping skill on these axes and record any clash:
   - trigger overlap (would both load for the same prompt?);
   - reply language and document language;
   - depth flags `!!` `***` `...` and answer length;
   - output format and structure;
   - evidence/sourcing depth and date-checking;
   - tools and environment (built-in browser vs Codex in Chrome, connectors, file locations);
   - safety and destructive actions;
   - cross-references (skills named inside other skills must exist with the exact name);
   - duplication of always-on rules that belong in settings.
4. **Resolve by precedence, not by copying rules:** domain skill > cross-cutting skill for format; stricter rule wins for safety and sourcing; the user's explicit flag or message beats any skill default. Write the precedence line into whichever skill needs it.
5. **Routing regression.** Re-run a routing check with the full, current skill list (including Anthropic's built-in skills such as skill-creator, docs, pdf): about 10 prompts that should trigger the new skill, 10 that should trigger neighbours, 5 that should trigger none. Fix descriptions until each prompt lands on exactly one intended skill.
6. **Impact proposals.** For every existing skill the change affects, prepare a complete updated SKILL.md (read the whole current file first). Deliver them the most critical first and list the rest as pending. Write each complete file to `~/.Codex/skills/<name>/SKILL.md`. Skills under `~/.Codex/skills/synced/` come from the claude.ai app and are never edited here. Built-in Anthropic skills cannot be edited: add the precedence line to his own skill instead, or give him a one-line settings text to paste. Changes to settings or scheduled-task prompts are suggested as exact text, never applied silently.
7. **Registry.** Update the skills table in the wiki page `skills` (and its `.de` and `.pt-BR` versions): one row per skill (name, role, owns, defers to, trigger summary, last changed, known conflicts resolved). The next forge run starts from it.

## 5. Synthesis
Compare versions per requirement. Pick the best; merge clearly superior elements from the others if they do not conflict. Re-check the merged version against the self-built scenarios, then run 4c.

## 6. Deliver (hand-off to skill-creator)
1. **Validate:** if skill-creator is available, copy each final skill folder to a scratch path and run its `scripts/quick_validate.py` on it; fix every error. Keep the original skill name for updates.
2. **Save (Codex route):** write the complete SKILL.md to `~/.Codex/skills/<name>/` (plus the impact updates from 4c), then write or update the skill's wiki page with the skill `wiki-page-writer` (its `## Steps` section holds the skill's own rules; `wiki check` fails without it) and run `wiki publish` and `mem use`. Codex cannot save claude.ai skill cards.
3. **Records:** save a design note, the evaluation results and the compatibility report in the wiki page of the skill; list limitations, open gaps from 4b and pending impact proposals from 4c.
4. **Optional:** skill-creator's description optimizer (`run_loop.py`, needs `Codex -p`) on the final description after he approves the skill. Run it only in isolation, or its score is invalid (found 2026-10-24): on a patched copy of the scripts (never edit the installed skill-creator), the nested `Codex -p` runs with `--setting-sources project --tools Skill,Read --strict-mcp-config` so it cannot edit, publish or fire his hooks; the skill under test is NOT installed in that project (the installed copy would be called instead of the temporary command) while his other skills are copied in as project skills; a call to any `<name>-skill-*` command counts as a trigger (parallel workers plant identical commands side by side and the model picks one at random); and when the held-out scores tie, compare the old and the new description on fresh queries before installing either.
```
