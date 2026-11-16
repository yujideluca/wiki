---
id: radiology-textbook-foundation
title: Textbook foundation (analysis/books_fetch.py and books_ground.py)
aliases: [textbook foundation, open radiology books, analysis/books_fetch.py, analysis/books_ground.py, books_fetch.py, books_ground.py, docs/books-manifest.json, docs/foundational-sources.json, foundational sources, grounding in textbooks]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/books_fetch.py
fed_by: [radiology-fulltext-resolver]
feeds: [radiology-finding-inventory]
sources: [radiology-crawler:analysis/books_fetch.py, radiology-crawler:analysis/books_ground.py, radiology-crawler:docs/books-manifest.json, radiology-crawler:docs/foundational-sources.json, radiology-crawler:tests/test_books_fetch.py, radiology-crawler:tests/test_books_ground.py, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:docs/finding-list-restructure.json]
reviewed: 2026-11-16T06:11Z
memory: []
---

## What it is
Two programs and two record files that tie the entries of the project's finding lists to radiology textbooks. They belong to the finding assistant project ([[radiology-report-matcher]]), a program that turns a loose description of something seen on a medical image into standard radiological terms. A "finding" is what is seen on the image, named in descriptive terms, such as a pleural effusion; the project keeps one list of findings per imaging method (X-ray, ultrasound, computed tomography or CT, magnetic resonance imaging or MRI), described on [[radiology-finding-inventory]].

The reason, given by Giovanni on 2026-11-15 and written at the head of the first program: the description of some findings is stated by no current journal article, because it was settled in the early days of radiology (the example in the code is the greenstick fracture). Such an entry must rest on the basic body of literature, which is in textbooks. So the project needs a collection of textbooks it may lawfully read with a program, and a way to find and check passages in them.

The parts, all in the repository `~/dev/radiology-crawler`, added on 2026-11-15 and 2026-11-16 (commits `8ac0fc0`, `780123d`, `1e5780e` and `17ee7c8`; this page describes commit `5d36ad7` of 2026-11-16):

- `analysis/books_fetch.py` finds free books, downloads them, cuts them into chapters of plain text and searches them.
- `analysis/books_ground.py` looks up list entries in those books and records what the books say ("grounding").
- `docs/books-manifest.json` lists the fetched books, with counts and licences only.
- `docs/foundational-sources.json` holds the result of the grounding.

State at this commit: 88 books are fetched. The grounding has been run for all 122 X-ray entries (62 grounded, 48 weak, 12 not found) and for the borderline entries of ultrasound (142 entries: 63 grounded, 74 weak, 5 not found) and of CT (190 searched: 81 grounded, 94 weak, 15 not found). The remaining entries of ultrasound and CT (19 and 40) and all 214 MRI entries are listed with the status "not searched". These programs change no finding list: the file is a record beside the lists. Since commit `17ee7c8` the session that builds the lists has copied some of its results into the ultrasound and CT lists (see "Who receives its output").

## What it does
### Which books are taken
A book is taken only when its licence makes it free to read and to process (requirement AN-166; a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check). A licence is the set of terms under which a text may be used. The accepted ones are the Creative Commons licences CC BY, CC BY-SA, CC BY-NC, CC BY-NC-SA and CC BY-NC-ND (standard public licences; the letters after "CC" name the conditions: attribution, share alike, non-commercial, no derivatives), CC0 (the author gives up all rights) and the public domain (no copyright: a public-domain mark, or a book published in 1929 or earlier). A book whose licence forbids derivatives is marked "quote only". Every other licence, and a book that states none, is refused.

Two kinds of site are refused by name before any request is sent: "shadow libraries", sites that hand out pirated copies of books (a fixed list in the code), and Radiopaedia, a reference site whose text the product never shows.

The same manners hold as for journal articles ([[radiology-fulltext-resolver]], whose network code this program uses): one fixed client name without personal data, at least one second between two requests to the same site, and a site that refuses (a login page, a test whether the visitor is a robot, or the answer codes 401, 403 and 429) is written down and left alone for the rest of the run. Nothing is tried in another guise (requirement AN-169).

