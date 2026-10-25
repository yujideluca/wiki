---
id: codex-skills
title: Codex skills
lang: de
source_hash: 27523d052fcf
---

## What it is
Ein privates Repository mit eigenen Codex-Anpassungen von Giovannis Claude-Skills. Ein Skill ist eine gespeicherte Anleitung, die bei einer passenden Anfrage geladen wird. Das Projekt erhält die Claude-Originale und pflegt eigene Codex-Anweisungen.

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
