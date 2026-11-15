---
id: radiology-one-time-test
title: One-time test of the X-ray test half (analysis/one_time_test.py)
aliases: [one-time test, analysis/one_time_test.py, one-time-test.json, parent rule, parent_rule, X-ray one-time test]
kind: process
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/one_time_test.py
fed_by: [radiology-finding-engine, radiology-real-report-factcheck]
feeds: [radiology-report-matcher]
sources: [radiology-crawler:analysis/one_time_test.py, radiology-crawler:tests/test_one_time_test.py, radiology-crawler:docs/one-time-test.json, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:PLAN.md, radiology-crawler:docs/plan.json]
reviewed: 2026-11-15T17:57Z
memory: []
---

## What it is
The command that will measure, a single time, how well the finding assistant works on X-ray descriptions it has never been tuned on. The finding assistant ([[radiology-report-matcher]]) is a program that turns a loose description of something seen on an image into exact radiological terms; a "finding" is one named observation on an image, for example a pleural effusion.

The project split its teaching cases in two halves. The "tuning half" may train and tune the assistant, and every number published so far was measured on it ([[radiology-finding-engine]]). The other half, the "test half", is frozen: its files were written once and are not opened. A number measured on the test half is honest only if nothing is changed afterwards because of it, so the test half can be scored exactly once. This page describes the program that does that scoring and the guards that keep it from happening by accident or twice.

State on 2026-11-15 (commit `ee38d77` of the repository `~/dev/radiology-crawler`): the command is **ready and has not been run**. The record file `docs/one-time-test.json` says `"state": "ready"`. No description of the test half has been scored, so there is no test result of any kind. The run waits for Giovanni's go, and for his decision on one open parameter, the "parent rule" described below.

## Flow
trigger t1: The X-ray tuning half reached its targets, so the single scoring of the test half is next | [[radiology-finding-engine]]
step s1: prepare records the checksum of every frozen file, without scoring anything
step s2: rehearse runs the same code on the tuning half with scratch records
decide d1: Has Giovanni chosen the parent rule and typed the confirmation sentence?
product p0: Nothing runs; the state stays "ready"
step s3: run checks every guard: not spent, files unchanged, code committed
decide d2: Does any guard refuse?
product p1: The run stops with the reason; nothing is scored
step s4: The half is marked "started", then scored on four sets and on the first real reports | [[radiology-real-report-factcheck]]
product p2: Two entries in the results registry and the state "spent" | [[radiology-report-matcher]]

t1 -> s1
s1 -> s2
s2 -> d1
d1 -no-> p0
d1 -yes-> s3
s3 -> d2
d2 -yes-> p1
d2 -no-> s4
s4 -> p2

## What it does
When it is run, the program scores the frozen X-ray test half on four sets, and then the fact-checked real reports of the first batch ("batch 1", [[radiology-real-report-factcheck]]). The model it scores is the "production fit": the engine with its learned matcher trained on the whole tuning corpus. The four sets:

- **Proper descriptions.** The wording two annotators quoted for each structure of the test half (a "structure" is one thing described). A hit means the right finding is among the three the assistant proposes.
- **Hurried descriptions.** A rewrite of each structure the way a rushed non-expert would type it, run through the assistant's questions. A program, not a person, answers the questions (the "simulated user"), and 15 % of its answers are made wrong or vague. Three numbers are reported: before any question, after the questions without the one in which the user picks the finding from a list of names, and after all questions. Giovanni asked for the three numbers on 2026-11-14, because picking from a list is the user recognising the finding, not the program.
- **Insufficient descriptions.** Each description with its deciding detail deleted, next to its complete twin: how often the assistant says "not enough" for the cut text and "enough" for the twin, and the hit rate after the questions.
- **Verdict.** How often the right finding is among the three when the assistant said the description was "sufficient".

The record file holds counts of the frozen sets, not results: read on the finding list of commit `87d9fc5`, the test half has 1,206 proper structures, 1,141 kept hurried rewrites and 299 kept insufficient descriptions. Of these, 21, 20 and 3 carry a label on a finding that was later merged into another; they are read as the surviving finding, and no label lost its finding. These numbers say how large the test will be. They are not scores, and no frozen file was opened to write this page.

**The parent rule** (requirement AN-110; a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check). Some findings in the list have a "generic parent": a less specific name of the same thing, such as "Fracture" above "Transverse fracture". The question is whether proposing the parent counts as right. It is one recorded parameter with two values:

