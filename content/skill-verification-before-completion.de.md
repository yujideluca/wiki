---
id: skill-verification-before-completion
lang: de
source_hash: af65dd9e3ccb
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