### Where the books come from
Four public catalogues are searched (`discover`):

- NCBI Bookshelf, the book archive of the US National Center for Biotechnology Information (NCBI): its open-access subset;
- Crossref, the registry of scholarly publications: books and chapters under an open licence from the publishers Springer and IntechOpen;
- the Internet Archive, a library of scanned books: old radiology books in the public domain;
- Wikibooks, the textbook project of the Wikimedia Foundation.

A hand-saved file can be added with `add`, with its title, year, licence and address.

From `docs/books-manifest.json` (generated 2026-11-16): 88 books with 3,491 chapters and about 103 million bytes of text. By licence: 71 under CC BY (63 recorded as "CC BY", 8 as "CC BY 4.0"), 14 in the public domain, 2 under CC BY-NC-ND 4.0, 1 under CC BY-SA 4.0. By catalogue: 63 through Crossref, 14 from the Internet Archive, 10 from Bookshelf, 1 from Wikibooks. Five books that were found were not fetched, each because no open licence was stated.

Books are sorted into layers by year (requirement AN-175). A book of 2015 or later is the "current" layer, the source of today's descriptive vocabulary: 74 books. A public-domain classic is the "historical" layer and is always flagged as such: 14 books. A book in between would be "older"; the manifest lists none.

A chapter counts for an imaging method when it names that method at least three times. By that count the manifest gives: X-ray 37 books (23 of them current) and 1,145 chapters; ultrasound 40 books and 1,387 chapters; CT 41 and 1,718; MRI 51 and 1,694. A chapter can count for several methods.

### What is stored
A fetched book is stored as chapters; a chapter is a set of titled text sections with its page range and licence (requirement AN-168). Images are never kept. A chapter without an open licence is dropped. Of a large reference work only the chapters about imaging are kept. The text stays in the folder `data/analysis/books/`, which is not in git (the version-control system that holds the code), so no book text enters the repository. The committed manifest holds, per book: title, edition, year, publisher, licence, address, layer, catalogue, chapters per imaging method, number of chapters, bytes, and how it was fetched (requirement AN-167).

### Searching the books
`python3 -I analysis/books_fetch.py find greenstick cortex --method xray` prints the passages that hold all the given terms, each with book, edition, year, chapter, section, pages and licence (requirement AN-170). `--method` keeps to chapters of one imaging method, `--layer` to one layer, and `--max-chars` caps the printed text (default 3,000 characters). The search cuts and ranks passages the same way as the article search of the full-text resolver.

### Grounding list entries
"Grounding" an entry means finding a textbook passage that states what characterises the finding on the image. `books_ground.py` does this per imaging method, on that method's own list and on the chapters that count for that method; nothing is pooled across methods. Since commit `1e5780e` a quote whose passage speaks only of another imaging method no longer counts as characterising: it is set down to a mention, by code. It takes these kinds of entry:

- **finding**: a list entry marked foundational (basic radiology that textbooks teach, kept without an article citation), or one whose only sources are abstracts or missing (X-ray);
- **target**: a visible sign proposed to replace an entry that names a diagnosis. The project decided on 2026-11-15 that its lists hold findings only; the proposals are in `docs/finding-list-restructure.json` ([[radiology-finding-inventory]]);
- **sign**: for ultrasound, CT and MRI, the visible sign of a family of diagnosis-like entries, worded for that method;
- **descriptor**: a descriptor (an attribute of a finding, such as its margin, with standard values) for which an earlier literature check found no sentence ([[radiology-modality-corpus]]);
- **borderline**: an entry that is a standard radiological term but also names a disease or condition. By Giovanni's rule of 2026-11-15 it stays a finding only with a defining description of the image, and a definition that rests on a measurement taken on the image must state that measurement;
- **measured**: a finding whose name or definition names a measurement.

The result per entry in `docs/foundational-sources.json` (requirement AN-171): a status, the characterising principle in one sentence, and up to three short quotes (at most 300 characters each) with book, year, chapter, place in the chapter, licence and layer. The statuses:

