---
id: skill-gerar-teste-automatizado
title: Skill: gerar-teste-automatizado
aliases: [gerar-teste-automatizado, bug-finding test skill]
kind: skill
project: skills
status: active
location: home:.claude/skills/gerar-teste-automatizado
fed_by: [skill-revisao-manutencao]
feeds: []
sources: [home:.claude/skills/gerar-teste-automatizado/SKILL.md]
reviewed: 2026-10-24T12:43Z
---

## What it is
The skill "gerar-teste-automatizado" ("generate automated test") creates, and later updates, the automated test suite that hunts for real bugs in a software project. Its description says: use it in Claude Code to create or update the automated bug-finding test suite of a project: full diagnosis of the code, a test matrix, tests that detect real defects, mutation and coverage checks. It is called by [[skill-revisao-manutencao]] on the first review of a project (create) and on later reviews (update), and can be asked for directly. It is not for fixing a single failing test or a bug ([[skill-systematic-debugging]]). It is based on a prompt written by Giovanni.

## What it does
The aim is tests that find real errors, regressions, invalid inputs, boundaries and integration failures, not tests that confirm the easy path. It never edits production code to make tests pass and proposes any needed fix separately.

## How it does it
A `SKILL.md` in `~/.claude/skills/gerar-teste-automatizado`. The record `docs/TESTES-AUTOMATIZADOS.md` at the project's root (or at a component's root, for a component with its own manifest, such as QuizApp's `tools/pipeline-check`) is the marker that the suite exists. Its role is "domain": it owns the bug-finding test suite and its record; it defers to the project's own test framework, requirements catalogue and CLAUDE.md, to [[skill-systematic-debugging]] (fixing a defect found) and to [[skill-verification-before-completion]]; it is called by [[skill-revisao-manutencao]].

## Where it sits in the pipeline
Called by [[skill-revisao-manutencao]] in step 4 of every review.

## Who receives its output
Giovanni (defects found, residual risks) and the project's test folders.

## Steps
Act as a senior engineer in automated testing and defect detection.
0. **Decide the mode first.** *Create*: `docs/TESTES-AUTOMATIZADOS.md` does not exist yet; do a full diagnosis, then build the suite. *Update*: it exists; read it and the suite, find what changed in the code, requirements and ADRs (architecture decision records) since the "Last reviewed" commit named in the file, and bring the matrix and the tests up to date: new behaviours get cases, removed ones lose them (with a reason), mutants that survived last time are retried; do not rewrite what still holds. Use the language and framework the project already uses; if there is none, ask Giovanni. Never run destructive operations on databases or external systems; no secrets or personal data in tests or reports.
1. **Analyse before writing any test.** The structure, language, dependencies, architecture, relevant modules and test tools already installed; the explicit requirements, business rules, function contracts and input and output formats (the project's `docs/REQUIREMENTS.md` first); the critical components, external dependencies and main failure modes; the existing tests and the gaps in their coverage; ambiguous or missing requirements (do not invent rules: record the uncertainty and proceed only on stated, justified hypotheses). Keep the project's architecture and patterns unless there is a documented technical reason.
2. **Plan the test matrix.** Map each requirement or behaviour to cases, chosen by risk and defect-finding power, not by count. Consider, where applicable: normal scenarios; equivalence classes of valid and invalid input; boundary values; null, missing, wrongly typed and malformed data; extreme cases and combinations; exceptions, network failure, unavailable dependencies; invalid states and forbidden transitions; duplicates and integrity violations; regressions; concurrency, idempotency, performance and security when in scope. No redundant cases.
3. **Implement.** Prefer the project's frameworks. Each test has a specific purpose and a name that describes the behaviour; builds its own inputs; acts; compares with an expected result defined independently of the code under test (hand-computed, from the requirement); checks relevant side effects; and fails with a clear message (arrange–act–assert). Do not call code without asserting on the result. Do not turn current behaviour into the oracle: confront it with the requirements. Tag tests with the project's convention (QuizApp: a `REQ <ID>` comment). Choose levels as needed (unit, integration, end-to-end, property-based, regression) and justify gaps. Qualities: deterministic, reproducible, isolated, low coupling, maintainable; external services faked in unit tests and real only in integration tests; no arbitrary waits, order dependence, internet calls or uncontrolled time.
4. **Verify that the tests can detect defects.** Run the new tests and investigate every failure (never change an expectation just to pass). Run again after real fixes, and run the existing suite for regressions. When viable, do mutation testing: plant controlled faults and check that the tests catch them, classifying each survivor as an equivalent mutant, irrelevant, or a real gap. Repeat runs to confirm independence and stable results. Measure line and branch coverage if a tool exists; coverage is not proof of correctness.
5. **Restrictions.** Do not change production code to make tests pass; do not edit requirements, reference data or expected results without a verifiable reason; do not delete tests, disable validations or weaken checks to get green. A needed production fix is proposed separately (defect, evidence, proposed change) and implemented only inside the authorised scope. Never claim a test passed without running it; state every limitation (missing tool, environment).
6. **Deliver: write `docs/TESTES-AUTOMATIZADOS.md` and report.** The record keeps: the analysis summary and strategy; the test matrix (requirement, scenario, expected result, priority); the files and their purposes; the run commands; the real results (run, passed, failed, ignored); coverage with the tool and gaps; defects found (description, evidence, impact, reproduction); limitations and residual risks; recommendations; and the header line `Last reviewed: <commit sha> <date>` that update mode reads. Mark clearly what was observed, what is inferred and what is a hypothesis. It is done only when the tests are implemented and organised, expected results have an identifiable basis, run commands are documented, tests were executed (or limits recorded), failures were investigated and classified, and risks and gaps are documented. Do not stop at a plan or code samples. End with "Verified by:".
