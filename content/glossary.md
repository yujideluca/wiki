---
id: glossary
title: Glossary
aliases: [terms, dictionary, definitions]
kind: reference
project: none
status: active
fed_by: []
feeds: []
reviewed: 2026-10-24
---

## What it is
This is the dictionary of the wiki: plain-language definitions of the technical words and abbreviations used on its pages, with a link to a good outside explanation wherever one exists. If you meet a word you do not know, look it up here; every page also explains a term where it first uses it. Entries that have their own page in this wiki point to it.

## What it does
It lets a reader with no background in software, in this system or in medicine understand any page without leaving the wiki for long. The terms are listed in alphabetical order under Notes. A term that is written in a different language (German exam names, for example) is explained here as well.

## How it does it
Each entry gives the full name of an abbreviation, a short definition in everyday words and, where useful, a link. The page is of the kind "reference": it can link to any page without drawing lines on the map (decision recorded as requirement BU-3). The top bar of every screen links to it.

## Where it sits in the pipeline
Beside the pages it explains. It belongs to no project and takes part in no pipeline.

## Who receives its output
Every reader of the wiki, above all [[giovanni]] and anyone new to the system.

## Notes
- **Activity / Android Activity**: one screen-hosting component of an Android app ([documentation](https://developer.android.com/guide/components/activities/intro-activities)).
- **adb** (Android Debug Bridge): a tool that lets a computer control an Android phone over a cable ([documentation](https://developer.android.com/tools/adb)); see [[skill-adb-android-control]].
- **ADR** (architecture decision record): a short note that records one important decision, why it was taken and what the alternatives were ([adr.github.io](https://adr.github.io/)); see [[quizapp-adrs]] and [[memory-adrs]].
- **Anki**: a flashcard program that uses spaced repetition ([apps.ankiweb.net](https://apps.ankiweb.net/)).
- **API** (application programming interface): the way one program offers its functions to other programs, usually over the web.
- **APK** (Android Package): the file that contains an Android app and is installed on the phone ([APK](https://en.wikipedia.org/wiki/Apk_%28file_format%29)).
- **Approbation**: in Germany, the licence to practise medicine. **Anerkennung** is the recognition of a foreign qualification. See [[skill-candidatura-alemanha]].
- **Append-only**: a record to which new items are only added, never edited or deleted; see [[events-log]].
- **Asset**: a file packed inside an app that is not code, such as data or images; see [[vocab-assets]].
- **Bash**: the standard command language of the Linux terminal; scripts written in it end in `.sh` ([Bash](https://www.gnu.org/software/bash/)).
- **Beta / stable channel**: two streams of versions of the app; the beta is tried first, the stable one is what the user normally runs; see [[release-channels]].
- **Branch**: a separate line of work in a git repository; `main` is the principal one.
- **Brief**: the short summary of the memory that every chat starts with; see [[session-brief]].
- **CI** (continuous integration): automatic checks that run on every change that is uploaded, so a mistake is noticed at once ([CI](https://en.wikipedia.org/wiki/Continuous_integration)); see [[quizapp-ci]].
- **CLAUDE.md**: a text file of standing instructions that Claude Code reads automatically at the start of a session; see [[global-claude-md]].
- **CLI** (command-line interface): a program used by typing commands in a terminal ([CLI](https://en.wikipedia.org/wiki/Command-line_interface)).
- **Clone**: a full local copy of a repository.
- **Commit**: one saved step in the history of a git repository, with a message that says what changed.
- **Conformance vectors**: shared test cases that two implementations must both pass; see [[quizweb-conformance]].
- **Cookie**: a small piece of data that a website asks the browser to keep and send back, used to remember a login ([cookie](https://en.wikipedia.org/wiki/HTTP_cookie)); see [[wiki-router]].
- **CPF** (Cadastro de Pessoas Físicas): the Brazilian personal tax number; the privacy scan blocks it ([[mem-validator]]).
- **CSP** (Content Security Policy): a rule that tells the browser what a web page may load ([CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)).
- **Debt, technical**: anything that works today but makes the next change slower or riskier ([technical debt](https://en.wikipedia.org/wiki/Technical_debt)); see [[maintenance-policy]].
- **Decoy**: a page that looks real but hides the real thing; see [[decoy-page]].
- **DNS** (Domain Name System): the internet's phone book, which turns names into network addresses ([DNS](https://en.wikipedia.org/wiki/Domain_Name_System)).
- **DOM** (Document Object Model): the browser's live model of a web page ([documentation](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)).
- **DORA** (DevOps Research and Assessment): a research programme that defined four measures of how well software is delivered, such as how often and how fast changes are released ([dora.dev](https://dora.dev/)); see [[pipeline-check]].
- **Elixir**: the programming language of the wiki's server ([elixir-lang.org](https://elixir-lang.org/)); see [[wiki-server]].
- **Elm**: the programming language of the wiki's front end ([elm-lang.org](https://elm-lang.org/)); see [[wiki-frontend]].
- **Escript**: an Elixir program packed into one runnable file; see [[wiki-cli]].
- **Event**: a record that something happened; in the memory, one file per event; see [[events-log]].
- **Exit code**: the number a program returns when it ends; 0 means success, anything else means an error ([exit status](https://en.wikipedia.org/wiki/Exit_status)).
- **Fitness function**: an automatic check that a quality of the design has not drifted ([fitness function](https://en.wikipedia.org/wiki/Fitness_function)); see [[fitness-check]].
- **Fold**: combining a whole list of events into one current state; see [[memory-fold]].
- **FSP** (Fachsprachprüfung): the German medical-language exam at level C1 that foreign doctors take before being licensed; see [[skill-alemao-goethe-fsp]].
- **Gate / quality gate**: one script that defines "passing" for a project; see [[template-quality-gate]].
- **Git**: the version-control tool that records every change to a project ([git-scm.com](https://git-scm.com/)).
- **GitHub / GitHub Actions**: a website that stores git repositories; Actions runs automatic jobs on its computers ([documentation](https://docs.github.com/en/actions)); see [[github]].
- **Goethe B2**: the general German exam at upper-intermediate level (level B2 of the European reference framework) ([Goethe-Zertifikat B2](https://www.goethe.de/en/spr/prf/gzb2.html)).
- **GRADE** (Grading of Recommendations Assessment, Development and Evaluation): a method for rating how certain a body of medical evidence is ([GRADE](https://www.gradeworkinggroup.org/)); see [[skill-analise-artigo-cientifico]].
- **Gradle**: the tool that compiles and tests Android projects ([gradle.org](https://gradle.org/)); see [[android-toolchain]].
- **Hash**: a short fingerprint calculated from some content; if the content changes, the fingerprint changes ([hash function](https://en.wikipedia.org/wiki/Hash_function)); see **SHA-256** (Secure Hash Algorithm 256).
- **Hook**: a small program that Claude Code runs automatically at a certain moment, such as the start of a chat ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)); see [[hook-session-start]].
- **Hospitation**: in Germany, an observation visit at a hospital department.
- **HTML** (HyperText Markup Language): the language in which web pages are written ([HTML](https://en.wikipedia.org/wiki/HTML)).
- **HTTPS** (Hypertext Transfer Protocol Secure): the encrypted way in which browsers and websites talk to each other.
- **Idempotent**: doing it twice gives the same result as doing it once ([idempotence](https://en.wikipedia.org/wiki/Idempotence)).
- **JSON** (JavaScript Object Notation): a plain-text format for structured data ([JSON](https://en.wikipedia.org/wiki/JSON)).
- **Kenntnisprüfung**: the exam of medical knowledge that foreign-trained doctors in Germany can take instead of a document equivalence check.
- **Kotlin / Jetpack Compose**: the programming language and the screen toolkit of the Android app ([Kotlin](https://kotlinlang.org/), [Compose](https://developer.android.com/compose)); see [[quizapp]].
- **Linger**: a Linux setting that lets a user's background services run without anyone being logged in; see [[acer-nitro]].
- **localStorage**: a small key-value storage that every web browser gives a web page ([documentation](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage)).
- **logcat**: Android's system log, read with adb ([documentation](https://developer.android.com/tools/logcat)).
- **Manifest**: a list that describes the files of a package and how to verify them; see [[content-manifest]].
- **Markdown**: a text format with simple marks for headings, lists and links ([Markdown](https://en.wikipedia.org/wiki/Markdown)); see [[wiki-content]].
- **Memory (workflow-memory)**: the shared long-term memory of Giovanni's Claude assistants; see [[workflow-memory]].
- **Mutation testing**: deliberately breaking a program to check that the tests notice ([mutation testing](https://en.wikipedia.org/wiki/Mutation_testing)); see [[mutation-check]].
- **OAuth** (Open Authorization) and **OIDC** (OpenID Connect): the standards through which a service such as Google tells a website who is signing in ([OAuth](https://en.wikipedia.org/wiki/OAuth)); see [[wiki-sign-in]].
- **Open item**: an unfinished goal or known problem kept in front of Giovanni until it is dealt with; see [[mem-task]].
- **OTP** (Open Telecom Platform): Erlang's standard libraries and runtime, on which Elixir runs ([erlang.org](https://www.erlang.org/)).
- **PICO** (population, intervention, comparator, outcome): the four parts of a well-formed clinical question.
- **Pipeline**: a chain of steps, where each step takes the result of the previous one; in this wiki also the chain of pages that feed one another.
- **Plugin**: an add-on package for Claude Code; see [[claude-plugins]].
- **Production code**: the code that actually runs in the finished program, as opposed to test code.
- **Promote**: to move a tested beta version to the stable channel, which is Giovanni's decision; see [[publish-apk]].
- **Pull / push**: downloading the newest version of a repository, and uploading your own changes to it.
- **Pull request**: a proposal to merge a change into the main line of a repository.
- **Pure function**: a function whose result depends only on its input and that changes nothing else ([pure function](https://en.wikipedia.org/wiki/Pure_function)).
- **PWA** (progressive web app): a web page that can be installed on a phone like an app and works offline ([PWA](https://en.wikipedia.org/wiki/Progressive_web_app)); see [[quizweb]].
- **Repository**: a project folder together with the full history of its changes, stored with git ([repository](https://en.wikipedia.org/wiki/Repository_%28version_control%29)).
- **Requirement**: a testable promise a program makes; see [[wiki-requirements]].
- **Remote Control**: the Claude Code feature that lets Giovanni talk to a session on the laptop from the Claude app; see [[claude-assistant]].
- **SDK** (software development kit): the libraries and tools for developing software for one platform; see [[android-toolchain]].
- **Service (systemd)**: a program that runs in the background and is started and watched by the operating system ([systemd](https://en.wikipedia.org/wiki/Systemd)); see [[wiki-service]].
- **Service worker**: a script that a browser runs in the background for a web page, which enables offline use ([documentation](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)); see [[quizweb-service-worker]].
- **SHA-256** (Secure Hash Algorithm 256): a way of calculating a fingerprint of a file ([SHA-2](https://en.wikipedia.org/wiki/SHA-2)).
- **Skill**: a packaged set of instructions that Claude loads when a task of that kind comes up; see [[skills]].
- **SM-2** (SuperMemo 2): an early spaced-repetition algorithm ([SuperMemo](https://en.wikipedia.org/wiki/SuperMemo)); see [[spaced-repetition-scheduler]].
- **Spaced repetition**: a study method in which what you know comes back after longer and longer gaps ([spaced repetition](https://en.wikipedia.org/wiki/Spaced_repetition)).
- **SSH** (Secure Shell): an encrypted way to log in to another computer ([SSH](https://en.wikipedia.org/wiki/Secure_Shell)); see [[remote-terminal]].
- **Stale**: out of date; a page is "may be stale" when its source changed or when too long has passed since its review.
- **Status line**: the single line at the bottom of the Claude Code terminal; see [[pbar]].
- **sudo**: the command that runs another command with administrator rights.
- **SVG** (Scalable Vector Graphics): a format for drawings made of shapes, used by the map ([SVG](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics)).
- **Tailnet**: the private network that Tailscale builds between your devices; see [[tailscale]].
- **Terminal**: the text window where commands are typed.
- **tmux**: a program that keeps a terminal session running when you disconnect ([tmux](https://github.com/tmux/tmux/wiki)).
- **Token**: a small piece of text, about three-quarters of a word, in which the use of an AI model is measured; also a secret code that proves identity.
- **TLS** (Transport Layer Security): the encryption used by HTTPS ([TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security)).
- **Traceability**: being able to follow every requirement to the test that checks it; see [[check-traceability]].
- **TSV** (tab-separated values): a plain-text table with columns separated by tab characters ([TSV](https://en.wikipedia.org/wiki/Tab-separated_values)).
- **UI** (user interface): what the user sees and touches on the screen.
- **URL** (Uniform Resource Locator): a web address.
- **User space**: installed in a user's own folders, so no administrator rights are needed; see [[user-space-tools]].
- **ViewModel**: the part of an Android app that prepares data for the screens and survives screen rotations ([documentation](https://developer.android.com/topic/libraries/architecture/viewmodel)); see [[study-view-model]].
- **VPN** (virtual private network): an encrypted link that makes distant devices behave as if they were on one local network ([VPN](https://en.wikipedia.org/wiki/Virtual_private_network)).
- **Web twin**: the web version that mirrors the Android app; see [[quizweb]].
