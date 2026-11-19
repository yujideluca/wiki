---
id: radiology-one-time-test
title: One-time test of the X-ray test half (analysis/one_time_test.py)
aliases: [one-time test, analysis/relabel.py, relabel.py, blind relabel, held-out relabel, scope hold, analysis/one_time_test.py, one-time-test.json, parent rule, parent_rule, X-ray one-time test]
kind: process
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/one_time_test.py
fed_by: [radiology-finding-engine, radiology-real-report-factcheck]
feeds: [radiology-report-matcher]
sources: [radiology-crawler:analysis/one_time_test.py, radiology-crawler:tests/test_one_time_test.py, radiology-crawler:docs/one-time-test.json, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:PLAN.md, radiology-crawler:docs/plan.json, radiology-crawler:analysis/relabel.py, radiology-crawler:tests/test_relabel.py, radiology-crawler:docs/SCOPE.md, radiology-crawler:docs/finding-list-restructure.json, radiology-crawler:docs/held-out-relabel.json]
reviewed: 2026-11-19T01:34Z
memory: []
---

## What it is
The command that will measure, a single time, how well the finding assistant works on X-ray descriptions it has never been tuned on. The finding assistant ([[radiology-report-matcher]]) is a program that turns a loose description of something seen on an image into exact radiological terms; a "finding" is one named observation on an image, for example a pleural effusion.

The project split its teaching cases in two halves. The "tuning half" may train and tune the assistant, and every number published so far was measured on it ([[radiology-finding-engine]]). The other half, the "test half", is frozen and kept out of tuning: its files were written once, and maintenance commands may read them only to check their fingerprints and labels, without scoring a description. A number measured on the test half is honest only if nothing is changed afterwards because of it, so the test half can be scored exactly once. This page describes the program that does that scoring and the guards that keep it from happening by accident or twice.

State on 2026-11-15 (commit `ee38d77` of the repository `~/dev/radiology-crawler`): the command is **ready and has not been run**. The record file `docs/one-time-test.json` says `"state": "ready"`. No description of the test half has been scored, so there is no test result of any kind. Giovanni gave the go and chose the strict parent rule. The run was then blocked until the X-ray list contained findings only and the engine was retuned; that block is lifted, see the update of 2026-11-18 at the end of this page. Since commit `976c81a` of 2026-11-15 the program enforces part of that itself: it refuses to score while a label of the test half points to a list entry that is a diagnosis and not a finding (see "The hold after the change of scope" below).

## Flow
trigger t1: The X-ray tuning half reached its targets, so the single scoring of the test half is next | [[radiology-finding-engine]]
step s1: prepare records the checksum of every frozen file, without scoring anything
step s2: rehearse runs the same code on the tuning half with scratch records
decide d1: Has the X-ray list been corrected and the engine retuned, and was the confirmation given?
product p0: Nothing runs; the state stays "ready"
step s3: run checks every guard: not spent, files unchanged, code committed, no label waiting for a relabel
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

The record says `strict`, and Giovanni chose that rule. The current plan blocks the run until the X-ray list holds visible findings only and the engine is retuned. Both values are tested code. The rule can be set only while the state is "ready" (`python3 -I analysis/one_time_test.py rule --parent-rule strict`), it is written into the result, and an unknown value stops the run before the test half is opened.

**Current gate** (commit `5183ef3` of 2026-11-16). The plan marks this milestone blocked. The stored state remains `ready` because the one-time test has not run; `ready` describes the command record, not permission to score the test half now. The program's own hold is back: after the post-operative lung entry left the X-ray list (commit `574b961`, [[radiology-finding-inventory]]), `status` prints one hold, "4 held-out label(s) point to a removed or diagnosis-class entry and are not relabelled". Relabelling the labels of the split post-operative entry blind is plan task T8 of the judge lane. Earlier that day, after the first relabel, the hold had been lifted (`"scope_hold": null`). What the plan still waits for: the engine reaches 90 % on hurried descriptions of the tuning half on the new list (it stands at 89.96 % without the pick question, a tuning-half number with a simulated user, counted without the texts whose label is a retired entry, see [[radiology-finding-engine]]), and Giovanni confirms.

**The hold after the change of scope** (requirements AN-161 to AN-165; `analysis/relabel.py`, commits `976c81a` and `ad929e1` of 2026-11-15). On 2026-11-15 Giovanni decided that the finding lists hold only what is seen on the image. A diagnosis-like entry such as "fracture" is to be replaced by its visible signs (a lucent line, a cortical step), and the old name is kept as an alias, a second name that points to the new entry. The labels of the held-out sets were made on the old lists, so some of them point to entries that will go. The old name must not turn into a sign by itself: a text that only says "fracture of the radius" describes no sign. The tool `relabel.py` handles this, for four held-out sets: the test half, batch 1 of the real reports, the open development batch and the sealed batch 2 ([[radiology-final-test-batch]]).

