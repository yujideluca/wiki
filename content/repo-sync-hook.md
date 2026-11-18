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
reviewed: 2026-11-18T06:23Z
memory: []
---

## What it is
A small read-only program that runs when an assistant ([[claude-code]]) finishes a reply and lists every repository under `~/dev` whose work is not safely on its remote `main`. It exists because the rules "keep one branch, `main`" and "every project has a GitHub repository" were only written text: a session that stopped at its usage limit left uncommitted files, branches made for continuous integration (CI), extra worktrees and repositories with no remote, and nothing noticed.

## What it does
For each folder in `~/dev` that is a git repository it reports: no remote at all; uncommitted files (with how many minutes ago the newest was touched, and a "live session?" hint under 20 minutes, because another session may still be working there); commits on `main` not pushed; a `main` that follows no remote branch (its unpushed commits could not be seen); a branch other than `main`, on the laptop or left on the remote only (as of the last fetch: it makes no network call); an extra worktree; and a repository git cannot read, which is listed as not checked instead of looking clean. A projects folder that does not exist gives an empty report, not a crash (fixed 2026-11-18, when the check on GitHub showed that a test had been reading the laptop's real folder). It gives the list once per session as a `systemMessage` (an answer in JSON (JavaScript Object Notation), a plain-text data format, that Claude Code shows to the user; until 2026-11-18 it printed plain text, which a Stop hook's output never shows to anyone) and never blocks the stop and never changes anything: committing, pushing and deleting stay a decision of the session or of Giovanni.

## How it does it
`python3 -I ~/dev/workflow-memory/scripts/repo_sync.py hook-stop` is the third Stop hook in `~/.claude/settings.json` (after the memory hook and the [[wiki-hook-stop]]; Claude Code starts them at the same moment). `report` runs the same check by hand. The sessions already told are kept as small files in `~/.local/state/repo-sync/` and removed after seven days. A branch that is meant to stay is declared with `git config --add repo-sync.branch NAME` (done for `bleeding-edge` in `german-quiz-releases`, the beta channel of the quiz app). A repository that is meant to exist on this laptop only is declared with `git config repo-sync.local "why"`: the "no remote" line then stays away, and its uncommitted files are still reported. Giovanni decided on 2026-11-18 that five temporary experiments get no GitHub repository (`b2-themen`, `b2-vorlagen`, `merlin-b2-scorecard`, `merlin-data`, `tor-setup`), and they carry that declaration; `vm-lab` got a private repository instead. Eight tests (`tests/test_repo_sync.py`) build a throw-away repository and a bare remote and check each report line and the hook's once-per-session answer; two more in the same file check the memory's own Stop hook: that it writes every result that is not a success (a failed push, a conflict) to its log, and that the log is cut back when it grows.

## Where it sits in the pipeline
Last line of defence after the work: the wiki hook says which pages are behind, this one says which repositories are behind.

## Notes
Since 2026-11-18 the same command is also a Stop hook of Codex (`~/.codex/hooks.json`, 20 seconds at most). Whether Codex shows a `systemMessage` on its screen was not checked. Repositories that are shared by several concurrent sessions show other sessions' unfinished files; the age hint is the only way to tell them apart.

## Who receives its output
Giovanni, on the screen of the session that is stopping. The assistant itself does not receive the text (only a hook that blocks the stop can speak to the assistant); it runs `repo_sync.py report` at the end of a task because the memory rule `git.sync-check` says so.
