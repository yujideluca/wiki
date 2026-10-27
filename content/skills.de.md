---
id: skills
lang: de
source_hash: f49491d6a071
title: Skills
---

## What it is
Eine Skill ist ein gepacktes Set von Anweisungen, das Claude lädt, wenn eine Aufgabe dieser Art ansteht ([Dokumentation zu Skills](https://docs.claude.com/en/docs/claude-code/skills)). Man kann sie sich als Kapitel eines Rezeptbuchs vorstellen, das Claude nur liest, wenn die Anfrage passt: ein Kapitel zum Korrigieren von Deutsch, eines zum Debuggen, eines zur Laptop-Reparatur. Jede Skill ist ein Ordner mit einer Datei `SKILL.md`: zuerst ein Name, dann eine „Beschreibung“, die entscheidet, wann die Skill geladen wird, dann die Anweisungen. Giovannis Skills liegen in `~/.claude/skills`; die Claude-App hat eigene Kopien ([[claude-ai-skills]]).

## Flow
trigger t1: Giovanni bittet um eine Aufgabe | [[giovanni]]
step s1: Claude sieht immer die Liste der Skill-Namen und -Beschreibungen | [[claude-code]]
decide d1: Passt die Anfrage zu einer Beschreibung?
step s2: Claude arbeitet ohne Skill
step s3: Claude lädt den vollen Text dieses Skills
step s4: Claude folgt seinen Anweisungen
trigger t2: Giovanni möchte einen neuen oder überarbeiteten Skill
step s5: skill-forge baut und testet ihn | [[skill-skill-forge]]
step s6: Er wird als Ordner mit einer SKILL.md in ~/.claude/skills gespeichert
product p1: Eine Aufgabe, so erledigt, wie Giovanni sie will
product p2: Ein neuer Skill, mit eigener Wiki-Seite
product p3: Getrennte Kopien für die Claude-App | [[claude-ai-skills]]

t1 -> s1
s1 -> d1
d1 -ja-> s3
d1 -nein-> s2
s3 -> s4
s4 -> p1
s2 -> p1
t2 -> s5
s5 -> s6
s6 -> p2
s6 -> p3

## What it does
Die Skills halten fest, wie Giovanni wiederkehrende Aufgaben erledigt haben will: Deutschtraining, klinische Antworten, Bewertung wissenschaftlicher Artikel, Bewerbungen in Deutschland, Magic: The Gathering, sichere Browser-Automatisierung, Laptop-Reparatur und der Entwicklungsprozess (Brainstorming, Debugging, Verifikation, Wartungs-Reviews, Testerstellung und Skill-Bau). Jede Skill hat eine Seite in diesem Wiki, die ihre eigene Definition enthält, sodass man die Datei `SKILL.md` nie öffnen muss, um sie zu verstehen.

## How it does it
Claude sieht in jedem Chat die Liste der Namen und Beschreibungen; passt eine Anfrage zu einer Beschreibung, lädt es den vollen Text dieser Skill und folgt ihm. Neue oder neu gebaute Skills laufen durch [[skill-skill-forge]]. Der Ordner wurde einst von der stillgelegten Pipeline gefüllt ([[retired-workflow-pipeline]]); die Skills sind jetzt gewöhnliche Ordner.

## Where it sits in the pipeline
Neben jeder Aufgabe: Eine Skill wird von der Claude-Instanz geladen, wenn ihre Beschreibung zur Anfrage passt.

## Who receives its output
[[claude-code]], der [[remote-assistant]] und, über ihre Kopien, die [[claude-app]].

## Notes
- [[skill-brainstorming]]
- [[skill-systematic-debugging]]
- [[skill-verification-before-completion]]
- [[skill-adb-android-control]]
- [[skill-skill-forge]]
- [[skill-wiki-page-writer]]
- [[skill-revisao-manutencao]]
- [[skill-gerar-teste-automatizado]]
- [[skill-alemao-goethe-fsp]]
- [[skill-consulta-clinica]]
- [[skill-analise-artigo-cientifico]]
- [[skill-candidatura-alemanha]]
- [[skill-bias-risk-triage]]
- [[skill-browser-automacao-segura]]
- [[skill-click-protocol]]
- [[skill-minimize-site-approvals]]
- [[skill-ligamagic-listas]]
- [[skill-ligamagic-replicar-carrinho-nas-lojas]]
- [[skill-regras-magic]]
- [[skill-reparo-kubuntu]]

Die 20 lokal gepflegten Skills haben getrennte installierte Kopien für Claude und Codex unter `~/.claude/skills` und `~/.agents/skills`. Ihre Seiten enthalten beide vollständigen ursprünglichen `SKILL.md`-Dateien in Notes neben den übersetzten Erklärungen. Dazu gehören die gesamte Beschreibung im Kopf und alle Anweisungen statt nur einer Zusammenfassung der Auslöser. Zusätzliche Referenzdateien sind nicht eingebettet. Die Regel für vollständige Quellen und ihre Prüfungen stehen in [[wiki-content]] und [[wiki-skill-source]].


Die Codex-Anpassungen liegen in [[codex-skills]] und werden durch [[codex-skillsctl]] installiert. Dokument-Skills des Anbieters bleiben bei diesem. Die folgende Liste erfasst jede Codex-Anpassung mit vollständiger Quelle.

| Skill | Version |
|---|---|
| [[skill-adb-android-control]] | Codex |
| [[skill-alemao-goethe-fsp]] | Codex |
| [[skill-analise-artigo-cientifico]] | Codex |
| [[skill-bias-risk-triage]] | Codex |
| [[skill-brainstorming]] | Codex |
| [[skill-browser-automacao-segura]] | Codex |
| [[skill-candidatura-alemanha]] | Codex |
| [[skill-click-protocol]] | Codex |
| [[skill-consulta-clinica]] | Codex |
| [[skill-deutsch-gespraech-memory]] | Codex |
| [[skill-gerar-teste-automatizado]] | Codex |
| [[skill-google-workspace]] | Codex |
| [[skill-gui-code-protocol]] | Codex |
| [[skill-import-memory]] | Codex |
| [[skill-ligamagic-listas]] | Codex |
| [[skill-ligamagic-replicar-carrinho-nas-lojas]] | Codex |
| [[skill-minimize-site-approvals]] | Codex |
| [[skill-morning]] | Codex |
| [[skill-regras-magic]] | Codex |
| [[skill-reparo-kubuntu]] | Codex |
| [[skill-revisao-manutencao]] | Codex |
| [[skill-setup-writing-style]] | Codex |
| [[skill-skill-forge]] | Codex |
| [[skill-systematic-debugging]] | Codex |
| [[skill-verification-before-completion]] | Codex |
| [[skill-wiki-page-writer]] | Codex |
