---
id: radiology-website
title: Finding assistant website (web/)
aliases: [finding assistant website, web/, web/start.sh, FindingWeb, web/bridge/bridge.py, finding_web]
kind: program
project: radiology-report-matcher
status: active
location: radiology-crawler:web
fed_by: [radiology-finding-engine]
feeds: [radiology-report-matcher]
sources: [radiology-crawler:tests/test_web_questions.py, radiology-crawler:web/start.sh, radiology-crawler:web/mix.exs, radiology-crawler:web/mix.lock, radiology-crawler:web/lib/finding_web/application.ex, radiology-crawler:web/lib/finding_web/bridge.ex, radiology-crawler:web/lib/finding_web/router.ex, radiology-crawler:web/bridge/bridge.py, radiology-crawler:web/elm/src/Main.elm, radiology-crawler:web/elm/src/Api.elm, radiology-crawler:web/elm/elm.json, radiology-crawler:web/elm/tests/MainTest.elm, radiology-crawler:web/priv/static/index.html, radiology-crawler:web/priv/static/boot.js, radiology-crawler:web/priv/static/style.css, radiology-crawler:web/.formatter.exs, radiology-crawler:web/.gitignore, radiology-crawler:web/test/test_helper.exs, radiology-crawler:web/test/router_test.exs, radiology-crawler:web/test/bridge_test.exs, radiology-crawler:tests/test_web.py, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:DESIGN.md, radiology-crawler:tools/quality_gate.sh, radiology-crawler:.github/workflows/quality-gate.yml, radiology-crawler:PLAN.md, radiology-crawler:web/priv/static/tryout.json, radiology-crawler:web/test/browser/site_check.mjs]
reviewed: 2026-11-16T23:38Z
memory: []
---

## What it is
A web page through which a radiologist can use the finding assistant of [[radiology-report-matcher]] in a browser. The user types a loose description of one thing seen on an image. The page answers with that description written in standard form, with three standard finding terms (a "finding" is one named observation on an image, such as a pleural effusion), the closest one marked, says whether the description is enough, and asks up to five questions. It shows no diagnosis, not even as a list: the top of the page says "It does not diagnose."

It was built on 2026-11-14 and rebuilt on 2026-11-15 (commit `3f9de45`) after Giovanni set a new scope for the project that day: a suggester of radiological findings and a formaliser of descriptions, which never guesses a clinical diagnosis (`docs/SCOPE.md` of the repository). The first version listed "related diagnoses" under each finding; that part was removed, and the description in standard form became the main part of a result. The limits that matter most: the site runs only while someone has started it by hand with `web/start.sh` on Giovanni's laptop and can only be opened from that same computer; it is in English only; and the finding lists it reads are only partly changed to the new scope: the X-ray list holds visible signs only since commit `af3afc6` of 2026-11-16, the ultrasound and CT lists since commit `4c7ebed` of the same day, and the MRI list since commit `ed564e1`, so no method proposes a diagnosis-like name any more (see [[radiology-finding-inventory]]). Measurements are held by 11 X-ray, 15 ultrasound and 22 CT entries and by no MRI entry (commit `5d36ad7`), so the block "To confirm, measure" described below can appear for those entries only. The plan lists the website milestone as in progress, with a check by a radiologist still open.

