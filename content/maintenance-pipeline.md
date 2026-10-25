---
id: maintenance-pipeline
title: Maintenance pipeline (measure, then judge)
aliases: [pipeline-check process, maintenance process]
kind: process
project: project-template
status: active
fed_by: []
feeds: []
sources: [QuizApp:docs/2026-10-24-pipeline-check-design.md, QuizApp:docs/adr/0013-program-measures-skill-judges.md]
reviewed: 2026-10-24T22:03Z
---

## What it is
This is the way Giovanni's software projects are kept maintainable: a program measures and blocks, a skill judges and proposes, and the two talk to each other only through one file, `report.json`. The split is deliberate (ADR-0013 in QuizApp; an ADR is an architecture decision record, a short note that keeps the reasons for a decision): numbers should come from a machine that cannot be talked out of them, and judgement should come from Claude, which can weigh them.

## What it does
It turns the rules of [[maintenance-policy]] into something a machine enforces: the CI job (continuous integration, automatic checks on every push) fails on a `falha` (failure), and the monthly review reads the same numbers instead of measuring by hand.

## How it does it
[[pipeline-check]] runs in CI and on the laptop; [[skill-revisao-manutencao]] reads its report. The program is not copied into projects: it lives in its own repository, `yujideluca/pipeline-check`, and each project pins a version in `pipeline-check.version`. To really block a merge, GitHub's branch protection must require the CI job, and only Giovanni changes that. On a private repository of a free GitHub plan this protection is not available (GitHub answers with error 403), so a local pre-push check (`pipeline-check --pre-push`, enabled with `git config core.hooksPath tools/hooks`) stops the push of `main` when a check fails. Giovanni chose the local check on 2026-10-24. On 2026-10-25 Giovanni decided to make the repositories that need protection public instead, because GitHub accepts branch protection (a setting that refuses changes to `main` until named checks pass) on public repositories of the free plan. Since then the CI job `gate` is a required check on `main` in german-quiz (the QuizApp project), remote-terminal, wiki and processing-sketches, and `pipeline-check` reports `protecao-de-branch` as `ok` there (`ok`: the check passed). workflow-memory is public but not protected yet: its `mem` job pushes derived files straight to `main` with GitHub's built-in token, and a required check could block those pushes, so Giovanni has to choose how to handle that. The pre-push check stays in place. It was first applied to [[quizapp]], then copied to the other projects and to [[project-template]].

## Where it sits in the pipeline
Between every push and the monthly review: [[quizapp-ci]], then [[monthly-architecture-review]].

## Who receives its output
Giovanni.

## Steps
1. A push runs the CI job `gate`, which runs [[pipeline-check]].
2. Any `falha` fails the job; branch protection (or the local pre-push check) stops the merge.
3. An `aviso` (warning) never fails but shows in the report.
4. At the monthly review, [[skill-revisao-manutencao]] turns warnings and failures into prioritised `debt` proposals.
5. Giovanni decides; the skill records a Preventive row in the decision log and publishes the wiki.