- **grounded**: at least one quote that characterises the finding; the number of independent books is given;
- **weak**: the books mention the finding and do not characterise it;
- **not found**: no passage;
- **not searched**: the grounding has not been run for this entry.

A borderline or measured entry also carries its defining description (a quote with its reference) and its measurements: what to measure, how, the criterion and the unit (requirement AN-174). When two books give different thresholds both are recorded and the difference is written down. A borderline entry that the open books do not define is marked so.

X-ray result, from the file (checked 2026-11-16):

| Kind | Grounded | Weak | Not found |
|---|---|---|---|
| finding | 1 | 3 | 2 |
| target | 18 | 13 | 0 |
| descriptor | 18 | 19 | 9 |
| borderline | 12 | 6 | 0 |
| measured | 13 | 7 | 1 |
| All (122) | 62 | 48 | 12 |

Twelve of the 18 X-ray borderline entries have a defining description from the open books and 6 do not. Sixteen entries carry measurements. In three entries the books disagree on a threshold (for example "more than 10 degrees" against "at least 10 degrees"), and the file says so. The 122 entries carry 176 quotes: 103 from books under CC BY-NC-ND 4.0, 59 under CC BY, 14 from public-domain books. The first run (commit `780123d`) counted 66 grounded and 44 weak; four entries went from grounded to weak when quotes about another imaging method stopped counting.

The other methods at the same commit, each on its own list and chapters:

| Method | Entries listed | Grounded | Weak | Not found | Not searched |
|---|---|---|---|---|---|
| Ultrasound | 161 | 63 | 74 | 5 | 19 |
| CT | 231 | 81 | 94 | 16 | 40 |
| MRI | 214 | 0 | 0 | 0 | 214 |

For ultrasound and CT only the borderline entries were searched (one CT descriptor apart). Of them the open books define 58 for ultrasound and 78 for CT; 19 ultrasound and 26 CT entries carry measurements; the books disagree on a threshold in one ultrasound and two CT entries. Ultrasound carries 181 quotes and CT 243.

## How it does it
Commands of the fetcher, run in the repository:

- `python3 -I analysis/books_fetch.py discover [--source bookshelf|crossref|archive|wikibooks]` searches the catalogues and records what it finds.
- `python3 -I analysis/books_fetch.py fetch [--book ID] [--limit N]` downloads. It can be stopped and started again: it resumes at the book, the chapter and even the partial download where it stopped. From Bookshelf it takes the archive file of a book through that site's documented bulk service and keeps only the chapter files in XML (Extensible Markup Language, a text format with named parts); from the Internet Archive the text file of a scan; from Wikibooks a page through its API (application programming interface, an address a program calls instead of a person); an open chapter comes through the full-text resolver.
- `status` prints what is recorded and fetched; `manifest` writes `docs/books-manifest.json`.
- `find` and `add` are described above.

The grounding runs in steps, each of which can be stopped and resumed; its work files are in `data/analysis/books/grounding/<method>/`:

1. **items**: the entries of the kinds above, each with search terms.
2. **candidates**, by code: the passages that hold the terms, those that read like a definition first, at most three per book and seven per entry.
3. **extract**: a first language model (Sonnet, a model of the Claude family) reads only those passages and returns the principle, up to three quotes and, for borderline and measured entries, the defining description and the measurements.
4. **verify**, in two parts. By code: every quote must stand word for word in the stored text of the named chapter, or it is dropped before anything is written (requirement AN-172). Then a second, different model (Haiku) reads each remaining quote and says what it claims: it characterises the finding, only mentions it, or is unrelated. An entry is grounded only when the second model reads a quote as characterising (requirement AN-173). A batch that fails stays open for the next run.
5. **write**: the status per entry.

The book passages are treated as untrusted text: both prompts say so, and the models are given no tools.

Commands: `python3 -I analysis/books_ground.py run --method xray [--kind borderline] [--limit N]`, then `write`, and `status`.

