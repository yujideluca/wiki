---
id: radiology-website
title: Finding assistant website (web/)
aliases: [finding assistant website, web/, web/start.sh, FindingWeb, web/bridge/bridge.py, finding_web]
kind: program
project: radiology-report-matcher
status: active
location: radiology-crawler:web
fed_by: [radiology-finding-engine, radiology-modality-corpus]
feeds: [radiology-report-matcher]
sources: [radiology-crawler:web/start.sh, radiology-crawler:web/mix.exs, radiology-crawler:web/mix.lock, radiology-crawler:web/lib/finding_web/application.ex, radiology-crawler:web/lib/finding_web/bridge.ex, radiology-crawler:web/lib/finding_web/router.ex, radiology-crawler:web/bridge/bridge.py, radiology-crawler:web/elm/src/Main.elm, radiology-crawler:web/elm/src/Api.elm, radiology-crawler:web/elm/elm.json, radiology-crawler:web/elm/tests/MainTest.elm, radiology-crawler:web/priv/static/index.html, radiology-crawler:web/priv/static/boot.js, radiology-crawler:web/priv/static/style.css, radiology-crawler:web/.formatter.exs, radiology-crawler:web/.gitignore, radiology-crawler:web/test/test_helper.exs, radiology-crawler:web/test/router_test.exs, radiology-crawler:web/test/bridge_test.exs, radiology-crawler:tests/test_web.py, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:DESIGN.md, radiology-crawler:tools/quality_gate.sh, radiology-crawler:.github/workflows/quality-gate.yml, radiology-crawler:PLAN.md, radiology-crawler:web/priv/static/tryout.json, radiology-crawler:web/test/browser/site_check.mjs]
reviewed: 2026-11-16T00:11Z
memory: []
---

## What it is
A web page through which a radiologist can use the finding assistant of [[radiology-report-matcher]] in a browser. The user types a loose description of one thing seen on an image. The page answers with three exact findings (a "finding" is one named observation on an image, such as a pneumothorax), marks the most likely one, says whether the description is enough, and asks up to five questions (three until 2026-11-15). Under each suggested finding it lists the diagnoses that the project's collected cases report together with that finding. It names visible findings; it does not diagnose the patient.

It was built on 2026-11-14 in two slices (a slice is a narrow but complete piece that works from the page down to the engine): the first gave findings, verdict and questions; the second, the same day (commit `bbfc3f1`), filled the part "related diagnoses" and made the questions usable on a phone. The later guided try-out and phone-first changes are described below. The limits that matter most: it runs only while someone has started it by hand with `web/start.sh` on Giovanni's laptop and can only be opened from that same computer; it is in English only; and few findings have related diagnoses yet (for X-ray 74 of 233, see [[radiology-modality-corpus]]). The plan lists the website milestone as in progress, with a check by a radiologist still open.

Three decisions by Giovanni of 2026-11-14 shape it (decision log of the repository's `DESIGN.md`): all four imaging methods can be chosen, none is hidden until it reaches its accuracy target; the site is started by hand and has no automatic start; and everything the site shows comes from the corpus (the project's collection of training texts, its only database), never from a second data store kept by the site.

## Architecture
### Context
person u: User — a radiologist, or Giovanni, at the laptop | [[giovanni]]
system s: Finding assistant website — takes a description, shows findings, verdict and questions
external e: Finding engine — the tested matching code the website calls and never changes | [[radiology-finding-engine]]

u -types a description and answers questions in-> s
s -asks for findings, verdict and next question from-> e

### Containers
person u: User | [[giovanni]]
container pg: Page — Elm program in the browser; holds the description and the answers
container be: Back end — Elixir web server on this computer only; passes requests on, keeps nothing
container br: Bridge — one long-running Python process that calls the engine
external e: Finding engine | [[radiology-finding-engine]]
store fl: Finding lists — names, descriptors and standard values per imaging method | [[radiology-finding-inventory]]
store tc: Training file — optional, in the data folder outside version control
store rd: Related-diagnoses tables — one per imaging method, built from the corpus | [[radiology-modality-corpus]]