- A label is **pending** when its entry is classed as diagnosis-like in `docs/finding-list-restructure.json` (the classification described on [[radiology-finding-inventory]]), or classed as borderline and no longer in the list. An entry that the corrected list has retired counts as diagnosis-like, and an alias never rescues its label.
- Each pending label is annotated again by two annotators (language models of two different makers, named `sonnet` and `codex` in the command). They work **blind**: they see only the wording of the text and the new findings-only list, never the old label. Each gives one verdict: the text describes a sign that the list names (with the entry), the text names only a diagnosis, or the text describes a sign the list lacks.
- A label is read as a sign only when both annotators name the same entry. A label both call "diagnosis only", a sign missing from the list, and every disagreement are **set aside**: left out of the scoring. The agreement between the two is reported.
- The annotation refuses to start while the list of that method still holds a diagnosis-like entry, so it cannot run before the lists are corrected. Since commits `4c7ebed` and `ed564e1` of 2026-11-16 the ultrasound, CT and MRI lists hold no diagnosis-like entry, so this guard no longer blocks them; their relabel (plan task T8) has not run.
- The texts, the annotations and the resulting map stay in a sealed folder outside git. The committed record is to hold counts only (pending, agreement, relabelled, set aside by cause) and the checksum of the map.
- **The hold.** While a label of a set is pending without an agreed relabel, or the map is not the one whose counts were recorded, or the classification does not cover the method, the scoring of that set refuses before any description is scored. `python3 -I analysis/one_time_test.py status` shows the checksum comparison of the frozen files and the hold; for that it reads the frozen files and the held-out labels, and it scores and writes nothing (wording corrected on 2026-11-18 after reading `status` in the program: it computes the checksum of every frozen file).

Commands: `python3 -I analysis/relabel.py count` (labels per set and method by class of their entry; counts only, no finding name, text or item), `hold --set test --method xray` (why a scoring must wait), `annotate --set SET --method METHOD --engine sonnet` and then `--engine codex`, and `join --set SET --method METHOD`.

State at commit `af3afc6` of 2026-11-16: the procedure and the hold are committed and tested (`tests/test_relabel.py`, six tests on invented examples). The corrected X-ray list was committed in that commit (41 diagnosis-like entries retired, see [[radiology-finding-inventory]]), so the X-ray annotation may now start. It had not run at that commit.

**The X-ray relabel is done** (commits `bb76b36`, `d9a3760` and `ee7d438` of 2026-11-16; record `docs/held-out-relabel.json`, which holds counts and checksums only: no finding name, no text, no label). Two models read each pending wording again, blind, with the corrected list. The pair in force is Sonnet and Opus; a first pair, Sonnet and Haiku, agreed less often, and its counts are kept beside in the record (`earlier_pairs`). `join --engines A B` names the two annotators and refuses two that are the same model. Counts for X-ray, pair in force:

| Set | Pending labels | Both agree | Relabelled as a sign | Set aside: only a diagnosis | Set aside: sign not in the list | Set aside: annotators disagree |
|---|---|---|---|---|---|---|
| Test half | 184 | 155 (84 %) | 45 | 108 | 2 | 29 |
| Batch 1 of real reports | 8 | 8 (100 %) | 2 | 6 | 0 | 0 |
| Batch 2 of real reports | 15 | 12 (80 %) | 1 | 11 | 0 | 3 |

With the first pair the agreement was 77 %, 38 % and 27 %. These are counts of labels, not scores: nothing was scored. A set-aside label is left out of the scoring; a relabelled one is read as its agreed sign. Ultrasound, CT and MRI have no relabel yet, because their lists still hold diagnosis-like entries.

Two corrections came with it (requirements AN-162 and AN-164). The relabel and the run now read the test half "as labelled": the reader that the engine uses turns an old identifier into its successor through the alias, and that would have turned a diagnosis label into a sign without any annotator reading the wording. And when a relabel gives a structure the same sign that another label of the same structure already has, it is counted once (`same_structure_twice`).

## How it does it
The program is `analysis/one_time_test.py`, run as `python3 -I analysis/one_time_test.py COMMAND`. Its commands are `status`, `prepare`, `rule`, `rehearse` and `run`.

**Guards of `run`** (requirement AN-99). The run refuses unless all of these hold:

- the confirmation sentence is typed exactly: `--confirm "score the xray test half once"`;
- the test half is not "spent" (already scored);
- every frozen file still has the checksum recorded by `prepare` (a checksum is a fingerprint that changes when the file changes); seven files are recorded;
- the fact-checked set of batch 1 has the checksum stated in its manifest;
- the record `docs/one-time-test.json` itself has no uncommitted change, so the parent rule that is used is the one in git (the version-control system that holds the code);
- the engine, the finding list, the scoring programs and the training-corpus record have no uncommitted change, so the commit named in the result is exactly what was scored;
- no label of the test half or of batch 1 is waiting for a relabel (the hold described above, requirement AN-165). When the run does happen, each pending label is read as its agreed sign and set-aside labels are left out.

**Order of marking.** The program marks the half "started" before it scores the first description, and "spent" together with the results. Numbers are printed only at the end. If the program crashes before any result file exists, `--after-crash` allows one repeat; once a result file exists, no repeat is possible. A spent half is never scored again.

