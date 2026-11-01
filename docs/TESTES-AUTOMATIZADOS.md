# Automated bug-finding tests: wiki

Last reviewed: a4ceb85 2026-11-01 (staleness/publication scope; the older sections retain their dated review scope)
Created by the skill `gerar-teste-automatizado` (create mode) in the first maintenance review. Update mode starts from the commit above.

## Analysis summary
Elixir back end (checker, build, publish, login gate with decoy) and Elm front end. The existing suite (31 Elixir tests, Elm tests, requirements AU-*, CO-*, MP-* with tagged tests) covers the login gate, the content checker and the map. Risks by cost of error: private or secret data published on a site that is reachable from the internet (the privacy scan is the last barrier before `wiki publish` pushes), and the login gate. This review examined the privacy scan, because its rule (CO-4) is stated by Giovanni and its patterns had never been tested against the rule itself. The login gate (AU-1..AU-6, DC-1) already has direct tests and was not re-examined. Observed: all tests below were run.

## Test matrix (`server/test/privacy_test.exs`, 5 tests)
| Requirement | Scenario | Expected |
|---|---|---|
| CO-4 | classic and fine-grained GitHub tokens, GitLab token, Google API key, AWS key, `sk-` key, Slack token, private key header | blocked |
| CO-4 | phone numbers: German and US international, Brazilian with and without area code in parentheses | blocked |
| CO-4 | a CPF | blocked |
| CO-4 | exam dates, versions, byte limits, ports and IPs, decimals, "+1 point" | not blocked |
| CO-4 | Giovanni's and Anthropic's addresses, in any case; any other address | allowed / blocked with the address named |

## How to run
```
cd server && mix test test/privacy_test.exs      # this file
tools/quality_gate.sh                              # everything, including wiki check over all 153 pages
```

## Results (observed, 2026-10-24)
Before the fix 3 of the 5 tests failed (tokens, phones, CPF); after the fix all 36 Elixir tests pass and `wiki check` over every page and translation finds no false alarm. No mutation tool for Elixir is installed; the failing-before / passing-after pairs are the evidence.

## Coverage
Not measured (`mix test --cover` was not run).

## Defects found (fixed)
1. Fine-grained GitHub tokens (`github_pat_`), GitLab tokens (`glpat-`) and Google API keys (`AIza`) were not recognised. Impact: a secret could be published on the wiki.
2. Brazilian phone numbers without a `+` ("(11) 91234-5678") and international numbers with other separators were not recognised, although CO-4 says phone numbers are blocked. Fix: two patterns.
3. A CPF (Brazilian personal id) was not recognised. Fix: one pattern. (The same gaps existed in workflow-memory's copy of this boundary and were fixed there the same day.)

## Limitations and residual risks
The scan is a list of patterns: unknown token formats and names written in prose pass. This boundary now exists twice (wiki, workflow-memory) with different patterns: debt P2, a shared definition would stop them drifting. The Elm front end, the router and the build were not re-examined.

## Recommendations
1. Make one privacy-pattern list that both projects use (or test the two against the same fixture of samples).
2. Add `mix test --cover` to the gate to see untested modules.
3. Next review: the stale-page detector and the publish step (git operations).


### Connected pages (AR-2), 2026-10-27

`frontend/tests/ArticleStepsTests.elm` checks a full long title and real page link, with duplicate edges producing one row, on desktop and phone in all three languages. The new check failed against the previous circular graph (no connected-pages list), then passed with the list. Visual checks cover wrapping and dense real pages.

## Staleness and publication audit — 2026-11-01

Update scope: stale-source detection, review claims, shared publication/hook state and isolated worktree source resolution. The router, privacy boundary and Elm interface were regression-tested through the gate, not independently re-audited. Findings and attribution: `docs/2026-11-01-wiki-stale-audit.md`; structural choices: ADR-0009.

| Requirement | Failure scenario | Expected result | Priority |
|---|---|---|---|
| ST-4, ST-5 | Self-source, date-only change, same-commit source/review; separate later source change | Ignore false stale cases; retain genuine later changes without a grace period | High |
| ST-6 | False review claim, followed by a newer source commit | Refuse publication based on source history at the claimed commit | High |
| ST-6 | New source exists only in the selected wiki worktree | Validate that source through `WIKI_ROOT`, preserving the source reference | High |
| UP-7 | Unrelated publish, uncovered files, linked worktree, same-second change | Preserve the unfinished obligation | High |
| UP-7 | Missing, malformed, zero, negative or future state | Diagnose safely or derive real obligations; never erase them during recovery | High |
| UP-7 | Two independent runtimes write 20,000 stamps each | Both exit normally; final stamp parses; no temporary files remain | High |

Cases live in `server/test/stale_test.exs` and `server/test/build_test.exs`; `server/test/support/stamp_writer.exs` runs the independent writer fixture. The writer workers use one scheduler each to bound resources; they load the real compiled module, not a mocked writer. The source-resolution test uses a file absent from the primary checkout.

Observed before the final corrections: the two new integration tests failed; a real two-process reproducer raised `File.RenameError`. Both targeted tests passed after the corrections. A controlled mutation removing process identity from the temporary name made the writer test fail again; the correction was restored. Coverage instrumentation initially exposed a fixture portability error (`:code.which` returned `:cover_compiled`); the fixture now uses the application build directory.

Observed final backend run: `mix test --cover` ran **95 tests, 0 failures**. Aggregate line coverage was **88.46%**, below Mix's unchanged default **90%** threshold, so that measurement command exited 3. This is a coverage gap, not a passing measurement. No threshold or project gate was weakened. Module figures: stale detector 95.17%, source resolver 76.47%, command interface 52%, Git helper 57.69%. Independent child-process execution is not merged into the parent's coverage data; branch coverage was not measured. The standard quality gate uses `mix test` rather than a coverage floor.

Commands: `cd server && mix test test/build_test.exs`, `cd server && mix test --cover`, and the production `tools/pipeline-check.sh`. Traceability covers 75 requirements; the generated matrix must be included with the commit.

Maintenance proposals, not yet created as issues: P2 expand command-interface/Git recovery coverage toward the existing measurement threshold; P3 review upgrading the pinned `pipeline-check` v0.4.0 to available v0.5.0. Existing privacy recommendations above are historical; the current gate checks the privacy-pattern copy against workflow-memory's shared list. No dependency upgrade, gate-limit change or unrelated privacy redesign was performed here.
