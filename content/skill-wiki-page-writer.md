---
id: skill-wiki-page-writer
title: Skill: wiki-page-writer
aliases: [wiki-page-writer, wiki writer]
kind: skill
project: skills
status: active
since: 2026-10-24
location: home:.claude/skills/wiki-page-writer
fed_by: []
feeds: [wiki-content]
sources: [home:.claude/skills/wiki-page-writer/SKILL.md]
reviewed: 2026-10-24T18:10Z
---

## What it is
The skill "wiki-page-writer" is the method [[claude-code]] follows to write or update the pages of this wiki. A skill is a packaged set of instructions that Claude loads when a request matches its description, so that one kind of task is done the same careful way every time (see [[skills]] and the [[glossary]]). This one covers a single task: turning what exists in Giovanni's systems into true pages that a stranger can understand, in English, German and Brazilian Portuguese.

## What it does
It is used after any task that changed something in the systems, when the Stop hook (a small program that runs when Claude finishes a turn, see [[wiki-hook-stop]]) says "Wiki update needed", or when Giovanni asks for a wiki page. Its description also names the translation work (the German and Portuguese versions, `source_hash` fixes) as part of the task, and says what it is not for: general encyclopedia articles, code comments, `DESIGN.md`, decision records, memory entries, and debugging or explaining the wiki tool itself. Its role is "process": it owns the content of the pages and the three language versions; it defers to the wiki's own rules in [[wiki-content]] and to the checker [[wiki-check]], which enforces them; and it honours the reply-language rule and the plain-language rule. The skill produces pages in `~/dev/wiki/content`, published with `wiki publish`.

## How it does it
A `SKILL.md` file in `~/.claude/skills/wiki-page-writer`; Claude loads it when a request matches. It does not copy the format rules: the checker knows them and fails on a violation, so the skill tells Claude to read the current rules each time instead of trusting memory. It was built with [[skill-skill-forge]] from three competing versions. On two real tasks (a page for a new file, and an out-of-date page) the winning version was tested in a sandbox copy of the wiki; a reader with no context could then answer questions about the new page, which is the plain-language "paraphrase test".

## Where it sits in the pipeline
It is the writing step inside [[end-of-task]]: after the work is proven ([[skill-verification-before-completion]]) and before the memory report. [[skill-revisao-manutencao]] uses it for the pages a maintenance review changes, and [[skill-skill-forge]] uses it to write the page of every new skill.

## Who receives its output
The wiki content ([[wiki-content]]), which [[wiki-check]] then validates.

## Steps
1. **Guard the tree.** Always run `git status` in `~/dev/wiki`. `wiki publish` commits everything in `content/`, so a change Claude did not make (another Claude session or Giovanni) must never be published by it. Foreign changes in pages the task does not touch: write the pages but do not publish, and tell Giovanni. Foreign changes in pages the task needs: stop and ask. A check failure caused by their edit is reported, not fixed.
2. **Learn the current rules.** Read the wiki's `CLAUDE.md`, the page [[wiki-content]], the list of kinds and the list of acronyms, and run `wiki check --local` once to see the starting state.
3. **Find the work.** From the request, or from `wiki stale` and the hook message. The hook compares the code with the last publish, so it can flag pages that `wiki stale` calls fresh; then read the `git log` of the source repository since the page last changed. Decide whether the subject gets its own page or a line in a module page; edit an existing page instead of making a near-duplicate.
4. **Verify before writing.** Every sentence comes from something read or run in this session: code, configuration, `git log`, tests, a real run. Old page text is re-checked, because pinned versions, requirement ranges and file names go stale. Anything that cannot be verified is written as "not verified" or left out.
5. **Write for a stranger.** Purpose in everyday words first, then the mechanism; present tense, active voice, short words. First mention of a technical term, tool, internal name or acronym carries its meaning (acronyms with their full name) and a link to the wiki page, the glossary or an official page that was opened. Terms new readers most often miss (gate, requirement tag, status words, config file names) are defined on every page that uses them.
6. **Shape the page.** The header and five sections of [[wiki-content]]; `fed_by` and `feeds` agree in both directions; every source file is listed in `sources`; a new page is linked from at least two others. Skill pages hold the skill's own rules or steps in a `## Steps` section; process pages list their steps in order.
7. **Keep it private.** No secrets and no data about other people.
8. **Check for understanding.** Read the page as someone who knows nothing; for a new page, a reader with no context answers four questions about it, and every word it could not work out is fixed.
9. **Translate.** The German and Portuguese pages keep the English headings and links, translate the text and the definitions, and carry the `source_hash` of the English text.
10. **Check and fix.** `wiki check --local` until it passes; never loosen or bypass it.
11. **Publish.** `wiki publish -m "what changed"`. "review: no page change" is used only after reviewing the flagged pages and finding them right.
12. **Close.** `mem use` for the memory entries that shaped the work, then a short reply: pages changed, anything not verified, the check and publish results, and a `Verified by:` line.

## Notes
- Limits found in testing: the guard rule had to say "always run it" because runners skipped it when they expected a clean tree; fresh readers still missed a few terms (gate, finding codes), which is why the skill lists the usual misses.
- The description optimizer was run on 2026-10-24 (the script `run_loop.py` of the skill-creator skill: it plants the description as a temporary command, asks a nested `claude -p` session each test query, and counts whether the session calls the skill). The installed description scored 11 of 12 on the training queries and 8 of 8 on the held-out ones; its one miss was a request that only asked for the translations. A rewrite scored 12 of 12 and 8 of 8. Because the held-out scores tied, the two were compared on 16 new queries (8 that should trigger, 8 that should not, 3 runs each): the old description scored 14 of 16 (both misses were translation-only requests) and the new one 16 of 16, so the new one is installed. The sample is small. The test setup had to be isolated to be valid: the real skill and the hooks hidden, only `Skill` and `Read` allowed, and a match on any temporary command name, because parallel workers plant identical commands and the model picks one at random.
- Known gap: the wiki page [[skills]] has no registry table, although [[skill-skill-forge]] says to update one.
