# Wiki staleness audit — 2026-11-01

Giovanni requested a Claude Code investigation of stale pages and the workflow that let them pass. Codex launched Claude session `511a72a0-1e62-4f79-85ce-7b518572b6b7`, reviewed its changes independently, and took responsibility for final deployment and verification. This report distinguishes source authorship from proof of a particular session's actions.

## Responsibility supported by evidence

| Evidence | Supported attribution | Limit |
|---|---|---|
| Wiki `3c12c76`, checker and `CLAUDE.md`, 2026-10-27 01:47 UTC | Coauthored by Claude Sonnet 5.5; later source review found the Architecture and engineering-practices rules missing from the corresponding pages | Coauthor identifies the assistant-associated source commit, not every later session that could have reviewed it |
| Wiki `12b5342`, `FlowView.elm`, 2026-10-27 02:12 UTC | Coauthored by Claude Sonnet 5.5; flow-view documentation needed correction | Same limit on exact later session attribution |
| workflow-memory `6a57d87`, `mem/validate.py`, 2026-10-30 20:12 UTC | Coauthored by Claude Sonnet 5.5; validator page omitted event-time clamping | Same limit |
| codex-pbar `f2b0389`, `tools`, 2026-10-30 04:43 UTC | Coauthored by Claude Sonnet 5.5; page still matched its sources and needed a recorded review | A stale timestamp alone does not prove incorrect text |
| Wiki `0f0b4ad` and `5b3ff90`, Status Quo design/layout | This Codex conversation created the pages and then added creation-date metadata; its final staleness check preceded the second commit | Confirmed verification miss by this Codex session; self/cross-source and metadata semantics also created false positives |
| Unversioned local configuration | Modification times establish that a change followed a review | No reliable commit/coauthor evidence identifies the exact modifying session; do not invent one |

The configured Git author `yujideluca` is not evidence that Giovanni personally performed an assistant's changes. Responsibility is recorded above only to the level the evidence supports.

## Why the workflow let it pass

1. `wiki check` validated format, links and translations, but `wiki publish` did not check whether a newly claimed review was older than its sources.
2. A single global publication timestamp advanced on every publication. An unrelated session could hide earlier unfinished documentation work.
3. The hook did not distinguish a current page from a source merely changed since that global timestamp. Self-sources and metadata-only wiki commits also produced false stale results.
4. Missing publication state silently disabled the hook; malformed state crashed integer parsing. Linked worktrees and commits in the publication timestamp's second could be missed.
5. A later source commit could hide an earlier missed review if publication validation considered only the newest source state rather than its history at the documentation commit.

ADR-0009 and requirements ST-4 through ST-6 and UP-7 document the repair. Exact same-commit review coverage is allowed; no arbitrary time grace period is allowed. The hook still reminds once per session/signature and avoids recursive Stop loops. Text review remains a human/assistant responsibility: timestamps cannot prove that prose was actually compared with source code.

## Independent review caught two further errors

- During deployment, the Claude session piped Git output through `tail` without preserving Git's exit status and recorded a promotion before checking the remote commit. The pre-push check had rejected a source reference absent from the primary checkout. Its next commit, `a4ceb85`, removed the source reference instead of repairing resolution. Codex restored the reference and made `wiki:` sources follow the selected `WIKI_ROOT`, so an isolated worktree validates its own files. No branch protection was bypassed.
- Temporary state names used only `System.unique_integer`, whose uniqueness is limited to one runtime. Two independent Elixir processes writing 20,000 stamps each reproduced a `File.RenameError` on `last_publish.tmp754`. Process identity now separates temporary names, and a regression test exercises two independent runtimes. Atomic rename remains in use.

Deployment commands must preserve exit status and completion reports must verify the remote commit, primary checkout, installed executable and served output. A progress-file assertion is not proof of promotion. The parent retained the source references, required exact-commit checks, and used strict shell error handling for final publication.

## Page reconciliation

Nine pages received text corrections after source comparison:

- `wiki-check`
- `wiki-content`
- `wiki-flow-view`
- `wiki-stale`
- `wiki-hook-stop`
- `mem-validator`
- `claude-auto-memory`
- `claude-plugins`
- `user-space-tools`

Six pages matched their sources and received a recorded review without body changes:

- `claude-code-settings`
- `laptop-setup`
- `codex-status-line`
- `codex-pbar`
- `skills` — changes were synchronization markers, not different skill instructions
- `wiki-skill-source`

English changes include matching German and Brazilian Portuguese versions. Separately, Codex clarified the two Status Quo pages in `cc72176`: account meters, token graphs, sessions, GitHub activity and memory are removable/interchangeable widgets with independent instance settings. The host tray has a widget catalog and replacement/restart acceptance checks.

The repair itself changed sources for five additional pages: `end-of-task`, `wiki`, `wiki-build`, `wiki-cli` and `wiki-requirements`. Their explanations and translations were updated too. Installing the command also changes the documented `~/.local/bin` source, so `user-space-tools` receives its final source review after installation, rather than a premature timestamp before that write.

## Verification record

The regression suite covers false review claims, later source changes, same-commit coverage without a grace period, malformed/missing/future state, preservation of uncovered files, linked worktrees, same-second commits, isolated source resolution and cross-process state writers. Final command outputs, CI results and installed-production checks are recorded in the task completion report; this document does not equate configuration or a passing unit test with a verified deployment.

The existing minute precision of `reviewed` is retained: the declared minute is treated as covered. This is not a guarantee about the exact order of two human actions within that minute. Source-text comparison and honest review times remain necessary. The hook still reminds only once per session/signature, as configured; it is not an infinite stop loop.

## Unchanged findings

The package manager reported existing advisories for `assent` 0.3.1, `bandit` 1.14.0 and `ssl_verify_fun` 1.1.7. Versions were not changed by this task; applicability and remediation remain separately recorded. The documentation-only `cc72176` main CI run hit an Elm package-registry timeout and passed when the same failed job was rerun unchanged. Existing CI action-runtime and runner-image migration notices were not modified.