Decisions by Giovanni shape it (decision log of the repository's `DESIGN.md`). Of 2026-11-14: all four imaging methods can be chosen, none is hidden until it reaches its accuracy target; the site is started by hand and has no automatic start; and everything the site shows comes from the project's own lists and corpus (its collection of training texts), never from a second data store kept by the site. Of 2026-11-15: no diagnosis is shown, and a finding that is defined by a measurement on the image says what to measure.

## Architecture
### Context
person u: User — a radiologist, or Giovanni, at the laptop | [[giovanni]]
system s: Finding assistant website — takes a description, shows it in standard form with finding terms, verdict and questions
external e: Finding engine — the tested matching code the website calls and never changes | [[radiology-finding-engine]]

u -types a description and answers questions in-> s
s -asks for findings, verdict, next question and the standard form from-> e

### Containers
person u: User | [[giovanni]]
container pg: Page — Elm program in the browser; holds the description and the answers
container be: Back end — Elixir web server on this computer only; passes requests on, keeps nothing
container br: Bridge — one long-running Python process that calls the engine
external e: Finding engine | [[radiology-finding-engine]]
store fl: Finding lists — names, descriptors, standard values, groups, variants and sources per imaging method | [[radiology-finding-inventory]]
store tc: Training file — optional, in the data folder outside version control

u -types into-> pg
pg -sends the text and all answers so far to-> be
be -hands each request, one at a time, to-> br
br -calls-> e
br -reads names, question values, groups, variants and sources from-> fl
br -trains the learned matcher at first use from-> tc

## What it does
What the user sees, in order:

1. The sentence "Describe what you see on the image, in your own words. The page proposes the standard finding terms and writes your description in standard form. It does not diagnose.", a choice of imaging method as four large switches (X-ray, ultrasound, CT for computed tomography, MRI for magnetic resonance imaging) and a text box. The page says "Each method has its own finding names. They are never mixed."
2. After the button "Propose standard terms": one card per structure. A "structure" is one thing described; a text that describes several things gets several cards (at most 12). Each card names its method.
3. A verdict in words: "The description is sufficient", "The description is not sufficient" (with what to do next) or "No standard finding term fits".
4. "Your description in standard form", written for one finding term. At the start that is the closest of the three terms, and the card says so: "Written with the closest term so far. If it is not what you see, choose another term below." The block shows:
   - "Standard finding term:" and the name;
   - "Stated, in standard values:": each descriptor (an attribute of a finding, such as its side) that the user's words or answers state, with its standard value;
   - "Not stated yet:": the descriptors of that finding that the description does not give. None is ever filled in;
   - "Standard wording to copy": one sentence built from these parts, with the button "Copy the wording".
5. The three finding terms. The closest is tagged "closest term"; each of the others has a button "Write it with this term", which rewrites the block above for that term. Beside each term the page shows, where the finding list holds it: the plain name of the term's group; the other variants of the same finding in the same imaging method (for example a focal and a diffuse form), never merged; and "Literature source of the finding list:" with the citation and, where the list holds one, the quoted passage. Text of Radiopaedia (a reference site the project collects pages from) is never shown.
6. For a finding that its list defines by a measurement on the image: "Defined by:" with the defining description, and "To confirm, measure:" with what to measure, how, the criterion with its unit, and the source. The page never fills in a measurement. Since commit `af3afc6` eleven X-ray entries carry measurements (scoliosis, for example, names the Cobb angle and the criterion "10 degrees or more"); since commit `17ee7c8` so do 15 ultrasound and 22 CT entries. The website's tests check this block with invented entries.
7. When the description is not sufficient, one question at a time, numbered "Question 1 of up to 5". The user is someone who is looking for the right term, so a question never shows that term. The rules, set by Giovanni on 2026-11-16:
   - The question is one short sentence about what is seen, worded by the engine, for example "Where is the finding?" or "Brighter, equal or darker than the adjacent tissue?".
   - An answer is a button that says what is seen in plain words ("brighter"), never the standard term ("hyperechoic", the ultrasound word for brighter). Where the finding list holds a sourced description of the answer, the page shows it under the button with its source.
   - The standard term appears only after the choice. In the list "Your answers" the chosen answer is followed by the line "Standard term:" and the term in bold. The term also goes into the description in standard form above, where it is marked "from your answer".
   - Every question has a way out as its last button, with a dashed border: "Not assessable / not seen" for a question about a property, "None of these" where the page offers body regions, kinds of structure or findings.
   - A question about one single property is asked as yes or no ("Is the calibre or volume enlarged?" with "Yes" and "No").
   - A measurement question says what to measure, shows how and the criterion with its source, and has a number field with the unit and an "Answer" button. The engine compares the number with the criterion; the number goes into the standard form. Anything that is not a number from 0 to 1,000,000 is refused.
   - The question that lets the user pick a finding from a list comes last and at most once, under the sentence "Does one of these match?". Each finding is shown by its defining description, for example "Both kidneys lie on the same side of the body and are fused", never by its name; the name is shown as "Standard term" after the choice. A finding without a sourced description is not offered.
   - An answer longer than 40 characters is always a full-width button whose text wraps. Only when a question has more than 8 short answers do they become one drop-down list with an "Answer" button.
   - "Take back the last answer" undoes one answer. The questions stop after five, or earlier when the description has become sufficient.
8. A "Clear" button that empties the page.

Changing the imaging method asks again with the same text. When the file with the trained data is not on the computer, or is damaged, the site still answers, from the lists of findings alone, and shows a notice that the suggestions are less accurate.

Nothing typed is stored. The page tells the user so: "Nothing you type is stored: it is analysed on this computer and forgotten."

**Guided try-out.** `web/priv/static/tryout.json` supplies 12 short tasks, three per imaging method. Each describes what is seen and names no diagnosis. The user marks a task right, wrong or confusing and may add a note. Marks and notes stay in the page only: they are never sent or stored, are gone on reload, can be deleted with "Delete my marks" and copied with "Copy the text".

This page does not claim that a radiologist has accepted the site.

## How it does it
The site has three parts in three languages, each chosen earlier by Giovanni for its role.

**The page** (`web/elm/src/Main.elm` and `Api.elm`) is written in Elm, a language that compiles to the JavaScript a browser runs. It keeps the whole dialog, meaning the description and every answer given so far, in its own memory and sends all of it with every request. The way out of a question ("Not assessable / not seen" or "None of these") is sent as an empty answer. The standard term of an answer is known to the page from the start but is drawn only after the choice, and is never sent back. The dialog disappears with "Clear" or when the page is closed. The page uses plain HTML (HyperText Markup Language) and CSS (Cascading Style Sheets, the language for layout and colours), loads nothing from outside the laptop, and adapts to a phone width and a desktop width.

**The back end** (`web/lib/finding_web/`) is written in Elixir, a language for server programs. It uses two libraries: Plug, which matches web addresses to code, and Bandit, the web server itself. It offers four addresses:

- `GET /` gives the page.
- `GET /api/methods` gives the imaging methods on offer and the number of questions.
- `POST /api/analyse` takes a method and a text and gives the structures, each with findings, verdict and first question.
- `POST /api/structure` takes a method, the text of one structure and the answers so far, and gives that structure again.

The last three are the API (application programming interface, the addresses a program calls instead of a person); they exchange JSON (JavaScript Object Notation, a plain-text format for structured data). The server listens only on the address `127.0.0.1`, which means "this computer": no other device can reach it. That address is fixed in the code. Only the port, the number after the colon in the web address, can be changed, through the environment variable `PORT`; the default is 4107. A request body above 20,000 bytes is refused. Every answer carries headers that tell the browser to keep no copy (`cache-control: no-store`) and to load scripts and styles from this site only (a Content Security Policy, CSP).

**The bridge** (`web/bridge/bridge.py`) is the single connection to the engine. The engine is written in Python and is still being changed by other work, so the website does not copy or rewrite its logic: the back end starts one Python process and keeps it open. The two talk in "JSON lines", one request per line of text in and one answer per line out, in the same order, so the engine handles one request at a time. The bridge calls the engine's public parts as they are. For each request it rebuilds the dialog from the text and the answers, reads out the three findings, the verdict and the next question, and forgets it. Only the loaded lists of findings and the trained matcher stay in memory. An imaging method is a folder of finding lists; the bridge offers every folder it finds, so a new method needs no change in the website. If the Python process ends or does not answer within 60 seconds, the back end reports "The assistant is not answering" and a supervisor (the part of an Elixir program that restarts failed parts) starts a fresh process.

Bad input gets a fixed sentence and a matching status number: an empty description ("Type a description first."), a description above 4,000 characters, an unknown method, a request that cannot be read. An error message never repeats what was typed; an internal error writes only the kind of error, for example `bridge: ValueError`.

Why the dialog lives in the page and not on the server: the decision log of the repository's `DESIGN.md` (2026-11-14) gives the reason that a server with no state is the simplest proof that nothing typed is stored. The same row records what was rejected: the larger web framework Phoenix (more packages than three addresses need), rewriting the matching code in Elixir (two copies of tuned mathematics), one Python process per request (slow start, retrains each time), and dialog state on the server (would keep typed text).

**The standard form** is not written by the website. For each of the three proposed findings the bridge calls the engine's function `formalise` (`assistant/formal.py`, see [[radiology-finding-engine]]) with the text and the answers so far, and passes on its result: the standard name, the stated descriptors with their values, the missing descriptors and the sentence. The bridge adds no word to it. The function uses fixed templates and no language model, so the same input always gives the same wording. When it fails, the page shows the terms without the standard form.

**No diagnosis.** The bridge used to read one table of related diagnoses per imaging method. Since commit `3f9de45` it reads no such table and no answer has a field for diagnoses; of the folder `assistant/lexicon` it loads only the lists of synonyms and abbreviations. The tables still exist in the repository as an internal aid of the engine work ([[radiology-modality-corpus]]).

What leaves the bridge is limited to what the lists of findings hold (finding names, group names, variant names, descriptor names and standard values, defining descriptions, measurements, allowed literature citations and passages), the engine's fixed sentences and its standard form, the user's own words and the site's fixed texts. It sends no teaching-case text, score or Radiopaedia passage. No file of the website holds a finding id or name: every term comes from the lists when the site runs, so a renamed or replaced list entry needs no change in the site (requirement WS-32).

### Starting it
`web/start.sh` compiles the page, fetches the Elixir packages and starts the server; it prints `Finding assistant: http://127.0.0.1:4107` and runs until Ctrl-C. There is no background service: when the script stops, the site is gone.

### Other files in the folder
Four small files of `web/` hold settings and no logic:

- `web/priv/static/style.css` is the page's style sheet, written by hand without a CSS framework. It gives one column on a phone and a wider column on a screen at least 60 rem wide (a rem is the height of the page's base letter size), and a second set of colours that the browser uses when the device is set to dark mode.
- `web/.formatter.exs` tells `mix format`, Elixir's code formatter, which files to format (the build file and everything under `lib/` and `test/`) and sets the line length to 120 characters. The quality gate fails when a file is not formatted this way.
- `web/.gitignore` keeps build output out of git, the version-control system: the compiled back end (`_build/`), the fetched packages (`deps/`), Elm's work folder and the compiled page `priv/static/app.js`, which `web/start.sh` builds again at every start.
- `web/test/test_helper.exs` is one line, `ExUnit.start()`, which starts Elixir's test tool before the tests of `web/test/` run.