u -types into-> pg
pg -sends the text and all answers so far to-> be
be -hands each request, one at a time, to-> br
br -calls-> e
br -reads names and question values from-> fl
br -trains the learned matcher at first use from-> tc
br -reads diagnosis names per finding from-> rd

## What it does
What the user sees, in order:

1. A choice of imaging method (X-ray, ultrasound, CT for computed tomography, MRI for magnetic resonance imaging) and a text box labelled "Description". The page says that loose words are fine.
2. After "Suggest findings": one card per structure. A "structure" is one thing described; a text that describes several things gets several cards (at most 12). Each card shows up to three suggested findings, the first tagged "most likely".
3. A verdict in words: "The description is sufficient", "The description is not sufficient" or "Fits no known finding".
4. When the description is not sufficient, one question at a time, worded from the name of a descriptor (an attribute of a finding, such as its side), for example "What is the side?". Since the second slice the sentence is the one the engine provides. The answers offered are the standard values of that descriptor plus "Don't know". One kind of question offers findings by name instead; there the way out is "None of these", which sets the offered findings aside. Up to 8 answers are shown as one button each; more than 8 become one drop-down list ("Choose one of N…") with an "Answer" button, so that a long list fits a phone. The questions stop after five (three until 2026-11-15), or earlier when the description has become sufficient.
5. Last on every card, the heading "Related diagnoses" with the sentence "Diagnoses that the collected cases report together with each suggested finding. This is not a diagnosis of the patient." Below it, one group per suggested finding, the most likely one opened, lists up to 10 diagnosis names under "Related diagnoses reported with this finding:". Names only: no count and no probability. A finding or a method without an entry shows "Not available yet for this method."; a card with no suggested finding shows "No finding was suggested, so there is nothing to relate."
6. A "Clear" button that empties the page.

When the file with the trained data is not on the computer, or is damaged, the site still answers, from the lists of findings alone, and shows a notice that the suggestions are less accurate.

Nothing typed is stored. The page tells the user so: "Nothing you type is stored: it is analysed on this computer and forgotten."

**Site update, 2026-11-15.** The result now shows each proposed finding’s plain group name, variants from the same imaging method, and an allowed literature source with its quoted passage where available. Radiopaedia text is not shown. At 360 pixels wide, the method switches and results are arranged for a phone; changing method asks again, and a user can take back the last answer. `web/priv/static/tryout.json` supplies 12 guided tasks, three per method. Right, wrong or confusing marks and notes stay in the page until reload or deletion and can be copied as text. The hand-run Chrome check in `web/test/browser/site_check.mjs` exercises the four methods at phone width and checks that typed text is absent from browser storage and watched output. This page does not claim that a radiologist has accepted the site.

## How it does it
The site has three parts in three languages, each chosen earlier by Giovanni for its role.

**The page** (`web/elm/src/Main.elm` and `Api.elm`) is written in Elm, a language that compiles to the JavaScript a browser runs. It keeps the whole dialog, meaning the description and every answer given so far, in its own memory and sends all of it with every request. "Don't know" is sent as an empty answer. The dialog disappears with "Clear" or when the page is closed. The page uses plain HTML (HyperText Markup Language) and CSS (Cascading Style Sheets, the language for layout and colours), loads nothing from outside the laptop, and adapts to a phone width and a desktop width.

**The back end** (`web/lib/finding_web/`) is written in Elixir, a language for server programs. It uses two libraries: Plug, which matches web addresses to code, and Bandit, the web server itself. It offers four addresses:

- `GET /` gives the page.
- `GET /api/methods` gives the imaging methods on offer and the number of questions.
- `POST /api/analyse` takes a method and a text and gives the structures, each with findings, verdict and first question.
- `POST /api/structure` takes a method, the text of one structure and the answers so far, and gives that structure again.

The last three are the API (application programming interface, the addresses a program calls instead of a person); they exchange JSON (JavaScript Object Notation, a plain-text format for structured data). The server listens only on the address `127.0.0.1`, which means "this computer": no other device can reach it. That address is fixed in the code. Only the port, the number after the colon in the web address, can be changed, through the environment variable `PORT`; the default is 4107. A request body above 20,000 bytes is refused. Every answer carries headers that tell the browser to keep no copy (`cache-control: no-store`) and to load scripts and styles from this site only (a Content Security Policy, CSP).

