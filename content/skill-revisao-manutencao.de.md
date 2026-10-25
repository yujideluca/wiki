---
id: skill-revisao-manutencao
lang: de
source_hash: 9b811c76642d
title: Skill: revisao-manutencao
---

## What it is
Die Skill „revisao-manutencao“ („Wartungs-Review“) ist die urteilende Hälfte der [[maintenance-pipeline]]: Sie liest, was [[pipeline-check]] gemessen hat, und schlägt vor, was damit zu tun ist. Ihre Beschreibung sagt: in Claude Code für den monatlichen Architektur-Review von Giovannis Softwareprojekten (ein offener Punkt im Gedächtnis) und am Ende einer Aufgabe in einem Softwareprojekt verwenden (Monatsreview, Wartungsreview, technische Schulden, debt, pipeline-check, report.json); sie führt pipeline-check aus, liest dessen `report.json`, schlägt Schulden-Issues P1–P3 und eine Präventiv-Zeile im Entscheidungsprotokoll vor; nicht zum Schreiben von Code, nicht für einen einzelnen Bug, nicht für Arbeit außerhalb von Software. Ihr Prinzip: Das Programm misst, die Skill urteilt (Entscheidung ADR-0013; ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Sie schlägt vor und entscheidet nie.

## What it does
Sie führt `tools/pipeline-check.sh` aus, liest `report.json` und misst nie neu. Für jede Warnung oder jeden Fehlschlag schlägt sie ein `debt`-Issue mit einer Priorität vor. Dann prüft sie, was eine Maschine nicht sieht, ergänzt eine Präventiv-Zeile im Entscheidungsprotokoll jedes geprüften Projekts, ruft [[skill-gerar-teste-automatizado]] auf (beim ersten Review „create“, danach „update“) und schließt mit `mem use`, `wiki publish` und „Verified by:“. Sie schließt nie Issues, ändert nie eine Grenze, befördert nie eine Version und ändert nie den Branch-Schutz, und sie legt ohne Giovannis Ok keine Issues an.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/revisao-manutencao`. Ausgelöst wird sie vom Monatsreview-Punkt in workflow-memory und am Ende einer Aufgabe in einem Softwareprojekt. Ihre Rolle ist „Prozess“; sie verweist für alles Messen auf `pipeline-check`, auf [[skill-gerar-teste-automatizado]], auf [[skill-verification-before-completion]] und auf die Checkliste `~/dev/project-template/docs/MAINTENANCE.md`.

## Where it sits in the pipeline
Sie führt den [[monthly-architecture-review]] und den Review am Ende einer Aufgabe in jedem Softwareprojekt aus.

## Who receives its output
Giovanni (Vorschläge und Entscheidungen) und das Entscheidungsprotokoll jedes Projekts.

## Steps
Nie von Hand messen: kein `wc`, kein Zählen mit `git log`, kein erneutes Ausführen des Gates, um eine Zahl zu sehen. Fehlt eine Zahl in `report.json`, das sagen und eine Prüfung für `pipeline-check.toml` vorschlagen. Ohne Giovannis ausdrückliches Wort keine Issues schließen, keine Grenze ändern, keine Version befördern, keinen Branch-Schutz anlegen oder ändern und keine Issues anlegen (der Vorschlag ist eine Liste; sie nach dem Ok anlegen). Pro Projekt (beim Monatsreview: jedes Projekt in `~/dev` und das Programm-Repository `pipeline-check` selbst):
1. **Ausführen und lesen.** `tools/pipeline-check.sh` im Projekt ausführen (lokaler Modus), dann `build/pipeline-check/report.json` lesen und den gelaufenen Modus nennen. Eine mit `pulado` (übersprungen) markierte Prüfung ist eine Lücke in den Belegen: unter „konnte nicht geprüft werden“ aufführen, nie als ok behandeln. Ein Projekt ohne `pipeline-check.toml`: das sagen, vorschlagen, sie aus der Vorlage zu ergänzen, und für dieses Projekt anhalten. Außerdem die Standards prüfen, die kein Werkzeug misst (hinsehen, nicht zählen): Jeder Projektordner ist ein Git-Repository mit GitHub-Remote (ein Ordner ohne eines ist ein P2-Vorschlag „unter Versionskontrolle stellen“); `git config core.hooksPath` ist `tools/hooks`, wo ein Pre-Push-Hook existiert (der lokale Ersatz für den Branch-Schutz); die festgelegte `pipeline-check.version` ist der neueste Tag von `yujideluca/pipeline-check` (zurück = P3 „aktualisieren, nachdem das Gate besteht“); und kein Skript wird zwischen Projekten kopiert (derselbe Dateiname in zwei Projekten ist ein P2 „in ein eigenes Repository verschieben und nach Version nutzen“).
2. **Ein Vorschlag pro `aviso` (Warnung) oder `falha` (Fehlschlag).** Titel, Beleg (Prüf-ID, Wert, Grenze, Notiz), Label `debt` und eine Priorität. **P1**: Risiko von Datenverlust oder falschen Ergebnissen (ein fehlgeschlagenes Gate oder eine Architekturprüfung, die Daten oder Terminplanung schützt, CI (Continuous Integration) rot, Branch nicht geschützt). **P2**: verlangsamt jede Änderung oder führt den Nutzer in die Irre (eine Warnung bei 90 % ihrer Grenze oder mehr, einschließlich der Gate-Zeitprüfung). **P3**: wünschenswert (eine Warnung zwischen dem Warnanteil und 90 % ihrer Grenze, kosmetisch). Eine `falha` ist nie unter P2. Eine übersprungene Prüfung, deren Gegenstand bei Fehlschlag P1 wäre (CI, Branch-Schutz, Gate), ist kein Fehlschlag, aber man schlägt ein P2 „diesen Beleg verfügbar machen“ vor (zum Beispiel `gh` installieren oder anmelden, das Kommandozeilenwerkzeug von GitHub). Einheiten nach ID prüfen: `gate` sind Sekunden ohne Grenze; die Grenze für die Zeit steht in `gate-segundos`. Zuerst vorhandene Issues prüfen (`gh issue list --label debt`), damit dieselbe Schuld nicht doppelt vorgeschlagen wird; ist `gh` nicht verfügbar, sagen, dass Duplikate nicht geprüft werden konnten. Ein P1, das älter als ein Monat ist, wird jetzt eingeplant. Eine Tabelle zeigen: Issue-Titel | Priorität | Beleg | vorgeschlagene Lösung.
3. **Was die Maschine nicht sieht** (lesen, nicht messen): Passen die Diagramme in DESIGN.md und die ADRs zum Code (jede Abweichung mit Datei und Abschnitt nennen)? Hat jede strukturelle Änderung seit dem letzten Review ein ADR (Zeilen des Entscheidungsprotokolls und Git-Log-Betreffs seit der letzten Präventiv-Zeile „Monthly architecture review“ vergleichen)? Wurde dasselbe Problem in verschiedenen Projekten doppelt gelöst (dann vorschlagen, die bessere Lösung nach `~/dev/project-template` zu übernehmen)? Der Block mit Lieferkennzahlen (DORA, DevOps Research and Assessment): steigende Nacharbeit oder ein Präventivanteil weit unter 20 % ist ein Grund, die wichtigste Schuld einzuplanen; das sagen, nicht danach handeln.
4. **Fehlersuchender Test.** `docs/TESTES-AUTOMATIZADOS.md` im Projekt suchen. Fehlt es → es ist der erste Review: vollständig diagnostizieren und [[skill-gerar-teste-automatizado]] im Modus „create“ aufrufen. Ist es da → im Modus „update“ aufrufen. Das schreibt Testdateien, also Giovanni vorher Bescheid geben und den Plan nennen.
5. **Entscheidungsprotokoll.** Eine Präventiv-Zeile „Monthly architecture review“ (oder „Maintenance review“ am Ende einer Aufgabe) ins Entscheidungsprotokoll der DESIGN.md jedes geprüften Projekts eintragen, neueste zuerst, mit dem heutigen Datum, Datum und Modus des Berichts, den Zahlen (Fehlschläge, Warnungen, übersprungen, Vorschläge) und wo die Vorschläge liegen (Issue-Nummern, sobald angelegt, sonst „Vorschläge in der Review-Antwort aufgelistet, noch nicht angelegt“). Die Zeile erst schreiben, nachdem Giovanni die Vorschläge gesehen hat; die Spalten des Projekts Datum | Typ | Entscheidung | Warum nutzen; „Last updated“ anheben; keine anderen Änderungen an DESIGN.md, außer Giovanni stimmt zu.
6. **Abschluss.** `mem use REF --note "wie"` für die Einträge, die den Review geprägt haben (der Monatspunkt bleibt als Erinnerung offen), `wiki publish -m "..."` (oder `-m "review: no page change"` nur, wenn keine Seite beschreibt, was sich geändert hat, während eine geprüfte und für richtig befundene Seite einen neuen `reviewed`-Zeitpunkt bekommt; Seiten, die geändert werden müssen, schreibt [[skill-wiki-page-writer]]) und mit „Verified by:“ enden, das aufführt, was lief (pipeline-check-Modus, die Berichtsdatei, welche Projekte) und was nicht geprüft werden konnte (jede übersprungene Prüfung, jedes Projekt ohne Konfiguration, GitHub, wenn `gh` fehlte).
7. **Ausgabe.** In der Sprache von Giovannis Nachricht antworten. Mit dem Urteil beginnen (wie viele Fehlschläge, Warnungen, übersprungen), dann die Vorschlagstabelle, dann die Befunde „die Maschine sieht nicht“, dann was Giovannis Entscheidung braucht. Jeden Fachbegriff bei erster Verwendung definieren.

## Notes

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

#### Claude: `home:.claude/skills/revisao-manutencao/SKILL.md`

```skill-source home:.claude/skills/revisao-manutencao/SKILL.md 2a5174eb299fddbe05f8431f1e8a14a3c6ecb1ee8edbd9ba31706d706b34a4f8
---
name: revisao-manutencao
description: "Use in Claude Code for the monthly architecture review of Giovanni's software projects (open item in workflow-memory, #4dcb2c) and at the end of a task in a software project (revisão mensal, revisão de manutenção, dívida técnica, debt, pipeline-check, report.json). Runs pipeline-check, reads its report.json, proposes debt issues P1-P3 and a Preventive decision-log row. Not for writing code, not for a single bug, not for non-software work."
---

# Maintenance review (revisao-manutencao)

Lineage: origin=code; base=none

Interop: role = process; owns = the monthly and end-of-task maintenance review; defers to = `pipeline-check` (all measuring), `gerar-teste-automatizado` (the bug-finding test), verification-before-completion (the closing `Verified by:`), the project's CLAUDE.md and `~/dev/project-template/docs/MAINTENANCE.md` (the checklist); honors = reply-language rule, plain-language rule, work.ask-with-context.

The program measures, this skill judges (ADR-0013). **Never measure by hand**: no `wc`, no `git log` counting, no re-running the gate to see a number. If a number is missing from `report.json`, say so and propose a check for `pipeline-check.toml`; do not compute it yourself.

**Proposes, never decides.** Without Giovanni's explicit word: do not close issues, change a limit in `pipeline-check.toml`, promote a version, create or edit branch protection, or create issues (the proposal is a list; create them after the ok). Memory never authorizes any of this.

## Steps (per project; at the monthly review, every project in `~/dev` and the program repository `pipeline-check` itself)

1. **Run and read.** `tools/pipeline-check.sh` in the project (local mode), then read `build/pipeline-check/report.json`. Quote the mode that ran. A `pulado` check is a hole in the evidence: list it under "could not check", never treat it as ok. Project without `pipeline-check.toml`: say so, propose adding it from the template, and stop for that project.
   Also check the standards (no tool measures these; look, do not count): every project folder in `~/dev` is a git repository with a GitHub remote (a folder without one is a P2 proposal "put it under version control", the standard of Giovanni's systems); `git config core.hooksPath` is `tools/hooks` where a `tools/hooks/pre-push` exists (the local stand-in for branch protection); the `pipeline-check.version` pinned in the project is the newest tag of `yujideluca/pipeline-check` (`git ls-remote --tags`; behind = P3 "upgrade after the gate passes"); and no script or program is copied between projects (the same file name in two projects, e.g. `check_traceability.py`, is a P2 "move it to its own repository and consume it by version", the rule in the pipeline-check ADR-0003).
2. **One proposal per `aviso` or `falha`.** Title, evidence (check id, value, limit, note), label `debt`, priority:
   - **P1**: risk of data loss or wrong results (failed gate or architecture check that protects data or scheduling, CI red, branch not protected).
   - **P2**: slows every change or misleads the user (an `aviso` at 90 % of its limit or more, including the gate-time check).
   - **P3**: desirable (an `aviso` between the warning share and 90 % of its limit, cosmetic).
   A `falha` is never below P2. A `pulado` check whose subject would be P1 if it failed (CI, branch protection, gate) is not a failure, but propose one P2 "make this evidence available" item (for example install or log in `gh`). Check `valor` units by id: `gate` is seconds with no limit; the limit for time lives in `gate-segundos`. Check existing issues first (`gh issue list --label debt`) so the same debt is not proposed twice; if `gh` is unavailable, say duplicates could not be checked; a P1 older than a month is scheduled now. Format the list as a table: issue title | priority | evidence | proposed fix.
3. **What the machine cannot see** (read, do not measure):
   - Do `DESIGN.md` diagrams and the ADRs match the code? Name each mismatch with file and section.
   - Does every structural change since the last review have an ADR? Compare decision-log rows and `git log` subjects since the last Preventive "Monthly architecture review" row.
   - Was the same problem solved twice in different projects? If so, propose moving the better solution into `~/dev/project-template`.
   - The DORA block: rising `retrabalho`, or `parcela_preventiva` far below 20 %, is a reason to schedule top debt; say it, do not act on it.
4. **Bug-finding test.** Look for `docs/TESTES-AUTOMATIZADOS.md` in the project. (The program `pipeline-check` is its own repository and is reviewed as its own project, with its own record, in update mode.) Missing: this is the first review, so do a full diagnosis of the code and call the skill `gerar-teste-automatizado` in **create** mode. Present: call it in **update** mode (it checks the test against what was implemented since). This writes test files, so tell Giovanni first and give the plan.
5. **Decision log.** Add a Preventive row "Monthly architecture review" (or "Maintenance review" at end of task) to each reviewed project's `DESIGN.md` decision log, newest first, with **today's date** (not the report's), the report's date and mode, the counts (falhas, avisos, pulados, proposals) and where the proposals live (issue numbers once Giovanni has had them created, otherwise "proposals listed in the review reply, not yet created"). Write the row after Giovanni has seen the proposals; use the columns Date | Type | Decision | Why of the project's table. Bump "Last updated". Only that row; no other `DESIGN.md` edits unless Giovanni agrees.
6. **Close.** `mem use REF --note "how"` for the entries that shaped the review (the monthly item stays open as the reminder), `wiki publish -m "..."` as the global CLAUDE.md requires (when pages need changing, write them with the skill `wiki-page-writer`, which also guards against publishing someone else's uncommitted edits) (`-m "review: no page change"` only when no page describes what changed; a page that was checked and found right gets a new `reviewed` time instead), and end with `Verified by:` listing what ran (pipeline-check mode, the report file, which projects) and what could not be checked (every `pulado` check, any project without a config, GitHub if `gh` was unavailable).

## Output
Reply in the language of Giovanni's message (Portuguese or English; memory entry language.reply). Lead with the verdict (how many `falha`, `aviso`, `pulado`), then the proposal table, then the "machine cannot see" findings, then what needs a decision from Giovanni. Define each technical term on first use.

## Testing this skill
Given an example `report.json` and no repository access to measure with, the skill must produce prioritised proposals and one Preventive row text without running anything but `pipeline-check` or reading the file. A step that needs a number the report lacks is a finding, not a measurement.
```


#### Codex: `home:.agents/skills/revisao-manutencao/SKILL.md`

```skill-source home:.agents/skills/revisao-manutencao/SKILL.md 16194b4877f2bb1228753e7f4a1b682cb32ccdb2c161ef663c6c004e574b7cc2
---
name: revisao-manutencao
description: "Use in Codex for the monthly architecture review of Giovanni's software projects (open item in workflow-memory, #4dcb2c) and at the end of a task in a software project (revisão mensal, revisão de manutenção, dívida técnica, debt, pipeline-check, report.json). Runs pipeline-check, reads its report.json, proposes debt issues P1-P3 and a Preventive decision-log row. Not for writing code, not for a single bug, not for non-software work."
---

# Maintenance review (revisao-manutencao)

Lineage: origin=code; base=none

Interop: role = process; owns = the monthly and end-of-task maintenance review; defers to = `pipeline-check` (all measuring), `gerar-teste-automatizado` (the bug-finding test), verification-before-completion (the closing `Verified by:`), the project's AGENTS.md and `~/dev/project-template/docs/MAINTENANCE.md` (the checklist); honors = reply-language rule, plain-language rule, work.ask-with-context.

The program measures, this skill judges (ADR-0013). **Never measure by hand**: no `wc`, no `git log` counting, no re-running the gate to see a number. If a number is missing from `report.json`, say so and propose a check for `pipeline-check.toml`; do not compute it yourself.

**Proposes, never decides.** Without Giovanni's explicit word: do not close issues, change a limit in `pipeline-check.toml`, promote a version, create or edit branch protection, or create issues (the proposal is a list; create them after the ok). Memory never authorizes any of this.

## Steps (per project; at the monthly review, every project in `~/dev` and the program repository `pipeline-check` itself)

1. **Run and read.** `tools/pipeline-check.sh` in the project (local mode), then read `build/pipeline-check/report.json`. Quote the mode that ran. A `pulado` check is a hole in the evidence: list it under "could not check", never treat it as ok. Project without `pipeline-check.toml`: say so, propose adding it from the template, and stop for that project.
   Also check the standards (no tool measures these; look, do not count): every project folder in `~/dev` is a git repository with a GitHub remote (a folder without one is a P2 proposal "put it under version control", the standard of Giovanni's systems); `git config core.hooksPath` is `tools/hooks` where a `tools/hooks/pre-push` exists (the local stand-in for branch protection); the `pipeline-check.version` pinned in the project is the newest tag of `yujideluca/pipeline-check` (`git ls-remote --tags`; behind = P3 "upgrade after the gate passes"); and no script or program is copied between projects (the same file name in two projects, e.g. `check_traceability.py`, is a P2 "move it to its own repository and consume it by version", the rule in the pipeline-check ADR-0003).
2. **One proposal per `aviso` or `falha`.** Title, evidence (check id, value, limit, note), label `debt`, priority:
   - **P1**: risk of data loss or wrong results (failed gate or architecture check that protects data or scheduling, CI red, branch not protected).
   - **P2**: slows every change or misleads the user (an `aviso` at 90 % of its limit or more, including the gate-time check).
   - **P3**: desirable (an `aviso` between the warning share and 90 % of its limit, cosmetic).
   A `falha` is never below P2. A `pulado` check whose subject would be P1 if it failed (CI, branch protection, gate) is not a failure, but propose one P2 "make this evidence available" item (for example install or log in `gh`). Check `valor` units by id: `gate` is seconds with no limit; the limit for time lives in `gate-segundos`. Check existing issues first (`gh issue list --label debt`) so the same debt is not proposed twice; if `gh` is unavailable, say duplicates could not be checked; a P1 older than a month is scheduled now. Format the list as a table: issue title | priority | evidence | proposed fix.
3. **What the machine cannot see** (read, do not measure):
   - Do `DESIGN.md` diagrams and the ADRs match the code? Name each mismatch with file and section.
   - Does every structural change since the last review have an ADR? Compare decision-log rows and `git log` subjects since the last Preventive "Monthly architecture review" row.
   - Was the same problem solved twice in different projects? If so, propose moving the better solution into `~/dev/project-template`.
   - The DORA block: rising `retrabalho`, or `parcela_preventiva` far below 20 %, is a reason to schedule top debt; say it, do not act on it.
4. **Bug-finding test.** Look for `docs/TESTES-AUTOMATIZADOS.md` in the project. (The program `pipeline-check` is its own repository and is reviewed as its own project, with its own record, in update mode.) Missing: this is the first review, so do a full diagnosis of the code and call the skill `gerar-teste-automatizado` in **create** mode. Present: call it in **update** mode (it checks the test against what was implemented since). This writes test files, so tell Giovanni first and give the plan.
5. **Decision log.** Add a Preventive row "Monthly architecture review" (or "Maintenance review" at end of task) to each reviewed project's `DESIGN.md` decision log, newest first, with **today's date** (not the report's), the report's date and mode, the counts (falhas, avisos, pulados, proposals) and where the proposals live (issue numbers once Giovanni has had them created, otherwise "proposals listed in the review reply, not yet created"). Write the row after Giovanni has seen the proposals; use the columns Date | Type | Decision | Why of the project's table. Bump "Last updated". Only that row; no other `DESIGN.md` edits unless Giovanni agrees.
6. **Close.** `mem use REF --note "how"` for the entries that shaped the review (the monthly item stays open as the reminder), `wiki publish -m "..."` as the global AGENTS.md requires (when pages need changing, write them with the skill `wiki-page-writer`, which also guards against publishing someone else's uncommitted edits) (`-m "review: no page change"` only when no page describes what changed; a page that was checked and found right gets a new `reviewed` time instead), and end with `Verified by:` listing what ran (pipeline-check mode, the report file, which projects) and what could not be checked (every `pulado` check, any project without a config, GitHub if `gh` was unavailable).

## Output
Reply in the language of Giovanni's message (Portuguese or English; memory entry language.reply). Lead with the verdict (how many `falha`, `aviso`, `pulado`), then the proposal table, then the "machine cannot see" findings, then what needs a decision from Giovanni. Define each technical term on first use.

## Testing this skill
Given an example `report.json` and no repository access to measure with, the skill must produce prioritised proposals and one Preventive row text without running anything but `pipeline-check` or reading the file. A step that needs a number the report lacks is a finding, not a measurement.
```
