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
sources: [home:.claude/skills/wiki-page-writer/SKILL.md, home:.agents/skills/wiki-page-writer/SKILL.md]
reviewed: 2026-10-25T20:41Z
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
3. **Find the work.** From the request, or from `wiki stale` (pages with a source changed after their `reviewed` time; it exits 1 when it lists any) and the hook message (it compares the code with the last publish, so it also sees what `wiki stale` cannot: a change in the same minute as a review, and new files). For each listed page read the `git log` of the source repository since the page's `reviewed` time, or the file itself for a source outside git. Decide whether the subject gets its own page or a line in a module page; edit an existing page instead of making a near-duplicate.
4. **Verify before writing.** Every sentence comes from something read or run in this session: code, configuration, `git log`, tests, a real run. Old page text is re-checked, because pinned versions, requirement ranges and file names go stale. Anything that cannot be verified is written as "not verified" or left out. A page compared with its sources in this session and found right, or made right, gets a new `reviewed` time (step 6); a page that was not compared does not.
5. **Write for a stranger.** Purpose in everyday words first, then the mechanism; present tense, active voice, short words. First mention of a technical term, tool, internal name or acronym carries its meaning (acronyms with their full name) and a link to the wiki page, the glossary or an official page that was opened. Terms new readers most often miss (gate, requirement tag, status words, config file names) are defined on every page that uses them.
6. **Shape the page.** The header and five sections of [[wiki-content]]; `fed_by` and `feeds` agree in both directions; every source file is listed in `sources`; a new page is linked from at least two others; `reviewed` is set to the current UTC time as the last act of verifying the page (never in the future, never on a page that was not compared with its sources, never on many pages at once to empty `wiki stale`). Skill pages hold the skill's own rules or steps in a `## Steps` section; process pages list their steps in order.
7. **Keep it private.** No secrets and no data about other people.
8. **Check for understanding.** Read the page as someone who knows nothing; for a new page, a reader with no context answers four questions about it, and every word it could not work out is fixed.
9. **Translate.** The German and Portuguese pages keep the English headings and links, translate the text and the definitions, and carry the `source_hash` of the English text.
10. **Check and fix.** `wiki check --local` until it passes; never loosen or bypass it.
11. **Publish.** `wiki publish -m "what changed"`. A page that was reviewed and found right still changes: its `reviewed` time, and that edit is the review. "review: no page change" is used only for changes that no page describes, for example a data file.
12. **Close.** `mem use` for the memory entries that shaped the work, then a short reply: pages changed, anything not verified, the check and publish results, and a `Verified by:` line.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.
- Limits found in testing: the guard rule had to say "always run it" because runners skipped it when they expected a clean tree; fresh readers still missed a few terms (gate, finding codes), which is why the skill lists the usual misses.
- The description optimizer was run on 2026-10-24 (the script `run_loop.py` of the skill-creator skill: it plants the description as a temporary command, asks a nested `claude -p` session each test query, and counts whether the session calls the skill). The installed description scored 11 of 12 on the training queries and 8 of 8 on the held-out ones; its one miss was a request that only asked for the translations. A rewrite scored 12 of 12 and 8 of 8. Because the held-out scores tied, the two were compared on 16 new queries (8 that should trigger, 8 that should not, 3 runs each): the old description scored 14 of 16 (both misses were translation-only requests) and the new one 16 of 16, so the new one is installed. The sample is small. The test setup had to be isolated to be valid: the real skill and the hooks hidden, only `Skill` and `Read` allowed, and a match on any temporary command name, because parallel workers plant identical commands and the model picks one at random.
- The rule about `reviewed` was added on 2026-10-24, after the rewrite of all pages hid unreviewed source changes from `wiki stale` ([[wiki-stale]]): the skill now sets the time only for pages it really compared, and never in bulk.
- Known gap: the wiki page [[skills]] has no registry table, although [[skill-skill-forge]] says to update one.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/wiki-page-writer/SKILL.md`

```skill-source home:.claude/skills/wiki-page-writer/SKILL.md 391d37651277ea19e86770aad05e6d9c12b5371266e883517b7e64e55207f9d6
---
name: wiki-page-writer
description: "Use this skill for any work on the content of Giovanni's wiki (~/dev/wiki, content/): writing, updating, translating or retiring a page. This covers the English page and its .de and .pt-BR versions (translations, source_hash fixes, wiki check failures in page files), and wiki publish. Trigger after finishing a task that changed something in his systems (project, program, module, function, script, skill, hook, service, data store, process, decision), when the Stop hook says 'Wiki update needed', or when he asks for a wiki page (página da wiki). Pages are written for a reader who knows nothing about the system. Not for general encyclopedia articles, code comments, DESIGN.md, ADRs, memory entries, or debugging and explaining the wiki tool itself."
---