### Requirements and tests
The website has the requirements WS-6 to WS-40; the number WS-30 is not used, and WS-15 and WS-16 are withdrawn (a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check; a test names its requirement in a comment `REQ <ID>`):

- WS-6: the bridge answers one JSON request per line, for a method given as a parameter.
- WS-7: the back end serves the page and the three API addresses; a bad request gets a JSON error and the site keeps working.
- WS-8: nothing typed is stored: no request log, file, database or cookie, and no dialog kept between requests.
- WS-9: one question at a time, at most five.
- WS-10: the site works without the trained data and says so.
- WS-11: only what the lists of findings hold, the engine's fixed sentences, the user's words and the site's fixed texts are shown.
- WS-12: the page works on a phone and a desktop with plain HTML and CSS, and shows per structure the standard form, three terms, the verdict, the question and the answers given.
- WS-13: no diagnosis is on the website: no block, no field in an answer, no table of diagnoses read.
- WS-14: the server listens on this computer only.
- WS-15 and WS-16: withdrawn on 2026-11-15. They described the related diagnoses.
- WS-17: a question with more than 8 answers is one drop-down list with an "Answer" button.
- WS-18: each question uses the engine's sentence, answers and way-out wording: "None of these" where findings, signs, kinds or regions are offered, "Not assessable / not seen" elsewhere.
- WS-19: the site is started by hand; the repository holds no service, timer or autostart entry for it.
- WS-20: every imaging method that has a list of findings can be chosen, with or without trained data.
- WS-21 to WS-23: each proposed term shows its group, its same-method variants and the literature source its list cites.
- WS-24: phone first: nothing scrolls sideways at 360 pixels, large method switches, and the last answer can be taken back.
- WS-25: a hand-run check in the installed Chrome browser exercises the site and checks that typed text is not retained.
- WS-26: twelve guided tasks collect marks and notes in the page only, with delete and copy controls.
- WS-27: a finding defined by a measurement shows the defining description and what to measure, how, the criterion and the source.
- WS-28: a description that is only a diagnosis word (such as "fracture") is never sufficient; the page asks which of its visible signs is seen and never repeats the word.
- WS-29: the site says plainly what it does; no title, label, button or verdict text offers or ranks a diagnosis.
- WS-31: the main part of a result is the description in standard form for the chosen term, with a copy button.
- WS-32: no file of the website holds a finding id or name; the try-out tasks name no diagnosis-like entry.
- WS-34: a measurement question shows what to measure, how, the criterion and its source, and takes a number.
- WS-35: an answer shows the engine's label and, under it, the list's sourced description; nothing is invented where the list has none.
- WS-36: the engine counts the questions; the pick from a list comes last and once; a property the text already states is not asked; each value of the standard form says whether it came from the text or from an answer.
- WS-37: where findings or signs are offered, each reads as its defining description, never as its name; one without a description is not offered.
- WS-38: the standard term of an answer is nowhere on the page before the choice and stands under the answer after it.
- WS-39: answers that are descriptions are full-width buttons that wrap, never a drop-down list.
- WS-40: beside a source the page shows how much of it was read only as a short label such as "full text"; a longer working note of the list is not shown.

