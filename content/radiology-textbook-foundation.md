---
id: radiology-textbook-foundation
title: Textbook tools for the finding lists (analysis/books_fetch.py, books_ground.py, books_mine.py, books_bought.py)
aliases: [textbook foundation, textbook tools, open radiology books, analysis/books_fetch.py, analysis/books_ground.py, analysis/books_mine.py, analysis/books_bought.py, books_mine.py, books_fetch.py, books_ground.py, books_bought.py, docs/foundational-sources.json, foundational sources, grounding in textbooks, bought textbooks]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/books_fetch.py
fed_by: [radiology-fulltext-resolver]
feeds: [radiology-finding-inventory, radiology-observable-descriptions]
sources: [radiology-crawler:analysis/books_fetch.py, radiology-crawler:analysis/books_ground.py, radiology-crawler:docs/foundational-sources.json, radiology-crawler:tests/test_books_fetch.py, radiology-crawler:tests/test_books_ground.py, radiology-crawler:analysis/books_mine.py, radiology-crawler:tests/test_books_mine.py, radiology-crawler:analysis/books_bought.py, radiology-crawler:tests/test_books_bought.py, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:docs/finding-list-restructure.json, radiology-crawler:PLAN.md]
reviewed: 2026-11-16T17:11Z
memory: []
---

## What it is
Four programs that take what radiology textbooks say about how a finding looks and bring it into the finding lists of the radiology finding assistant ([[radiology-report-matcher]]). The assistant turns a loose description of something seen on a medical image into standard radiological terms. A "finding" is what is seen on the image, named in descriptive terms, such as a pleural effusion; the project keeps one list of findings per imaging method (X-ray, ultrasound, computed tomography or CT, magnetic resonance imaging or MRI), described on [[radiology-finding-inventory]].

Why textbooks: the description of some findings is stated by no current journal article, because it was settled in the early days of radiology (the example in the code is the greenstick fracture). Such an entry must rest on the basic literature, which is in textbooks (Giovanni, the physician who owns the project, 2026-11-15). The lists are built by the "corpus lane", the Claude session that owns the finding lists and their training texts; the project's tasks are in its plan file `PLAN.md`.

How the project treats the books (Giovanni, 2026-11-16): a book, like an article or a case website, is not part of the project. It only feeds the finding lists and the example texts, and each list entry keeps a short source field saying where its wording comes from. So this page describes the tools and what they put into the lists, not the books.

The programs, all in the repository `~/dev/radiology-crawler` (this page describes commit `5183ef3` of 2026-11-16):

- `analysis/books_fetch.py` finds books that are free to read, downloads them, cuts them into chapters of plain text and searches them.
- `analysis/books_ground.py` looks up list entries in those books and records whether the books state what characterises them ("grounding").
- `analysis/books_mine.py` reads the oldest, public-domain books from start to end and keeps what they say about how a finding looks.
- `analysis/books_bought.py` reads the textbooks Giovanni bought and prepares, for the session that builds the lists, short lines in the project's own words.

## What it does
### Which books may be read
`books_fetch.py` takes a book only when its licence makes it free to read and to process (requirement AN-166; a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test checks). A licence is the set of terms under which a text may be used. Accepted are the Creative Commons licences CC BY, CC BY-SA, CC BY-NC, CC BY-NC-SA and CC BY-NC-ND (standard public licences; the letters name the conditions: attribution, share alike, non-commercial, no derivatives), CC0 (the author gives up all rights) and the public domain (a public-domain mark, or a book published in 1929 or earlier). A book whose licence forbids derivatives is "quote only": a short quote with its reference may be recorded, but no line may be written from it. Every other licence, and a book that states none, is refused.

Two kinds of site are refused by name before any request: "shadow libraries", sites that hand out pirated copies (a fixed list in the code), and Radiopaedia, a reference site whose text the assistant and its website never show. The program keeps the same manners as the article fetcher [[radiology-fulltext-resolver]], whose network code it uses: one fixed client name without personal data, at least one second between two requests to a site, and a site that refuses (a login page, a robot test, or the answer codes 401, 403 and 429) is left alone for the rest of the run (AN-169).