# Wiki page writer (wiki-page-writer)

Lineage: origin=code; base=none

Interop: role = process; owns = the content of wiki pages and their three-language versions; defers to = `~/dev/wiki/CLAUDE.md` and the page `wiki-content` (format), `wiki check` (the rules, enforced), verification-before-completion (the closing `Verified by:`), revisao-manutencao (it calls this skill's publish step at the end of a review), skill-forge (creating or changing a skill; this skill then writes the skill's page); honors = reply-language rule, plain-language rule, work.verified-by, policy.third-party-data, safety.ask-before-outward.

Pages say what exists, to a stranger. The rules of format are not copied here: `wiki check` knows them and fails on a violation; `wiki-content` describes them. This skill is the method for writing true, understandable pages and for not breaking the publishing flow.

## Steps

1. **Guard the tree. Always run it, even when you expect a clean tree** (a clean tree is only known by looking). `git -C ~/dev/wiki status --short`. `wiki publish` commits all of `content/`, so changes you did not make are not yours to publish. If there are changes you did not make (another Claude session or Giovanni editing):
   - name the files to Giovanni and do not publish, stage or reset anything;
   - if the foreign changes are in pages your task does not touch, you may write your own pages (so the work is ready) but you must not run `wiki publish`; tell Giovanni that publishing waits until the other edit is committed or discarded;
   - if they are in pages you need to change, stop and ask;
   - a failing `wiki check --local` caused by their edit (for example outdated translations of their page) is theirs: report it, do not fix it.
