---
id: radiology-one-time-test
title: One-time test of the X-ray test half (analysis/one_time_test.py), run once on 2026-11-19
aliases: [one-time test, analysis/relabel.py, relabel.py, blind relabel, held-out relabel, scope hold, analysis/one_time_test.py, one-time-test.json, parent rule, parent_rule, X-ray one-time test]
kind: process
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/one_time_test.py
fed_by: [radiology-finding-engine, radiology-real-report-factcheck]
feeds: [radiology-report-matcher]
sources: [radiology-crawler:analysis/one_time_test.py, radiology-crawler:tests/test_one_time_test.py, radiology-crawler:docs/one-time-test.json, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:PLAN.md, radiology-crawler:docs/plan.json, radiology-crawler:analysis/relabel.py, radiology-crawler:tests/test_relabel.py, radiology-crawler:docs/SCOPE.md, radiology-crawler:docs/finding-list-restructure.json, radiology-crawler:docs/held-out-relabel.json, radiology-crawler:docs/results-registry.json, radiology-crawler:DESIGN.md]
reviewed: 2026-11-25T17:37Z
memory: []
---

## What it is
The command that measured, a single time, how well the finding assistant works on X-ray descriptions it had never been tuned on. It was run once, on 2026-11-19. The finding assistant ([[radiology-report-matcher]]) is a program that turns a loose description of something seen on an image into exact radiological terms; a "finding" is one named observation on an image, for example a pleural effusion.

The project split its teaching cases in two halves. The "tuning half" may train and tune the assistant, and every number published so far was measured on it ([[radiology-finding-engine]]). The other half, the "test half", is frozen and kept out of tuning: its files were written once, and maintenance commands may read them only to check their fingerprints and labels, without scoring a description. A number measured on the test half is honest only if nothing is changed afterwards because of it, so the test half can be scored exactly once. This page describes the program that did that scoring, the guards that keep it from happening by accident or twice, and the numbers of the one run.

**State since 2026-11-19: spent.** The record file `docs/one-time-test.json` says `"state": "spent"`, with the run started at 2026-11-19T02:49:29Z and scored at 2026-11-19T02:52:13Z on the commit `cccd813` of the repository `~/dev/radiology-crawler`. The result is in the section "The run of 2026-11-19" below and in entries H17 and H18 of the results registry. The test half cannot be scored again, and nothing may be tuned on these numbers. `python3 -I analysis/one_time_test.py status` (it reads and scores nothing) was run for this page: it prints "spent", the same `scored` time, no hold (`scope_hold` empty) and says that all seven frozen files are present and unchanged.

How it got there. Giovanni gave the go on 2026-11-18 (the decision log of `DESIGN.md`: the test runs in a separate judge-lane session, with the strict parent rule, on the committed state of registry entry H15). Before the run: the 4 X-ray test-half labels that pointed to the split post-operative entry were relabelled blind by two models (commit `61a0b70`; the record was prepared again on the current list, 2026-11-19T02:29:54Z); the rehearsal was repaired so that tuning-half texts whose label is no longer a finding of the list are left out and counted, as the tuning bench does (requirement AN-213, commit `cccd813`); a full rehearsal on the tuning half was reported as passed by the session that ran it (the repository keeps no record of it, and a rehearsal number is in-sample and not a result); then the test was run once. Giovanni chose the strict parent rule on 2026-11-15. Earlier, from 2026-11-15, the program had enforced a hold: it refused to score while a label of the test half pointed to a list entry that was a diagnosis and not a finding (see "The hold after the change of scope" below).

