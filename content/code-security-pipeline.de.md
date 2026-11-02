---
id: code-security-pipeline
lang: de
source_hash: 2a30c6f89789
title: Code-Struktur und Sicherheits-Pipeline (hier beginnen)
---

## What it is
Dies ist der Einstiegsknoten einer kleinen Gruppe von Seiten, die erklären, wie Giovannis Software gebaut und geschützt wird. Jedes Projekt folgt demselben Rezept: ein festes Ordnerlayout ([[repository-layout]]), ein Skript, das entscheidet, ob der Code besteht ([[quality-gate-explained]]), automatische Prüfungen bei jedem Hochladen ([[ci-explained]]), schriftlich festgehaltene Entscheidungen ([[adr-explained]]) und ein Sicherheitsnetz gegen verlorene Geheimnisse ([[security-layers]]). Die folgenden Seiten erklären jede Idee von Grund auf und listen dann die Prüfer und Regeln jedes einzelnen Projekts auf.

## Flow
trigger t1: Jemand ändert Code und pusht ihn | [[branch-protection-explained]]
step s1: Die lokale Pre-Push-Prüfung führt das Gate aus, bevor main gepusht wird | [[branch-protection-explained]]
step s2: Automatische Prüfungen auf GitHub führen dasselbe Gate aus | [[ci-explained]]
step s3: Das Gate führt Tests, Anforderungs-Tags, Mutation und Größenlimits aus | [[quality-gate-explained]]
step s4: Die Geheimnis-Scanner suchen nach Schlüsseln, Tokens und persönlichen Daten | [[security-layers]]
decide d1: Schlägt irgendeine Prüfung fehl?
step s5: Push oder Merge wird gestoppt und die Änderung korrigiert
step s6: Die Änderung wird angenommen und jede strukturelle Entscheidung als Eintrag festgehalten | [[adr-explained]]
product p1: Eine Änderung, die alle Projektprüfungen bestanden hat | [[checker-catalog]]
product p2: Eine blockierte Änderung mit Name der fehlgeschlagenen Prüfung

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -yes-> s5
d1 -no-> s6
s5 -> p2
s6 -> p1

## What it does
Sie gibt einem neuen Leser eine Karte in drei Schichten. Schicht 1 erklärt die gemeinsamen Ideen: [[ci-explained]], [[adr-explained]], [[quality-gate-explained]], [[branch-protection-explained]] und [[security-layers]]. Schicht 2 ist die gemeinsame Struktur: [[repository-layout]] und die vollständige Liste der Prüfer in [[checker-catalog]]. Schicht 3 ist eine Seite pro Projekt mit den Prüfern und Regeln, die nur dieses Projekt hat: [[checks-quizapp]], [[checks-quizweb]], [[checks-wiki]], [[checks-workflow-memory]], [[checks-pipeline-check]], [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-remote-terminal]], [[checks-processing-sketches]], [[checks-radiology-crawler]], [[checks-status-quo]] und [[checks-project-template]].

## How it does it
Das gemeinsame Rezept liegt in [[project-template]]; das Messprogramm [[pipeline-check]] liegt in einem eigenen Repository, und jedes Projekt legt eine Version davon fest. Der Prozess darum ist in [[maintenance-pipeline]] und [[maintenance-policy]] beschrieben.

## Where it sits in the pipeline
Sie steht über den Projektseiten und neben [[system-overview]], das das ganze System zeigt statt nur den Engineering-Teil.

## Who receives its output
[[giovanni]] und jede Claude-Sitzung, die wissen muss, welche Prüfung was schützt.

## Steps
1. Eine Änderung wird gepusht. Akteur: Giovanni oder eine Claude-Sitzung. Ergebnis: ein Commit auf einem Branch.
2. Der Pre-Push-Hook auf dem Laptop führt das Projekt-Gate aus, bevor `main` gepusht wird. Ergebnis: ein gestoppter oder erlaubter Push.
3. GitHub Actions führt dasselbe Gate aus. Ergebnis: ein grünes oder rotes Zeichen und eine `report.json` für Projekte, die [[pipeline-check]] nutzen.
4. Das Gate führt die Tests und Prüfer des Projekts aus (siehe [[checker-catalog]]). Ergebnis: bestanden oder die erste fehlgeschlagene Prüfung.
5. Geheimnis- und Datenschutz-Scanner laufen im Gate oder beim Veröffentlichen von Inhalten ([[security-layers]]). Ergebnis: eine Ablehnung, die die Art des Geheimnisses nennt, nie seinen Wert.
6. Eine strukturelle Entscheidung wird ein ADR (Architecture Decision Record) und eine Zeile im Entscheidungslog ([[adr-explained]]). Ergebnis: eine Datei in `docs/adr/`.
