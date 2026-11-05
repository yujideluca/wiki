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
sources: [workflow-memory:mem/tags.py, workflow-memory:mem/tags.toml, workflow-memory:mem/cli.py, workflow-memory:docs/adr/0007-rule-tags.md]
reviewed: 2026-11-05T03:57Z
---

## What it is
A tag is a short word that says for which kind of task a rule matters, for example `deploy` (installing or changing something) or `git`. `mem rules` prints the full rules that carry a tag, and `mem tag` changes the tags of a rule. They exist because the text a chat receives at its start is cut after 2 KB (kilobytes, a measure of text size) and cannot hold every rule: it holds an index of the tags instead, and Claude reads the rules of a kind of task when it starts such a task ([[session-brief]]).

## What it does
`mem rules deploy git` prints every active rule that has the tag `deploy` or `git`, each once, in the full current wording. A line looks like `- [git.no-force-push] Never force-push. (#d6931b)`: the key, the text, and the short `#code` that `mem use` and `mem feedback` accept. Only the rules of the current project and of the current tool are shown (a rule scoped to another project, or to Codex only, is left out), and a rule marked wrong is left out. An unknown tag is refused and the known tags are listed.

`mem tag KEY deploy,git` replaces the tags of the rule with that key (`--scope` when the same key exists in several scopes, or the `#code` instead of the key); `mem tag KEY -` removes them. It writes a new event that replaces the old one, so the log keeps its history. `mem add --tags` sets the tags of a new rule ([[mem-add]]).

## How it does it
The known tags and their one-line "use when" text live in `mem/tags.toml` (TOML is a plain text format of `name = "text"` lines). The checker ([[mem-validator]]) refuses an event whose tag is not in that file or that has more than six tags, and `mem check` prints a warning for every rule written by Giovanni that has no tag, because such a rule would be reachable by no tag. The tags are part of the ruling in [[memory-fold]]: the same words with other tags replace the older event. The tag `always` marks the few rules that the start-up brief prints in full. The same lists are written to `views/rules/TAG.md` for chats that cannot run commands ([[memory-views]]).

## Where it sits in the pipeline
Claude runs `mem rules TAG` before a task of that kind; the start-up brief tells it to ([[hook-session-start]]). Giovanni can run it too.

## Who receives its output
The [[session-brief]] (the index and the `always` rules) and the chat that asked.

## Functions
- `mem rules TAG [TAG ...] [--project NAME]`: print the full rules with any of the tags
- `mem tag KEY|#code TAG[,TAG] [--scope S]`: set the tags of a rule; `-` clears them
- `mem add ... --tags TAG[,TAG]`: tag a new rule; a rule that replaces another keeps its tags unless `--tags` says otherwise
