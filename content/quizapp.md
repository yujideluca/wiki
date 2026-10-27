---
id: quizapp
title: QuizApp (German Quiz, Android)
aliases: [German Quiz, Deutsch B2, german-quiz]
kind: project
project: none
status: active
location: QuizApp:
fed_by: [claude-code, project-template]
feeds: [quizweb]
sources: [QuizApp:DESIGN.md, QuizApp:CLAUDE.md]
reviewed: 2026-10-27T01:34Z
---

## What it is
QuizApp ("German Quiz") is an Android app that Giovanni uses to drill German for the B2 level of the Goethe exam. It works offline and uses spaced repetition in the style of [Anki](https://apps.ankiweb.net/): a method in which questions you answer well come back after longer and longer gaps, and questions you get wrong come back soon ([spaced repetition](https://en.wikipedia.org/wiki/Spaced_repetition)). The repository is `yujideluca/german-quiz`, the folder is `~/dev/QuizApp`, and the app's package name is `dev.yuji.quiz`. It is also the reference project for how Giovanni's projects are built.

## Flow
trigger t1: Giovanni opens the app on the phone | [[phone]]
step s1: Picks one of the five study modes | [[game-modes]]
step s2: The scheduler picks the next question from the pool | [[spaced-repetition-scheduler]]
step s3: Giovanni answers; the grader checks it | [[answer-grader]]
decide d1: Correct and quick?
step s4: The card moves out to days, weeks, months
step s5: The card comes back soon
step s6: Daily goal and streak calendar update | [[daily-goal]], [[activity-calendar]]
trigger t2: A new question pack is published | [[question-pack]]
step s7: The app fetches the pack, with no new app release
trigger t3: Giovanni asks for a change | [[giovanni]]
step s8: The change takes the release path, beta before stable | [[quizapp-release]]
product p1: Learning progress, backed up on request | [[progress-backup]]
product p2: A new beta or stable app on the phone | [[update-client]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -yes-> s4
d1 -no-> s5
s4 -> s6
s5 -> s6
s6 -> p1
t2 -> s7
s7 -> s2
t3 -> s8
s8 -> p2

## Architecture
### Context
person p: Player — studies German vocabulary | [[giovanni]]
system a: German Quiz app — spaced-repetition quiz for Android
external w: German Quiz web — the same quiz in a browser | [[quizweb]]
external f: Release feed — latest version, signed app file, question pack | [[release-feed]]
external d: Phone storage or Google Drive — holds the backup file | [[phone]]

p -studies with-> a
p -studies with-> w
a -shares questions and test vectors with-> w
a -downloads updates and questions from-> f
a -saves backups to-> d

### Containers
person p: Player | [[giovanni]]
container ui: Screens — what the player sees and taps
container ct: Study controller — the one door the screens use | [[quizapp-app]]
container co: Core module — scheduler, grader, queue; no Android | [[quizapp-core]]
container da: Data layer — progress, settings, updater
store v: Vocabulary files — built into the app | [[vocab-assets]]
store dl: Downloaded question pack — newer questions
external f: Release feed | [[release-feed]]

p -taps-> ui
ui -calls-> ct
ct -runs the rules in-> co
ct -saves through-> da
da -reads-> v
da -reads and writes-> dl
da -downloads from-> f

## What it does
It offers five study modes over a curated pool of B2 content ([[game-modes]]): der/die/das, prepositions, plural forms, Präteritum (the German simple past) and "Fehler finden" (find the error). Wrong or slow answers return soon; known cards move out to days, weeks and months ([[spaced-repetition-scheduler]]). It has a daily goal and a streak calendar ([[daily-goal]], [[activity-calendar]]), a backup of progress ([[progress-backup]]) and updates from inside the app ([[update-client]]). Since 2026-10-22 the question pool can grow without a new app release: new [[question-pack]]s arrive from the update feed ([[question-pool-updater]], [[publish-content]]).

## How it does it
It is written in [Kotlin](https://kotlinlang.org/) with [Jetpack Compose](https://developer.android.com/compose) (Android's modern way of drawing screens), split into two Gradle modules (parts built separately): [[quizapp-core]] (pure Kotlin logic: scheduler, grader, queue, session, content) and [[quizapp-app]] (Android screens, storage, updates). The content is built from tab-separated text files by [[build-vocab]]. Every change goes requirement → test → code, passes the [[quizapp-quality-gate]], and reaches the phone through the beta channel first ([[release-channels]], [[quizapp-release]]). The design and its decisions are in [[quizapp-design-doc]] and [[quizapp-adrs]].

## Where it sits in the pipeline
It is Giovanni's main study tool. Its web twin is [[quizweb]], which must behave the same way ([[check-web-sync]]). Releases go out through the [[release-feed]].

## Who receives its output
Giovanni, on the [[phone]]; [[quizweb]] receives its rules, test vectors and translations.

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
1. **The spacing rules come first** (they are requirements, pinned by tests): the spacing-rule and simulation tests, the shared vectors and the planted-fault checks.
2. **Logic is framework-free**: scheduler, grader, queue and session live in the core module, which has no Android; an `import android.*` there does not compile.
3. **Requirement, then test, then code**: checked by the traceability step of the gate.
4. **Nothing reaches the player without the beta app first**, and a version may be promoted once it survives the automated tests updated for what it changes; then promoting is Giovanni's call.
5. **The web twin behaves like the app**: shared test vectors, a sync check, and both continuous integration runs.
6. **Decisions are written where the code is**: decision log with its type, an architecture decision record for structural ones, the C4 diagrams in `DESIGN.md` change in the same commit.

### Decisions
13 architecture decision records (ADRs, short notes that keep the reasons for a decision) in `docs/adr/`, [[quizapp-adrs]]: Kotlin with Jetpack Compose; a pure scheduler with an injected clock; an update feed with an in-app updater; two release channels (beta first); a web twin; spacing rules as requirements; requirements first; a pure core module; progress backup as one file; promotion after updated tests; a downloadable question pool; a program that measures and a skill that judges. `DESIGN.md` also holds the decision log.

### Requirements
33 requirements in `docs/REQUIREMENTS.md` ([[quizapp-requirements]]), grouped by prefix (spacing rules SP, scheduling and daily goal DG, question pool QP, backup PE, updates UP and more). Each has a test tagged `REQ <ID>`, and the traceability check ([[check-traceability]]) fails when one has none.

### Quality gate
[[quizapp-quality-gate]] is one script, seven steps: core and app tests with coverage; coverage thresholds for the logic packages; the web tests; the conformance vectors identical in app and web; requirement traceability; Android lint; the fitness functions and the question pool manifest. Before a promotion a mutation check also runs (faults planted on purpose must be caught).

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` runs the gate on GitHub for every push ([[quizapp-ci]]); after pushing, the run must be green.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` (P1 to P3) under the [[maintenance-policy]]. The [[monthly-architecture-review]] checks the project every month; the next is due 2026-11-22.
