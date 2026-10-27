---
id: processing-sketches
title: Processing sketches
aliases: [drachenkurve project]
kind: project
project: none
status: active
location: processing-sketches:
fed_by: []
feeds: []
sources: [processing-sketches:drachenkurve, processing-sketches:drachenfraktal]
reviewed: 2026-10-27T01:34Z
---

## What it is
Small generative-art programs (art made by code) written in [Processing](https://processing.org/), a programming environment for drawing based on Java. They are in `~/dev/processing-sketches`. A "sketch" is what Processing calls a program.

## Flow
trigger t1: Giovanni writes a sketch in Processing
step s1: Each sketch is a .pde file in its own folder
step s2: Running it draws the Heighway dragon curve
decide d1: Which version?
step s3: Exported as an app build, ignored by git | [[drachenkurve]]
step s4: Rendered as the QuizApp launcher icon | [[quizapp]]
trigger t2: A push to the repository | [[pipeline-check]]
step s5: The quality gate and the automatic checks run
product p1: The QuizApp launcher icon | [[quizapp]]
product p2: A second dragon-curve sketch, as a program only | [[drachenfraktal]]
product p3: Checked sketches on GitHub

t1 -> s1
s1 -> s2
s2 -> d1
d1 -drachenkurve-> s3
d1 -drachenfraktal-> p2
s3 -> s4
s4 -> p1
t2 -> s5
s5 -> p3

## Architecture
### Context
person g: Giovanni — draws and runs the sketches | [[giovanni]]
system s: processing-sketches — a folder of small Processing sketches
external p: Processing — the tool that runs a sketch
external h: GitHub — keeps the history, private | [[github]]

g -runs sketches with-> p
g -keeps the sketches in-> s
s -is pushed to-> h

### Containers
person g: Giovanni | [[giovanni]]
container dk: Dragon curve sketch | [[drachenkurve]]
container df: Dragon fractal sketch | [[drachenfraktal]]
store bo: build/ — jars made when a sketch runs, never committed
container qg: Quality gate — each sketch has its .pde file and no build output is tracked

g -runs-> dk
g -runs-> df
dk -writes-> bo
df -writes-> bo
qg -checks-> dk
qg -checks-> df
qg -checks that none is committed in-> bo

## What it does
It draws the Heighway dragon curve in two versions: [[drachenkurve]] (exported as an app; it rendered the QuizApp launcher icon) and [[drachenfraktal]].

## How it does it
Each sketch is a `.pde` file in its own folder; `drachenkurve` also has an exported build. Since 2026-10-24 the folder is a GitHub repository (`yujideluca/processing-sketches`, public since 2026-10-25) with a quality gate, CI (continuous integration, automatic checks on every push) and the [[pipeline-check]] pre-push check; the build output is ignored by git.

## Where it sits in the pipeline
Off to the side of the other projects; its one link into them is the icon of [[quizapp]].

## Who receives its output
[[quizapp]] (its launcher icon).

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
1. **One folder per sketch**: each holds a `.pde` file of the same name; the gate fails when one does not.
2. **Build output is never committed**: the gate fails when a tracked file lies under a `build/` folder.
3. **The gate decides**: `tools/quality_gate.sh` is the only definition of passing, and continuous integration runs it.
4. **Decisions go in `DESIGN.md`.**

### Decisions
There are no architecture decision records yet; the decision log in `DESIGN.md` has three rows: the project was put under git on GitHub (private) with a gate and CI, the first maintenance review, and the monthly review of 2026-10-25.

### Requirements
There is no requirements list yet, because the sketches have no behaviour tests (technical debt P3: move the curve geometry into a tested function if the sketches grow).

### Quality gate
The gate `tools/quality_gate.sh` checks that every sketch folder holds its `.pde` file and that no build output is tracked by git. `tools/pipeline-check.sh` adds the full measurement.

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` runs the gate on GitHub for every push, through `pipeline-check` pinned in `pipeline-check.version`.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` (P1 to P3) under the [[maintenance-policy]]. The [[monthly-architecture-review]] checks the project every month; the next is due 2026-11-22.