## Flow
trigger t1: The X-ray tuning half reached its targets and Giovanni gave the go on 2026-11-18 | [[radiology-finding-engine]]
step s1: prepare records the checksum of every frozen file, without scoring anything
step s2: rehearse runs the same code on the tuning half with scratch records
step s3: run checks every guard: not spent, files unchanged, code committed, no label waiting for a relabel
decide d1: Does any guard refuse?
product p1: The run stops with the reason; nothing is scored
step s4: The half is marked "started", then scored on four sets and on the first real reports | [[radiology-real-report-factcheck]]
product p2: Two entries in the results registry (H17, H18) and the state "spent" | [[radiology-report-matcher]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -yes-> p1
d1 -no-> s4
s4 -> p2

## What it does
The program scores the frozen X-ray test half on four sets, and then the fact-checked real reports of the first batch ("batch 1", [[radiology-real-report-factcheck]]). The model it scores is the "production fit": the engine with its learned matcher trained on the whole tuning corpus. The four sets:

- **Proper descriptions.** The wording two annotators quoted for each structure of the test half (a "structure" is one thing described). A hit means the right finding is among the three the assistant proposes.
- **Hurried descriptions.** A rewrite of each structure the way a rushed non-expert would type it, run through the assistant's questions. A program, not a person, answers the questions (the "simulated user"), and 15 % of its answers are made wrong or vague. Three numbers are reported: before any question, after the questions without the one in which the user picks the finding from a list of names, and after all questions. Giovanni asked for the three numbers on 2026-11-14, because picking from a list is the user recognising the finding, not the program.
- **Insufficient descriptions.** Each description with its deciding detail deleted, next to its complete twin: how often the assistant says "not enough" for the cut text and "enough" for the twin, and the hit rate after the questions.
- **Verdict.** How often the right finding is among the three when the assistant said the description was "sufficient".

The record file also holds the counts of the frozen sets before the relabel: read on the finding list of commit `3d2b214`, the test half had 1,206 proper structures, 1,141 kept hurried rewrites and 299 kept insufficient descriptions (the run scored 1,064, 1,009 and 257 of them, see above). The record file (the section `labels_on_current_list`, written by `prepare` on 2026-11-19, re-read on 2026-11-25) counts, from finding identifiers only, how many of these labels the list read at that commit reads differently: 173 of the 1,206 proper, 164 of the 1,141 hurried and 43 of the 299 insufficient labels name an old identifier that is now an alias (`merged_into_another`: an earlier name that points to another entry, which includes the retired diagnosis-like names), and 29, 28 and 10 name a finding that is neither in the list nor an alias (`not_in_list`). An earlier version of this page gave much smaller numbers (21, 20 and 3) and said no label lost its finding; that does not match the record. How the run handled the labels counted as `not_in_list` is not verified here (the code of `relabel.py` and the guard that stops a run on such labels are described below). These counts are not scores, and no frozen file was opened to write this page.

**The run of 2026-11-19.** Every number below is from the test half (cases the assistant never saw and never trained on) unless it says "real reports"; "simulated user" means a program answers the questions and 15 % of its answers are wrong or vague. "Right among three" means the labelled finding itself is one of the three proposed (a generic parent or a child of it counts as a miss, the strict rule). The target is 90 %. Source: `docs/one-time-test.json` and registry entries H17 and H18.

| Set (test half) | Structures | Right among three | 95 % interval | Note |
|---|---|---|---|---|
| Proper descriptions | 1,064 | 93.1 % | 91.4 % to 94.6 % | target met; the first of the three is right in 80.0 % |
| Hurried descriptions (simulated user), before any question | 1,009 | 88.1 % | not computed | |
| Hurried, after the questions without the pick from a list | 1,009 | 93.1 % | not computed | 2.3 questions on average; target met |
| Hurried, after all questions | 1,009 | 94.2 % | 92.8 % to 95.8 % | 2.3 questions on average; first of three right in 83.8 % |

- **Proper descriptions that were set aside.** Of the 1,206 proper test labels, 142 were set aside by the blind relabel (110 labels were only a diagnosis, 3 named a sign the list lacks, 29 had annotators who disagreed), which leaves 1,064 scored. Of these 1,064, 14 labels were read as the finding they had been merged into.
- **Insufficient descriptions (257 pairs).** For the text with its deciding detail deleted the assistant said "not enough" in 75.5 % of the pairs; for the complete twin it said "enough" in 65.4 %. The right finding was among the three in 49.0 % of these texts before any question, 64.6 % after the questions without the pick and 69.3 % after all questions (simulated user).
- **Verdict.** When the assistant called a description sufficient, the right finding was among the three in 98.6 % of the proper descriptions (646 of them) and in 98.0 % of the hurried ones before any question (394). When it did not call them sufficient, 84.7 % of the proper (418) and 81.8 % of the hurried (615) were still right among three.
- **Real reports, batch 1** (registry H18): 39 fact-checked structures from 25 published reports, 97.4 % right among three as written (95 % interval 90.9 % to 100.0 %); the first of the three was right in 87.2 %. The assistant called 29 of the 39 sufficient and all 29 were right. With a simulated user answering from the words of the report, the share is 100.0 % after the questions without the pick and 97.4 % after all questions. This batch is a development batch: its gaps were used to correct the finding list after reading it, so the number is optimistic, and 39 structures is a small set with a wide interval. It is not the final test; that is batch 2 ([[radiology-final-test-batch]]), which has no go.
- **Beside the tuning half** (registry H15, simulated user, different texts, five-fold cross-check, not a test): proper 93.5 %, hurried 86.5 % before any question, 91.7 % after the questions without the pick, 93.8 % after all questions. The test half is within about one point of the tuning half on every line, in both directions.

**The parent rule** (requirement AN-110; a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check). Some findings in the list have a "generic parent": a less specific name of the same thing, such as "Fracture" above "Transverse fracture". The question is whether proposing the parent counts as right. It is one recorded parameter with two values:

- `strict`: only the labelled finding itself counts. Every tuning number was measured this way.
- `parent_counts`: the labelled finding or its generic parent counts.

The record says `strict`, Giovanni chose that rule, and the run used it. Both values are tested code. The rule can be set only while the state is "ready" (`python3 -I analysis/one_time_test.py rule --parent-rule strict`), it is written into the result, and an unknown value stops the run before the test half is opened.

**Gate before the run** (history). On 2026-11-16 (commit `5183ef3`) the plan marked this milestone blocked: the engine stood at 89.96 % for hurried descriptions without the pick question on the tuning half, and the program's hold said that 4 held-out labels pointed to a removed or diagnosis-class entry. Both were cleared on 2026-11-18: the engine reached 91.7 % (registry H15, [[radiology-finding-engine]]) and the 4 labels were relabelled blind (commit `61a0b70`). `status` now prints no hold.

**The hold after the change of scope** (requirements AN-161 to AN-165; `analysis/relabel.py`, commits `976c81a` and `ad929e1` of 2026-11-15). On 2026-11-15 Giovanni decided that the finding lists hold only what is seen on the image. A diagnosis-like entry such as "fracture" is to be replaced by its visible signs (a lucent line, a cortical step), and the old name is kept as an alias, a second name that points to the new entry. The labels of the held-out sets were made on the old lists, so some of them point to entries that will go. The old name must not turn into a sign by itself: a text that only says "fracture of the radius" describes no sign. The tool `relabel.py` handles this, for four held-out sets: the test half, batch 1 of the real reports, the open development batch and the sealed batch 2 ([[radiology-final-test-batch]]).

- A label is **pending** when its entry is classed as diagnosis-like in `docs/finding-list-restructure.json` (the classification described on [[radiology-finding-inventory]]), or classed as borderline and no longer in the list. An entry that the corrected list has retired counts as diagnosis-like, and an alias never rescues its label.
- Each pending label is annotated again by two annotators (language models of two different makers, named `sonnet` and `codex` in the command). They work **blind**: they see only the wording of the text and the new findings-only list, never the old label. Each gives one verdict: the text describes a sign that the list names (with the entry), the text names only a diagnosis, or the text describes a sign the list lacks.
- A label is read as a sign only when both annotators name the same entry. A label both call "diagnosis only", a sign missing from the list, and every disagreement are **set aside**: left out of the scoring. The agreement between the two is reported.
- The annotation refuses to start while the list of that method still holds a diagnosis-like entry, so it cannot run before the lists are corrected. Since commits `4c7ebed` and `ed564e1` of 2026-11-16 the ultrasound, CT and MRI lists hold no diagnosis-like entry, so this guard no longer blocks them; their relabel is described below under plan task T8.
- The texts, the annotations and the resulting map stay in a sealed folder outside git. The committed record is to hold counts only (pending, agreement, relabelled, set aside by cause) and the checksum of the map.
- **The hold.** While a label of a set is pending without an agreed relabel, or the map is not the one whose counts were recorded, or the classification does not cover the method, the scoring of that set refuses before any description is scored. `python3 -I analysis/one_time_test.py status` shows the checksum comparison of the frozen files and the hold; for that it reads the frozen files and the held-out labels, and it scores and writes nothing (wording corrected on 2026-11-18 after reading `status` in the program: it computes the checksum of every frozen file).

Commands: `python3 -I analysis/relabel.py count` (labels per set and method by class of their entry; counts only, no finding name, text or item), `hold --set test --method xray` (why a scoring must wait), `annotate --set SET --method METHOD --engine sonnet` and then `--engine codex`, and `join --set SET --method METHOD`.

State at commit `af3afc6` of 2026-11-16: the procedure and the hold are committed and tested (`tests/test_relabel.py`, six tests on invented examples). The corrected X-ray list was committed in that commit (41 diagnosis-like entries retired, see [[radiology-finding-inventory]]), so the X-ray annotation may now start. It had not run at that commit.

**The X-ray relabel is done** (commits `bb76b36`, `d9a3760` and `ee7d438` of 2026-11-16; record `docs/held-out-relabel.json`, which holds counts and checksums only: no finding name, no text, no label). Two models read each pending wording again, blind, with the corrected list. The pair in force is Sonnet and Opus; a first pair, Sonnet and Haiku, agreed less often, and its counts are kept beside in the record (`earlier_pairs`). `join --engines A B` names the two annotators and refuses two that are the same model. Counts for X-ray, pair in force (test half as of commit `61a0b70` of 2026-11-18, which added the 4 labels of the split post-operative entry; the earlier counts of 2026-11-16 were 184, 155, 45, 108, 2 and 29):

| Set | Pending labels | Both agree | Relabelled as a sign | Set aside: only a diagnosis | Set aside: sign not in the list | Set aside: annotators disagree |
|---|---|---|---|---|---|---|
| Test half | 188 | 159 (85 %) | 46 | 110 | 3 | 29 |
| Batch 1 of real reports | 8 | 8 (100 %) | 2 | 6 | 0 | 0 |
| Batch 2 of real reports | 15 | 12 (80 %) | 1 | 11 | 0 | 3 |

With the first pair the agreement was 77 %, 38 % and 27 %. These are counts of labels, not scores. The test half was scored later, on 2026-11-19, with the labels read this way. A set-aside label is left out of the scoring; a relabelled one is read as its agreed sign. Ultrasound, CT and MRI have no relabel yet; plan task T8 relabelled the held-out labels of the development batch and batch 2 of these methods on 2026-11-19; the test halves of ultrasound, CT and MRI are not built yet, so their relabel is open.

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

**Result.** The real run of 2026-11-19 wrote two entries to the results registry (`docs/results-registry.json`, the project's list of scored tests): H17 for the test half and H18 for batch 1, each with the commit, the date, the parent rule and how the labels were read. Detailed outcomes go to the folder `data/`, which is not in git and was not opened for this page.

Requirements AN-98 to AN-100, AN-110 and AN-161 to AN-165 describe this. `tests/test_one_time_test.py` holds tests on small invented examples; none opens a frozen file. Requirement AN-213 (the rehearsal leaves out and counts tuning-half texts whose label is not a finding of the current list) was added on 2026-11-18. At commit `af3afc6` one of them failed, because it expected the old identifier of a rib fracture to resolve to an entry that the corrected list had retired. Commit `cc58042` of 2026-11-16 adapted it: the engine may read a retired diagnosis identifier as the sign that replaced it, but a held-out label on such an identifier is never read through that alias. It stays pending until two annotators agree on the sign (`relabel.py`). On 2026-11-16, in the working copy at commit `3c3cdb8`, `tests/test_one_time_test.py` and `tests/test_relabel.py` passed (15 tests, all on invented examples).

## Steps
1. The judge session (a Claude session that works only on held-out data and never changes the assistant in the same session) runs `prepare`. Output: the checksums and label counts in `docs/one-time-test.json`, state "ready". Done on 2026-11-14, and again on 2026-11-19T02:29:54Z on the current list.
2. The judge runs `rehearse`. Output: scratch records that show the command completes and refuses a second run. Done on 2026-11-14.
3. Giovanni decides the parent rule. Done on 2026-11-15: `strict`, which is what the record already said.
4. The session that builds the finding lists (the "corpus lane") corrects the X-ray list to findings only. Done on 2026-11-16 (commit `af3afc6`). The engine was then retuned on the tuning half and reached 91.7 % for hurried descriptions without the pick question (tuning half, simulated user, registry H15). Done on 2026-11-18.
5. The judge relabels the pending labels of the test half and batch 1 with `relabel.py annotate` (twice) and `join`, and commits the counts. Done for X-ray on 2026-11-16 (pair in force: Sonnet and Opus). The 4 labels of the split post-operative entry were relabelled on 2026-11-18 (commit `61a0b70`).
6. Giovanni gave the go on 2026-11-18. The judge runs `run --confirm "score the xray test half once"`. Output: the scores printed once, two registry entries (H17, H18), state "spent". Done on 2026-11-19 (commit `cccd813`).
7. The judge commits the registry and the record (commit `f4bfc97`) and sets the plan milestone "X-ray: the one-time test" to done with the plan tool (commit `e82c86c`). Done.

## Where it sits in the pipeline
After the engine reached its X-ray targets on the tuning half ([[radiology-finding-engine]]) and after the fact-check of batch 1 ([[radiology-real-report-factcheck]]). It is separate from the final test on fresh real reports, which has its own batch and its own single-run command ([[radiology-final-test-batch]]). The program takes an imaging method (`--method`), but only the X-ray test half has been prepared and run; the other three methods wait for their own milestone.

## Who receives its output
Giovanni and any reader of the plan on [[radiology-report-matcher]], through the results registry. Nothing measured here may flow back into the engine: the test half is spent and nothing is tuned on it.

## Notes
The frozen test-half files and everything under `data/` were not opened for this page. Everything here comes from the programs, their tests, the committed record, the requirement rows and the plan. The relabel tool was not run for this page, because even its `count` command reads held-out files. `python3 -I analysis/one_time_test.py status` was run on 2026-11-16; it prints the record and the hold and scores nothing.

Update 2026-11-19 (milestone closed; commits `61a0b70` to `4caf417`). The plan milestone "X-ray: the one-time test" is done. Checked for this page: `docs/one-time-test.json`, registry entries H15, H17 and H18, `docs/held-out-relabel.json`, the decision log of `DESIGN.md`, requirement AN-213, the program's docstring and the output of `status`. Not verified: the rehearsal before the run (no record in the repository). The files under `data/analysis/one-time-test/` and `data/analysis/real-reports/` were not opened, and no single finding of the test half is named here.

Update 2026-11-25 (compared with the repository now): the program `analysis/one_time_test.py`, `analysis/relabel.py` and their tests have not changed since this page was last reviewed, and `python3 -I analysis/one_time_test.py status` (read-only) still prints state "spent", `scored` 2026-11-19T02:52:13Z, parent rule `strict`, an empty hold (`scope_hold` null) and all seven frozen files present and unchanged. Milestone M4 of the plan ("X-ray: the one-time test") is still marked done. The scope line of the plan (line 9) repeats that the X-ray test half is spent and nothing is tuned on it. Since then the engine kept changing on the tuning half only (registry entries H19 to H64, up to 2026-11-24); none of those runs opened the test half. Ultrasound, CT and MRI: their test halves are still unscored; scoring them once is plan task T78, which waits until each finding is at 90 % on the tuning half (milestone M5, "Ultrasound, CT and MRI at target"). Giovanni put the whole project on hold on 2026-11-25 (see [[radiology-report-matcher]]): no further scoring happens until he restarts it, and nothing is deleted.