- `strict`: only the labelled finding itself counts. Every tuning number was measured this way.
- `parent_counts`: the labelled finding or its generic parent counts.

The record currently says `strict`. That is the default, not Giovanni's decision: the plan note of 2026-11-15 says "Giovanni decides the rule and gives the go". Both values are tested code. The rule can be set only while the state is "ready" (`python3 -I analysis/one_time_test.py rule --parent-rule strict`), it is written into the result, and an unknown value stops the run before the test half is opened.

## How it does it
The program is `analysis/one_time_test.py`, run as `python3 -I analysis/one_time_test.py COMMAND`. Its commands are `status`, `prepare`, `rule`, `rehearse` and `run`.

**Guards of `run`** (requirement AN-99). The run refuses unless all of these hold:

- the confirmation sentence is typed exactly: `--confirm "score the xray test half once"`;
- the test half is not "spent" (already scored);
- every frozen file still has the checksum recorded by `prepare` (a checksum is a fingerprint that changes when the file changes); seven files are recorded;
- the fact-checked set of batch 1 has the checksum stated in its manifest;
- the record `docs/one-time-test.json` itself has no uncommitted change, so the parent rule that is used is the one in git (the version-control system that holds the code);
- the engine, the finding list, the scoring programs and the training-corpus record have no uncommitted change, so the commit named in the result is exactly what was scored.

**Order of marking.** The program marks the half "started" before it scores the first description, and "spent" together with the results. Numbers are printed only at the end. If the program crashes before any result file exists, `--after-crash` allows one repeat; once a result file exists, no repeat is possible. A spent half is never scored again.

**Labels on a changed list** (requirement AN-100). The test half was labelled on an earlier version of the finding list (commit `fe137a2`, 228 findings). The record notes that by commit `3575a75` nine findings had been added and four merged into others; later merges are handled the same way. A label on a merged finding is read as the surviving one, two labels that become the same structure count once, and a label whose finding left the list with no successor stops the run.

**Rehearsal.** `rehearse` runs the same code on the tuning half, with scratch copies of the record and the results registry under `~/.cache/radiology-tmp/`, never the real registry and never the test half. Its purpose is to prove the command works end to end before the one real run. The commit that introduced the program (`7bbdaaa`, 2026-11-14) records one rehearsal: 1,453 proper and 1,379 hurried structures of the tuning half, a second run refused, the real registry untouched. Rehearsal numbers are "in-sample" (the model trained on those very rows), so they are not results and are not quoted here.

**Result.** A real run writes two entries to the results registry (`docs/results-registry.json`, the project's list of scored tests): one for the test half and one for batch 1, each with the commit, the date, the parent rule and how the labels were read. Detailed outcomes go to the folder `data/`, which is not in git.

Requirements AN-98 to AN-100 and AN-110 describe this. `tests/test_one_time_test.py` holds nine tests on small invented examples; none opens a frozen file.

## Steps
1. The judge session (a Claude session that works only on held-out data and never changes the assistant in the same session) runs `prepare`. Output: the checksums and label counts in `docs/one-time-test.json`, state "ready". Done on 2026-11-14.
2. The judge runs `rehearse`. Output: scratch records that show the command completes and refuses a second run. Done on 2026-11-14.
3. Giovanni decides the parent rule. If it is not `strict`, the judge runs `rule --parent-rule parent_counts` and commits the record. Not done: the decision is open.
4. Giovanni gives the go. The judge runs `run --confirm "score the xray test half once"`. Output: the scores printed once, two registry entries, state "spent". Not done.
5. The judge commits the registry and the record and sets the plan milestone "X-ray: the one-time test" to done with the plan tool. Not done.

## Where it sits in the pipeline
After the engine reached its X-ray targets on the tuning half ([[radiology-finding-engine]]) and after the fact-check of batch 1 ([[radiology-real-report-factcheck]]). It is separate from the final test on fresh real reports, which has its own batch and its own single-run command ([[radiology-final-test-batch]]). The program takes an imaging method (`--method`), but only the X-ray test half has been prepared.

## Who receives its output
Giovanni and any reader of the plan on [[radiology-report-matcher]], through the results registry. Nothing measured here may flow back into the engine: after the run nothing is tuned on the test half.

## Notes
The frozen test-half files and everything under `data/` were not opened for this page. Everything here comes from the program, its tests, the committed record, the requirement rows and the plan.
