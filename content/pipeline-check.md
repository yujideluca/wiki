---
id: pipeline-check
title: pipeline-check
aliases: [pipeline-check.sh, report.json]
kind: program
project: quizapp
status: active
location: pipeline-check:src
fed_by: [fitness-check]
feeds: [quizapp-ci, skill-revisao-manutencao]
sources: [pipeline-check:src/lib.rs, pipeline-check:docs/adr/0003-one-repository-consumed-by-version.md, QuizApp:pipeline-check.toml, QuizApp:tools/pipeline-check.sh, QuizApp:docs/adr/0013-program-measures-skill-judges.md]
---

## What it is
A Rust program that measures a project and makes the machine, not Claude's habit, refuse a bad merge (ADR-0013). It replaces `fitness_check.py`. Language chosen by Giovanni.

## What it does
Writes `build/pipeline-check/report.json` (project, date, mode `local` or `ci`, checks with status `ok`/`aviso`/`falha`/`pulado`, value and limit, and a `dora` block) and exits 1 if any check is `falha`; a warning never fails. Checks: the project gate ([[quizapp-quality-gate]]) runs once; the architecture check (no `android.*` or `androidx.*` import in `:core`, read from the source); fitness functions with a warning from 80 % of the limit and a failure at 100 %; DORA figures from git, the release feed and the decision log; and, in local mode only, whether the last CI run is green and branch protection requires the job `gate` (read-only, through `gh`). A check that could not run is `pulado`, never `ok`; if it is required it is `falha`.

## How it does it
Rust with `serde`, `toml` and `clap`; `git` and `gh` are called as processes. Limits live in `pipeline-check.toml`, changed only by Giovanni with a decision-log row. `tools/pipeline-check.sh` builds and runs it; the gate calls it with `--measure-only` (no recursion). Requirements PC-1..PC-11, tests tagged `REQ`. It went through its own process first: the skill [[skill-gerar-teste-automatizado]] wrote bug-finding tests (`tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`) that found six defects, all fixed, and a hand-made mutation check (`mutants.py`) catches every planted fault.

## Where it sits in the pipeline
CI runs it instead of the bare gate ([[quizapp-ci]]); Claude runs it at the start of every [[skill-revisao-manutencao]]. Part of the [[maintenance-pipeline]].

## Who receives its output
[[quizapp-ci]] (the red or green mark) and [[skill-revisao-manutencao]] (reads `report.json`, never re-measures).

## Functions
- `classify`: ok below the warning share, aviso up to the limit, falha from the limit
- `arch::check`: import scan of the pure module and its build file
- `dora::compute`: frequency, lead time, rework and preventive share, `null` without data
