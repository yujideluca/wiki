---
id: skill-verification-before-completion
lang: de
source_hash: ac2db376af7d
title: Skill: verification-before-completion
---

## What it is
Die Skill „verification-before-completion“ ist die Regel, dass Belege vor jeder Behauptung kommen, Arbeit sei fertig, behoben oder bestanden. Ihre Beschreibung sagt: vor der Aussage verwenden, Arbeit sei fertig, behoben, bestanden oder abgeschlossen, und vor dem Committen: die Prüfbefehle ausführen und ihre Ausgabe zuerst lesen; Belege vor Behauptungen. Sie speist die Zeile `Verified by:`, mit der jeder Bericht an Giovanni endet. Sie wurde aus den Open-Source-Skills „superpowers“ (Version 7.0.0, MIT-Lizenz) angepasst, ohne deren dauerhaften Start-Hook. Ihre Rolle ist „Prozess“; sie verweist für Build-, Test- und Geräteschritte auf die CLAUDE.md des Projekts und für die Abschlussschritte (`mem use`, `wiki publish`) auf die globale [[global-claude-md]].

## What it does
Bevor es „fertig“ sagt oder committet, muss Claude den Befehl ausführen, der die Behauptung belegt, und seine Ausgabe lesen. Die abschließende Zeile „Verified by:“ sagt dann, was ausgeführt wurde und was nicht geprüft werden konnte.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/verification-before-completion`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Teil des Entwicklungsprozesses in Claude Code, in jedem Projekt benutzt; sie kommt vor [[end-of-task]].

## Who receives its output
Giovanni (der Bericht) und der Commit.

## Steps
Das eiserne Gesetz: keine Fertigmeldungen ohne frischen Prüfbeleg. Wurde der Prüfbefehl nicht in dieser Nachricht ausgeführt, darf man nicht behaupten, er bestehe.
1. **Bestimmen**, welcher Befehl die Behauptung belegt.
2. **Ausführen**: den vollständigen Befehl, frisch und komplett.
3. **Lesen**: die ganze Ausgabe, den Exit-Code prüfen, die Fehler zählen.
4. **Prüfen**, ob die Ausgabe die Behauptung bestätigt. Wenn nicht, den wahren Status mit Beleg nennen; wenn ja, die Behauptung mit Beleg nennen.
5. **Erst dann** die Behauptung aufstellen. Jeden Schritt zu überspringen ist kein Prüfen.

Was als Beleg zählt: „Tests bestehen“ braucht die Ausgabe des Testbefehls mit 0 Fehlern (nicht einen früheren Lauf oder „sollte bestehen“); „Linter sauber“ braucht Linter-Ausgabe mit 0 Fehlern; „Build gelingt“ braucht den Exit-Code 0 des Build-Befehls (ein bestandener Linter ist kein Build); „Bug behoben“ braucht den Test des ursprünglichen Symptoms; ein Regressionstest braucht den Rot-Grün-Zyklus (schreiben, ausführen und bestehen, Fix zurücknehmen, ausführen und Fehlschlag sehen, wiederherstellen, ausführen und bestehen); „Agent fertig“ braucht einen Blick auf den Versionskontroll-Diff, nicht den Bericht des Agenten; „Anforderungen erfüllt“ braucht eine Zeile-für-Zeile-Checkliste, nicht nur bestandene Tests.

Warnzeichen, die Stopp bedeuten: Wörter wie „sollte“, „wahrscheinlich“, „scheint“; Zufriedenheit äußern („Super!“, „Fertig!“) vor der Prüfung; kurz davor sein, ohne Prüfung zu committen, zu pushen oder einen Pull Request zu öffnen; dem Erfolgsbericht eines Hilfsassistenten vertrauen; sich auf eine Teilprüfung stützen; „nur dieses eine Mal“; müde sein. Ausreden ändern die Regel nicht: Zuversicht ist kein Beleg, ein Linter ist kein Compiler, und andere Wortwahl entkommt der Regel nicht. Sie gilt vor jeder Erfolgsbehauptung, jeder Äußerung von Zufriedenheit, dem Committen, Pull Requests, dem Übergang zur nächsten Aufgabe und dem Delegieren.

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

#### Claude: `home:.claude/skills/verification-before-completion/SKILL.md`

````skill-source home:.claude/skills/verification-before-completion/SKILL.md e634cc29dba539d72868c7ff66d7e61d77ae7368defd016e34fc080c99ac9ae1
---
name: verification-before-completion
description: "Use in Claude Code before saying work is done, fixed, passing or complete, and before committing: run the verification commands and read their output first; evidence before assertions. Feeds the `Verified by:` line that every done report ends with."
---

# Verification Before Completion

Lineage: origin=code; base=none

Interop: role = process; owns = proof before any success claim; defers to = the project's CLAUDE.md (its build/test/device steps, e.g. QuizApp: adb install, launch, logcat), the global CLAUDE.md (closing steps: mem use, wiki publish); honors = reply-language rule, debug-after-coding.

Adapted from obra/superpowers 7.0.0 (commit bb92a77, MIT, LICENSE in this folder), without its always-on startup hook.

## Overview

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness
````


#### Codex: `home:.agents/skills/verification-before-completion/SKILL.md`

````skill-source home:.agents/skills/verification-before-completion/SKILL.md f2e64936cb0291708538d88c7bdfe6aa5140a8fc8a7413ac36b5844c31353532
---
name: verification-before-completion
description: "Use in Codex before saying work is done, fixed, passing or complete, and before committing: run the verification commands and read their output first; evidence before assertions. Feeds the `Verified by:` line that every done report ends with."
---

# Verification Before Completion

Lineage: origin=claude; base=sha256:e634cc29dba539d72868c7ff66d7e61d77ae7368defd016e34fc080c99ac9ae1; adaptation=codex

Interop: role = process; owns = proof before any success claim; defers to = the project's AGENTS.md (or CLAUDE.md when it is the existing project guide) (its build/test/device steps, e.g. QuizApp: adb install, launch, logcat), the global CLAUDE.md (closing steps: mem use, wiki publish); honors = reply-language rule, debug-after-coding.

Adapted from obra/superpowers 7.0.0 (commit bb92a77, MIT, LICENSE in this folder), without its always-on startup hook.

## Overview

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness


## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
