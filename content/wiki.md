---
id: wiki
title: Wiki (this site)
aliases: [wiki, concept wiki]
kind: project
project: none
status: active
location: wiki:
fed_by: [claude-code, project-template]
feeds: []
sources: [wiki:docs/2026-10-22-wiki-design.md, wiki:DESIGN.md]
memory: [#f1e117]
reviewed: 2026-10-27T01:34Z
---

## What it is
This site is a wiki: an encyclopedia of every project, program, skill and process in Giovanni's systems, with a map that shows how they connect. Each topic has its own page, written so that a reader who knows nothing about the system or its technical language can follow it. New to a word? Open the [[glossary]], which explains the terms used on the pages. The repository `yujideluca/wiki` is public (since 2026-10-25), the folder is `~/dev/wiki`, and the project was started on 2026-10-22 from [[project-template]].

## Flow
trigger t1: Claude finishes a task that changed a system | [[end-of-task]]
step s1: Writes Markdown pages, each with a small header | [[wiki-content]]
step s2: wiki check applies the content rules | [[wiki-check]]
decide d1: Do the rules pass?
step s3: wiki build turns the pages into data | [[wiki-build]]
step s4: Only content/ is committed and uploaded | [[github]]
step s5: The server serves the site: Giovanni's Google account gets in, everyone else sees a decoy | [[wiki-router]], [[decoy-page]]
trigger t2: Giovanni opens the wiki | [[giovanni]]
step s6: Searches, hovers over the map, clicks a dot | [[wiki-frontend]]
product p1: Publishing refused, with the problems listed
product p2: A page that answers the architecture question

t1 -> s1
s1 -> s2
s2 -> d1
d1 -no-> p1
d1 -yes-> s3
s3 -> s4
s4 -> s5
t2 -> s5
s5 -> s6
s6 -> p2

## Architecture
### Context
person g: Giovanni — reads the pages on a laptop or phone | [[giovanni]]
person c: Claude Code — writes the pages at the end of every task | [[claude-code]]
system w: Wiki — the pages, the map and the checks
external f: Tailscale Funnel — the public web address | [[tailscale-funnel]]
external o: Google sign-in — proves it is Giovanni | [[google-oauth-client]]
external h: GitHub — keeps the history of the pages | [[github]]

g -opens-> f
f -passes requests to-> w
c -publishes pages to-> w
w -asks who is there-> o
w -pushes the pages to-> h

### Containers
person g: Giovanni — in a browser | [[giovanni]]
person c: Claude Code — at the end of a task | [[claude-code]]
container fe: Elm front end — the map and the articles | [[wiki-frontend]]
container sv: Elixir server — login gate, decoy page, files | [[wiki-server]]
container cli: The wiki command — check, publish, hook | [[wiki-cli]]
store pg: Pages — Markdown files in three languages | [[wiki-content]]
store st: Built site — the data files the front end reads | [[wiki-site]]
external o: Google sign-in | [[google-oauth-client]]

g -uses-> fe
g -signs in through-> sv
fe -reads-> st
sv -serves-> st
sv -asks-> o
c -runs-> cli
cli -reads and checks-> pg
cli -builds-> st

## What it does
It lets Giovanni answer an architecture question after one search and at most two clicks: search with suggestions while typing, hover over a dot on the map to see what it is in four boxes, click the dot for the full page ([[wiki-frontend]]). On a phone the map fills the screen with a search bar on top and tapping a dot opens a balloon with its description; on a desktop the map is seen through a lens and its dots stretch elastically when dragged ([[wiki-map-view]]). It is kept up to date automatically at the end of every task ([[end-of-task]]). For the whole system on one page, start with [[system-overview]].

## How it does it
The content is Markdown text files, each with a small header ([[wiki-content]]); they are checked by [[wiki-check]] and turned into JSON (JavaScript Object Notation) data by [[wiki-build]]. The part you see is written in Elm ([[wiki-frontend]]); the server is written in Elixir ([[wiki-server]]) and lets in only one Google account, showing everyone else a decoy ([[wiki-router]], [[decoy-page]]). It is reachable on the internet through [[tailscale-funnel]]. The languages are English, German and Brazilian Portuguese.

## Where it sits in the pipeline
Beside [[workflow-memory]]: the memory holds rules and preferences, while the wiki describes what exists and how it works, and links to memory entries instead of copying them.

## Who receives its output
[[giovanni]], in the browser on the laptop or the phone.

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
1. **Requirement, then test, then code**: every promise is a row in `docs/REQUIREMENTS.md`, checked by the traceability check in the gate.
2. **Default deny**: without Giovanni's verified Google session nothing real is served; the login-gate and decoy tests check it.
3. **Content follows the rules before it is published**: `wiki check` refuses a bad page and `wiki publish` will not run on a problem.
4. **The gate decides**: `tools/quality_gate.sh` is the only definition of passing, and the continuous integration run uses the same script.
5. **Decisions are written where the code is**: a row in the decision log of `DESIGN.md`, and an architecture decision record for structural ones.

### Decisions
The design file `DESIGN.md` keeps the C4 diagrams and a decision log, newest first, each row with its maintenance type. Architecture decision records (ADRs, short notes that keep the reasons for a decision) in `docs/adr/`: 0002 Elm front end and Elixir back end; 0003 one login gate with a decoy page for everyone else; 0004 pages as Markdown with a header, checked before publishing; 0005 a program measures and a skill judges; 0006 the review time is kept in the page; 0007 the flowchart section. See also the [[monthly-architecture-review]].

### Requirements
69 requirements in `docs/REQUIREMENTS.md`, grouped by a two-letter prefix (login AU, decoy DC, content CO, flowcharts FL, project pages PJ, map MP, phone layout MB and more). Each one has a test tagged `REQ <ID>`, and the traceability check ([[check-traceability]]) fails when one has none.

### Quality gate
[[wiki-quality-gate]] is one script, five steps: the Elixir tests; the Elm tests and the optimized build; requirement traceability; the content rules (`wiki check`); the fitness functions (largest file, gate time, bundle size).

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` on GitHub installs Erlang, Elixir, Node and Elm and runs the gate through `pipeline-check` on every push and pull request. A commit reaches `main` only after the gate is green on that exact commit.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` (P1 to P3) under the [[maintenance-policy]]. The [[monthly-architecture-review]] checks the project every month; the next is due 2026-11-22.
