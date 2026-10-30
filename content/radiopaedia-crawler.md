---
id: radiopaedia-crawler
title: Radiopaedia crawler (crawl.py)
aliases: [crawl.py, crawler]
kind: program
project: radiology-report-matcher
status: active
location: radiology-crawler:crawl.py
fed_by: []
feeds: [report-translator]
sources: [radiology-crawler:crawl.py, radiology-crawler:progress.py, radiology-crawler:run_all.sh]
reviewed: 2026-10-30T04:25Z
---

## What it is
A command-line program that downloads the article and case pages of Radiopaedia (a free radiology reference site) slowly and politely, keeps a raw copy of every page, and extracts clean text from them into a database. A "crawler" is a program that visits web pages one after another; "extracting" means pulling out the title, headings and body text and dropping menus and scripts. It is part of [[radiology-report-matcher]].

## Architecture
### Context
person g: Giovanni — starts and stops the downloads | [[giovanni]]
system s: crawl.py — downloads Radiopaedia pages and extracts their text
external r: Radiopaedia — the free reference site
external t: Report translator — reads the extracted articles | [[report-translator]]

g -runs-> s
s -downloads pages from-> r
s -hands articles to-> t

### Containers
person g: Giovanni | [[giovanni]]
container cm: Commands — sitemap, fetch, extract, run, stats
store u: urls table — every address and its status
store raw: Raw pages — compressed copy of each page
store a: articles and cases tables — the extracted text
store pj: progress-data.js — live numbers for the plan site
external r: Radiopaedia

g -runs-> cm
cm -reads lists and pages from-> r
cm -tracks every page in-> u
cm -keeps copies in-> raw
cm -writes text to-> a
cm -rewrites every few seconds-> pj

## What it does
It has five commands, run as `python3 -I crawl.py <command>` in `~/dev/radiology-crawler`:

- `sitemap` reads the site's sitemap (the site's own list of its pages) and stores every article and case address in the table `urls` with status `pending`.
- `fetch` downloads pending pages, one every 10 to 12 seconds, and saves each as a compressed file in `data/raw/`. Options: `--kind articles|cases`, `--limit N`. Within each kind the pages are taken in a fixed pseudo-random order (not alphabetical), so a download stopped early still holds a fair sample of all diagnoses.
- `extract` turns saved pages into rows of the tables `articles` and `cases` in `data/radiopaedia.sqlite` (SQLite is a database kept in one file). It skips pages already extracted unless `--all` is given.
- `run` does all of the above in turn (sitemap, articles, cases, extract) and repeats while a pass still reduces the pending list. While it works it rewrites `progress-data.js` in the plan site folder `~/Documents/Radiology Report Matcher/` every 5 seconds (the code is in `progress.py`), so the progress bars of the plan site stay live. It ends with success when nothing is left, with failure when pages are left (for example no network), and with code 75 after repeated blocks. If the crawl is started with `run_all.sh`, that script also starts the background service `radiology-plan-updater` (systemd, the Linux service manager, user level), which keeps the same file fresh and restarts itself after a crash or reboot.
- `stats` prints how many pages are pending, done or gone, and the days left.

`run_all.sh` is the older manual way: it runs sitemap, then fetch for articles, then fetch for cases, then extract, and can simply be run again to resume. On 2026-10-27 the sitemaps listed 17,359 articles and 70,535 cases, about 11 days of downloading at this speed.

## How it does it
- It reads `robots.txt` first and skips any address that file blocks (search, tags, playlists, the programming interface, admin pages). The delay of 10 seconds is the `Crawl-delay` value in that file; a random 0 to 2 seconds is added.
- It sends an honest User-Agent line (the name a program gives a website) that says it is a personal research crawler and gives Giovanni's contact address, plus normal Accept headers. Without them the site answered HTTP 406 ("not acceptable") on the first test.
- An answer of 429 or 503 (too many requests, busy) makes it wait and retry up to three times. An answer of 404 or 410 marks the page `gone`. Three answers of 403 or 406 (refused) stop the whole run; it does not try to get around a block.
- The status of every page is stored in the database, so a stopped run resumes where it stopped. Raw pages are kept so extraction can be improved without downloading again.
- An article is stored with its title, synonym and tag list, author, modified date, body text split by heading and links to other articles. A case is stored with its title, presentation, age and sex, the findings text of each image series with its modality, tags and linked articles. The language is stored as `en`; Radiopaedia has no other language.
- The database file is opened in write-ahead mode (a SQLite mode that lets several programs use one file) so the crawler, the extractor and [[report-translator]] can run together.

## Where it sits in the pipeline
First step of the data chain of [[radiology-report-matcher]]. It runs in the background on the laptop ([[acer-nitro]]) with sleep blocked while it works.

The user service `radiology-crawler.service` (systemd, the Linux program that starts background services) runs `python3 -I crawl.py run` whenever the laptop starts. It restarts 10 minutes after a failure and stays stopped after success (everything fetched and extracted) or after code 75 (blocked). The page `plan site` bars say "the crawler is not running" if the numbers are older than a minute. Check it with `systemctl --user status radiology-crawler`.

## Who receives its output
[[report-translator]] reads the `articles` table. The planned index builder will read both tables.
