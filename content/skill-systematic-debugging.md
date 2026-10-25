---
id: skill-systematic-debugging
title: Skill: systematic-debugging
aliases: [systematic-debugging]
kind: skill
project: skills
status: active
location: home:.claude/skills/systematic-debugging
fed_by: []
feeds: []
sources: [home:.claude/skills/systematic-debugging/SKILL.md]
reviewed: 2026-10-25T02:07Z
---

## What it is
The skill "systematic-debugging" is the discipline Claude follows on any bug, test failure, crash or unexpected behaviour (in code, scripts, the sync pipeline or an app on the phone), before proposing a fix: find the root cause first, change one thing at a time, and stop after three failed fixes. Its description says it is not for Kubuntu desktop repair ([[skill-reparo-kubuntu]]). It was adapted from the open-source "superpowers" skills (version 7.0.0, MIT licence), without their always-on startup hook. Its role is "process"; it defers to [[skill-reparo-kubuntu]] for system problems, to [[workflow-memory]] for recording a lasting correction, and to the project's CLAUDE.md.

## What it does
It forbids guessing. Its core principle is: always find the root cause before attempting fixes; symptom fixes are failure. Under time pressure, when a fix "seems obvious", or after a first fix failed, the process matters most.

## How it does it
A `SKILL.md` in `~/.claude/skills/systematic-debugging` (with supporting notes on root-cause tracing, defence in depth and condition-based waiting); Claude loads it when a request matches its description.

## Where it sits in the pipeline
Part of the development process in Claude Code, used in every project.

## Who receives its output
Claude, while fixing; the fix then goes through [[skill-verification-before-completion]].

## Steps
The iron law: no fixes without root-cause investigation first. Four phases, each completed before the next.
1. **Phase 1, root cause.** Read error messages and stack traces completely (note line numbers, file paths, error codes). Reproduce the problem consistently: exact steps, every time; if not reproducible, gather more data instead of guessing. Check recent changes (git diff, new dependencies, configuration, environment). In a system with several components (for example continuous integration (CI) → build → signing), add diagnostic output at every boundary, run once, and see where the data goes wrong before investigating that component. Trace bad values backwards through the call chain to their source, and fix at the source.
2. **Phase 2, pattern.** Find similar working code in the same codebase; read any reference implementation completely; list every difference between working and broken, however small; understand the dependencies, settings and assumptions.
3. **Phase 3, hypothesis.** State one hypothesis ("I think X is the root cause because Y"), write it down, test it with the smallest possible change, one variable at a time. If it worked, go on; if not, form a new hypothesis and do not pile more fixes on top. When something is not understood, say so.
4. **Phase 4, implementation.** Write a failing test that reproduces the bug first (an automated test in the project's own setup, or a one-off script). Make a single fix for the root cause, with no "while I'm here" improvements. Verify: the test passes, nothing else broke, the issue is really resolved (using [[skill-verification-before-completion]]).
5. **Three failed fixes means stop.** Count the attempts. Below three, return to phase 1 with the new information. At three or more, question the architecture: does each fix reveal new coupling elsewhere, need massive refactoring, or create new symptoms? Discuss with Giovanni before a fourth attempt.
6. **Red flags that mean "return to phase 1".** "Quick fix now, investigate later"; "just try changing X"; several changes at once; skipping the test; proposing fixes before tracing the data; "one more attempt" after two failures. Giovanni's signals of doing it wrong: "Is that not happening?" (assumed without verifying), "Stop guessing", "We're stuck?".
7. **When there is truly no root cause** (environmental, timing, external): document what was investigated, add handling such as a retry, a timeout or a clear error message, and add logging for the future. But 95 % of "no root cause" cases are incomplete investigations.
