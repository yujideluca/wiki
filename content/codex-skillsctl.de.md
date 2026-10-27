---
id: codex-skillsctl
title: Codex skills manager
lang: de
source_hash: dd1e7dce10e9
---

## What it is
Ein Python-Befehl zum Prüfen, Installieren und Wiederherstellen der Skill-Dateien in [[codex-skills]]. Er verwaltet Dateien und Verknüpfungen; er führt die Skills nicht aus.

## Architecture
### Kontext
person g: Giovanni — führt Prüfungen und Installationen aus | [[giovanni]]
system s: skillsctl — prüft, installiert und stellt Skill-Dateien wieder her
external r: codex-skills-Repository — die angepassten Skills | [[codex-skills]]
external c: Claude-Skills — die Originale, nur lesbar | [[skills]]
external x: Codex — findet die installierten Links | [[codex]]

g -führt aus-> s
s -verwaltet die Skills in-> r
s -vergleicht mit-> c
s -installiert Links für-> x

### Container
person g: Giovanni | [[giovanni]]
container cm: Befehle — prüfen, Abweichungen melden, installieren, zurücknehmen
store sr: Quell-Basislinien — genaue Kopien der Claude-Skills
store mf: Manifest — Fingerabdrücke der Dateien
store sk: Angepasste Skills — die 26, die Codex gehören
store bk: Sicherungen — vor jeder Installation angelegt
external lv: Skill-Links, die Codex finden kann | [[codex]]

g -führt aus-> cm
cm -vergleicht mit-> sr
cm -speichert Fingerabdrücke im-> mf
cm -prüft-> sk
cm -legt an-> bk
cm -installiert Links in-> lv

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