2. **Learn the current rules.** Read `~/dev/wiki/CLAUDE.md` and `content/wiki-content.md`, and skim `content/_kinds.json` and `content/_acronyms.tsv`. Do not rely on memory or on this file for header fields, kinds or required sections; they change. Run `wiki check --local` once now: a failing baseline is a problem to report, not to hide.
3. **Find the work.** Take the subject from the request, or run `wiki stale` (it lists the pages with a source changed after their `reviewed` time and exits 1 when it lists any) and read the Stop hook message (it lists pages to update and files "no page covers"; it compares the code with the last publish, so it also sees what `wiki stale` cannot: a change in the same minute as a review, and new files). For each listed page run `git log` in the source repository since the page's `reviewed` time (for a source outside git, read the file) and read what changed. For each subject decide the granularity (rule D11 in the wiki CLAUDE.md): own page, or a line in a module page's `## Functions`. Edit an existing page rather than create a near-duplicate (`ls content`, grep for the name and its aliases).
4. **Verify before you write.** Every sentence must come from something read or run in this session: the code and config in the `sources` repositories, `git log` for what changed and when, tests and requirement IDs, a real run (`--help`, a dry run, `systemctl status`). Re-check old page text before keeping it; older pages go stale (a pinned version, a requirement range, a renamed file are the usual casualties). Copy numbers, versions, paths and IDs from the source. Label intent and plans as such. If you cannot verify a point, write "not verified" or leave it out; never fill it with a guess. Do not claim to have read or run what you did not. A page you compared with its sources this session, and found right or made right, gets a new `reviewed` time (step 6); a page you did not compare does not.
5. **Write for a stranger.** The reader has never seen the system and does not know its vocabulary (Diátaxis: reference describes neutrally and mirrors the system's structure; explanation adds the why and the connections; each page here is a short mix, so keep the what in "What it does" and "How it does it", and the why in one sentence next to the step it explains).
   - Open with the purpose in everyday words, then the mechanism. Present tense, active voice, short words, one idea per sentence, no hidden verbs ("analyze", not "conduct an analysis"). No "obviously", "simply", "just".
   - First mention of a technical term, tool, internal name, acronym or abbreviation: give its meaning in the text (acronym: the full name next to it; `wiki check` fails when an acronym from `_acronyms.tsv` has no full name within 100 characters of its first use on the page), and link it to the wiki page or [[glossary]] entry that explains it more, or to an official page you opened this session. A definition may not contain another undefined term. Never leave the explanation to the link alone.
   - Terms that fresh readers most often miss, define them on every page that uses them: gate, requirement tag (`REQ <ID>`), finding or error codes, the status words (`ok`, `aviso`, `falha`, `pulado`), config file names and formats, hook, report file, "local mode", names of other pages used as nouns.
   - A term that deserves a definition and has none: add it to the glossary (kind `reference`), in three languages; if only this page uses it, define it inline.
   - Give a real example (input and output from the code or tests) where the rule is not obvious. Say why a step exists when the reason is not obvious.
   - Neutral: no promotion ("robust", "seamless"), no opinion. The strength of the wording matches the evidence ("does" only for what you verified).
6. **Page shape.** Header and the five sections as in `wiki-content`, plus `## Steps` where it applies. Edges: `fed_by` and `feeds` agree in both directions (edit the neighbour in the same change). `sources` lists `repo:path` for every file the claims come from (this is the citation system and what makes `wiki stale` work). `reviewed` is required on every page (rule CO-6): the current UTC time as `date -u +%Y-%m-%dT%H:%MZ`, set as the last act of verifying the page, never in the future. It is what `wiki stale` compares the sources with. Never set it on a page you did not compare with its sources, and never on many pages at once to empty `wiki stale`. Rules and preferences are linked by `#code` in `memory:`, never copied. A new page must be linked from at least two others (`wiki check` enforces it).
   A new page must be linked from at least two others: link it from the neighbour it belongs to and add a glossary entry or another real link. Leave `memory:` empty when no entry applies.
   | Kind | Must also contain |
   |---|---|
   | skill | `## Steps` holding the skill's own rules or steps (enforced), a plain definition of "a skill" in two sentences, what it is for, when it triggers (from its description) and what it does not cover, what it produces, where it lives, limits. Read the skill's `SKILL.md` first; never describe it from name or description alone. Role, owns, defers-to and honors from its Interop line. |
   | process | `## Steps`, in order, each step naming the actor and the output. |
   | module | `## Functions`: one line per function. |
   | project | what it is for, who uses it, repository, the quality gate, where to start. |
   | decision | the decision, the reasons, what was rejected, a link to the ADR. |
   | external | what depends on it and what breaks if it is gone. |
7. **Privacy.** No secrets, keys, tokens or `.env` contents (name the file, never the value). No clinical, secret or contact data about other people, in any language. `wiki check` scans, but you are the first filter.
8. **Check for understanding.** Before translating, read the page as someone who knows nothing: could they say what the subject is after "What it is" alone? Is any word used before it is explained? Does any sentence depend on another page without a link and a one-clause reminder? Rewrite until yes. (Plain-language practice, paraphrase testing from digital.gov: if a fresh reader cannot restate it, rewrite it.) For a new or heavily changed page, when a subagent is available, give a no-context reader only the page and ask four questions (what is it for, what happens in the failure case, how is it configured, which words could you not work out); fix every word it lists. In tests this removed the gaps the author had stopped seeing.
9. **Translate.** For each changed English page write `<id>.de.md` and `<id>.pt-BR.md` with the header (`id`, `lang`, `source_hash`, `title`) and the same section headings in English (the headings are keys); translate the text, not word by word. Keep identifiers, file names, commands, `[[id]]` links and requirement IDs. Definitions and acronym expansions are translated too (acronym kept, full name in the language of the page). Use the terms neighbouring translated pages already use. Never edit English without redoing both translations in the same change.
10. **Check, fix, hash.** Run `wiki check --local`. It prints the expected `source_hash` for every outdated translation: set it only after the translation really matches the English. Fix every problem it reports (do not bypass or loosen the check). Run it again until it passes.
11. **Publish.** `wiki publish -m "what changed"` (check, build, commit `content/`, push). A page you reviewed and found right still changes: its `reviewed` time, and that edit is the review. `wiki publish -m "review: no page change"` is only for changes that no page describes (for example a data file); never to silence the Stop hook over pages you did not review. Never edit `events/` or `views/`; never force-push.
12. **Close.** `wiki stale` shows nothing for what you touched. `mem use REF1,REF2 --note "how"` for the entries that shaped the work. Reply in Giovanni's language, in a short list: pages created or changed (all three languages count as one), any "not verified" gap, terms added to the glossary, the `wiki check` and `wiki publish` result stated plainly including a failure, and end with `Verified by:` (what ran: `wiki check --local`, `wiki stale`, the sources read; what could not be checked, for example the live site in a browser). Do not paste the pages into chat unless asked.

### Complete skill content (mandatory for `kind: skill`)
Before generating or updating a skill page, locate the real `SKILL.md` using its `sources`, `location`, and the installed skill folders. Read the whole file, not only its name, frontmatter description, or an older wiki summary. If Claude and Codex have separate installed versions, identify and include both, clearly labelled; never merge away their differences. If a source is unavailable, report the gap rather than claiming completeness.

Keep the readable explanation and translated Steps, and append the complete original `SKILL.md` under `## Notes`, including the full frontmatter description, instructions, examples, limits and reference paths. A summary or link alone does not satisfy this rule. Preserve the original source language in all three wiki versions, with a translated introduction explaining that it is the authoritative source; the surrounding explanation remains translated. Do not copy referenced auxiliary files unless they are part of the requested documentation scope, and do not describe the snapshot as containing those files.

For each source, use a Markdown fenced block whose info string is `skill-source <repo:path/to/SKILL.md> <sha256>`; the fence must be longer than any run of backticks inside the source. The SHA-256 fingerprint is computed from the entire copied text, with line endings changed to LF and a final newline added only if absent. List every copied file in `sources`. Refresh the copy and fingerprint whenever its source changes. Never omit content to pass privacy checks: report the blocked source instead. `wiki check --local` must confirm each English copy matches its source, and every translation must retain exactly the same originals. Checks without local files validate the fingerprint and presence, but cannot prove freshness against an unavailable source.

## Never

- Fabricate a fact, number, path, requirement ID, quotation or command output; present a plan or a guess as how the system works; copy an old claim without re-checking it.
- Set `reviewed` on a page you did not compare with its sources, or on many pages at once to clear `wiki stale`; publish over changes that are not yours; publish a page that `wiki check` rejects; use `review: no page change` for pages you did not review.
- Leave an acronym, abbreviation or internal name without its meaning at first use, in any language; rely on a link alone to explain a term; link a URL you did not open.
- Put secrets, other people's data, rules or preferences into a page; add code in a new language.

## Testing this skill

Scenarios the skill must handle: (1) a new function with a real source file; (2) a skill page (needs `## Steps`); (3) a stale page after a code change (a version or count changed); (4) a claim that cannot be verified; (5) another session's uncommitted changes in `content/`; (6) acronym-heavy subject; (7) a source containing a secret or personal data; (8) the Stop hook lists pages that are already correct. Pass means: `wiki check` passes, every claim traces to a source read, nothing outside the task is published, and a stranger can paraphrase the page.
```


#### Codex: `home:.agents/skills/wiki-page-writer/SKILL.md`

````skill-source home:.agents/skills/wiki-page-writer/SKILL.md ca0c4cb11bce73beb9d565c9cb3356d0067d68d8a43830e1eec1ed4c92d3149a
---
name: wiki-page-writer
description: "Use this skill for any work on the content of Giovanni's wiki (~/dev/wiki, content/): writing, updating, translating or retiring a page. This covers the English page and its .de and .pt-BR versions (translations, source_hash fixes, wiki check failures in page files), and wiki publish. Trigger after finishing a task that changed something in his systems (project, program, module, function, script, skill, hook, service, data store, process, decision), when the Stop hook says 'Wiki update needed', or when he asks for a wiki page (página da wiki). Pages are written for a reader who knows nothing about the system. Not for general encyclopedia articles, code comments, DESIGN.md, ADRs, memory entries, or debugging and explaining the wiki tool itself."
---

# Wiki page writer (wiki-page-writer)

Lineage: origin=claude; base=sha256:391d37651277ea19e86770aad05e6d9c12b5371266e883517b7e64e55207f9d6; adaptation=codex

Interop: role = process; owns = the content of wiki pages and their three-language versions; defers to = `~/dev/wiki/CLAUDE.md` and the page `wiki-content` (format), `wiki check` (the rules, enforced), verification-before-completion (the closing `Verified by:`), revisao-manutencao (it calls this skill's publish step at the end of a review), skill-forge (creating or changing a skill; this skill then writes the skill's page); honors = reply-language rule, plain-language rule, work.verified-by, policy.third-party-data, safety.ask-before-outward.

Pages say what exists, to a stranger. The rules of format are not copied here: `wiki check` knows them and fails on a violation; `wiki-content` describes them. This skill is the method for writing true, understandable pages and for not breaking the publishing flow.

## Steps

1. **Guard the tree. Always run it, even when you expect a clean tree** (a clean tree is only known by looking). `git -C ~/dev/wiki status --short`. `wiki publish` commits all of `content/`, so changes you did not make are not yours to publish. If there are changes you did not make (another assistant session or Giovanni editing):
   - name the files to Giovanni and do not publish, stage or reset anything;
   - if the foreign changes are in pages your task does not touch, you may write your own pages (so the work is ready) but you must not run `wiki publish`; tell Giovanni that publishing waits until the other edit is committed or discarded;
   - if they are in pages you need to change, stop and ask;
   - a failing `wiki check --local` caused by their edit (for example outdated translations of their page) is theirs: report it, do not fix it.
2. **Learn the current rules.** Read `~/dev/wiki/CLAUDE.md` and `content/wiki-content.md`, and skim `content/_kinds.json` and `content/_acronyms.tsv`. Do not rely on memory or on this file for header fields, kinds or required sections; they change. Run `wiki check --local` once now: a failing baseline is a problem to report, not to hide.
3. **Find the work.** Take the subject from the request, or run `wiki stale` (it lists the pages with a source changed after their `reviewed` time and exits 1 when it lists any) and read the Stop hook message (it lists pages to update and files "no page covers"; it compares the code with the last publish, so it also sees what `wiki stale` cannot: a change in the same minute as a review, and new files). For each listed page run `git log` in the source repository since the page's `reviewed` time (for a source outside git, read the file) and read what changed. For each subject decide the granularity (rule D11 in the wiki CLAUDE.md): own page, or a line in a module page's `## Functions`. Edit an existing page rather than create a near-duplicate (`ls content`, grep for the name and its aliases).
4. **Verify before you write.** Every sentence must come from something read or run in this session: the code and config in the `sources` repositories, `git log` for what changed and when, tests and requirement IDs, a real run (`--help`, a dry run, `systemctl status`). Re-check old page text before keeping it; older pages go stale (a pinned version, a requirement range, a renamed file are the usual casualties). Copy numbers, versions, paths and IDs from the source. Label intent and plans as such. If you cannot verify a point, write "not verified" or leave it out; never fill it with a guess. Do not claim to have read or run what you did not. A page you compared with its sources this session, and found right or made right, gets a new `reviewed` time (step 6); a page you did not compare does not.
5. **Write for a stranger.** The reader has never seen the system and does not know its vocabulary (Diátaxis: reference describes neutrally and mirrors the system's structure; explanation adds the why and the connections; each page here is a short mix, so keep the what in "What it does" and "How it does it", and the why in one sentence next to the step it explains).
   - Open with the purpose in everyday words, then the mechanism. Present tense, active voice, short words, one idea per sentence, no hidden verbs ("analyze", not "conduct an analysis"). No "obviously", "simply", "just".
   - First mention of a technical term, tool, internal name, acronym or abbreviation: give its meaning in the text (acronym: the full name next to it; `wiki check` fails when an acronym from `_acronyms.tsv` has no full name within 100 characters of its first use on the page), and link it to the wiki page or [[glossary]] entry that explains it more, or to an official page you opened this session. A definition may not contain another undefined term. Never leave the explanation to the link alone.
   - Terms that fresh readers most often miss, define them on every page that uses them: gate, requirement tag (`REQ <ID>`), finding or error codes, the status words (`ok`, `aviso`, `falha`, `pulado`), config file names and formats, hook, report file, "local mode", names of other pages used as nouns.
   - A term that deserves a definition and has none: add it to the glossary (kind `reference`), in three languages; if only this page uses it, define it inline.
   - Give a real example (input and output from the code or tests) where the rule is not obvious. Say why a step exists when the reason is not obvious.
   - Neutral: no promotion ("robust", "seamless"), no opinion. The strength of the wording matches the evidence ("does" only for what you verified).
6. **Page shape.** Header and the five sections as in `wiki-content`, plus `## Steps` where it applies. Edges: `fed_by` and `feeds` agree in both directions (edit the neighbour in the same change). `sources` lists `repo:path` for every file the claims come from (this is the citation system and what makes `wiki stale` work). `reviewed` is required on every page (rule CO-6): the current UTC time as `date -u +%Y-%m-%dT%H:%MZ`, set as the last act of verifying the page, never in the future. It is what `wiki stale` compares the sources with. Never set it on a page you did not compare with its sources, and never on many pages at once to empty `wiki stale`. Rules and preferences are linked by `#code` in `memory:`, never copied. A new page must be linked from at least two others (`wiki check` enforces it).
   A new page must be linked from at least two others: link it from the neighbour it belongs to and add a glossary entry or another real link. Leave `memory:` empty when no entry applies.
   | Kind | Must also contain |
   |---|---|
   | skill | `## Steps` holding the skill's own rules or steps (enforced), a plain definition of "a skill" in two sentences, what it is for, when it triggers (from its description) and what it does not cover, what it produces, where it lives, limits. Read the skill's `SKILL.md` first; never describe it from name or description alone. Role, owns, defers-to and honors from its Interop line. |
   | process | `## Steps`, in order, each step naming the actor and the output. |
   | module | `## Functions`: one line per function. |
   | project | what it is for, who uses it, repository, the quality gate, where to start. |
   | decision | the decision, the reasons, what was rejected, a link to the ADR. |
   | external | what depends on it and what breaks if it is gone. |
7. **Privacy.** No secrets, keys, tokens or `.env` contents (name the file, never the value). No clinical, secret or contact data about other people, in any language. `wiki check` scans, but you are the first filter.
8. **Check for understanding.** Before translating, read the page as someone who knows nothing: could they say what the subject is after "What it is" alone? Is any word used before it is explained? Does any sentence depend on another page without a link and a one-clause reminder? Rewrite until yes. (Plain-language practice, paraphrase testing from digital.gov: if a fresh reader cannot restate it, rewrite it.) For a new or heavily changed page, when a subagent is available, give a no-context reader only the page and ask four questions (what is it for, what happens in the failure case, how is it configured, which words could you not work out); fix every word it lists. In tests this removed the gaps the author had stopped seeing.
9. **Translate.** For each changed English page write `<id>.de.md` and `<id>.pt-BR.md` with the header (`id`, `lang`, `source_hash`, `title`) and the same section headings in English (the headings are keys); translate the text, not word by word. Keep identifiers, file names, commands, `[[id]]` links and requirement IDs. Definitions and acronym expansions are translated too (acronym kept, full name in the language of the page). Use the terms neighbouring translated pages already use. Never edit English without redoing both translations in the same change.
10. **Check, fix, hash.** Run `wiki check --local`. It prints the expected `source_hash` for every outdated translation: set it only after the translation really matches the English. Fix every problem it reports (do not bypass or loosen the check). Run it again until it passes.
11. **Publish.** `wiki publish -m "what changed"` (check, build, commit `content/`, push). A page you reviewed and found right still changes: its `reviewed` time, and that edit is the review. `wiki publish -m "review: no page change"` is only for changes that no page describes (for example a data file); never to silence the Stop hook over pages you did not review. Never edit `events/` or `views/`; never force-push.
12. **Close.** `wiki stale` shows nothing for what you touched. `mem use REF1,REF2 --note "how"` for the entries that shaped the work. Reply in Giovanni's language, in a short list: pages created or changed (all three languages count as one), any "not verified" gap, terms added to the glossary, the `wiki check` and `wiki publish` result stated plainly including a failure, and end with `Verified by:` (what ran: `wiki check --local`, `wiki stale`, the sources read; what could not be checked, for example the live site in a browser). Do not paste the pages into chat unless asked.

### Complete skill content (mandatory for `kind: skill`)
Before generating or updating a skill page, locate the real `SKILL.md` using its `sources`, `location`, and the installed skill folders. Read the whole file, not only its name, frontmatter description, or an older wiki summary. If Claude and Codex have separate installed versions, identify and include both, clearly labelled; never merge away their differences. If a source is unavailable, report the gap rather than claiming completeness.

Keep the readable explanation and translated Steps, and append the complete original `SKILL.md` under `## Notes`, including the full frontmatter description, instructions, examples, limits and reference paths. A summary or link alone does not satisfy this rule. Preserve the original source language in all three wiki versions, with a translated introduction explaining that it is the authoritative source; the surrounding explanation remains translated. Do not copy referenced auxiliary files unless they are part of the requested documentation scope, and do not describe the snapshot as containing those files.

For each source, use a Markdown fenced block whose info string is `skill-source <repo:path/to/SKILL.md> <sha256>`; the fence must be longer than any run of backticks inside the source. The SHA-256 fingerprint is computed from the entire copied text, with line endings changed to LF and a final newline added only if absent. List every copied file in `sources`. Refresh the copy and fingerprint whenever its source changes. Never omit content to pass privacy checks: report the blocked source instead. `wiki check --local` must confirm each English copy matches its source, and every translation must retain exactly the same originals. Checks without local files validate the fingerprint and presence, but cannot prove freshness against an unavailable source.

## Never

- Fabricate a fact, number, path, requirement ID, quotation or command output; present a plan or a guess as how the system works; copy an old claim without re-checking it.
- Set `reviewed` on a page you did not compare with its sources, or on many pages at once to clear `wiki stale`; publish over changes that are not yours; publish a page that `wiki check` rejects; use `review: no page change` for pages you did not review.
- Leave an acronym, abbreviation or internal name without its meaning at first use, in any language; rely on a link alone to explain a term; link a URL you did not open.
- Put secrets, other people's data, rules or preferences into a page; add code in a new language.

## Testing this skill

Scenarios the skill must handle: (1) a new function with a real source file; (2) a skill page (needs `## Steps`); (3) a stale page after a code change (a version or count changed); (4) a claim that cannot be verified; (5) another session's uncommitted changes in `content/`; (6) acronym-heavy subject; (7) a source containing a secret or personal data; (8) the Stop hook lists pages that are already correct. Pass means: `wiki check` passes, every claim traces to a source read, nothing outside the task is published, and a stranger can paraphrase the page.


## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
