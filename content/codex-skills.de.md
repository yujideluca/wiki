---
id: codex-skills
title: Codex skills
lang: de
source_hash: 674c2db2650d
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

## Architecture
### Kontext
person g: Giovanni — prüft jede Anpassung | [[giovanni]]
system s: codex-skills — Codex' eigene angepasste Skills
external c: Claude-Skills — die Originale, nur lesbar | [[skills]]
external x: Codex — findet und lädt die Skills | [[codex]]

g -passt von Hand an-> s
c -wird als Schnappschuss kopiert nach-> s
s -installiert Skills für-> x

### Container
person g: Giovanni | [[giovanni]]
store sr: sources/ — genaue Schnappschüsse der Claude-Skills
store mf: manifest.json — Fingerabdrücke, Quellpfade, Grenzen
store sk: skills/ — die angepassten Skills, die Codex gehören
container ct: skillsctl — prüft, meldet Abweichungen, installiert, macht rückgängig | [[codex-skillsctl]]
external lv: Skill-Links, die Codex finden kann | [[codex]]

g -passt an-> sk
g -führt aus-> ct
ct -vergleicht mit-> sr
ct -speichert Fingerabdrücke in-> mf
ct -prüft-> sk
ct -installiert mit Sicherungen-> lv

## What it does
Enthält 26 Anpassungen, vollständige Ausgangsquellen und Fingerabdrücke der Dateien. Ein Fingerabdruck ist ein berechneter Wert, der Änderungen erkennt. Änderungen an der Quelle werden gemeldet, ohne die Anpassungen zu überschreiben. Anbieter-Skills für Dokumente bleiben bei ihrem bisherigen Eigentümer.

## How it does it
Repository: `yujideluca/codex-skills`; Ordner: `~/dev/codex-skills`. Python prüft und installiert über [[codex-skillsctl]] mit Rücknahmefunktion. Die Qualitätsprüfung entscheidet, ob eine Änderung besteht: `tools/quality_gate.sh`. GitHub führt sie bei jeder Veröffentlichung von Änderungen aus. Einstieg: README.md und AGENTS.md.

## Where it sits in the pipeline
Claude-Quellordner gehen in die manuelle Prüfung ein; danach installiert das Werkzeug die Codex-Skills. [[skills]] listet die Anweisungen.

## Who receives its output
Codex liest die installierten Skills. Die nutzende Person erhält Ergebnisse und Hinweise auf fehlende Fähigkeiten.

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Prinzipien
1. **Codex besitzt die Anpassungen**: Die Claude-Originale sind nur lesbare Eingaben, werden nie automatisch zusammengeführt und nie als gültige Anweisungen gelesen.
2. **Nichts wird ungeprüft installiert**: `skillsctl check` prüft jeden Skill, und die Installation legt Sicherungen an, die sich zurückspielen lassen.
3. **Anforderung, dann Test, dann Code**: Tests tragen `REQ CS-N`, geprüft vom Rückverfolgbarkeitsschritt des Gates.
4. **Das Gate entscheidet**: `tools/quality_gate.sh` ist die einzige Definition von „bestanden“, und die kontinuierliche Integration führt es aus.

### Entscheidungen
Drei Architekturentscheidungsprotokolle (kurze Notizen, die die Gründe einer Entscheidung bewahren) in `docs/adr/`: 0002 Anpassungen im Besitz von Codex mit ausdrücklicher Fähigkeitserkennung; 0003 ein Programm misst und ein Skill urteilt. `DESIGN.md` enthält das Diagramm und das Entscheidungsprotokoll.

### Anforderungen
8 Anforderungen (Präfix CS) in `docs/REQUIREMENTS.md`. Jede hat einen Test mit dem Tag `REQ CS-N`, und die Rückverfolgbarkeitsprüfung ([[check-traceability]]) schlägt fehl, wenn eine keinen hat.

### Quality Gate
Das Gate führt `skillsctl check` aus; die Unit-Tests; eine Mutationsprüfung (absichtlich eingebaute Fehler müssen auffallen); die Rückverfolgbarkeit der Anforderungen; und die Fitnessfunktionen.

### Kontinuierliche Integration
Kontinuierliche Integration (CI) heißt automatische Prüfungen bei jedem Push. Der Workflow `quality-gate.yml` führt das Gate bei jedem Push auf GitHub aus, über `pipeline-check`, festgelegt in `pipeline-check.version`.

### Wartung
Technische Schulden werden als GitHub-Issues mit dem Label `debt` (P1 bis P3) nach der [[maintenance-policy]] geführt. Die [[monthly-architecture-review]] prüft das Projekt jeden Monat; die nächste ist am 22.11.2026 fällig.

## Notes

Die Befehle und Rücknahme stehen in README.md. Installationsbelege bleiben außerhalb der Versionsverwaltung. Fehlende Browser-, Google- oder Planungsfunktionen bleiben ausdrückliche Grenzen.

[[skill-adb-android-control]], [[skill-alemao-goethe-fsp]], [[skill-analise-artigo-cientifico]], [[skill-bias-risk-triage]], [[skill-brainstorming]], [[skill-browser-automacao-segura]], [[skill-candidatura-alemanha]], [[skill-click-protocol]], [[skill-consulta-clinica]], [[skill-deutsch-gespraech-memory]], [[skill-gerar-teste-automatizado]], [[skill-google-workspace]], [[skill-gui-code-protocol]], [[skill-import-memory]], [[skill-ligamagic-listas]], [[skill-ligamagic-replicar-carrinho-nas-lojas]], [[skill-minimize-site-approvals]], [[skill-morning]], [[skill-regras-magic]], [[skill-reparo-kubuntu]], [[skill-revisao-manutencao]], [[skill-setup-writing-style]], [[skill-skill-forge]], [[skill-systematic-debugging]], [[skill-verification-before-completion]], [[skill-wiki-page-writer]]


Der nur lesende Befehl `doctor` prüft installierte Skill-Verknüpfungen, doppelte Namen und Änderungen an der Quelle. Ein doppelter Name bedeutet, dass zwei verfügbare Anleitungspakete gleich heißen. Eine Quellenänderung bedeutet, dass aktuelle Claude-Dateien von der gespeicherten Ausgangsversion abweichen. Die ausdrückliche Einstellung `prefer_bundled` wählt den mit Codex gelieferten skill-creator und bewahrt die verdeckende Codex-Kopie in einer Sicherung für die Rücknahme auf. Zuerst wird geprüft, ob der Ersatz vorhanden ist. Prüfung und offene Vorschläge zur Wiederherstellung und Dokumentanbindung stehen in `codex-skills:docs/WORKFLOW-AUDIT.md`.
