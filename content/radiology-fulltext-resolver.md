---
id: radiology-fulltext-resolver
title: Full-text resolver (analysis/fulltext.py)
aliases: [full-text resolver, fulltext.py, analysis/fulltext.py, papers-to-fetch.md, papers to fetch by hand]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/fulltext.py
fed_by: []
feeds: [radiology-real-report-factcheck]
sources: [radiology-crawler:analysis/fulltext.py, radiology-crawler:tests/test_fulltext.py, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:docs/TRACEABILITY.md]
reviewed: 2026-11-15T17:31Z
memory: []
---

## What it is
A program that fetches the whole text of a medical journal article, given only the article's identifier, and records how it got the text. It belongs to the finding assistant project ([[radiology-report-matcher]]), a program that turns a loose description of something seen on a medical image into exact radiological terms. It is one file, `analysis/fulltext.py`, in the repository `~/dev/radiology-crawler`, added on 2026-11-15 (commits `5cf9fa4` and `cea15a6`).

It exists because of a rule Giovanni gave that day: a check of the project's labels against the medical literature (a label says that a given real radiology report states a given finding) must rest on full articles, never on abstracts (an abstract is the short summary at the head of an article). The check itself is described on [[radiology-real-report-factcheck]]. The services that hand out article texts to programs often serve only the abstract, even when the article's own web page is free to read. The resolver tries several open ways in a fixed order and accepts a text only when it is a real article body. It is a shared tool: any session of the project may call it. No other program of the repository calls it; a person or a session runs it by hand or from code.

It reads only what is openly offered. It does not log in, does not pass a paywall and does not pretend to be a browser.

## What it does
It takes one identifier of an article, in any of four forms:

