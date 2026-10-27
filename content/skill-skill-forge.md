---
id: skill-skill-forge
title: Skill: skill-forge
aliases: [skill-forge]
kind: skill
project: skills
status: active
location: home:.claude/skills/skill-forge
fed_by: []
feeds: []
sources: [home:.claude/skills/skill-forge/SKILL.md, home:.agents/skills/skill-forge/SKILL.md]
reviewed: 2026-10-25T21:08Z
---

## What it is
The skill "skill-forge" is the full pipeline for creating or rebuilding a skill for Giovanni. Its description says: three competing versions, tests, compatibility checks with his other skills, then validation and packaging through skill-creator; use it when he asks to create, rebuild, optimise or "forge" a skill, turn a rule or workflow into a new skill, or wants tested or compared versions; for small changes to one skill (fix a line, rename, change the description, add an example) or just packaging a skill file, skill-creator alone is enough. Its philosophy: a skill is codified expert knowledge, so understand the domain and the user deeply, design an explicit architecture, then evaluate the result against the requirements (build → evaluate → refine, as in design-science research).

## Flow
trigger t1: Giovanni asks to create, rebuild or optimise a skill, or wants tested or compared versions | [[giovanni]]
step s1: Picks the mode first
step s2: Analyses the requirements, then designs the architecture
step s3: Builds three competing versions
step s4: Runs two evaluations
decide d1: Is any result unreproducible?
step s5: Gap resolution: finds out why and closes the gap
step s6: Compatibility layer: checks the winner against his other skills, settings and scheduled tasks
step s7: Synthesis, then hand-off to skill-creator to validate and package
product p1: A tested skill saved in the skills folder | [[skills]]
product p2: Proposed updates for every skill it affects | [[claude-ai-skills]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -yes-> s5
d1 -no-> s6
s5 -> s6
s6 -> s7
s7 -> p1
s7 -> p2

## What it does
It produces a tested skill that does not collide with Giovanni's other skills, settings or scheduled tasks, and proposes updates to every skill it affects.

## How it does it
A `SKILL.md` in `~/.claude/skills/skill-forge`; Claude loads it when a request matches its description. The finished skill is saved in `~/.claude/skills/<name>/`, with the wiki page [[skills]] updated as the registry.

## Where it sits in the pipeline
How every new or rebuilt skill is made.

## Who receives its output
The [[skills]] folder (and the Claude app's copies, [[claude-ai-skills]]).

## Steps
0. **Pick the mode first.** A new skill, a rebuild, "optimise", "forge", "test or compare versions", or a change that alters triggers or interoperation with other skills → the *full pipeline* (steps 1–6 here, then skill-creator for validation and packaging). A small edit to one skill (a line, an example, wording, a rename), "just write it", or packaging an existing SKILL.md → *skill-creator only*, unchanged, followed by a compatibility mini-check (re-read the interop header; run steps 3 and 6 of the compatibility layer only if the edit touches triggers, format or cross-references). Giovanni's explicit wording wins ("full forge" or "quick"); if unsure, state the assumed mode in one line and proceed.
1. **Requirements analysis.** Purpose, user, trigger situations, inputs, outputs, and the failure modes that matter most (ranked by cost of error). Existing assets: the user's saved preferences, memory notes, overlapping skills (avoid duplicates; decide what belongs in settings versus in a skill). Domain knowledge: the expert procedure as a step list, the decisions in it, and the facts or tables it needs.
2. **Architecture.** Choose the structure from the kind of knowledge: a procedure with fragile steps → exact steps or a script; judgement → a decision table or an ordered checklist; reference knowledge → a compact lookup table; style or format → a template plus one example. Write a short design note: modules, order, what goes in SKILL.md versus in references.
3. **Three versions.** V1 and V2 are two different design philosophies relevant to the problem (state each and why it fits). V3 is a literature review of the domain and of skill and prompt design, written as the evidence-based version, including any mathematical or algorithmic optimisation of its logic (ordering of checks, short-circuiting, lookup structures, minimal token use).
4. **Two evaluations.** A self-built one: a scenario set covering the requirements and the ranked failure modes, scored with a rubric (correctness, adherence to steps, output format, token cost). And a pre-existing one: find through research a published benchmark or standard checklist that fits the purpose and apply it unchanged.
5. **Unreproducible results (gap resolution).** When an output disagrees with an expected answer, label, verifier or the user's own example and you cannot explain why, do not record it as a "known gap" yet. (i) Pin the gap: state exactly what differs and list 2–3 hypotheses for the missing information. (ii) Ask the user targeted questions, one round of at most 3, offering the hypotheses as options; ask only what he can plausibly know. (iii) Research in parallel for the source of the expected answer and try to reproduce it. (iv) Resolve: encode the explanation that reproduces the result, labelled with its source ("per user", "per <document, year>", or "reproduces a quirk or bug in <reference>"); if his explanation conflicts with the evidence, show both and let him decide. (v) If still unresolved, keep the most defensible behaviour, flag the gap in the skill and the report, and list the open question for him.
6. **Compatibility layer (on the winning version, before delivery).** (a) *Inventory*: read the skills table in the wiki page [[skills]], then every one of his skills in full, his saved preferences and the scheduled tasks that invoke a skill; also work not live yet (open items, skill proposals waiting). A pending skill counts as existing: extend it instead of building a parallel one. (b) *Interop header*: one line under the title, `Interop: role = domain | cross-cutting; owns = <format / workflow / facts>; defers to = <skills>; honors = language rule, flags !! *** ...`. Domain skills own the format of their answers; cross-cutting skills only set minimums or safety rules. (c) *Conflict matrix* against each overlapping skill on: trigger overlap, reply and document language, depth flags and answer length, output format, evidence and date-checking depth, tools and environment, safety and destructive actions, cross-references (skill names must exist exactly), and duplication of always-on rules that belong in settings. (d) *Resolve by precedence, not by copying rules*: domain skill beats cross-cutting skill for format; the stricter rule wins for safety and sourcing; the user's explicit flag or message beats any skill default. (e) *Routing regression*: re-run a routing check with the full current skill list, including built-in ones: about 10 prompts that should trigger the new skill, 10 that should trigger neighbours, 5 that should trigger none; fix descriptions until each prompt lands on exactly one intended skill. (f) *Impact proposals*: for every existing skill the change affects, prepare a complete updated SKILL.md (reading the whole current file first), deliver the most critical first and list the rest as pending, writing each into `~/.claude/skills/<name>/SKILL.md`; the skills under `~/.claude/skills/synced/` come from the Claude app and are never edited here; built-in skills cannot be edited, so add the precedence line to his own skill or give him a one-line settings text to paste; changes to settings or scheduled-task prompts are suggested as exact text, never applied silently. (g) *Registry*: update the skills table in the wiki page [[skills]] (and its translations): one row per skill with name, role, owns, defers to, trigger summary, last changed and known conflicts resolved.
7. **Synthesis.** Compare the versions per requirement, pick the best, merge clearly superior elements from the others if they do not conflict, re-check the merged version against the self-built scenarios and then run the compatibility layer.
8. **Deliver (hand-off to skill-creator).** Validate: if skill-creator is available, copy each final skill folder to a scratch path and run its quick validation, fixing every error, and keep the original skill name for updates. Save (the Claude Code route): write the complete SKILL.md to `~/.claude/skills/<name>/` (plus the impact updates), then write or update the skill's wiki page with [[skill-wiki-page-writer]], and run `wiki publish` and `mem use`; Claude Code cannot save the Claude app's skill cards. Records: save a design note, the evaluation results and the compatibility report in the skill's wiki page, listing limitations, open gaps and pending impact proposals. Optionally run skill-creator's description optimiser on the final description after Giovanni approves, but only in isolation, or its score is invalid: on a patched copy of its scripts, with the nested `claude -p` limited to the tools `Skill` and `Read` and to the project's own settings (so it cannot edit, publish or start Giovanni's hooks), with the skill under test not installed in that project (the installed copy would be called instead of the temporary command) and his other skills copied in, counting a call to any temporary command of that skill as a trigger (parallel workers plant identical commands and the model picks one at random), and comparing the old and the new description on fresh queries when the held-out scores tie.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

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

````skill-source home:.agents/skills/skill-forge/SKILL.md 380625c475372530c07f8f3fd085ed044008eeca30fc275699ebd9b0818f30c1
---
name: "skill-forge"
description: "Full skill pipeline for Giovanni: three competing versions, tests, compatibility checks with his other skills, then validation and packaging through skill-creator. Use when he asks to create, rebuild, optimize or forge a skill, turn a rule or workflow into a new skill, or wants tested or compared versions. For small changes to one skill (fix a line, rename, change the description, add an example) or just packaging a skill file, skill-creator alone is enough."
---

Lineage: origin=claude; adaptation=codex; baseline recorded in manifest.json.



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
2. **Ask for complementary explanations:** ask the user targeted questions with the available user-input tool, one round, at most 3 questions, offering your hypotheses as options (e.g. "Is 'stock' meant to exclude ADRs and class B shares?"; "Where did the expected value come from?"; "Which guideline or version defines this?"). Ask only what the user can plausibly know; never ask him to do the research for you.
3. **Research in parallel:** while waiting, search for the source of the expected answer (reference code, dataset documentation, guideline text, benchmark repository) and try to reproduce it.
4. **Resolve:** encode the explanation that reproduces the result, labelled with its source ("per user", "per <doc, year>", or "reproduces a quirk/bug in <reference>"). If the user's explanation conflicts with the evidence, show both and let him decide.
5. **If still unresolved** (or the session is unattended): keep the most defensible behavior, flag the gap explicitly in the skill and the report, and list the open question for him.

## 4c. Compatibility layer (run on the winning version, before delivery)
Goal: a new or changed skill must not collide with his other skills, settings or scheduled tasks, and every affected skill gets an update proposal.

1. **Inventory.** Read the skills table in the wiki page `skills` (`~/dev/wiki/content/skills.md`). Then read every one of his skills in full (`~/.agents/skills/<name>/SKILL.md`), his saved preferences/settings rules, and scheduled tasks that invoke a skill (available scheduling tools, `crontab -l`, `systemctl --user list-timers`). Also read work that is not live yet: open items (`mem search skill`) and Codex skill proposals and the repository manifest. A pending skill or a project instruction set counts as existing: extend it instead of building a parallel one.
2. **Interop header.** Give the new skill one line under its title: `Interop: role = domain | cross-cutting; owns = <format / workflow / facts>; defers to = <skills>; honors = language rule, flags !! *** ...`. Domain skills own the format of their answers; cross-cutting skills (e.g. bias-risk-triage, browser-automacao-segura) only set minimums or safety rules and never dictate format.
3. **Conflict matrix.** Compare the new skill against each overlapping skill on these axes and record any clash:
   - trigger overlap (would both load for the same prompt?);
   - reply language and document language;
   - depth flags `!!` `***` `...` and answer length;
   - output format and structure;
   - evidence/sourcing depth and date-checking;
   - tools and environment (built-in browser vs the available browser tool, connectors, file locations);
   - safety and destructive actions;
   - cross-references (skills named inside other skills must exist with the exact name);
   - duplication of always-on rules that belong in settings.
4. **Resolve by precedence, not by copying rules:** domain skill > cross-cutting skill for format; stricter rule wins for safety and sourcing; the user's explicit flag or message beats any skill default. Write the precedence line into whichever skill needs it.
5. **Routing regression.** Re-run a routing check with the full, current skill list (including Anthropic's built-in skills such as skill-creator, docs, pdf): about 10 prompts that should trigger the new skill, 10 that should trigger neighbours, 5 that should trigger none. Fix descriptions until each prompt lands on exactly one intended skill.
6. **Impact proposals.** For every existing skill the change affects, prepare a complete updated SKILL.md (read the whole current file first). Deliver them the most critical first and list the rest as pending. Write complete managed files under `~/dev/codex-skills/skills/<name>/SKILL.md`; update a non-managed Codex skill only in its actual writable location. Skills under `~/.agents/skills/synced/` come from the claude.ai app and are never edited here. Built-in Anthropic skills cannot be edited: add the precedence line to his own skill instead, or give him a one-line settings text to paste. Changes to settings or scheduled-task prompts are suggested as exact text, never applied silently.
7. **Registry.** Update the skills table in the wiki page `skills` (and its `.de` and `.pt-BR` versions): one row per skill (name, role, owns, defers to, trigger summary, last changed, known conflicts resolved). The next forge run starts from it.

## 5. Synthesis
Compare versions per requirement. Pick the best; merge clearly superior elements from the others if they do not conflict. Re-check the merged version against the self-built scenarios, then run 4c.

## 6. Deliver (hand-off to skill-creator)
1. **Validate:** use the bundled Codex skill-creator at `$CODEX_HOME/skills/.system/skill-creator` (normally `~/.codex/skills/.system/skill-creator`), not a same-name Claude copy. Copy each final skill folder to a scratch path and run the bundled `scripts/quick_validate.py` on it; fix every error. Keep the original skill name for updates.
2. **Save (Codex route):** write the complete SKILL.md to its owned Codex repository folder (managed adaptations: `~/dev/codex-skills/skills/<name>/`) (plus the impact updates from 4c), then write or update the skill's wiki page with the skill `wiki-page-writer` (its `## Steps` section holds the skill's own rules; `wiki check` fails without it) and run `wiki publish` and `mem use`. Codex cannot save claude.ai skill cards.
3. **Records:** save a design note, the evaluation results and the compatibility report in the wiki page of the skill; list limitations, open gaps from 4b and pending impact proposals from 4c.
4. **Optional evaluation tooling:** use an actual supported runner only when requested and available. Do not translate Claude command names or flags into guessed Codex flags. Prefer an independent read-only subagent evaluation when available under the current delegation rules; give it the skill and realistic cases, not expected answers. Never install a skill into an evaluator that is meant to test a temporary version. Report routing results as manual or observed; structural validation is not a measured routing score.

## Codex ownership

Managed adaptations live in ~/dev/codex-skills/skills and are linked into ~/.agents/skills. Edit the repository source, validate, seal fingerprints and install through tools/skillsctl.py. Do not write through synced source copies or edit ~/.claude. Inspect the actual skill catalog (including bundled and plugin skills); do not assume Claude built-ins are present. Existing project guides named CLAUDE.md remain valid fallback references; prefer AGENTS.md where provided. For wiki updates, follow wiki-page-writer: investigate an isolated committed worktree and narrow reconciliation before declaring publication blocked. Preserve other text and staged work.
````
