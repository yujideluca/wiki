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
sources: [pipeline-check:LICENSE, pipeline-check:src/lib.rs, pipeline-check:src/shellcheck.rs, pipeline-check:src/traceability.rs, pipeline-check:docs/adr/0003-one-repository-consumed-by-version.md, QuizApp:pipeline-check.toml, QuizApp:tools/pipeline-check.sh, QuizApp:docs/adr/0013-program-measures-skill-judges.md]
reviewed: 2026-10-27T01:45Z
---

## What it is
pipeline-check is a program, written in [Rust](https://www.rust-lang.org/) (the language was Giovanni's choice), that measures a software project and makes a machine, not Claude's good habits, refuse a bad merge (decision ADR-0013 in QuizApp; an ADR is an architecture decision record, a short note that keeps the reasons for a decision). It replaced the older Python script `fitness_check.py`.

## Architecture
### Context
person g: Giovanni — the only one who changes the limits | [[giovanni]]
system p: pipeline-check — measures a project and blocks a bad change
external a: A project that uses it — its gate, limits and source
external c: Automatic checks on GitHub — run it on every push | [[quizapp-ci]]
external h: GitHub — read-only questions about protection and runs | [[github]]
external s: Review skill — reads the report and judges | [[skill-revisao-manutencao]]

g -changes the limits of-> a
c -runs-> p
p -measures-> a
p -asks-> h
p -writes a report for-> s

### Containers
person g: Giovanni or a build job
container cl: Command line — options such as --measure-only and --traceability
container ru: Runner — runs the checks in order and builds the report
container ga: Project checks — the project's own gate once, and every requirement has a tagged test
container co: Code checks — forbidden imports, size limits that warn at 80 % and fail at 100 %, shell-script lint
container gh: GitHub and delivery checks — branch protection, runs, how often changes ship
store cf: pipeline-check.toml — the limits, in each project
store rp: report.json — every check with status, value and limit

g -runs-> cl
cl -starts-> ru
ru -reads the limits in-> cf
ru -runs-> ga
ru -runs-> co
ru -runs-> gh
ru -writes-> rp

## What it does
It writes `build/pipeline-check/report.json`: the project, the date, the mode (`local` or `ci`), a list of checks each with a status (`ok`, `aviso` = warning, `falha` = failure, `pulado` = skipped), a value and a limit, plus a `dora` block of delivery metrics (DORA: DevOps Research and Assessment). It exits with code 1 if any check is a `falha`; a warning never fails. The checks are:
- the project's own quality gate ([[quizapp-quality-gate]]), run once;
- the architecture check: no `android.*` or `androidx.*` import may appear in the module `:core`, which is read from the source;
- fitness functions (automatic limits such as file size), with a warning from 80 % of a limit and a failure at 100 %;
- DORA figures, taken from git, the release feed and the decision log;
- and, in local mode only, whether the last run of continuous integration (CI, automatic checks on GitHub) is green and whether branch protection requires the job `gate` (read-only, through the `gh` command of GitHub). A repository that cannot have the protection documents why with `protection_exception` in the `[github]` section of its `pipeline-check.toml`; the check is then `aviso` (a warning that does not fail the run) and states the reason, and it is never `ok`.
- when the project has a `[shellcheck]` section in its `pipeline-check.toml`, whether its shell scripts pass `shellcheck` (a program that finds mistakes in shell scripts), run on every `.sh` file that git tracks plus the extra files listed there, at the chosen severity (requirement PC-15, version v0.4.0). A clean run is `ok`, a finding is `falha` and names the first one, and a machine without `shellcheck` gives `pulado`.
A check that could not run is `pulado`, never `ok`; if it was required, it counts as `falha`.

The program has two more modes besides the report: `--traceability` checks that every requirement has a test ([[check-traceability]], PC-14), and `--pre-push` is the git hook described below (PC-13). With `--no-github` it never asks GitHub (PC-12).

## How it does it
It is Rust with the libraries `serde`, `toml` and `clap`, and it runs `git` and `gh` as separate processes. The limits live in `pipeline-check.toml` in each project and are changed only by Giovanni, with a decision-log row. The script `tools/pipeline-check.sh` builds and runs it; the gate calls it with `--measure-only` so it does not run the gate again (no recursion). Its own requirements (PC-1 to PC-15) have tests tagged `REQ`. It went through its own process first: the skill [[skill-gerar-teste-automatizado]] wrote bug-finding tests (record in `tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`) that found six defects, all fixed, and a hand-made mutation check (`mutants.py`, which plants faults on purpose) catches every planted fault.

## Where it sits in the pipeline
CI runs it instead of the bare gate ([[quizapp-ci]]), and Claude runs it at the start of every [[skill-revisao-manutencao]]; it is part of the [[maintenance-pipeline]]. The program lives once, in its own public repository (`yujideluca/pipeline-check`). [[project-template]], [[quizapp]], the [[wiki]], [[quizweb]], [[workflow-memory]], [[remote-terminal]] and [[processing-sketches]] each pin a version tag in a file named `pipeline-check.version` (v0.5.0 in workflow-memory, v0.4.0 in the others) and keep only their own `pipeline-check.toml` and a small runner script. It also runs as the git pre-push hook (`--pre-push`), which stops a push of `main` when a check fails, because branch protection is not available on private free-plan repositories. Why one repository and not copies: ADR-0003 in that repository. The repository carries the MIT licence (a short permissive licence: anyone may use, copy and change the software, provided the copyright notice stays), set on 2026-10-25 in the file `LICENSE` and in `Cargo.toml`.

## Who receives its output
[[quizapp-ci]] (the red or green mark) and [[skill-revisao-manutencao]] (which reads `report.json` and never measures again).

## Functions
- `classify`: ok below the warning share, aviso up to the limit, falha from the limit
- `arch::check`: import scan of the pure module and its build file
- `dora::compute`: frequency, lead time, rework and preventive share, `null` without data
