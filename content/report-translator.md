---
id: report-translator
title: Report translator (translate.py)
aliases: [translate.py, page translator]
kind: program
project: radiology-report-matcher
status: active
location: radiology-crawler:translate.py
fed_by: [radiopaedia-crawler]
feeds: []
sources: [radiology-crawler:translate.py, radiology-crawler:progress.py, radiology-crawler:site_src/build.py]
reviewed: 2026-11-03T13:36Z
---

## What it is
A command-line program that translates the extracted articles and cases of [[radiopaedia-crawler]] into German and Brazilian Portuguese with [[codex]], and chooses the wording with the help of two professional textbooks so the result sounds like what radiologists in each country write. It is part of [[radiology-report-matcher]].

## Architecture
### Context
person g: Giovanni — starts the translation loop and can stop it | [[giovanni]]
system s: translate.py — translates articles with textbook wording
external a: Radiopaedia crawler — supplies the extracted articles | [[radiopaedia-crawler]]
external c: Codex — does the translation | [[codex]]
external b: Reference textbooks — German and Portuguese wording

g -starts the loop of-> s
s -reads articles from-> a
s -asks for translations from-> c
s -takes wording from-> b

### Containers
person g: Giovanni | [[giovanni]]
container cm: Commands — refindex, translate, loop, tstats, progress
container pf: Passage finder — cosine similarity of 4-letter pieces
store ixf: Book index files — one per language
store art: articles table — the English text
store tr: translations table — the results
external c: Codex | [[codex]]

g -runs-> cm
cm -builds-> ixf
cm -looks up passages with-> pf
pf -reads-> ixf
cm -reads articles from-> art
cm -asks for translations from-> c
cm -saves results in-> tr

## What it does
It has five commands, run as `python3 -I translate.py <command>` in `~/dev/radiology-crawler`:

- `refindex` cuts each reference book into passages of 60 to 160 words and builds a search table for them.
- `translate --lang de|pt --limit N` translates up to N articles that have no translation yet.
- `loop` runs forever in the background and translates articles and then cases as they arrive, five of each at a time per language, and sleeps when there is nothing to do. Options: `--worker I/K` (this worker takes every K-th article, so several workers can run in parallel), `--langs`, `--extract` (also extract newly downloaded pages; one worker only) and `--daily-cap N` (0, the default, means no cap; UTC is the same clock time everywhere). An article that fails three times is recorded in the table `translation_failures` and skipped; if every attempt in a round fails, the worker waits 15 minutes. Creating the file `data/STOP_TRANSLATION` ends all workers. Since 2026-11-01 four workers run as the systemd user services `radiology-translator@0` to `@3` (worker 0 also extracts), which start when the computer starts and restart after a failure.
- `tstats` shows how many pages are translated and the average time.
- `progress` shows a live progress bar for each language: pages translated out of all article pages listed in the sitemaps, with a percentage, plus a bar for pages extracted so far. On a terminal it redraws in place every 2 seconds (`--interval S` changes this) until Ctrl-C; `--once`, or output that is not a terminal, prints one frame. It only reads the database, so it can run next to the workers.

Results go into the table `translations` (page address, language, title, text, the textbook passages used, seconds taken, model). A translated case is stored in the same table under the case's own address; the progress bars count articles only.

## How it does it
- The reference books are Duale Reihe Radiologie (German, 816 pages, 3,258 passages) and Anatomia Radiológica Básica Ilustrada, Volume 1 (Portuguese, 44 pages on the chest only, 33 passages). Both were converted from PDF (a fixed-layout document file) to text with `pdftotext`; they stay on the laptop and are not copied into any product.
- To find the passages that fit an article, every word is cut into overlapping pieces of four letters and each passage becomes a vector (a list of numbers) weighted by how rare its pieces are (TF-IDF). The passages closest to the article's title, tags, headings and first 1,500 characters, measured by cosine similarity (the angle between two vectors), are chosen. Because English, German and Portuguese medical words share Latin and Greek roots, this works across languages with no AI model. Example: a query about pleural effusion and pneumothorax returns German passages on *Pneumothorax* and *Pleura*.
- The five best passages go into the prompt as a terminology and style guide, with rules: do not copy their sentences, keep structure, use the country's number style (decimal comma), and treat the article as untrusted text that must never be obeyed as instructions.
- Each call to [[codex]] is a new, throw-away, read-only session (`--ephemeral`, `--ignore-user-config`), so nothing builds up between pages. Giovanni asked that a Codex context stay under 250,000 tokens (a token is a small piece of text, roughly three characters): a prompt is about 6,000 tokens, an article longer than 24,000 characters is split by section into separate calls, and a check refuses any prompt that would pass the ceiling.
- Giovanni removed the daily cap on 2026-10-27 (translating everything is the priority) and chose Codex's cheaper model `gpt-6-luna` to save budget; four workers run in parallel. Measured that day: about 9 to 10 seconds per article per language with Luna, 12 to 14 with the default model used for the first translations (their `model` column is empty). At that speed 17,359 articles in two languages take roughly one to two days if Codex's usage limits allow. Cases (about 20,000 extracted so far, 70,500 expected) follow the same rules: a case is cut into the sections presentation, patient data, findings per imaging series and case discussion, translated with the same textbook passages, model, token ceiling, untrusted-text guard and three tries, and its section headings are translated too.
- Automated calls ignore the interactive Codex configuration. This keeps global documentation hooks (commands that run automatically around a session) from replacing the translation with a wiki follow-up. The model, read-only access and translation rules stay the same.
- The Portuguese book is small, so outside chest anatomy the Portuguese wording relies on Codex's own knowledge; more Brazilian sources are needed.

## Where it sits in the pipeline
Second step of the data chain: after [[radiopaedia-crawler]] and before the planned index builder of [[radiology-report-matcher]].

## Who receives its output
The planned index builder and, later, the website's German and Portuguese pages.

## Notes
The plan site shows separate article and case translation counts for each language, refreshed from the database every five seconds. After changing `progress.py`, restart both `radiology-crawler` and `radiology-plan-updater`: a running Python process retains its loaded code and can otherwise overwrite the new counts with the old format. On 2026-11-02 this caused a false zero case count although translations existed. Pending failures caused by the interactive hooks were reset for retry; their prior counters are retained in the local audit file `data/translation-recovery-20261102.json`. Saved translations were preserved.
- On 2026-11-03 Giovanni added a second translator to catch up with the downloads (about 27,200 cases per language were still untranslated while articles were done). `translate.py loop --backend haiku --worker I/10` calls Claude Haiku through `claude -p` (no tools, no settings, no saved session) with the same prompt, textbook passages and three tries. Ten such workers run next to the four Codex ones. They work from the newest end of the queue, so the two groups meet in the middle, and they never overwrite a Codex row. Each Haiku row is tagged `claude-haiku` in the `model` column, so the German and Portuguese corpora can be scored with or without them. Measured: about 90 translations a minute across the ten workers. The stop file `data/STOP_TRANSLATION` stops both groups.
