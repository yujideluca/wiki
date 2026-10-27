---
id: skill-gerar-teste-automatizado
lang: de
source_hash: 0bf93f2deb37
title: Skill: gerar-teste-automatizado
---

## What it is
Die Skill „gerar-teste-automatizado“ („automatisierten Test erzeugen“) erstellt und aktualisiert später die automatisierte Testsuite, die in einem Softwareprojekt nach echten Fehlern sucht. Ihre Beschreibung sagt: in Claude Code verwenden, um die automatisierte fehlersuchende Testsuite eines Projekts zu erstellen oder zu aktualisieren: vollständige Diagnose des Codes, eine Testmatrix, Tests, die echte Defekte erkennen, Mutations- und Abdeckungsprüfungen. Sie wird von [[skill-revisao-manutencao]] beim ersten Review eines Projekts (create) und bei späteren Reviews (update) aufgerufen und kann auch direkt verlangt werden. Nicht zum Beheben eines einzelnen fehlschlagenden Tests oder Bugs ([[skill-systematic-debugging]]). Sie beruht auf einem Prompt, den Giovanni geschrieben hat.

## Flow
trigger t1: Die erste Überprüfung eines Projekts, eine spätere oder eine direkte Bitte um eine fehlersuchende Testsuite | [[skill-revisao-manutencao]]
step s1: Entscheidet zuerst den Modus: erstellen oder aktualisieren
step s2: Analysiert den ganzen Code, bevor ein Test entsteht
step s3: Plant die Testmatrix
step s4: Setzt Tests um, die echte Fehler finden können
step s5: Prüft, dass die Tests Fehler erkennen, mit Mutations- und Abdeckungsprüfung | [[mutation-check]]
decide d1: Fangen die Tests die eingebauten Fehler?
step s6: Stärkt die schwachen Tests
step s7: Schreibt docs/TESTES-AUTOMATIZADOS.md und berichtet
product p1: Tests in den Testordnern des Projekts
product p2: Ein Bericht über gefundene Fehler und Restrisiken für Giovanni | [[giovanni]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> d1
d1 -ja-> s7
d1 -nein-> s6
s6 -> s7
s7 -> p1
s7 -> p2

## What it does
Ziel sind Tests, die echte Fehler, Regressionen, ungültige Eingaben, Grenzfälle und Integrationsfehler finden, nicht Tests, die den leichten Weg bestätigen. Sie ändert nie Produktionscode, damit Tests bestehen, und schlägt jede nötige Korrektur getrennt vor.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/gerar-teste-automatizado`. Das Protokoll `docs/TESTES-AUTOMATIZADOS.md` an der Wurzel des Projekts (oder an der Wurzel einer Komponente mit eigenem Manifest, etwa QuizApps `tools/pipeline-check`) ist die Markierung, dass die Suite existiert. Ihre Rolle ist „Domäne“: Sie besitzt die fehlersuchende Testsuite und ihr Protokoll; sie verweist auf das eigene Test-Framework, den Anforderungskatalog und die CLAUDE.md des Projekts, auf [[skill-systematic-debugging]] (einen gefundenen Defekt beheben) und auf [[skill-verification-before-completion]]; aufgerufen wird sie von [[skill-revisao-manutencao]].

## Where it sits in the pipeline
Aufgerufen von [[skill-revisao-manutencao]] in Schritt 4 jedes Reviews.

## Who receives its output
Giovanni (gefundene Defekte, Restrisiken) und die Testordner des Projekts.

## Steps
Als erfahrener Ingenieur für automatisiertes Testen und Fehlererkennung handeln.
0. **Zuerst den Modus bestimmen.** *Create*: `docs/TESTES-AUTOMATIZADOS.md` existiert noch nicht; vollständig diagnostizieren, dann die Suite bauen. *Update*: Es existiert; es und die Suite lesen, herausfinden, was sich seit dem in der Datei genannten „Last reviewed“-Commit in Code, Anforderungen und ADRs (Architecture Decision Records) geändert hat, und Matrix und Tests aktualisieren: Neue Verhaltensweisen bekommen Fälle, entfallene verlieren sie (mit Begründung), beim letzten Mal überlebende Mutanten werden erneut versucht; nicht umschreiben, was noch gilt. Sprache und Framework nutzen, die das Projekt schon verwendet; gibt es keine, Giovanni fragen. Nie zerstörerische Operationen auf Datenbanken oder externen Systemen ausführen; keine Geheimnisse oder persönlichen Daten in Tests oder Berichten.
1. **Analysieren, bevor ein Test geschrieben wird.** Struktur, Sprache, Abhängigkeiten, Architektur, relevante Module und bereits installierte Testwerkzeuge; die ausdrücklichen Anforderungen, Geschäftsregeln, Funktionsverträge und Ein- und Ausgabeformate (zuerst die `docs/REQUIREMENTS.md` des Projekts); die kritischen Komponenten, externen Abhängigkeiten und Hauptfehlerarten; die vorhandenen Tests und die Lücken ihrer Abdeckung; mehrdeutige oder fehlende Anforderungen (keine Regeln erfinden: die Unsicherheit festhalten und nur auf genannten, begründeten Hypothesen fortfahren). Architektur und Muster des Projekts beibehalten, außer es gibt einen dokumentierten technischen Grund.
2. **Die Testmatrix planen.** Jede Anforderung oder jedes Verhalten auf Fälle abbilden, gewählt nach Risiko und Fehlerfindungskraft, nicht nach Anzahl. Wo anwendbar bedenken: Normalszenarien; Äquivalenzklassen gültiger und ungültiger Eingaben; Grenzwerte; Null-, fehlende, falsch typisierte und fehlerhafte Daten; Extremfälle und Kombinationen; Ausnahmen, Netzwerkausfall, nicht verfügbare Abhängigkeiten; ungültige Zustände und verbotene Übergänge; Duplikate und Integritätsverletzungen; Regressionen; Nebenläufigkeit, Idempotenz, Leistung und Sicherheit, wenn im Umfang. Keine redundanten Fälle.
3. **Umsetzen.** Die Frameworks des Projekts bevorzugen. Jeder Test hat einen bestimmten Zweck und einen Namen, der das Verhalten beschreibt; baut seine Eingaben selbst; handelt; vergleicht mit einem erwarteten Ergebnis, das unabhängig vom getesteten Code definiert ist (von Hand berechnet, aus der Anforderung); prüft relevante Nebenwirkungen; und schlägt mit klarer Meldung fehl (Arrange–Act–Assert). Code nicht aufrufen, ohne das Ergebnis zu prüfen. Das aktuelle Verhalten nicht zum Orakel machen: es mit den Anforderungen konfrontieren. Tests nach der Konvention des Projekts taggen (QuizApp: ein `REQ <ID>`-Kommentar). Ebenen nach Bedarf wählen (Unit, Integration, End-to-End, property-basiert, Regression) und Lücken begründen. Eigenschaften: deterministisch, reproduzierbar, isoliert, lose gekoppelt, wartbar; externe Dienste in Unit-Tests gefälscht und nur in Integrationstests echt; keine beliebigen Wartezeiten, Reihenfolgeabhängigkeit, Internetaufrufe oder unkontrollierte Zeit.
4. **Prüfen, dass die Tests Defekte erkennen können.** Die neuen Tests ausführen und jeden Fehlschlag untersuchen (nie eine Erwartung ändern, nur damit es besteht). Nach echten Korrekturen erneut ausführen und die vorhandene Suite auf Regressionen laufen lassen. Wenn möglich, Mutationstests machen: kontrollierte Fehler einbauen und prüfen, dass die Tests sie fangen, und jeden Überlebenden als äquivalenten Mutanten, irrelevant oder echte Lücke einordnen. Läufe wiederholen, um Unabhängigkeit und stabile Ergebnisse zu bestätigen. Zeilen- und Zweigabdeckung messen, wenn es ein Werkzeug gibt; Abdeckung ist kein Beweis für Korrektheit.
5. **Einschränkungen.** Produktionscode nicht ändern, damit Tests bestehen; Anforderungen, Referenzdaten oder erwartete Ergebnisse nicht ohne nachprüfbaren Grund ändern; Tests nicht löschen, Validierungen nicht abschalten oder Prüfungen nicht abschwächen, um grün zu werden. Eine nötige Produktionskorrektur wird getrennt vorgeschlagen (Defekt, Beleg, vorgeschlagene Änderung) und nur im genehmigten Umfang umgesetzt. Nie behaupten, ein Test habe bestanden, ohne ihn auszuführen; jede Einschränkung nennen (fehlendes Werkzeug, Umgebung).
6. **Abliefern: `docs/TESTES-AUTOMATIZADOS.md` schreiben und berichten.** Das Protokoll enthält: die Zusammenfassung der Analyse und die Strategie; die Testmatrix (Anforderung, Szenario, erwartetes Ergebnis, Priorität); die Dateien und ihre Zwecke; die Ausführungsbefehle; die echten Ergebnisse (ausgeführt, bestanden, fehlgeschlagen, ignoriert); Abdeckung mit Werkzeug und Lücken; gefundene Defekte (Beschreibung, Beleg, Auswirkung, Reproduktion); Einschränkungen und Restrisiken; Empfehlungen; und die Kopfzeile `Last reviewed: <Commit-SHA> <Datum>`, die der Update-Modus liest. Klar kennzeichnen, was beobachtet, was geschlossen und was Hypothese ist. Fertig ist es erst, wenn die Tests umgesetzt und geordnet sind, erwartete Ergebnisse eine erkennbare Grundlage haben, Ausführungsbefehle dokumentiert sind, Tests ausgeführt wurden (oder Grenzen festgehalten), Fehlschläge untersucht und eingeordnet wurden und Risiken und Lücken dokumentiert sind. Nicht bei einem Plan oder Codebeispielen stehen bleiben. Mit „Verified by:“ enden.

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

#### Claude: `home:.claude/skills/gerar-teste-automatizado/SKILL.md`

```skill-source home:.claude/skills/gerar-teste-automatizado/SKILL.md 5ef692eacb4e55d231aba1007926f683002fd53247ef6043d6be0d73d9ca077e
---
name: gerar-teste-automatizado
description: "Use in Claude Code to create or update the automated bug-finding test suite of a software project: full diagnosis of the code, test matrix, tests that detect real defects, mutation and coverage checks (criar testes automatizados, suíte de testes, buscar bugs). Called by revisao-manutencao on the first review of a project (create) and on later reviews (update); can also be asked for directly. Not for fixing a single failing test or a bug (systematic-debugging)."
---

# Automated bug-finding tests (gerar-teste-automatizado)

Lineage: origin=code; base=none

Interop: role = domain; owns = the bug-finding test suite and its record `docs/TESTES-AUTOMATIZADOS.md`; defers to = the project's existing test framework, requirements catalogue and CLAUDE.md (REQ tags, gate), systematic-debugging (fixing a defect found), verification-before-completion; called by = revisao-manutencao; honors = reply-language rule, work.ask-language, work.test-yourself.

Act as a senior engineer in automated testing and defect detection. The aim is tests that **find real errors, regressions, invalid inputs, boundaries and integration failures**, not tests that confirm the easy path.

## Mode (decide first)
- **Create**: `docs/TESTES-AUTOMATIZADOS.md` does not exist in the project. Full diagnosis, then build the suite. That file is the marker that the suite exists. The record lives at the root of the project; for a component with its own manifest (for example QuizApp's `tools/pipeline-check`) it lives at that component's root, `tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`, and the review checks each component that has one.
- **Update**: it exists. Read it and the suite, find what changed in the code, requirements and ADRs since the "Last reviewed" commit in the file, and bring the matrix and tests up to date: new behaviours get cases, removed ones lose them (with a reason), mutants that survived last time are retried. Do not rewrite what still holds.
Programming language and framework: use what the project already uses; if there is none, ask Giovanni (work.ask-language). Never run destructive operations on databases or external systems; no secrets or personal data in tests or reports.

## 1. Analyse before writing any test
1. Structure, language, dependencies, architecture, relevant modules, test tools already installed.
2. Explicit requirements, business rules, function contracts, input and output formats (the project's `docs/REQUIREMENTS.md` first).
3. Critical components, external dependencies, main failure modes.
4. Existing tests and the gaps in their coverage.
5. Ambiguous or missing requirements: do not invent rules. Record the uncertainty and proceed only on stated, justified hypotheses.
Keep the project's architecture and patterns unless there is a documented technical reason.

## 2. Plan: the test matrix
Map each requirement or behaviour to cases, chosen by risk and defect-finding power, not by count. Consider where applicable: normal scenarios; equivalence classes of valid and invalid input; boundary values; null, missing, wrong-typed and malformed data; extreme cases and combinations; exceptions, network failure, unavailable dependencies; invalid states and forbidden transitions; duplicates and integrity violations; regressions; concurrency, idempotency, performance, security when in scope. No redundant cases.

## 3. Implement
Prefer the project's frameworks. Each test: a specific purpose and a name that describes the behaviour; builds its own inputs; acts; compares with an expected result **defined independently of the code under test** (hand-computed, from the requirement); checks relevant side effects; fails with a clear message. Arrange-Act-Assert. Do not call code without asserting on the result. Do not turn current behaviour into the oracle: confront it with the requirements. Tag tests with the project's convention (QuizApp: `REQ <ID>` comment). Choose levels as needed (unit, integration, end-to-end, property-based, regression) and justify gaps; do not force every level.

Qualities: deterministic, reproducible, isolated, low coupling (public behaviour and contracts), maintainable, external services faked in unit tests and real only in integration tests; no arbitrary waits, order dependence, internet calls, or uncontrolled time.

## 4. Verify the tests can detect defects
1. Run the new tests; investigate every failure. Never change an expectation just to pass.
2. Run again after real fixes; run the existing suite for regressions.
3. When viable, mutation testing: plant controlled faults and check the tests catch them. Classify each survivor: equivalent mutant, irrelevant, or a real gap.
4. Repeat runs to confirm independence and stable results.
5. Measure line and branch coverage if a tool exists. Coverage is not proof of correctness.

## 5. Restrictions
Do not change production code to make tests pass; do not edit requirements, reference data or expected results without a verifiable reason; do not delete tests, disable validations or weaken checks to get green. A needed production fix is **proposed separately** (defect, evidence, proposed change) and implemented only if inside the authorised scope. Never claim a test passed without running it; state every limitation (missing tool, environment).

## 6. Deliver: write `docs/TESTES-AUTOMATIZADOS.md` and report
The record keeps, in the project: analysis summary and strategy; the test matrix (requirement, scenario, expected result, priority); files and purposes; run commands; real results (run, passed, failed, ignored); coverage with tool and gaps; defects found (description, evidence, impact, reproduction); limitations and residual risks; recommendations; and the header line `Last reviewed: <commit sha> <date>` that Update mode reads. Mark clearly what was observed, what is inferred, and what is a hypothesis.

Done only when: tests implemented and organised; expected results have an identifiable basis; run commands documented; tests executed (or limits recorded); failures investigated and classified; risks and gaps documented. Do not stop at a plan or code samples. End with `Verified by:`.
```


#### Codex: `home:.agents/skills/gerar-teste-automatizado/SKILL.md`

````skill-source home:.agents/skills/gerar-teste-automatizado/SKILL.md ad3648f66cccf231e6b3a3d522a6704e48238928825846a4bce7324502efd6b2
---
name: gerar-teste-automatizado
description: "Use in Codex to create or update the automated bug-finding test suite of a software project: full diagnosis of the code, test matrix, tests that detect real defects, mutation and coverage checks (criar testes automatizados, suíte de testes, buscar bugs). Called by revisao-manutencao on the first review of a project (create) and on later reviews (update); can also be asked for directly. Not for fixing a single failing test or a bug (systematic-debugging)."
---

# Automated bug-finding tests (gerar-teste-automatizado)

Lineage: origin=claude; base=sha256:5ef692eacb4e55d231aba1007926f683002fd53247ef6043d6be0d73d9ca077e; adaptation=codex

Interop: role = domain; owns = the bug-finding test suite and its record `docs/TESTES-AUTOMATIZADOS.md`; defers to = the project's existing test framework, requirements catalogue and CLAUDE.md (REQ tags, gate), systematic-debugging (fixing a defect found), verification-before-completion; called by = revisao-manutencao; honors = reply-language rule, work.ask-language, work.test-yourself.

Act as a senior engineer in automated testing and defect detection. The aim is tests that **find real errors, regressions, invalid inputs, boundaries and integration failures**, not tests that confirm the easy path.

## Mode (decide first)
- **Create**: `docs/TESTES-AUTOMATIZADOS.md` does not exist in the project. Full diagnosis, then build the suite. That file is the marker that the suite exists. The record lives at the root of the project; for a component with its own manifest (for example QuizApp's `tools/pipeline-check`) it lives at that component's root, `tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`, and the review checks each component that has one.
- **Update**: it exists. Read it and the suite, find what changed in the code, requirements and ADRs since the "Last reviewed" commit in the file, and bring the matrix and tests up to date: new behaviours get cases, removed ones lose them (with a reason), mutants that survived last time are retried. Do not rewrite what still holds.
Programming language and framework: use what the project already uses; if there is none, ask Giovanni (work.ask-language). Never run destructive operations on databases or external systems; no secrets or personal data in tests or reports.

## 1. Analyse before writing any test
1. Structure, language, dependencies, architecture, relevant modules, test tools already installed.
2. Explicit requirements, business rules, function contracts, input and output formats (the project's `docs/REQUIREMENTS.md` first).
3. Critical components, external dependencies, main failure modes.
4. Existing tests and the gaps in their coverage.
5. Ambiguous or missing requirements: do not invent rules. Record the uncertainty and proceed only on stated, justified hypotheses.
Keep the project's architecture and patterns unless there is a documented technical reason.

## 2. Plan: the test matrix
Map each requirement or behaviour to cases, chosen by risk and defect-finding power, not by count. Consider where applicable: normal scenarios; equivalence classes of valid and invalid input; boundary values; null, missing, wrong-typed and malformed data; extreme cases and combinations; exceptions, network failure, unavailable dependencies; invalid states and forbidden transitions; duplicates and integrity violations; regressions; concurrency, idempotency, performance, security when in scope. No redundant cases.

## 3. Implement
Prefer the project's frameworks. Each test: a specific purpose and a name that describes the behaviour; builds its own inputs; acts; compares with an expected result **defined independently of the code under test** (hand-computed, from the requirement); checks relevant side effects; fails with a clear message. Arrange-Act-Assert. Do not call code without asserting on the result. Do not turn current behaviour into the oracle: confront it with the requirements. Tag tests with the project's convention (QuizApp: `REQ <ID>` comment). Choose levels as needed (unit, integration, end-to-end, property-based, regression) and justify gaps; do not force every level.

Qualities: deterministic, reproducible, isolated, low coupling (public behaviour and contracts), maintainable, external services faked in unit tests and real only in integration tests; no arbitrary waits, order dependence, internet calls, or uncontrolled time.

## 4. Verify the tests can detect defects
1. Run the new tests; investigate every failure. Never change an expectation just to pass.
2. Run again after real fixes; run the existing suite for regressions.
3. When viable, mutation testing: plant controlled faults and check the tests catch them. Classify each survivor: equivalent mutant, irrelevant, or a real gap.
4. Repeat runs to confirm independence and stable results.
5. Measure line and branch coverage if a tool exists. Coverage is not proof of correctness.

## 5. Restrictions
Do not change production code to make tests pass; do not edit requirements, reference data or expected results without a verifiable reason; do not delete tests, disable validations or weaken checks to get green. A needed production fix is **proposed separately** (defect, evidence, proposed change) and implemented only if inside the authorised scope. Never claim a test passed without running it; state every limitation (missing tool, environment).

## 6. Deliver: write `docs/TESTES-AUTOMATIZADOS.md` and report
The record keeps, in the project: analysis summary and strategy; the test matrix (requirement, scenario, expected result, priority); files and purposes; run commands; real results (run, passed, failed, ignored); coverage with tool and gaps; defects found (description, evidence, impact, reproduction); limitations and residual risks; recommendations; and the header line `Last reviewed: <commit sha> <date>` that Update mode reads. Mark clearly what was observed, what is inferred, and what is a hypothesis.

Done only when: tests implemented and organised; expected results have an identifiable basis; run commands documented; tests executed (or limits recorded); failures investigated and classified; risks and gaps documented. Do not stop at a plan or code samples. End with `Verified by:`.


## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