Three sets of automated tests check them. `tests/test_web.py` (Python) tests the bridge and scans the site's source files for forbidden things, for example file writes, browser storage and a listening address open to other computers. One test sends a marker word to a running bridge and checks that it appears in no error output, later answer or file. `web/test/` (ExUnit, Elixir's test tool) tests the back end and its bridge process. `web/elm/tests/MainTest.elm` (elm-test) tests the page's logic. The tests of the questions are in their own file, `tests/test_web_questions.py`: they build an invented finding list, walk through a whole dialog and check what the bridge passes on of each question. At commit `043d41a` the two Python files hold 39 test functions (32 and 7), and there are 11 ExUnit tests and 26 Elm tests. The hand-run browser check (`web/test/browser/site_check.mjs`) is a further check of the running page: at phone size (360 by 740 pixels) it goes through the four methods and checks the standard form, that no diagnosis is on the page, that another term can be chosen, the copy button, and that typed text is in no cookie, browser storage or output. Of every question it checks that there is a way out, that each answer is shown in full, and that no offered answer is one of the finding terms the page proposes.

The quality gate of the repository (the one script that decides whether the code passes, see [[checks-radiology-crawler]]) runs the Elixir and Elm tests in its step "1b website". On a computer without Elixir or Elm it skips that part with a visible notice. Continuous integration (CI, automatic checks on GitHub at every push) installs Elixir 1.18 with OTP (Open Telecom Platform, Elixir's runtime) 27 and Elm 0.19.1 so the step runs there. In the CI run on commit `7bbdaaa` of 2026-11-14 the step ran: 11 ExUnit tests and 14 Elm tests passed.

## Where it sits in the pipeline
Last in the chain of the project: the lists of findings ([[radiology-finding-inventory]]) and the training data ([[radiology-modality-corpus]]) feed the engine ([[radiology-finding-engine]]); the website puts the engine in front of a person. It is the product of the plan milestone "Website" in [[radiology-report-matcher]].

## Who receives its output
Whoever sits at Giovanni's laptop while `web/start.sh` runs. Nobody else: the site is not published on the internet.

## Notes
Update 2026-11-16 (questions for someone who is looking for the term; commits `656029b`, `da4c7d6` and `043d41a`): the question part of the page was rebuilt as described in point 7 above. The wording of questions and answers comes from the engine ([[radiology-finding-engine]]); the page shows whatever fields the engine sends, so a later change of wording needs no change in the site. The bridge adds one safeguard of its own: if the engine ever labels a finding by its name in a question, the bridge replaces the name by the list's defining description or drops the answer. The running site was checked on 2026-11-16 in the installed Chrome browser at phone size (360 by 740 pixels) with the hand-run check: all four methods, eight descriptions, every check held; 53 answers were offered, none of them a proposed finding term, and six standard terms were revealed after a choice. In that run no measurement question and no question about the signs of a diagnosis word came up with the real lists; those two are covered by the automated tests with invented entries only.

Update 2026-11-16, evening (commits `574b961` and `5183ef3`, made by the session that builds the lists): the X-ray finding list now holds, in the project's own wording, a line of what is seen for 346 of its 1,120 distinct descriptor values and a defining description for 163 of its 205 findings ([[radiology-observable-descriptions]]). The engine offers such a line as an answer, so X-ray questions can now show these lines where before they showed only plain words and relative forms; ultrasound, CT and MRI have no lines yet. Nothing in `web/` changed. One line of the bridge test `tests/test_web.py` changed: the wording of the pick question now depends on the answers it offers. The site was not started again for this update, so the new X-ray answers have not been looked at in a browser.

Update 2026-11-16, night (commits `4c7ebed`, `ed564e1` and `97e3a55`, made by the session that builds the lists): the ultrasound, CT and MRI lists hold visible signs only, and reviewed lines from the textbooks Giovanni bought filled gaps in all four lists, so more answers and findings can be offered by their description ([[radiology-observable-descriptions]]). The site itself was not changed or started for this note.

Update 2026-11-15, earlier that day (five questions; commit `f4408cc`): Giovanni decided that the assistant asks at most five questions per description instead of three. The limit is one constant of the engine, `MAX_QUESTIONS` in `assistant/dialog.py`; the bridge reads it and reports it to the page as `max_questions`, so the website followed without a logic change of its own. In the folder `web/` only three things changed: the sentence at the top of the page now says "up to five questions", and the tests of the back end expect the limit of five. The Python test of the bridge (`tests/test_web.py`) also checks that no question is asked twice within the five, except the one that offers findings by name, which may come again with names not shown before. The effect of five questions on the engine's measured numbers (tuning data, simulated user) is on [[radiology-finding-engine]]. Nothing else in `web/` changed between commits `7bbdaaa` and `33d7776`. The site was not started for this update either.

Not verified for the parts of this page written before 2026-11-16: the site was not started in the sessions that wrote them. The behaviour described there comes from the code and the tests at commit `3f9de45` of 2026-11-15; the CI run named above is of the first version. On a copy of the repository at commit `af3afc6` (the lists changed once more up to `5d36ad7`, the website did not) the Python tests of the website passed, except one that needs a git checkout. Between commit `3f9de45` and the question work of 2026-11-16 no file under `web/` changed; that the site shows the new X-ray entries and their measurements follows from the code, which reads the lists when it runs, and was not watched in a browser.

The website is a different thing from the "plan site", the offline pages that show the project plan and results (described on [[radiology-report-matcher]]). Requirements WS-1 to WS-5 and WS-33 belong to the plan site. WS-33 (2026-11-15): the plan site presents the project under the new scope, and its pages about the first design, which ranked diagnoses, carry a note that this design was dropped.
