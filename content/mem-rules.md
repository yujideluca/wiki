---
id: mem-rules
title: mem rules and mem tag (rules by kind of task)
aliases: [rule tags, mem tag, tags.toml]
kind: function
project: workflow-memory
status: active
location: workflow-memory:mem/tags.py
fed_by: []
feeds: [session-brief]
sources: [workflow-memory:mem/tags.py, workflow-memory:mem/tags.toml, workflow-memory:mem/cli.py, workflow-memory:docs/adr/0007-rule-tags.md, workflow-memory:docs/adr/0008-router-rules-as-modules.md, workflow-memory:mem/hooks.py, workflow-memory:docs/adr/0010-briefings-before-full-text.md]
reviewed: 2026-11-22T14:16Z
---

## What it is
A tag is a short word that says for which kind of task a rule matters, for example `deploy` (installing or changing something) or `git`. `mem rules` prints a briefing of the rules that carry a tag (one line per rule) and, with `--full`, their full wording, and `mem tag` changes the tags of a rule. Rules work as modules: no rule is printed when a chat starts. The chat receives only a short instruction, the router, and an index of the tags. The router is the one standing order: for every message, decide which tags fit the task, load their briefing first, then load in full each rule that touches the task ([[session-brief]]). This exists because the text a chat receives at its start is cut after 2 KB (kilobytes, a measure of text size), and because a chat that loads only the rules of its current task is not distracted by the others.

## What it does
`mem rules deploy git` prints a briefing: one line for every active rule that has the tag `deploy` or `git`, each once. A line looks like `- [git.no-force-push] Never force-push. (#d6931b)`: the key, the text, and the short `#code` that `mem use` and `mem feedback` accept. A rule of up to 160 characters is shown whole. A longer rule is cut at the end of a sentence or word and ends in `…`, and a closing note tells the chat to load in full every rule that touches its task. `mem rules --full work.dedication` prints the full current wording; after `--full` a name can be a tag (its whole set of rules), a rule key or a `#code`. The briefing exists because a task touches only a few rules of a tag, and every character a chat has loaded is read again at each of its steps ([[task-delegation]]). Measured on 2026-11-22, the briefing of `coding` has 4,861 characters and its full wording 12,491 (ADR-0010; an ADR is an architecture decision record, the written record of one decision). Only the rules of the current project and of the current tool are shown (a rule scoped to another project, or to Codex only, is left out), and a rule marked wrong is left out. A name that is no tag, rule key or `#code` is refused and the known tags are listed.

`mem tag KEY deploy,git` replaces the tags of the rule with that key (`--scope` when the same key exists in several scopes, or the `#code` instead of the key); `mem tag KEY -` removes them. It writes a new event that replaces the old one, so the log keeps its history. `mem add --tags` sets the tags of a new rule ([[mem-add]]).

## How it does it
The known tags and their one-line "use when" text live in `mem/tags.toml` (TOML is a plain text format of `name = "text"` lines). The checker ([[mem-validator]]) refuses an event whose tag is not in that file or that has more than six tags, and `mem check` prints a warning for every rule written by Giovanni that has no tag, because such a rule would be reachable by no tag. The tags are part of the ruling in [[memory-fold]]: the same words with other tags replace the older event. The tag `always` once marked rules printed in full at start-up. Since 2026-11-07 it is retired: nothing prints it, and `mem check` warns about a rule that still carries it. The tag `outward` covers acts that others see or that cannot be undone (sending email or messages, purchases, publishing, deleting); `deploy` covers installs, releases and configuration. The same lists are written to `views/rules/TAG.md` for chats that cannot run commands ([[memory-views]]).

## Where it sits in the pipeline
Claude or Codex runs `mem rules TAG` as the first step of a task of that kind, then `mem rules --full` for the rules that apply. The start-up brief tells it to ([[hook-session-start]]), and so does a one-line reminder on every message ([[hook-prompt]]). Giovanni can run it too. A test on 2026-11-07 ran 15 sample requests through 7 Claude and Codex models: the right rules were loaded before the first action in 50% of the runs with the old start-up text and in 96% with the router (ADR-0008, an architecture decision record).

## Who receives its output
The [[session-brief]] (the index) and the chat that asked.

## Functions
- `mem rules TAG [TAG ...] [--project NAME]`: print the briefing, one line per rule with any of the tags
- `mem rules --full NAME [NAME ...]`: print the full wording; NAME is a tag, a rule key or a `#code`
- `mem tag KEY|#code TAG[,TAG] [--scope S]`: set the tags of a rule; `-` clears them
- `mem add ... --tags TAG[,TAG]`: tag a new rule; a rule that replaces another keeps its tags unless `--tags` says otherwise