- a DOI (digital object identifier, the permanent name of an article, such as `10.1089/thy.2015.0020`);
- a PMID (the article's number in PubMed, the public index of medical articles of the US National Library of Medicine);
- a PMCID (the article's number in PubMed Central, the same library's free archive of whole articles, written `PMC` plus digits);
- a URL (uniform resource locator, a web address) of the article.

Anything else is refused before any request is sent and before any file is written (requirement AN-137; a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check). Free text, a finding name or a file path is not an identifier.

It then tries four routes in order and stops at the first one that gives a real body (requirement AN-133):

1. **Open article services.** For an article in PubMed Central it asks four API endpoints (API: application programming interface, an address a program calls instead of a person): the full-text file of Europe PMC (a European mirror of PubMed Central), the article file of the US library's `efetch` service (its general service for fetching records), the same library's BioC service (which delivers articles cut into passages for text analysis), and its open-access package (a bundle of the files of one article that the library offers for download when the licence allows reuse). The first two and the last give the article as JATS XML, the standard file format in which journals deliver articles (JATS: Journal Article Tag Suite; XML: Extensible Markup Language, a text format with named parts); BioC gives it as JSON (JavaScript Object Notation, a plain-text format for structured data). An article without a PMCID skips this route.
2. **Open copies named by discovery services.** A "discovery service" is a public catalogue of scholarly articles that says, among other things, where a free copy of an article lies. Four are asked: Europe PMC, OpenAlex and Semantic Scholar (two open catalogues of research papers) and Crossref (the registry that issues DOIs). The last three need a DOI. Each address they name is fetched and read like a page, at most eight addresses per article, PubMed Central pages first and PDF files last.
3. **The article's own page.** The page is read in three ways, in this order: (a) the article text in the HTML (HyperText Markup Language, the format of web pages), cut into sections at its headings; (b) data that the page carries inside its script tags (the parts of a page that hold program code for the browser), because some sites deliver the article text as data for a script instead of as visible HTML; (c) the links the page gives in its `citation_...` meta tags (hidden lines of a page that tell indexing services where the full text or the PDF is), each followed once. A PDF is turned into text with the command-line tool `pdftotext`.
4. **PDF files saved by hand.** A person can save an article as a PDF in the folder `~/Downloads/radiology-papers/`. The resolver matches a file to the article by the DOI, the PMCID or the title, in the file name or in the first part of its text, and reads it only as data.

**What counts as a real body** (requirement AN-134). A text is accepted only when it has at least 3,000 characters in two or more titled sections, not counting the abstract, the reference list and the back matter (acknowledgements, funding, declarations and similar parts). A text without sections, such as a PDF, needs 6,000 characters. A section shorter than 200 characters does not count. So an abstract alone is never accepted, however it is delivered.

**What it writes.** Two places only (requirement AN-137):

- One record per article in the cache folder `data/analysis/fulltext/`, a JSON file. It holds the identifiers, the title, the status (`obtained` or `not obtained`), the route and address that gave the body, the licence (the terms under which the text may be reused) when one was stated, the time, the number of body sections and characters, the sections themselves (title, text, and whether the section counts as body), and every attempt with its result and reason. A later call for the same article returns the cached record when it is `obtained`.
- The list `data/analysis/papers-to-fetch.md`. When no route gives a body, the article gets one line there: title, authors, year, address and the reason per route (requirement AN-136). An article already on the list is not added twice. The list is for a person: fetch the paper by hand, save the PDF in the folder of route 4, and run `retry-list`.

Both lie in `data/`, which is not in git (the version-control system that holds the code), so article texts never enter the repository. The resolver never opens the project's sealed batches of real reports, the report texts kept aside for the final test, which no building session may read ([[radiology-final-test-batch]]).

## How it does it
Commands, run in the repository:

- `python3 -I analysis/fulltext.py get PMC4739132` resolves one article; the argument may be a DOI, a PMID, a PMCID or a URL. `--refresh` ignores a cached copy. It prints the status, the route, the size of the body and one line per attempt with its address. The exit code is 0 when the body was obtained and 1 when not; an argument that is not an identifier ends with code 2.
- `python3 -I analysis/fulltext.py retry-list` tries every paper of the list again and removes the lines whose paper is now obtained.
- `python3 -I analysis/fulltext.py status` prints how many articles are cached as obtained, by route, which are not obtained, and how many lines wait on the list.

From Python code: `fulltext.get("10.1089/thy.2015.0020")` returns the record.

**Limits it keeps** (requirement AN-135). These are fixed in the code and are not options:

- One client name, `radiology-fulltext/1 (research tool)`, is sent with every request. It is never a browser's name and carries no name or e-mail address of a person.
- Before it fetches a page or a file it reads the site's `robots.txt` (the file in which a site tells automated visitors what they may fetch) and obeys it, at every step of a redirect too. The documented API endpoints of route 1 and of the discovery services are called as APIs, without this check.
- It waits at least one second between two requests to the same site, or longer when `robots.txt` asks for it; when a site asks for more than 60 seconds it leaves that site alone.
- A refusal ends the route and the site for the rest of the run: the answer codes 401, 402, 403, 407, 429 and 451, a page that tests whether the visitor is a robot (a "bot check" or CAPTCHA), and a login page or a redirect to one. Since commit `cea15a6` a `robots.txt` that is itself answered with a refusal or a bot check also stops the site; before, it was read as "no rules". Nothing is tried again in another guise.
- At most six redirects are followed, and an answer larger than 80 million bytes is dropped.

A network error or a refusal ends one route, never the whole run: the next route is tried, and the reason is kept in the record.

**Reading a page.** For the HTML, the program looks for the part of the page that holds the article (a fixed list of common containers), drops menus, tables, figures and reference lists, and cuts the rest at the headings. Text before the first heading is treated as front matter (title, authors, often the abstract) and never counts as body. For the script data it collects every JSON value inside the page's script tags and walks through it, looking for a field named `articleBody`, for pairs of a title and a text, and for long runs of prose. A field named like an abstract (`abstract`, `description`, `summary`) is kept as an abstract and never as body.

**Tests.** `tests/test_fulltext.py` holds 19 test functions, 35 cases when run, all on recorded or invented samples with a simulated web: no test touches the network. They cover the five requirements AN-133 to AN-137: the order of the routes, the abstract rule, `robots.txt` and the delay, the refusals, the client name, the list, and the refusal of anything that is not an identifier. The 35 cases passed when this page was written.

### Known weak points
- **Route 3 (b), script data, and route 4, hand-saved PDFs, are tested only on samples.** In the cache on Giovanni's laptop when this page was written, seven articles were obtained: three by the Europe PMC file, two by an open copy that OpenAlex named, one from the HTML of the article page and one from a PDF named in a meta tag. None came from script data or from a hand-saved PDF, so those two ways have not been seen to work on a real site.
- **A site that refuses the client is not read.** The resolver states honestly what it is, and a publisher's site that answers that with a refusal or a bot check ends the route by design. How many publisher sites do so was not measured for this page; the commit message of `cea15a6` says its fixes came from a trial on live sites.
- **PDF text has no sections.** A PDF becomes one untitled block, with the reference list cut off when a line "References" stands in the later part of the text. Whoever reads the record cannot tell the methods from the discussion, and page headers and footers stay in the text. A scanned PDF without a text layer gives nothing, and so does a machine without `pdftotext`.
- **The body rule is a size rule.** It counts characters and section titles. It does not check that the text is the right article or that it is complete.
- **The list of page containers and of section titles to skip is fixed.** A site with another page layout can yield no body, or a body with stray parts.

## Functions
- `get(identifier, refresh=False)`: the record of one article; the function other code calls.
- `parse_id(text)`: the DOI, PMID, PMCID and URL found in one identifier; refuses anything else.
- `Net.get(url, page=True)`: one fetch under the limits above (`robots.txt`, delay, redirects, refusals); raises `Stop` with the reason.
- `block_reason(resp)`: why an answer is a wall (refusal code, login page, bot check), or nothing.
- `is_real_body(sections)`, `body_stats(sections)`: the body rule and the counts it uses.
- `sections_from_jats`, `sections_from_bioc`, `sections_from_html`, `sections_from_json`, `sections_from_pdf_text`: the sections of a text in each of the five forms it can arrive in.
- `script_blobs(html)`: every JSON value inside the script tags of a page.
- `meta_links(html, base)`: the full-text and PDF addresses a page names in its meta tags.
- `pdf_to_text(data)`: the text of a PDF through `pdftotext`; empty when the tool is missing or fails.
- `Resolver.get`, `retry_list`, `status`: the three commands.
- `Resolver._apis`, `_open_copies`, `_page`, `_local`: the four routes.
- `Resolver._queue`: adds the line to the list of papers to fetch by hand, once.

## Where it sits in the pipeline
Beside the fact-check of real reports ([[radiology-real-report-factcheck]]), which since requirement AN-123 counts a decision as supported only when a source was read in full text. The resolver is one way to get that full text; the commit message of `e0a94e6` records one fact-check decision whose source, a guideline, was read through it. It is listed among the analysis tools on [[radiology-analysis]]. It takes nothing from another program of the project: its input is an identifier typed by a person or a session.

## Who receives its output
The session that checks labels against the literature (the project calls it the "judge": a Claude session that works only on the data kept for testing) and any other session of the project that needs an article body: they read the cached record. Giovanni receives the list `papers-to-fetch.md`, which names the papers only a person can fetch. When this page was written the list held no open paper.
