---
id: skill-systematic-debugging
lang: de
source_hash: dc8e53a458be
title: Skill: systematic-debugging
---

## What it is
Die Skill „systematic-debugging“ ist die Disziplin, der Claude bei jedem Bug, Testfehler, Absturz oder unerwarteten Verhalten folgt (in Code, Skripten, der Sync-Pipeline oder einer App auf dem Handy), bevor es einen Fix vorschlägt: zuerst die Grundursache finden, jeweils nur eine Sache ändern und nach drei fehlgeschlagenen Fixes anhalten. Ihre Beschreibung sagt, dass sie nicht für die Reparatur des Kubuntu-Desktops gilt ([[skill-reparo-kubuntu]]). Sie wurde aus den Open-Source-Skills „superpowers“ (Version 7.0.0, MIT-Lizenz) angepasst, ohne deren dauerhaften Start-Hook. Ihre Rolle ist „Prozess“; sie verweist für Systemprobleme auf [[skill-reparo-kubuntu]], für das Festhalten einer dauerhaften Korrektur auf [[workflow-memory]] und auf die CLAUDE.md des Projekts.

## What it does
Sie verbietet Raten. Ihr Kernprinzip: immer die Grundursache finden, bevor man Fixes versucht; Symptom-Fixes sind ein Scheitern. Unter Zeitdruck, wenn ein Fix „offensichtlich“ scheint, oder nachdem ein erster Fix scheiterte, zählt der Prozess am meisten.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/systematic-debugging` (mit Zusatznotizen zu Ursachenverfolgung, Verteidigung in der Tiefe und bedingungsbasiertem Warten); Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Teil des Entwicklungsprozesses in Claude Code, in jedem Projekt benutzt.

## Who receives its output
Claude, während es repariert; der Fix läuft danach durch [[skill-verification-before-completion]].

## Steps
Das eiserne Gesetz: keine Fixes ohne vorherige Untersuchung der Grundursache. Vier Phasen, jede abgeschlossen, bevor die nächste beginnt.
1. **Phase 1, Grundursache.** Fehlermeldungen und Stack-Traces vollständig lesen (Zeilennummern, Dateipfade, Fehlercodes notieren). Das Problem zuverlässig reproduzieren: genaue Schritte, jedes Mal; ist es nicht reproduzierbar, mehr Daten sammeln statt zu raten. Letzte Änderungen prüfen (git diff, neue Abhängigkeiten, Konfiguration, Umgebung). In einem System mit mehreren Komponenten (etwa Continuous Integration (CI) → Build → Signierung) an jeder Grenze Diagnoseausgaben einfügen, einmal laufen lassen und sehen, wo die Daten falsch werden, bevor man diese Komponente untersucht. Schlechte Werte rückwärts durch die Aufrufkette bis zur Quelle verfolgen und an der Quelle beheben.
2. **Phase 2, Muster.** Ähnlichen funktionierenden Code in derselben Codebasis finden; jede Referenzimplementierung vollständig lesen; jeden Unterschied zwischen funktionierend und defekt auflisten, auch den kleinsten; Abhängigkeiten, Einstellungen und Annahmen verstehen.
3. **Phase 3, Hypothese.** Eine Hypothese formulieren („Ich glaube, X ist die Grundursache, weil Y“), aufschreiben, mit der kleinstmöglichen Änderung testen, jeweils eine Variable. Hat es funktioniert, weitermachen; wenn nicht, eine neue Hypothese bilden und nicht weitere Fixes darauf stapeln. Wo etwas nicht verstanden ist, das sagen.
4. **Phase 4, Umsetzung.** Zuerst einen fehlschlagenden Test schreiben, der den Bug reproduziert (ein automatischer Test im eigenen Setup des Projekts oder ein einmaliges Skript). Einen einzigen Fix für die Grundursache machen, ohne „wenn ich schon dabei bin“-Verbesserungen. Prüfen: Der Test besteht, nichts anderes ging kaputt, das Problem ist wirklich gelöst (mit [[skill-verification-before-completion]]).
5. **Drei fehlgeschlagene Fixes heißt Stopp.** Die Versuche zählen. Unter drei zu Phase 1 mit den neuen Informationen zurück. Bei drei oder mehr die Architektur hinterfragen: Zeigt jeder Fix neue Kopplung an anderer Stelle, braucht massives Refactoring oder erzeugt neue Symptome? Vor einem vierten Versuch mit Giovanni besprechen.
6. **Warnzeichen, die „zurück zu Phase 1“ bedeuten.** „Jetzt schnell fixen, später untersuchen“; „probier einfach X zu ändern“; mehrere Änderungen auf einmal; den Test überspringen; Fixes vorschlagen, bevor die Daten verfolgt wurden; „noch ein Versuch“ nach zwei Fehlschlägen. Giovannis Signale, dass es falsch läuft: „Is that not happening?“ (ohne Prüfung angenommen), „Stop guessing“, „We're stuck?“.
7. **Wenn es wirklich keine Grundursache gibt** (Umgebung, Timing, extern): dokumentieren, was untersucht wurde, eine Behandlung wie Wiederholung, Zeitlimit oder klare Fehlermeldung einbauen und Logging für die Zukunft ergänzen. Aber 95 % der Fälle „keine Grundursache“ sind unvollständige Untersuchungen.
