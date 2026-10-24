---
id: skill-gerar-teste-automatizado
lang: de
source_hash: 866037e1feec
title: Skill: gerar-teste-automatizado
aliases: [gerar-teste-automatizado]
---

## What it is
Der Skill, der die automatisierte Testsuite, die echte Fehler jagt, in einem Projekt anlegt und später aktualisiert.

## What it does
Anlegen-Modus (noch kein `docs/TESTES-AUTOMATIZADOS.md`): eine vollständige Diagnose des Codes, eine an die Anforderungen gebundene Testmatrix, Tests, deren erwartete Ergebnisse vom Code unabhängig sind, dann Prüfungen, ob die Tests Fehler erkennen (Mutationstests, Abdeckung, wiederholte Läufe). Aktualisieren-Modus: liest die Aufzeichnung und die Suite, findet, was sich seit dem genannten Commit geändert hat, und bringt beide auf den Stand. Er ändert nie Produktionscode, damit Tests bestehen, und schlägt jede Korrektur getrennt vor.

## How it does it
Eine `SKILL.md` in `~/.claude/skills/gerar-teste-automatizado`, nach einer Anweisung von Giovanni. Die Aufzeichnung `docs/TESTES-AUTOMATIZADOS.md` ist die Markierung, dass die Suite existiert.

## Where it sits in the pipeline
Wird von [[skill-revisao-manutencao]] in Schritt 4 jeder Überprüfung aufgerufen.

## Who receives its output
Giovanni (gefundene Fehler, Restrisiken) und die Testordner des Projekts.