It searches four public catalogues (`discover`): the open-access part of the book archive of the US National Center for Biotechnology Information (NCBI Bookshelf), the scholarly registry Crossref for open books and chapters, the Internet Archive for public-domain scans, and Wikibooks. A hand-saved file can be added with `add`.

A fetched book is stored as chapters of titled text sections with page range and licence (AN-168); images are never kept. The text stays in `data/analysis/books/`, which git (the version-control system of the repository) does not track. A book of 2015 or later counts as the "current" layer; a public-domain classic as the "historical" layer and is always flagged as such (AN-175). A chapter counts for an imaging method when it names that method at least three times.

`python3 -I analysis/books_fetch.py find greenstick cortex --method xray` prints the passages that hold all the given terms, each with its reference and licence (AN-170).

### Grounding: does a book state what characterises an entry?
`books_ground.py` works per imaging method, on that method's own list and on the chapters that count for that method; nothing is pooled. A quote whose passage speaks only of another imaging method counts only as a mention. It takes these kinds of entry:

- **finding**: an entry marked foundational (basic radiology taught without an article citation), or one whose only sources are abstracts;
- **target**: a visible sign proposed to replace an entry that names a diagnosis (the lists hold findings only since 2026-11-15, see [[radiology-finding-inventory]]);
- **sign**: for ultrasound, CT and MRI, the visible sign of a family of diagnosis-like entries;
- **descriptor**: an attribute of a finding with standard values (such as its margin) for which an earlier check found no sentence;
- **borderline**: a standard term that also names a disease. By Giovanni's rule it stays a finding only with a defining description of the image, and with the measurement when the definition rests on one;
- **measured**: a finding whose name or definition names a measurement.

The result goes to `docs/foundational-sources.json`, a record beside the lists (AN-171): per entry a status, the characterising principle in one sentence, and up to three short quotes with their reference. The statuses:

- **grounded**: at least one quote that characterises the finding;
- **weak**: the books mention the finding and do not characterise it;
- **not found**: no passage;
- **not searched**: the entry has not been looked up yet.

A borderline or measured entry also gets its defining description and its measurements: what to measure, how, the criterion and the unit (AN-174). When two books give different thresholds, both are kept and the difference is written down.

Result per method, from the file at commit `5183ef3` (729 entries; unchanged since `fa70aa2`):

| Method | Entries | Grounded | Weak | Not found | Not searched |
|---|---|---|---|---|---|
| X-ray | 123 | 75 | 30 | 12 | 6 |
| Ultrasound | 161 | 74 | 80 | 7 | 0 |
| CT | 231 | 101 | 109 | 21 | 0 |
| MRI | 214 | 113 | 78 | 23 | 0 |

X-ray by kind: borderline 14 grounded and 3 weak; measured 18 grounded, 2 weak, 1 not found; targets 24 grounded, 7 weak, 4 not searched; descriptors 17 grounded, 16 weak, 9 not found, 2 not searched; other findings 2, 2 and 2. Fifteen of the 75 grounded X-ray entries are grounded only by the historical layer (see the next part). The six not searched are entries added after the last grounding run, four of them visible signs of the split post-operative entry ([[radiology-finding-inventory]]).

### Mining the historical books
`books_mine.py` (requirements AN-176 to AN-178) goes the other way: it reads each public-domain classic from start to end and keeps what it says about how a finding looks. Each of these books speaks of X-ray only, so its passages are mapped to the X-ray list only. The steps are described under "How it does it".

Result, written on 2026-11-16 (commit `fa70aa2`) as the section `historical_mining` of `docs/foundational-sources.json`: 3,079 text blocks read, 2,714 quotes retained, 91 list entries with at least one retained quote, 480 candidate gaps (visible signs the list lacks, handed to the session that builds the lists), 42 contradictions with a current book (recorded, the modern passage preferred), and 15 entries that were weak or not found now grounded by the historical layer only, flagged so.

### The textbooks Giovanni bought
`books_bought.py` (commit `f35556a`, requirements AN-190 to AN-193) reads the radiology textbooks Giovanni bought, which are copyrighted copies on his laptop. The rules written into the program:

- The book text, the quotes and the results stay in the git-ignored folder `data/analysis/books/bought/`, a store of its own that no other program of the project reads. Nothing about these books is committed. The text goes to no outside service: the models run as local command-line sessions.
- What may reach a list is a candidate line in the project's own words: at most 25 words, never a run of 6 words copied from the book (checked by code), with a short source field (book and page). A word-for-word quote stays in the work files only, as proof.
- A line is kept only when its quote stands word for word in the passage, it holds neither the value's term nor the finding's name, and a second model reads the quote as stating it, as seen on the image and about the item (AN-191).
- Each imaging method is read on its own list and only in the chapters and passages that speak of it (AN-192). For a brighter, equal or darker value the line keeps the tissue the book compares with as its reference.

It asks four kinds of question per list entry (AN-193): a defining description for a finding that has none (and for a borderline entry pending one); an observable line for a descriptor value that has none ([[radiology-observable-descriptions]]); for a measured entry, what, how, the criterion and the unit; and, for an entry the open books left weak or not found, whether it is grounded.

State at commit `5183ef3`: the program and its tests are committed; the run has not produced its candidates file yet, so nothing from these books is in the lists. Mining them is plan task T24 of the corpus lane.

## How it does it
**Fetcher.** `discover [--source bookshelf|crossref|archive|wikibooks]` searches the catalogues; `fetch [--book ID] [--limit N]` downloads and resumes where it stopped, down to a partial download. From Bookshelf it takes a book's archive file through that site's documented bulk service and keeps only the chapter files in XML (Extensible Markup Language, a text format with named parts); from the Internet Archive the text of a scan; from Wikibooks a page through its API (application programming interface, an address a program calls); an open chapter comes through the full-text resolver. `status` prints what is fetched.

**Grounding**, steps that can each be stopped and resumed, work files in `data/analysis/books/grounding/<method>/`:

1. **items**: the entries of the kinds above, each with search terms.
2. **candidates**, by code: passages that hold the terms, definitions first, at most three per book and seven per entry.
3. **extract**: a first language model (Sonnet, a model of the Claude family) reads only those passages and returns the principle, up to three quotes and, where needed, the defining description and the measurements.
4. **verify**: code drops every quote that does not stand word for word in the stored chapter (AN-172); then a second model (Haiku) says whether each quote characterises the finding, only mentions it, or is unrelated. Only "characterises" grounds an entry (AN-173).
5. **write**: the status per entry.

Commands: `python3 -I analysis/books_ground.py run --method xray [--kind borderline] [--limit N]`, then `write` and `status`.

**Mining** (`books_mine.py`), work files in `data/analysis/books/mining/`:

1. **blocks**, by code: the book is cut into text blocks; a block without any word of shape or appearance is skipped and counted; an earlier edition of a book held in a later edition is not read.
2. **extract**: a first model (Haiku) keeps short quotes that state what is seen (lines, cortex, density, margins, alignment, displacement, shape, a measurement and its criterion). Treatment, cause, clinical course, old technique and normal anatomy are dropped and counted.
3. **check**, by code: a quote stays only when it stands word for word in the stored text.
4. **verify**: a second model (Sonnet) maps each quote to one entry or descriptor of the X-ray list, or names the visible sign the list lacks (a candidate gap). A sign found by examining the patient (touch, movement, pain) and not seen on the image is dropped here. The program never edits the lists.
5. **compare**: where a current open book also characterises the entry, a model says whether the old statement contradicts it.
6. **write**: the section `historical_mining`.

Commands: `python3 -I analysis/books_mine.py run [--book ID] [--limit N]`, then `write`.

**Bought books** (`books_bought.py`), work files in `data/analysis/books/bought/work/<method>/`:

1. **convert**, by code, one file at a time, holding the project's lock file for heavy jobs (`/tmp/radiology-heavy.lock`, so that only one long job runs on the laptop at a time): a PDF (Portable Document Format) file page by page (a page without a text layer is read by optical character recognition, the program tesseract), an EPUB electronic book chapter by chapter with sections at its page markers, or an HTML (HyperText Markup Language, the format of web pages) file.
2. **candidates**, by code: the passages that hold the item's words, defining ones first, two per book at most.
3. **extract**: a first model (Sonnet) writes the line and gives the words it rests on; code checks the quote, the length, the absent term and the absence of a copied run.
4. **verify**: a second model (Haiku) checks the line against the quote.
5. **write**: `data/analysis/books/bought/candidates.json`, per method and per list entry, for the session that builds the lists.

