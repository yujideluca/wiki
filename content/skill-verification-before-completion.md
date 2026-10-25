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
sources: [home:.claude/skills/verification-before-completion/SKILL.md, home:.agents/skills/verification-before-completion/SKILL.md]
reviewed: 2026-10-25T20:41Z
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

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/verification-before-completion/SKILL.md`

````skill-source home:.claude/skills/verification-before-completion/SKILL.md e634cc29dba539d72868c7ff66d7e61d77ae7368defd016e34fc080c99ac9ae1
---
name: verification-before-completion
description: "Use in Claude Code before saying work is done, fixed, passing or complete, and before committing: run the verification commands and read their output first; evidence before assertions. Feeds the `Verified by:` line that every done report ends with."
---

# Verification Before Completion

Lineage: origin=code; base=none

Interop: role = process; owns = proof before any success claim; defers to = the project's CLAUDE.md (its build/test/device steps, e.g. QuizApp: adb install, launch, logcat), the global CLAUDE.md (closing steps: mem use, wiki publish); honors = reply-language rule, debug-after-coding.

Adapted from obra/superpowers 7.0.0 (commit bb92a77, MIT, LICENSE in this folder), without its always-on startup hook.

## Overview

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness
````


#### Codex: `home:.agents/skills/verification-before-completion/SKILL.md`

````skill-source home:.agents/skills/verification-before-completion/SKILL.md f2e64936cb0291708538d88c7bdfe6aa5140a8fc8a7413ac36b5844c31353532
---
name: verification-before-completion
description: "Use in Codex before saying work is done, fixed, passing or complete, and before committing: run the verification commands and read their output first; evidence before assertions. Feeds the `Verified by:` line that every done report ends with."
---

# Verification Before Completion

Lineage: origin=claude; base=sha256:e634cc29dba539d72868c7ff66d7e61d77ae7368defd016e34fc080c99ac9ae1; adaptation=codex

Interop: role = process; owns = proof before any success claim; defers to = the project's AGENTS.md (or CLAUDE.md when it is the existing project guide) (its build/test/device steps, e.g. QuizApp: adb install, launch, logcat), the global CLAUDE.md (closing steps: mem use, wiki publish); honors = reply-language rule, debug-after-coding.

Adapted from obra/superpowers 7.0.0 (commit bb92a77, MIT, LICENSE in this folder), without its always-on startup hook.

## Overview

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness


## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
