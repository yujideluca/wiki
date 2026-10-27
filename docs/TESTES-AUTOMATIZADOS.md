# Automated bug-finding tests: wiki

Last reviewed: c25b6ec 2026-10-24
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