**Tests.** `tests/test_books_fetch.py` holds 14 tests and `tests/test_books_ground.py` 9, for the requirements AN-166 to AN-175. They use invented samples and a simulated web and model; none touches the network. One test compares every quote of the committed file with the stored books, and can do so only on a computer where the books are stored. On a copy of commit `af3afc6` without the books, both files passed when this page was written.

### Known limits
- **Not every method is grounded.** X-ray is complete; for ultrasound and CT only the borderline entries were searched; MRI is listed and not searched.
- **Only part of it has reached the lists.** The defining descriptions and measurements of the X-ray list cite that list's own article sources, not this file. For ultrasound and CT, the borderline entries that had no article definition took a quote from this file (10 and 16 entries), and the measurements the passages state were copied (15 and 22 entries). Targets, signs and descriptors have not been taken over, and MRI not at all ([[radiology-finding-inventory]]).
- **"Grounded" rests on two models and a word-for-word check.** The code proves that the quote is in the book. That the quote characterises the finding is the reading of one model, checked by a second. No radiologist has read the result.
- **Old scans are machine-read.** The text of an Internet Archive scan comes from optical character recognition, so words may be misread (the manifest says so for each such book), and a correct quote can fail the word-for-word check.
- **Old books carry old knowledge.** The historical layer is flagged so that a reader can tell a passage of 1917 from one of 2023.
- **Most quotes come from a licence that forbids derivatives.** Those books are marked "quote only"; the file holds short quotes with their reference.
- **Free books are not all books.** The standard commercial textbooks are not among them, so "not found" means not found in these 88 books.
- Not verified for this page: the programs were not run and the stored books were not opened. The counts are those of the two committed files.

## Functions
In `analysis/books_fetch.py`:

- `licence_code(text)`, `refuse(book)`, `blocked_site(url)`: read a licence, and refuse a book without a free licence or an address of a refused site.
- `Fetcher.discover_bookshelf` and its siblings for Crossref, the Internet Archive and Wikibooks: record the books a catalogue offers.
- `Fetcher` (download part), `download(url, dest)`: fetch a book, resumable.
- `sections_from_bits(xml)`, `sections_from_scan(text)`: the sections of a Bookshelf chapter file and of the text of a scan.
- `Store`, `chapter_record(...)`: the catalogue and the chapters on disk.
- `add_local(...)`: add a hand-saved file.
- `layer_of(year)`: current, older or historical.
- `Corpus.search`: the passages that hold the terms.
- `quote_present(corpus, book_id, chapter, quote)`: whether a quote stands word for word in a stored chapter.
- `manifest(store)`: write the manifest.

In `analysis/books_ground.py`:

- `build_items(method)`: the entries to ground, by kind.
- `candidates(corpus, item)`: the passages offered to the first model.
- `run(method, kind, limit)`: the steps extract and verify, resumable.
- `check_quotes(corpus, quotes)`: drop every quote that is not in the book.
- `own_method_only(store, method, quotes)`: set a quote about another imaging method down to a mention.
- `decide(item, principle, quotes)`: grounded, weak or not found.
- `write()`: the file `docs/foundational-sources.json`.

## Where it sits in the pipeline
Beside the building of the finding lists ([[radiology-finding-inventory]]), after the classification of every entry as finding, diagnosis-like or borderline, which names the entries that need a textbook basis. It uses the network code and the passage search of [[radiology-fulltext-resolver]]. It is listed among the analysis tools on [[radiology-analysis]].

## Who receives its output
The session that builds the finding lists, which the project calls the "corpus lane": it reads `docs/foundational-sources.json` when it rewords an entry or adds a defining description and measurements. In commit `17ee7c8` of 2026-11-16 it did so for ultrasound and CT: a borderline entry without a definition from an article got a short word-for-word quote from a book as its `defining_description`, with the book chapter added to the list file's sources, and so stays a finding (ultrasound 10 entries, CT 16). Kept borderline entries got the measurements those passages state (ultrasound 15 entries, CT 22), each with its book source; where books give different thresholds both are kept and flagged. Three records that are not measured on the image (for example a time course in days) were left out. Any session of the project may search the books with `find`. Giovanni reads the two record files.
