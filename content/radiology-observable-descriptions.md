---
id: radiology-observable-descriptions
title: Observable descriptions for the finding lists (analysis/observable.py)
aliases: [observable descriptions, analysis/observable.py, observable.py, docs/observable-descriptors.json, observable line, defining description, defining_description]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/observable.py
fed_by: [radiology-fulltext-resolver, radiology-textbook-foundation]
feeds: [radiology-finding-inventory, radiology-finding-engine]
sources: [radiology-crawler:analysis/observable.py, radiology-crawler:tests/test_observable.py, radiology-crawler:docs/observable-descriptors.json, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:assistant/dialog.py, radiology-crawler:assistant/modules/xray/msk-trauma.json, radiology-crawler:PLAN.md]
reviewed: 2026-11-16T17:56Z
memory: []
---

## What it is
A program that writes, for the finding lists of the radiology finding assistant ([[radiology-report-matcher]]), one short line of what is seen on the image for each answer the assistant may offer. The assistant helps a user who saw something on a medical image and does not know the standard radiological term for it: it asks a few questions and then names the "finding" (what is seen, in standard terms, such as a pleural effusion). The lists of findings, one set per imaging method (X-ray, ultrasound, computed tomography or CT, magnetic resonance imaging or MRI), are described on [[radiology-finding-inventory]].

Why it exists: the user is looking for the term, so a question can never offer the term itself as an answer (a rule of 2026-11-16 by Giovanni, the physician who owns the project; requirement FA-32 of the engine). A requirement is a numbered promise in the project's file `docs/REQUIREMENTS.md`, checked by a test. Instead of the term, the assistant offers a line that says what is seen. Example from the program's own description: for the value "spiral" of a fracture line, the line is "line winding around the long axis of the shaft". A value without such a line cannot be offered at all.

The program is `analysis/observable.py` in the repository `~/dev/radiology-crawler`, added in commit `574b961` of 2026-11-16 and changed in commit `5183ef3` the same day (requirements AN-159, AN-160 and AN-181). It writes two kinds of field into the list files (`assistant/modules/<method>/*.json`):

- on each descriptor, a field `observable`: for each value, a line `{text, source, level}`. A descriptor is an attribute of a finding with a fixed set of standard values, such as its margin or its side;
- on each finding, a field `defining_description` `{text, source, level}`: what is seen, without the finding's own name. The assistant uses it in its last question, where the user picks a finding by its description, not by its name.

`text` is the line; `source` points to an entry of the list file's own source list; `level` says how the line was obtained: "plain words", "full text" (from the body of a cited article, or the list's own definition written from such articles), "open textbook passage", or "foundational" (basic radiology stated alike by the open sources). `source` is a key such as `S35` or `BK1` into the `sources` table at the top of the same list file. A line written from a passage is in the project's own wording: since commit `5183ef3` no quote of a source is written into a list; the quotes stay in the work files, only to check the line.

## What it does
For every value and every finding of one imaging method, on that method's own list (nothing is pooled across methods), it decides which line may stand:

- **Plain words.** A value that is no term needs no source: every word is a plain word of place, side, presence, number or size ("right", "absent", "proximal"), or the value asks for a number. Since commit `0f2188e` (Giovanni's rule of 2026-11-16, plan task T31) an anatomical or site name is plain too, when it is the value of a place descriptor (site, location, bone, level, segment, region and similar: `PLACE_DESCRIPTORS`), for example "right iliac fossa", "tentorium" or "C5"; the same word under another descriptor stays a term, and a value that names a disease (a word of the diagnosis-word list, or words such as malformation, tumour, cyst, nodule, mass) is never plain. Its line is the value itself, without any bracket ("joint (CPPD)" is shown as "joint"), at the level "plain words".
- **From a passage.** Any other value gets a line only when a passage of a source states it. A passage counts only from the body of an article the entry cites (never its abstract) or from a current open textbook ([[radiology-textbook-foundation]]); Radiopaedia, a reference website whose text the product never shows, is never used (AN-181). The first model writes the line in its own short technical wording and names the words of the passage it rests on (the quote). The quote must stand word for word in the passage; the line must not share six or more words in a row with it; and a second, different language model must read the quote as stating the line and the line as something seen on the image. A passage whose licence allows no derivative text feeds no line at all. Why: Giovanni's scope rule of 2026-11-16 that every source only feeds a body of knowledge in the project's own words, with no copied text (`PLAN.md`, scope line 6).
- **The list's own definition** (X-ray only). A finding whose list definition was written from sources read in full text keeps that definition as its defining description.
- **None.** Otherwise the value or the finding gets no line and the assistant cannot offer it.

A line never holds the value's term or the finding's name, nor a diagnosis word (a word that names a disease, an injury or a cause, from the method's internal word list `assistant/lexicon/<method>-diagnosis-words-en.json`, which is never shown). Code cuts a line before the first clause that holds such a word, and drops it when fewer than four words remain.

The counts go to `docs/observable-descriptors.json`, per method, with the values and findings still without a line. At commit `0f2188e` only X-ray has been processed:

- Descriptor value slots (a value counted once for each finding that uses it): 2,122. Of these 855 are plain words, 39 have a line from an open textbook passage, 36 a line from the body of a cited article, and 1,192 have none (before the place-name rule: 652 plain, 1,394 none).
- Distinct values: 1,120, of which 493 have a line and 627 do not (774 before the place-name rule). The descriptors with the most values left without a line are type, extent, pattern and shape; graded scales (for example the grades of a vertebral height loss) are among them too.
- Findings: 205, of which 163 have a defining description (145 from the list's own full-text definition, 17 kept from an earlier step, 1 from an open textbook passage) and 42 have none.

The first run, at commit `574b961`, had given 375 values and 167 findings a line; the lines that copied their source were removed by the new rule and will be written again in own words on the next run. Ultrasound, CT and MRI have no lines yet; their lists come next (task T1 of the project plan `PLAN.md`, for the "corpus lane", the Claude session that builds the lists and their training texts).

## How it does it
Steps, each of which can be stopped and resumed. Work files are kept in `data/analysis/observable/<method>/`, which git (the version-control system of the repository) does not track.

1. **fetch**: the bodies of the cited articles from PubMed Central (the free full-text archive of the US National Library of Medicine) into the full-text cache of [[radiology-fulltext-resolver]].
2. **candidates**, by code: per value or finding, up to seven sentences that hold its wording, first from the bodies of the articles it cites, then from the current open textbooks (only chapters that speak of the method).
3. **describe**: a first model (Sonnet, a model of the Claude family) writes the line from one sentence and names the words of the sentence it rests on. Code then checks that those words stand word for word in the sentence, that the line copies no run of six words of it, and that the line does not hold the term.
4. **verify**: a second model (Haiku, a smaller model of the same family) says whether the quote states the line and whether the line is something seen on the image.
5. **write**: the list files get the fields (never a quote, never a line from a no-derivatives source); the counts file is written.

The passages are treated as untrusted text: the prompts say so and the models have no tools.

The program is run by hand, one imaging method at a time. Commands: `python3 -I analysis/observable.py fetch xray`, then `candidates`, `describe xray [--workers 2]`, `verify xray`, `write xray`.

How the assistant uses the result: `assistant/dialog.py` offers a value only when its line has a text and either a source or the level "plain words"; a line from an abstract only does not count. A value written as a brightness term (for example "hyperechoic" in ultrasound or "T2 hyperintense" in MRI) can also be offered in its relative form, "brighter", "equal" or "darker" than the neighbouring tissue, without a line ([[radiology-finding-engine]]).

**Tests.** `tests/test_observable.py` holds 7 tests for AN-159, AN-160 and AN-181, on invented lists and passages. On 2026-11-16 they passed in the working copy at commit `f35556a`, and they passed again at commits `5183ef3` and `0f2188e` (with the full quality gate).

### Known limits
- **Other list text may still be copied.** The own-words check above covers the lines this program writes. Plan task T26 of the corpus lane is to find any committed list text (defining descriptions, lines, measurements) copied word for word from any source, Radiopaedia included, and rewrite it; it is not done. This includes the list definitions that X-ray findings keep as their defining description.
- Only X-ray has lines. Of its distinct values, more than half still have none, so many X-ray questions can offer only plain words or relative forms.
- "Stated by the passage" is the reading of one model, checked by a second. The word-for-word check proves only that the quote is in the passage. No radiologist has read the lines.
- Not verified for this page: the program was not run. The counts are those of the committed file.

## Functions
- `plain(value, descriptor, banned)`: whether a value is no term (plain words of place, side, presence, number or size, a number to give, or the site name of a place descriptor).
- `place(value, descriptor, banned)`: whether a value of a place descriptor names a site and no disease.
- `items(method)`: what needs a line: each term value of a descriptor and each finding without a defining description.
- `definition_fits(finding)`: whether the list's own definition can stand as the defining description.
- `fetch(method)`: download the cited article bodies not yet cached.
- `candidates(method)`: the sentences offered to the first model.
- `describe(method)` and `verify(method)`: the two model steps.
- `checked(...)`: the code checks on a model answer, or the reason it is dropped.
- `accepted(method)`: the lines that passed both the code check and the second reading.
- `copies(line, source)`: whether a line repeats six or more words in a row of its source.
- `clean(text, banned)`: cut a line before a diagnosis word or the finding's own name.
- `write(method)`: the fields in the list files and the counts file.

## Where it sits in the pipeline
After the lists hold findings only ([[radiology-finding-inventory]]) and before the questions of the assistant ([[radiology-finding-engine]]). It reads the article cache of [[radiology-fulltext-resolver]] and the open textbooks fetched by [[radiology-textbook-foundation]]. It is listed among the analysis tools on [[radiology-analysis]].

## Who receives its output
The finding lists, and through them the engine and the website ([[radiology-website]]): an answer button shows the line, and the term is revealed only after the user's choice. The session that builds the lists (the "corpus lane") reads the counts file to see what is still missing.