**The bridge** (`web/bridge/bridge.py`) is the single connection to the engine. The engine is written in Python and is still being changed by other work, so the website does not copy or rewrite its logic: the back end starts one Python process and keeps it open. The two talk in "JSON lines", one request per line of text in and one answer per line out, in the same order, so the engine handles one request at a time. The bridge calls the engine's public parts as they are. For each request it rebuilds the dialog from the text and the answers, reads out the three findings, the verdict and the next question, and forgets it. Only the loaded lists of findings and the trained matcher stay in memory. An imaging method is a folder of finding lists; the bridge offers every folder it finds, so a new method needs no change in the website. If the Python process ends or does not answer within 60 seconds, the back end reports "The assistant is not answering" and a supervisor (the part of an Elixir program that restarts failed parts) starts a fresh process.

Bad input gets a fixed sentence and a matching status number: an empty description ("Type a description first."), a description above 4,000 characters, an unknown method, a request that cannot be read. An error message never repeats what was typed; an internal error writes only the kind of error, for example `bridge: ValueError`.

Why the dialog lives in the page and not on the server: the decision log of the repository's `DESIGN.md` (2026-11-14) gives the reason that a server with no state is the simplest proof that nothing typed is stored. The same row records what was rejected: the larger web framework Phoenix (more packages than three addresses need), rewriting the matching code in Elixir (two copies of tuned mathematics), one Python process per request (slow start, retrains each time), and dialog state on the server (would keep typed text).

**Related diagnoses** come from one table per imaging method, `assistant/lexicon/<method>-related-diagnoses-en.json`, which the corpus work builds from the training texts ([[radiology-modality-corpus]] says how, and what a link rests on). The bridge only reads it. Per suggested finding it passes on at most 10 diagnosis names, the one with the most corpus rows first. The table's numbers stay in the bridge: they say how often the collected texts showed the pair, not how likely a diagnosis is. The bridge looks at the file on every request and reads it again only when it has changed, so a new table is used without a restart. When the table is missing, damaged or made for another method, the bridge reports "not available" and the rest of the site works.

What leaves the bridge is limited to finding names, group names, variant names, descriptor names and standard values from the lists of findings, allowed literature citations and passages from those lists, diagnosis names from the corpus table, the user's own words and the site's fixed sentences. It sends no teaching-case text, score or Radiopaedia passage (Radiopaedia is one reference site the project collects pages from).

### Starting it
`web/start.sh` compiles the page, fetches the Elixir packages and starts the server; it prints `Finding assistant: http://127.0.0.1:4107` and runs until Ctrl-C. There is no background service: when the script stops, the site is gone.

### Other files in the folder
Four small files of `web/` hold settings and no logic:

- `web/priv/static/style.css` is the page's style sheet, written by hand without a CSS framework. It gives one column on a phone and a wider column on a screen at least 60 rem wide (a rem is the height of the page's base letter size), and a second set of colours that the browser uses when the device is set to dark mode.
- `web/.formatter.exs` tells `mix format`, Elixir's code formatter, which files to format (the build file and everything under `lib/` and `test/`) and sets the line length to 120 characters. The quality gate fails when a file is not formatted this way.
- `web/.gitignore` keeps build output out of git, the version-control system: the compiled back end (`_build/`), the fetched packages (`deps/`), Elm's work folder and the compiled page `priv/static/app.js`, which `web/start.sh` builds again at every start.
- `web/test/test_helper.exs` is one line, `ExUnit.start()`, which starts Elixir's test tool before the tests of `web/test/` run.

### Requirements and tests
Twenty-one requirements, WS-6 to WS-26 (a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check; a test names its requirement in a comment `REQ <ID>`):