Commands: `python3 -I analysis/books_bought.py convert [--book KEY]`, `run [--method M] [--limit N]`, `write`, `status`.

In all four programs the book text is untrusted input: the prompts say so and the models get no tools.

**Tests.** `tests/test_books_fetch.py` (14 tests) and `tests/test_books_ground.py` (9) for AN-166 to AN-175; `tests/test_books_mine.py` (8) for AN-176 to AN-178; `tests/test_books_bought.py` (6) for AN-190 to AN-193. They use invented samples and a simulated web and model; none touches the network or a real book. On 2026-11-16, in the working copy at commit `f35556a`, the files for mining and bought books passed together with the other new test files (63 passed).

### Known limits
- **Searched is not grounded.** Of the 729 entries, 297 are only mentioned by the books (weak), 63 were not found and 6 not yet searched.
- **Only part of it has reached the lists.** For ultrasound, CT and MRI, borderline entries without an article definition took a quote from the grounding file as their defining description, and kept borderline entries took the measurements those passages state. The X-ray defining descriptions mostly come from the list's own full-text definitions ([[radiology-observable-descriptions]]). Targets, signs and the historical results have not been taken over.
- **"Grounded" rests on two models and a word-for-word check.** The code proves the quote is in the book; that it characterises the finding is one model's reading, checked by a second. No radiologist has read the result.
- **Old scans are machine-read**, so a correct quote can fail the word-for-word check; and old books carry old knowledge, which is why the historical layer is flagged and a contradicted quote grounds nothing.
- **The bought books have produced nothing yet.** Their lines will be the project's own short wording; no text of them appears on this page or in the repository.
- Not verified for this page: the programs were not run. The counts are those of the committed record file.

## Functions
In `analysis/books_bought.py`:

- `convert(key)`: convert one bought book (or all, one at a time) into the private store.
- `items_of(method)`: the questions to ask for one method: define, value, measure, ground.
- `candidates(corpus, item)`: the passages offered to the first model.
- `copied(line, text, run)`: whether a line repeats 6 or more words in a row of the book.
- `holds_term(line, item)`: whether a line names the term or the finding.
- `line_problem(line, item, passage)`: why a line cannot be shown, or none.
- `run(method, limit)`: candidates, extract, code checks and verify, resumable.
- `cite(store, src)`: the short source field (book and page).
- `write()`: the candidates file in `data/`.

In `analysis/books_mine.py`:

- `blocks_of(store, only)`: every block of every historical book to read.
- `later_edition(books)`: which book is also held in a later edition.
- `targets_of(method)`: the list entries and descriptors a quote can be mapped to.
- `run(book, limit)`: blocks, extract, check, verify and compare.
- `for_entries(method)`: per entry, the quotes that may ground it.
- `section(store)`: the `historical_mining` section.

In `analysis/books_fetch.py`:

- `licence_code(text)`, `refuse(book)`, `blocked_site(url)`: read a licence; refuse a book without a free licence or from a refused site.
- `Fetcher`: discover and download, resumable.
- `sections_from_bits(xml)`, `sections_from_scan(text)`: the sections of a Bookshelf chapter and of a scan.
- `Store`, `add_local(...)`, `layer_of(year)`: the books on disk, a hand-saved file, the layer.
- `Corpus.search`, `quote_present(...)`: find passages; check that a quote stands word for word.

In `analysis/books_ground.py`:

- `build_items(method)`, `candidates(corpus, item)`, `run(method, kind, limit)`: the grounding steps.
- `check_quotes(corpus, quotes)`, `own_method_only(store, method, quotes)`: drop quotes not in the book; set quotes about another method down to a mention.
- `decide(item, principle, quotes)`, `write()`: the status, and the record file.

## Where it sits in the pipeline
Beside the building of the finding lists ([[radiology-finding-inventory]]): it supplies passages for the observable lines and defining descriptions ([[radiology-observable-descriptions]]) and grounding for entries without an article source. It uses the network code and passage search of [[radiology-fulltext-resolver]]. It is listed among the analysis tools on [[radiology-analysis]].

## Who receives its output
The session that builds the finding lists (the "corpus lane"). It reads the grounding file when it adds a defining description or measurements, with the book and chapter as the entry's source; it will read the bought-book candidates file in the same way. Any session of the project may search the open books with `find`.
