---
id: wiki-skill-source
lang: de
source_hash: 0af807178e15
title: Prüfer für vollständige Skill-Quellen
---

## What it is
`Wiki.Content.SkillSource` ist das Elixir-Modul, das prüft, ob eine Skill-Seite ihre vollständigen ursprünglichen Anweisungsdateien enthält. Ein Skill ist ein Paket mit Anweisungen für eine Art von Aufgabe. Seine `SKILL.md` enthält die Beschreibung für die Auswahl und die danach befolgten Anweisungen.

## What it does
Es verlangt eine vollständige Kopie jeder `SKILL.md` in den `sources` einer Skill-Seite. Es prüft den SHA-256-Fingerabdruck (einen aus dem gesamten Text berechneten Wert, der Änderungen erkennbar macht), Beschreibung und Anweisungen sowie identische Originale in beiden Übersetzungen. Im lokalen Modus liest es auch die installierten Dateien und vergleicht den gesamten Text. Fehler verhindern die Veröffentlichung. Ohne lokale Dateien kann der Fingerabdruck die Aktualität nicht nachweisen.

## How it does it
Der Verfasser sucht und liest zuerst die Quelle nach [[skill-wiki-page-writer]]. Er kopiert das Original in Notes in einen Codeblock mit der Kennzeichnung `skill-source <repo:path/to/SKILL.md> <sha256>`. Die Begrenzung ist länger als jede Folge von Backticks im Original. Zeilenenden werden zu LF, und nur bei Bedarf wird ein abschließender Zeilenumbruch ergänzt. Der Parser bewahrt Quellüberschriften und verschachtelte Beispiele als Text. Übersetzungen behalten die Originale in ihrer Ausgangssprache. Zusätzliche Referenzdateien werden nicht automatisch übernommen. Die Datenschutzprüfung liest weiterhin den gesamten kopierten Text.

## Where it sits in the pipeline
[[wiki-check]] ruft es für Skill-Seiten auf. Die Erinnerung des [[wiki-hook-stop]] verweist auf diese Regel, die in [[wiki-content]] und der `AGENTS.md` des Projekts steht.

## Who receives its output
[[wiki-check]] erhält die Fehler; [[wiki-cli]] verweigert die Veröffentlichung von Seiten, die die Prüfung nicht bestehen.

## Functions
- `check`: prüft eine Skill-Seite und ihre Übersetzungen; liest installierte Originale nur im lokalen Modus.

## Notes

Eine Skill-Seite ist am Kopffeld `kind: skill` erkennbar. `wiki check --local` aktiviert den lokalen Modus, der installierte Quelldateien liest; eine unlesbare Datei ist ein Fehler. Ein Pfad wie `home:.agents/skills/example/SKILL.md` beginnt im persönlichen Ordner des Benutzers; `wiki:path` beginnt in `~/dev/wiki`, und andere Repository-Namen beginnen im entsprechenden Ordner unter `~/dev`. Kopien gehören unter die Seitenüberschrift `## Notes`. Die Übersetzungen sind `<id>.de.md` (Deutsch) und `<id>.pt-BR.md` (brasilianisches Portugiesisch); eine fehlende Übersetzung ist ein Fehler im gesamten Prüfer. LF bedeutet Line Feed, das Zeilenumbruchzeichen des kopierten Textes. Datenschutzprüfungen weisen Geheimnisse und Kontaktdaten anderer Menschen auch innerhalb der Quellkopien zurück. Prüfungen ohne `--local` lesen keine installierten Originale und geben bei passenden Fingerabdrücken keine Warnung zur Aktualität aus; ein Erfolg in diesem Modus allein weist die Aktualität nicht nach.
