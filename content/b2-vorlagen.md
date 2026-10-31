---
id: b2-vorlagen
title: B2 writing templates site
aliases: [b2-vorlagen, Goethe B2 Schreiben site]
kind: project
project: none
status: active
location: home:dev/b2-vorlagen
fed_by: []
feeds: []
sources: [home:dev/b2-vorlagen/build/site.py, home:dev/b2-vorlagen/build/templates.py, home:dev/b2-vorlagen/data/new_forum.py, home:dev/b2-vorlagen/data/new_mail.py]
reviewed: 2026-10-31T22:20Z
---

## What it is
A single web page, "Goethe B2 Schreiben: texts that score 10", for Giovanni's practice of the writing part (Schreiben) of the Goethe-Zertifikat B2, a German language exam. It is built from the folder `~/dev/b2-vorlagen`. A "Vorlage" is a template: a text whose sentences are fixed and whose gaps (called slots) Giovanni fills in.

## Flow
trigger t1: Giovanni runs build/site.py
step s1: The task texts and slot values are read from the files in data/
step s2: Each task is filled into the Forumsbeitrag or the E-Mail template
step s3: The page index.html is written and copied to public/
product p1: Page with the 20 corrected texts and the 40 new practice topics

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> p1

## Architecture
### Context
person g: Giovanni — practises the Schreiben tasks | [[giovanni]]
system s: b2-vorlagen — builds one practice page

g -reads the page from-> s

### Containers
person g: Giovanni | [[giovanni]]
container bs: build/site.py — writes the page
container tp: build/templates.py — the two templates
store dt: data/ — tasks, slot values and corrections
store ev: eval/ — blind scores
store pg: index.html and public/index.html — the page

bs -reads-> tp
bs -reads-> dt
bs -reads-> ev
bs -writes-> pg
g -reads-> pg

## What it does
The page has four parts: the two templates (Forumsbeitrag, a forum post, and formelle E-Mail, a formal e-mail) with a guide to each slot; a table of scores; the 20 tasks Giovanni has already written, each with the task, his text, a correction line by line and a template version; and, since 2026-10-31, 20 new Forumsbeitrag topics and 20 new E-Mail topics (section 4). The new topics have the task and a model text built from the template, but no text of Giovanni's, so they have no correction and no score.

The scores are "blind scores": a separate model session saw only the criteria, the task and the text. The build prints the means: 4.45 for Giovanni's originals and 9.31 for the template versions. They are one model's judgement, not an official Goethe mark. The new topics were not scored.

## How it does it
`python3 build/site.py` reads `data/` and `eval/` and writes `index.html`; `public/index.html` is a copy. `build/templates.py` holds each template as sentences marked core (always used) or extra (added only when the task asks for more); a sentence is dropped when one of its slots has no value. For example `Ehrlich gesagt bin ich der Ansicht, dass {MEINUNG_N}.` becomes a sentence once `MEINUNG_N` is given. The slot name tells the grammar: `_N` is a clause with the verb last, `_H` a main clause with the verb second, `_Z` a `zu` plus infinitive.

The new topics are in `data/new_forum.py` and `data/new_mail.py`. Each task copies the shape of an exam task: four points to cover, a minimum number of words, greeting and closing. The page links are teal (CSS variable `--lk`, contrast about 7:1 on the light theme and 10:1 on the dark one).

## Where it sits in the pipeline
Off to the side. It supports the German practice described in [[skill-alemao-goethe-fsp]]. Nothing else reads its output.

## Who receives its output
Giovanni, who reads the page in a browser.

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
Not yet followed: the folder has no git repository, no quality gate and no tests (verified 2026-10-31).

### Decisions
No decision records.

### Requirements
No requirements list.

### Quality gate
None yet.

### Continuous integration
None yet.

### Maintenance
Not covered by the [[monthly-architecture-review]]. It has no repository yet.

## Notes
The model texts of the new topics were written in one session and checked only for completeness (every slot filled) and length (at least 125 words for an E-Mail and 224 for a Forumsbeitrag, with the extra sentences). A native speaker has not reviewed the German.
