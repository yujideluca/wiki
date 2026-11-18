---
id: repo-sync-hook
title: Repo sync Stop hook
aliases: [repo_sync, repo-sync, git sync check]
kind: hook
project: workflow-memory
status: active
location: workflow-memory:scripts/repo_sync.py
fed_by: [claude-code-settings, workflow-memory]
feeds: [claude-code]
sources: [workflow-memory:scripts/repo_sync.py, workflow-memory:tests/test_repo_sync.py]
reviewed: 2026-11-18T05:31Z
memory: []
---

## What it is
A small read-only program that runs when an assistant ([[claude-code]]) finishes a reply and lists every repository under `~/dev` whose work is not safely on its remote `main`. It exists because the rules "keep one branch, `main`" and "every project has a GitHub repository" were only written text: a session that stopped at its usage limit left uncommitted files, branches made for continuous integration (CI), extra worktrees and repositories with no remote, and nothing noticed.

## What it does
For each folder in `~/dev` that is a git repository it reports: no remote at all; uncommitted files (with how many minutes ago the newest was touched, and a "live session?" hint under 20 minutes, because another session may still be working there); commits on `main` not pushed; a branch other than `main`; and an extra worktree. It prints the list once per session as a notice and never blocks the stop and never changes anything: committing, pushing and deleting stay a decision of the session or of Giovanni.

## How it does it
`python3 -I ~/dev/workflow-memory/scripts/repo_sync.py hook-stop` is the second Stop hook in `~/.claude/settings.json` (after the memory hook and the [[wiki-hook-stop]]). `report` runs the same check by hand. The sessions already told are kept as small files in `~/.local/state/repo-sync/` and removed after seven days. A branch that is meant to stay is declared with `git config --add repo-sync.branch NAME` (done for `bleeding-edge` in `german-quiz-releases`, the beta channel of the quiz app). Two tests (`tests/test_repo_sync.py`) build a throw-away repository and a bare remote and check each report line.

## Where it sits in the pipeline
Last line of defence after the work: the wiki hook says which pages are behind, this one says which repositories are behind.

## Notes
Not installed for Codex yet; `~/.codex/hooks.json` has no entry. Repositories that are shared by several concurrent sessions show other sessions' unfinished files; the age hint is the only way to tell them apart.

## Who receives its output
The assistant session that is stopping (it shows the notice) and, through it, Giovanni.
