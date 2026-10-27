---
id: project-template
title: project-template (golden path)
aliases: [template, golden path]
kind: project
project: none
status: active
location: project-template:
fed_by: []
feeds: [quizapp, wiki]
sources: [project-template:README.md, project-template:CLAUDE.md]
reviewed: 2026-10-27T01:34Z
---

## What it is
project-template is the starting point for every new software project of Giovanni's. It is a ready-made folder (`~/dev/project-template`, repository `yujideluca/project-template`) that already contains the good working habits, so that doing it the right way is also the quickest way. It was chosen in the maintenance and evolution review of 2026-10-22, and [[quizapp]] was the reference project it was extracted from.

## Flow
trigger t1: A new project starts | [[new-project]]
step s1: The template folder is copied into a new project folder
step s2: It brings enforced principles, a design file, tagged tests, a gate and a debt policy | [[template-quality-gate]], [[maintenance-policy]]
step s3: Claude fills in CLAUDE.md, the design file, first requirements and the gate steps
step s4: The private repository and its labels are created
step s5: The project pins a pipeline-check version; the program itself is not copied | [[pipeline-check]]
trigger t2: A running project finds a better practice | [[monthly-architecture-review]]
step s6: The improvement is moved into the template
product p1: A new project that starts with the good habits built in | [[wiki]]
product p2: A better template for the next project

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> p1
t2 -> s6
s6 -> p2

## Architecture
### Context
person g: Giovanni — asks for a new project and picks the language | [[giovanni]]
person c: Claude Code — copies the template and fills it in | [[claude-code]]
system t: project-template — the starting folder with the good habits built in
external n: A new project — a copy that starts with the habits
external p: pipeline-check — the measuring program, fetched by version | [[pipeline-check]]
external h: GitHub — a private repository for the new project | [[github]]

g -asks for a project from-> t
c -copies and fills in-> t
t -is copied into-> n
n -pins a version of-> p
n -is pushed to-> h

### Containers
person c: Claude Code | [[claude-code]]
container cm: CLAUDE.md — principles and working rules
container ds: DESIGN.md — C4 diagrams and the decision log
store ad: docs/adr — decision records
store rq: REQUIREMENTS.md — promises with IDs | [[check-traceability]]
store mt: MAINTENANCE.md — the debt policy and review list | [[maintenance-policy]]
container qg: quality_gate.sh — the one definition of passing | [[template-quality-gate]]
container ru: pipeline-check.sh — fetches and runs the pinned version
container ci: Automatic-check workflow — runs the runner on every push
external p: pipeline-check | [[pipeline-check]]

c -fills in-> cm
c -fills in-> ds
c -writes-> ad
c -writes-> rq
c -follows-> mt
c -fills in the steps of-> qg
ci -starts-> ru
ru -runs-> qg
ru -fetches-> p

## What it does
From day one a new project gets: principles that are each enforced by a check; a design file with diagrams (in the [C4 model](https://c4model.com/) style, drawn with [Mermaid](https://mermaid.js.org/)) and a decision log; ADRs (architecture decision records, short notes that keep the reasons for decisions); a list of requirements with tests tagged to them ([[check-traceability]]); a quality gate (one script that defines "passing", [[template-quality-gate]]); CI (continuous integration: automatic checks on every push); and the policy for technical debt and reviews ([[maintenance-policy]]).

## How it does it
The folder is copied with `cp -r` into a new project folder. In the first session Claude fills in the project's CLAUDE.md (its instruction file), section 1 of the design file, the first requirements, the gate's steps and ADR-0002 for the chosen technology, and then creates the private GitHub repository and its labels ([[new-project]]). Before any of that, Giovanni chooses the programming language ([[work-ask-language]]). The maintenance program [[pipeline-check]] is not copied into the project: the folder carries the file `pipeline-check.version` (`v0.4.0` on 2026-10-24), the runner `tools/pipeline-check.sh`, which fetches and builds that version from `yujideluca/pipeline-check` once (the machine needs Rust, `cargo` and git), the limits in `pipeline-check.toml`, and a local pre-push check in `tools/hooks/pre-push`, turned on with `git config core.hooksPath tools/hooks`.

## Where it sits in the pipeline
Upstream of every new project. This [[wiki]] was the first project started from it.

## Who receives its output
New projects such as the [[wiki]]; improvements found in running projects flow back into the template during the [[monthly-architecture-review]].

## Engineering practices
### Principles
1. **Requirement, then test, then code**: a behaviour becomes a row in `docs/REQUIREMENTS.md`, then a test tagged `REQ <ID>`; the traceability step of the gate checks it.
2. **Logic is framework-free**: each project names its pure module and what enforces it (a module boundary or an architecture test).
3. **The gate decides**: `tools/quality_gate.sh` is the only definition of passing, and continuous integration runs it through `pipeline-check`.
4. **A tool used by more than one project lives once**, in its own repository, consumed by pinned version and never copied.
5. **Decisions are written where the code is**: a decision-log row with its type in `DESIGN.md`, and an architecture decision record for structural ones.

### Decisions
Two architecture decision records (ADRs, short notes that keep the reasons for a decision) in `docs/adr/`: 0001 record decisions as ADRs, and 0003 a program measures and a skill judges (0002 is left for each new project's choice of technology). `DESIGN.md` holds the decision log with its maintenance type.

### Requirements
`docs/REQUIREMENTS.md` holds one placeholder row (`XX-1`) that shows the format; a new project replaces it with its own requirements, each with a test tagged `REQ <ID>` ([[check-traceability]]).

### Quality gate
[[template-quality-gate]] is a script with three placeholder steps to fill in: build and tests, requirement traceability, and the fitness functions (limits in `pipeline-check.toml`).

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` runs the runner `tools/pipeline-check.sh` on GitHub for every push; a local pre-push check in `tools/hooks/pre-push` stands in for branch protection on a private repository.

### Maintenance
The template carries the policy itself: [[maintenance-policy]] (technical debt as GitHub issues labelled `debt`, P1 to P3, about one session in five spent on it) and the [[monthly-architecture-review]] checklist. An improvement found in a running project is moved back here; the next review is due 2026-11-22.
