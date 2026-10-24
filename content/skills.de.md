---
id: skills
lang: de
source_hash: 22aaae483c68
title: Skills
---

## What it is
Eine Skill ist ein gepacktes Set von Anweisungen, das Claude lädt, wenn eine Aufgabe dieser Art ansteht ([Dokumentation zu Skills](https://docs.claude.com/en/docs/claude-code/skills)). Man kann sie sich als Kapitel eines Rezeptbuchs vorstellen, das Claude nur liest, wenn die Anfrage passt: ein Kapitel zum Korrigieren von Deutsch, eines zum Debuggen, eines zur Laptop-Reparatur. Jede Skill ist ein Ordner mit einer Datei `SKILL.md`: zuerst ein Name, dann eine „Beschreibung“, die entscheidet, wann die Skill geladen wird, dann die Anweisungen. Giovannis Skills liegen in `~/.claude/skills`; die Claude-App hat eigene Kopien ([[claude-ai-skills]]).

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
