---
id: codex-skills
title: Codex skills
lang: de
source_hash: eb3b95269d69
---

## What it is
Ein privates Repository mit eigenen Codex-Anpassungen von Giovannis Claude-Skills. Ein Skill ist eine gespeicherte Anleitung, die bei einer passenden Anfrage geladen wird. Das Projekt erhält die Claude-Originale und pflegt eigene Codex-Anweisungen.

## Flow
trigger t1: Ein Claude-Skill ändert sich | [[skills]]
step s1: codex-skillsctl vergleicht die Quelle mit dem gespeicherten Fingerabdruck | [[codex-skillsctl]]
decide d1: Hat sich die Quelle geändert?
step s2: Meldet die Änderung, ohne die Codex-Anpassung zu überschreiben
step s3: Die Anpassung und ihre Basis werden von Hand aktualisiert
step s4: Das Quality Gate läuft bei jedem Push zu GitHub
step s5: codex-skillsctl installiert die Anpassungen, umkehrbar
trigger t2: Giovanni bittet Codex um eine Aufgabe, die zu einer Skill-Beschreibung passt
step s6: Codex liest die installierte Anpassung
product p1: Nichts zu tun: Anpassungen bleiben, wie sie sind
product p2: Aktuelle Anpassungen mit frischen Fingerabdrücken
product p3: Das Aufgabenergebnis oder ein Bericht über eine fehlende Fähigkeit

t1 -> s1
s1 -> d1
d1 -ja-> s2
d1 -nein-> p1
s2 -> s3
s3 -> s4
s4 -> s5
s4 -> p2
s5 -> s6
t2 -> s6
s6 -> p3

## What it does
Enthält 26 Anpassungen, vollständige Ausgangsquellen und Fingerabdrücke der Dateien. Ein Fingerabdruck ist ein berechneter Wert, der Änderungen erkennt. Änderungen an der Quelle werden gemeldet, ohne die Anpassungen zu überschreiben. Anbieter-Skills für Dokumente bleiben bei ihrem bisherigen Eigentümer.

## How it does it
Repository: `yujideluca/codex-skills`; Ordner: `~/dev/codex-skills`. Python prüft und installiert über [[codex-skillsctl]] mit Rücknahmefunktion. Die Qualitätsprüfung entscheidet, ob eine Änderung besteht: `tools/quality_gate.sh`. GitHub führt sie bei jeder Veröffentlichung von Änderungen aus. Einstieg: README.md und AGENTS.md.

## Where it sits in the pipeline
Claude-Quellordner gehen in die manuelle Prüfung ein; danach installiert das Werkzeug die Codex-Skills. [[skills]] listet die Anweisungen.

## Who receives its output
Codex liest die installierten Skills. Die nutzende Person erhält Ergebnisse und Hinweise auf fehlende Fähigkeiten.

## Notes

Die Befehle und Rücknahme stehen in README.md. Installationsbelege bleiben außerhalb der Versionsverwaltung. Fehlende Browser-, Google- oder Planungsfunktionen bleiben ausdrückliche Grenzen.

[[skill-adb-android-control]], [[skill-alemao-goethe-fsp]], [[skill-analise-artigo-cientifico]], [[skill-bias-risk-triage]], [[skill-brainstorming]], [[skill-browser-automacao-segura]], [[skill-candidatura-alemanha]], [[skill-click-protocol]], [[skill-consulta-clinica]], [[skill-deutsch-gespraech-memory]], [[skill-gerar-teste-automatizado]], [[skill-google-workspace]], [[skill-gui-code-protocol]], [[skill-import-memory]], [[skill-ligamagic-listas]], [[skill-ligamagic-replicar-carrinho-nas-lojas]], [[skill-minimize-site-approvals]], [[skill-morning]], [[skill-regras-magic]], [[skill-reparo-kubuntu]], [[skill-revisao-manutencao]], [[skill-setup-writing-style]], [[skill-skill-forge]], [[skill-systematic-debugging]], [[skill-verification-before-completion]], [[skill-wiki-page-writer]]


Der nur lesende Befehl `doctor` prüft installierte Skill-Verknüpfungen, doppelte Namen und Änderungen an der Quelle. Ein doppelter Name bedeutet, dass zwei verfügbare Anleitungspakete gleich heißen. Eine Quellenänderung bedeutet, dass aktuelle Claude-Dateien von der gespeicherten Ausgangsversion abweichen. Die ausdrückliche Einstellung `prefer_bundled` wählt den mit Codex gelieferten skill-creator und bewahrt die verdeckende Codex-Kopie in einer Sicherung für die Rücknahme auf. Zuerst wird geprüft, ob der Ersatz vorhanden ist. Prüfung und offene Vorschläge zur Wiederherstellung und Dokumentanbindung stehen in `codex-skills:docs/WORKFLOW-AUDIT.md`.
