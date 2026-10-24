---
id: skill-candidatura-alemanha
title: Skill: candidatura-alemanha (applications in Germany)
aliases: [candidatura-alemanha]
kind: skill
project: skills
status: active
location: home:.claude/skills/candidatura-alemanha
fed_by: []
feeds: []
sources: [home:.claude/skills/candidatura-alemanha/SKILL.md]
---

## What it is
The skill "candidatura-alemanha" supports Giovanni's applications for medical posts in Germany (specialist training in radiology, a Hospitation = a trial visit at a hospital, and a position as Assistenzarzt = resident doctor) and the recognition process (Approbation, the licence to practise medicine, and Anerkennung, recognition of qualifications) for a doctor trained outside the EU. It is written in Portuguese. Its description says: use it whenever he asks for a Lebenslauf (CV), Anschreiben (cover letter), Bewerbung (application), an e-mail to a hospital or chief physician, a Bestätigung über beabsichtigte Beschäftigung (confirmation of intended employment), a document checklist, the choice of federal state, the Kenntnisprüfung (knowledge exam), the FSP (Fachsprachprüfung, the medical-language exam) or questions about deadlines and recognition authorities.

## What it does
It prepares CVs and letters in German, document checklists tailored to the state, and advice on states and hospitals. Giovanni's profile it works from: a Brazilian doctor with experience in pre-hospital emergency care and airport medicine, aiming at radiology training, with Goethe B2 in November 2026, then Approbation and a move planned for the first half of 2027. The skill is of the "domain" kind: it owns the master CV, the cover letters and the Approbation checklist; it defers to [[skill-alemao-goethe-fsp]] for correcting texts Giovanni wrote himself; and it honours the language of the message (documents for hospitals are in German) and the depth flags `!!`, `***` and `...`.

## How it does it
A `SKILL.md` in `~/.claude/skills/candidatura-alemanha` (with dated legal facts in `references/approbation.md`); Claude loads it when a request matches its description.

## Where it sits in the pipeline
Giovanni's study and career work, outside the code projects.

## Who receives its output
Giovanni (drafts to send personally; nothing is sent by Claude).

## Steps
1. **Legal rules: always check the date.** Before stating anything about deadlines, fees, validity of documents or procedure, reopen the official source of the state (the current form of the responsible authority) and write "consulted on DD/MM/YYYY" beside each source. Use the form for graduates from outside the EU: the general Approbation form has different rules (for example validity of 1 month versus 3 months). If a secondary source and the official one disagree, follow the official one and show the divergence. Highlighted fact: a law passed in 2026 (Bundestag 26 March, Bundesrat 8 May), expected to apply from 1 November 2026, makes the direct Kenntnisprüfung the standard for non-EU graduates and the document equivalence analysis optional, on request; the material requirements for Approbation do not change; this affects Giovanni's calendar. Language: general B2 plus C1 technical language (the FSP at the state medical chamber).
2. **Lebenslauf (the German standard for doctors).** Tabular, reverse chronological, periods in MM/YYYY without gaps (some authorities require a signed CV without gaps). Blocks: personal data (photo optional, not required by the anti-discrimination law) → professional experience → education → Approbation/recognition (honest status, such as "application planned after Goethe B2 (11/2026)" or "filed on …") → languages (CEFR level + certificate and date) → training and certificates → publications → IT/interests (short) → place, date, signature. Explain Brazilian institutions in brackets when not obvious. Never invent dates, posts, grades or certificates; mark [fill in] where data is missing.
3. **One master CV.** There is one master CV, `Lebenslauf_MASTER.md` (in the connected folder or the active project). A new fact goes into the master first, in the right place, plus a line in the final block `Änderungen` (`YYYY-MM-DD | what changed`). Versions are derived from the master and named `Lebenslauf_<destination>_<YYYY-MM-DD>`; never edit a version without updating the master. Fidelity: nothing that is not in the master enters a version, not even the profile summary (no new adjectives or invented interests); missing data → a visible [fill in]. Reverse chronology inside each block. By destination: an application for specialist or resident posts includes clinical experience, radiology and Hospitationen, languages, certificates and publication, and cuts school details (at most 2 pages); an Approbation/authority CV includes everything, without gaps (gaps over 3 months explained) and no marketing text; a Hospitation CV is one page with radiology, languages and availability. Basis: the single-source principle and the checklist of the Federal Employment Agency's application guide.
4. **Anschreiben / e-mail to the chief physician.** One page, about 250–350 words. Structure: reference (the vacancy or initiative, how the service was found) → why this hospital and radiology (specific: research lines, musculoskeletal imaging, modalities) → what Giovanni brings (emergency care, decision-making, trauma imaging) → status of Approbation and language with realistic dates → a concrete request (Hospitation, interview, confirmation of intended employment) → closing formula. Register: the formal "Sie" form, "Sehr geehrte/r Frau/Herr Prof. Dr. …", "Mit freundlichen Grüßen". Clear German at B2.1–B2.2 level (he prefers not to sound above his real level; the interview will reveal it). When he wrote the text himself, review it with the correction rule of [[skill-alemao-goethe-fsp]].
5. **Document checklist, made to measure for the state.** A numbered table like the official form with the columns: document | issuer | form (simple copy / certified / apostille / translation) | maximum validity | when to get it (3-month documents last) | status. Mark as inference whatever is not on the form (for example which Brazilian body issues it). End with "the next 3 steps", with dates relative to Goethe B2.
6. **Request for a confirmation of employment (Stellenzusage).** In Baden-Württemberg the employer's declaration corresponds to the form "Anlage 3" signed by the employer; it is mandatory only for a temporary permit to practise (Berufserlaubnis) or if another state requests it. When asking the chief physician: be courteous without pressure, attach or mention the form, offer an alternative (an informal letter of intent) and explain in one sentence what it is for.
7. **Vague requests** (for example "write an e-mail to radiology"): do not ask back if there is enough context. Choose the most likely goal from the history, state the assumption in the first line, deliver the finished e-mail and a short variant for the other plausible goal (first contact).
8. **Strategy.** When asked for an opinion on a state or hospital, compare reported processing time, language requirements, radiology vacancies and cost of living; make clear what is official data and what is inference; cite the source and date.