- WS-6: the bridge answers one JSON request per line, for a method given as a parameter.
- WS-7: the back end serves the page and the three API addresses; a bad request gets a JSON error and the site keeps working.
- WS-8: nothing typed is stored: no request log, file, database or cookie, and no dialog kept between requests.
- WS-9: one question at a time with standard values and "Don't know", at most five (three until 2026-11-15).
- WS-10: the site works without the trained data and says so.
- WS-11: only terms of the lists of findings, diagnosis names of the corpus table, the user's words and fixed sentences are shown.
- WS-12: the page works on a phone and a desktop with plain HTML and CSS.
- WS-13: related diagnoses are shown last on every result.
- WS-14: the server listens on this computer only.
- WS-15: related diagnoses come from the corpus table only, up to 10 names per finding, never a count; a table that arrives later is used without a restart.
- WS-16: the page lists them under each suggested finding, by name, and says they are not a diagnosis of the patient.
- WS-17: a question with more than 8 answers is one drop-down list with an "Answer" button.
- WS-18: each question uses the engine's sentence; where findings are offered by name the way out is "None of these", elsewhere "Don't know".
- WS-19: the site is started by hand; the repository holds no service, timer or autostart entry for it.
- WS-20: every imaging method that has a list of findings can be chosen, with or without trained data.
- WS-21 to WS-23: each result shows its group, same-method variants and allowed literature support where present.
- WS-24: phone layout, clear method switches and the ability to take back an answer.
- WS-25: a hand-run Chrome check exercises the site and checks that typed text is not retained.
- WS-26: twelve guided tasks collect marks and notes in the page only, with delete and copy controls.

Three sets of automated tests check them. `tests/test_web.py` (Python) tests the bridge and scans the site's source files for forbidden things, for example file writes, browser storage and a listening address open to other computers. One test sends a marker word to a running bridge and checks that it appears in no error output, later answer or file. `web/test/` (ExUnit, Elixir's test tool) tests the back end and its bridge process. `web/elm/tests/MainTest.elm` (elm-test) tests the page's logic. The hand-run browser check is a further check of the running page.

The quality gate of the repository (the one script that decides whether the code passes, see [[checks-radiology-crawler]]) runs the Elixir and Elm tests in its step "1b website". On a computer without Elixir or Elm it skips that part with a visible notice. Continuous integration (CI, automatic checks on GitHub at every push) installs Elixir 1.18 with OTP (Open Telecom Platform, Elixir's runtime) 27 and Elm 0.19.1 so the step runs there. In the CI run on commit `7bbdaaa` of 2026-11-14 the step ran: 11 ExUnit tests and 14 Elm tests passed.

## Where it sits in the pipeline
Last in the chain of the project: the lists of findings ([[radiology-finding-inventory]]) and the training data feed the engine ([[radiology-finding-engine]]); the corpus work also supplies the tables of related diagnoses ([[radiology-modality-corpus]]); the website puts both in front of a person. It is the product of the plan milestone "Website" in [[radiology-report-matcher]].

## Who receives its output
Whoever sits at Giovanni's laptop while `web/start.sh` runs. Nobody else: the site is not published on the internet.

## Notes
Update 2026-11-15 (five questions; commit `f4408cc`): Giovanni decided that the assistant asks at most five questions per description instead of three. The limit is one constant of the engine, `MAX_QUESTIONS` in `assistant/dialog.py`; the bridge reads it and reports it to the page as `max_questions`, so the website followed without a logic change of its own. In the folder `web/` only three things changed: the sentence at the top of the page now says "up to five questions", and the tests of the back end expect the limit of five. The Python test of the bridge (`tests/test_web.py`) also checks that no question is asked twice within the five, except the one that offers findings by name, which may come again with names not shown before. The effect of five questions on the engine's measured numbers (tuning data, simulated user) is on [[radiology-finding-engine]]. Nothing else in `web/` changed between commits `7bbdaaa` and `33d7776`. The site was not started for this update either.

Not verified for this page: the site was not started in the session that wrote it (it was not running, and starting it writes build files into the repository). The behaviour described comes from the code, the tests and the CI run named above. Apart from the update above, the page describes commit `7bbdaaa` of 2026-11-14.

The website is a different thing from the "plan site", the offline pages that show the project plan and results (described on [[radiology-report-matcher]]). Requirements WS-1 to WS-5 belong to the plan site.
