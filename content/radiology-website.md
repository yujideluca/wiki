---
id: radiology-website
title: Finding assistant website, first slice (web/)
aliases: [finding assistant website, web/, web/start.sh, FindingWeb, web/bridge/bridge.py, finding_web]
kind: program
project: radiology-report-matcher
status: active
location: radiology-crawler:web
fed_by: [radiology-finding-engine]
feeds: [radiology-report-matcher]
sources: [radiology-crawler:web/start.sh, radiology-crawler:web/mix.exs, radiology-crawler:web/mix.lock, radiology-crawler:web/lib/finding_web/application.ex, radiology-crawler:web/lib/finding_web/bridge.ex, radiology-crawler:web/lib/finding_web/router.ex, radiology-crawler:web/bridge/bridge.py, radiology-crawler:web/elm/src/Main.elm, radiology-crawler:web/elm/src/Api.elm, radiology-crawler:web/elm/elm.json, radiology-crawler:web/elm/tests/MainTest.elm, radiology-crawler:web/priv/static/index.html, radiology-crawler:web/priv/static/boot.js, radiology-crawler:web/test/router_test.exs, radiology-crawler:web/test/bridge_test.exs, radiology-crawler:tests/test_web.py, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:DESIGN.md, radiology-crawler:tools/quality_gate.sh, radiology-crawler:.github/workflows/quality-gate.yml, radiology-crawler:PLAN.md]
reviewed: 2026-11-14T18:50Z
memory: []
---

## What it is
A web page through which a radiologist can use the finding assistant of [[radiology-report-matcher]] in a browser. The user types a loose description of one thing seen on an image. The page answers with three exact findings (a "finding" is one named observation on an image, such as a pneumothorax), marks the most likely one, says whether the description is enough, and asks up to three questions. It names findings; it does not diagnose.

This is a first working slice, built on 2026-11-14, and not the finished website. Three limits matter most: it runs only while someone has started it by hand with `web/start.sh` on Giovanni's laptop and can only be opened from that same computer; the part "related diagnoses" is an empty placeholder; and it is in English only. The plan lists the website milestone as in progress, with two open points: related diagnoses and a check with a radiologist.

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

u -types into-> pg
pg -sends the text and all answers so far to-> be
be -hands each request, one at a time, to-> br
br -calls-> e
br -reads names and question values from-> fl
br -trains the learned matcher at first use from-> tc

## What it does
What the user sees, in order:

1. A choice of imaging method (X-ray, ultrasound, CT for computed tomography, MRI for magnetic resonance imaging) and a text box labelled "Description". The page says that loose words are fine.
2. After "Suggest findings": one card per structure. A "structure" is one thing described; a text that describes several things gets several cards (at most 12). Each card shows up to three suggested findings, the first tagged "most likely".
3. A verdict in words: "The description is sufficient", "The description is not sufficient" or "Fits no known finding".
4. When the description is not sufficient, one question at a time, worded from the name of a descriptor (an attribute of a finding, such as its side), for example "What is the side?". The answers offered are the standard values of that descriptor plus "Don't know". The questions stop after three, or earlier when the description has become sufficient.
5. Last on every card, the heading "Related diagnoses" with the sentence "Not available yet." The field exists so the layout is settled; nothing fills it yet.
6. A "Clear" button that empties the page.

When the file with the trained data is not on the computer, or is damaged, the site still answers, from the lists of findings alone, and shows a notice that the suggestions are less accurate.

Nothing typed is stored. The page tells the user so: "Nothing you type is stored: it is analysed on this computer and forgotten."

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

What leaves the bridge is limited to finding names, descriptor names and standard values from the lists of findings, the user's own words and the site's fixed sentences. It sends no definition, no text of a teaching case, no score and no text from Radiopaedia (the reference site the project collects pages from).

### Starting it
`web/start.sh` compiles the page, fetches the Elixir packages and starts the server; it prints `Finding assistant: http://127.0.0.1:4107` and runs until Ctrl-C. There is no background service: when the script stops, the site is gone.

### Requirements and tests
Nine requirements, WS-6 to WS-14 (a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check; a test names its requirement in a comment `REQ <ID>`):

- WS-6: the bridge answers one JSON request per line, for a method given as a parameter.
- WS-7: the back end serves the page and the three API addresses; a bad request gets a JSON error and the site keeps working.
- WS-8: nothing typed is stored: no request log, file, database or cookie, and no dialog kept between requests.
- WS-9: one question at a time with standard values and "Don't know", at most three.
- WS-10: the site works without the trained data and says so.
- WS-11: only terms of the lists of findings, the user's words and fixed sentences are shown.
- WS-12: the page works on a phone and a desktop with plain HTML and CSS.
- WS-13: related diagnoses are shown last; until built, an empty placeholder that says "Not available yet".
- WS-14: the server listens on this computer only.

Three sets of tests check them. `tests/test_web.py` (Python) tests the bridge and scans the site's source files for forbidden things, for example any call that writes a file or a log, any browser storage, a listening address open to other computers. One of its tests sends requests containing a marker word to a running bridge and checks that the word appears in no error output, no later answer and no file. `web/test/` (ExUnit, Elixir's test tool) tests the back end and its bridge process: 11 tests. `web/elm/tests/MainTest.elm` (elm-test) tests the page's logic: 10 tests.

The quality gate of the repository (the one script that decides whether the code passes, see [[checks-radiology-crawler]]) runs the Elixir and Elm tests in its step "1b website". On a computer without Elixir or Elm it skips that part with a visible notice. Continuous integration (CI, automatic checks on GitHub at every push) installs Elixir 1.18 with OTP (Open Telecom Platform, Elixir's runtime) 27 and Elm 0.19.1 so the step runs there. In the CI run on commit `600af44` of 2026-11-14 the step ran: 11 ExUnit tests and 10 Elm tests passed.

## Where it sits in the pipeline
Last in the chain of the project: the lists of findings ([[radiology-finding-inventory]]) and the training data feed the engine ([[radiology-finding-engine]]); the website puts the engine in front of a person. It is the product of the plan milestone "Website" in [[radiology-report-matcher]].

## Who receives its output
Whoever sits at Giovanni's laptop while `web/start.sh` runs. Nobody else: the site is not published on the internet.

## Notes
Not verified for this page: the site was not started in the session that wrote it (it was not running, and starting it writes build files into the repository). The behaviour described comes from the code, the tests and the CI run named above.

The website is a different thing from the "plan site", the offline pages that show the project plan and results (described on [[radiology-report-matcher]]). Requirements WS-1 to WS-5 belong to the plan site.
