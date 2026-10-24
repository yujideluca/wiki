---
id: skill-verification-before-completion
title: Skill: verification-before-completion
aliases: [verification-before-completion]
kind: skill
project: skills
status: active
location: home:.claude/skills/verification-before-completion
fed_by: []
feeds: []
sources: [home:.claude/skills/verification-before-completion/SKILL.md]
---

## What it is
The skill "verification-before-completion" is the rule that evidence comes before any claim that work is done, fixed or passing. Its description says: use it before saying work is done, fixed, passing or complete, and before committing: run the verification commands and read their output first; evidence before assertions. It feeds the `Verified by:` line that ends every report to Giovanni. It was adapted from the open-source "superpowers" skills (version 7.0.0, MIT licence), without their always-on startup hook. Its role is "process"; it defers to the project's CLAUDE.md for the build, test and device steps and to the global [[global-claude-md]] for the closing steps (`mem use`, `wiki publish`).

## What it does
Before saying "done" or committing, Claude must run the command that proves the claim and read its output. The closing "Verified by:" line then says what was run and what could not be checked.

## How it does it
A `SKILL.md` in `~/.claude/skills/verification-before-completion`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Part of the development process in Claude Code, used in every project; it comes before [[end-of-task]].

## Who receives its output
Giovanni (the report) and the commit.

## Steps
The iron law: no completion claims without fresh verification evidence. If the verification command was not run in this message, you cannot claim it passes.
1. **Identify** which command proves the claim.
2. **Run** the full command, fresh and complete.
3. **Read** the whole output, check the exit code, count the failures.
4. **Verify** that the output confirms the claim. If not, state the real status with the evidence; if yes, state the claim with the evidence.
5. **Only then** make the claim. Skipping any step is not verifying.

What counts as proof: "tests pass" needs the test command's output with 0 failures (not a previous run or "should pass"); "linter clean" needs linter output with 0 errors; "build succeeds" needs the build command's exit code 0 (a passing linter is not a build); "bug fixed" needs the original symptom tested; a regression test needs the red-green cycle (write, run and pass, revert the fix, run and see it fail, restore, run and pass); "agent completed" needs a look at the version-control diff, not the agent's own report; "requirements met" needs a line-by-line checklist, not just passing tests.

Red flags that mean stop: words like "should", "probably", "seems to"; expressing satisfaction ("Great!", "Done!") before verifying; being about to commit, push or open a pull request without verification; trusting a sub-assistant's success report; relying on a partial check; "just this once"; being tired. Excuses do not change the rule: confidence is not evidence, a linter is not a compiler, and different wording does not escape the rule. It applies before any success claim, any expression of satisfaction, committing, pull requests, moving to the next task and delegating.