**Labels on a changed list** (requirement AN-100). The test half was labelled on an earlier version of the finding list (commit `fe137a2`, 228 findings). The record notes that by commit `3575a75` nine findings had been added and four merged into others; later merges are handled the same way. A label on a merged finding is read as the surviving one, two labels that become the same structure count once, and a label whose finding left the list with no successor stops the run.

**Rehearsal.** `rehearse` runs the same code on the tuning half, with scratch copies of the record and the results registry under `~/.cache/radiology-tmp/`, never the real registry and never the test half. Its purpose is to prove the command works end to end before the one real run. The commit that introduced the program (`7bbdaaa`, 2026-11-14) records one rehearsal: 1,453 proper and 1,379 hurried structures of the tuning half, a second run refused, the real registry untouched. Rehearsal numbers are "in-sample" (the model trained on those very rows), so they are not results and are not quoted here.

**Result.** A real run writes two entries to the results registry (`docs/results-registry.json`, the project's list of scored tests): one for the test half and one for batch 1, each with the commit, the date, the parent rule and how the labels were read. Detailed outcomes go to the folder `data/`, which is not in git.

Requirements AN-98 to AN-100, AN-110 and AN-161 to AN-165 describe this. `tests/test_one_time_test.py` holds nine tests on small invented examples; none opens a frozen file. At commit `af3afc6` one of them failed, because it expected the old identifier of a rib fracture to resolve to an entry that the corrected list had retired. Commit `cc58042` of 2026-11-16 adapted it: the engine may read a retired diagnosis identifier as the sign that replaced it, but a held-out label on such an identifier is never read through that alias. It stays pending until two annotators agree on the sign (`relabel.py`). On 2026-11-16, in the working copy at commit `3c3cdb8`, `tests/test_one_time_test.py` and `tests/test_relabel.py` passed (15 tests, all on invented examples).

## Steps
1. The judge session (a Claude session that works only on held-out data and never changes the assistant in the same session) runs `prepare`. Output: the checksums and label counts in `docs/one-time-test.json`, state "ready". Done on 2026-11-14.
2. The judge runs `rehearse`. Output: scratch records that show the command completes and refuses a second run. Done on 2026-11-14.
3. Giovanni decides the parent rule. Done on 2026-11-15: `strict`, which is what the record already said.
4. The session that builds the finding lists (the "corpus lane") corrects the X-ray list to findings only. Done on 2026-11-16 (commit `af3afc6`). The engine is then retuned on the tuning half: measured again, at 87.2 % for hurried descriptions without the pick question (tuning half, simulated user), below the 90 % target; not done.
5. The judge relabels the pending labels of the test half and batch 1 with `relabel.py annotate` (twice) and `join`, and commits the counts. Done for X-ray on 2026-11-16 (pair in force: Sonnet and Opus). Step 4 is done since 2026-11-18, see the update at the end of this page.
6. Giovanni gave the go on 2026-11-15; the plan of 2026-11-16 asks for his confirmation again once X-ray is back at 90 %. Once steps 4 and 5 are done, the judge runs `run --confirm "score the xray test half once"`. Output: the scores printed once, two registry entries, state "spent". Not done.
7. The judge commits the registry and the record and sets the plan milestone "X-ray: the one-time test" to done with the plan tool. Not done.

## Where it sits in the pipeline
After the engine reached its X-ray targets on the tuning half ([[radiology-finding-engine]]) and after the fact-check of batch 1 ([[radiology-real-report-factcheck]]). It is separate from the final test on fresh real reports, which has its own batch and its own single-run command ([[radiology-final-test-batch]]). The program takes an imaging method (`--method`), but only the X-ray test half has been prepared.

## Who receives its output
Giovanni and any reader of the plan on [[radiology-report-matcher]], through the results registry. Nothing measured here may flow back into the engine: after the run nothing is tuned on the test half.

## Notes
The frozen test-half files and everything under `data/` were not opened for this page. Everything here comes from the programs, their tests, the committed record, the requirement rows and the plan. The relabel tool was not run for this page, because even its `count` command reads held-out files. `python3 -I analysis/one_time_test.py status` was run on 2026-11-16; it prints the record and the hold and scores nothing.

Update 2026-11-18 (status; commit `799b335`, from `PLAN.md` milestone M4 and entry H15 of `docs/results-registry.json`). The plan milestone "X-ray: the one-time test" now has the status "waiting for Giovanni" (the plan's own mark `[?]`), no longer blocked. The reason: the engine reached the target on the X-ray tuning half (proper descriptions 93.5 %, hurried ones after the questions 91.7 % without the pick from a list; tuning half, simulated user, not a test; [[radiology-finding-engine]]). Step 4 above is therefore done, and step 6 waits only for Giovanni's go. Nothing of the test half was scored: no run happened, and the record still says "ready". Not verified for this page: whether the program's own hold on relabelled labels (see "Current gate") still prints a hold, because `status` was not run.
