---
id: wiki-content
lang: de
source_hash: 1a821c508079
title: Wiki-Inhalt (Markdown-Seiten)
---

## What it is
Das sind die Seiten selbst: die Quelle der Wahrheit dieses Wikis. Es gibt eine [Markdown](https://en.wikipedia.org/wiki/Markdown)-Datei (eine Textdatei mit einfachen Zeichen für Überschriften, Listen und Links) pro Konzept im Ordner `content/`, auf Englisch, mit einer deutschen Fassung `<id>.de.md` und einer brasilianisch-portugiesischen `<id>.pt-BR.md`. Drei weitere Dateien enthalten Einstellungen: `_kinds.json`, die offene Liste der Seitenarten und ihrer Farben; `_acronyms.tsv`, die Liste der Akronyme, deren erste Verwendung auf einer Seite mit dem vollen Namen kommen muss; und `_ignore.txt`, die Datenordner, die der Stop-Hook nicht Datei für Datei überwacht ([[wiki-hook-stop]]).

## What it does
Jede Seite hat einen Kopf (`id, title, aliases, kind, project, status, location, fed_by, feeds, sources, memory, since, until, reviewed`) und feste Abschnitte: What it is, What it does, How it does it, Where it sits in the pipeline, Who receives its output, dazu optional Steps (für Abläufe und Skills), Functions und Notes. Das Feld `reviewed` ist auf jeder Seite Pflicht: Es sagt, wann die Seite zuletzt mit ihren Quellen verglichen wurde, als Datum und Minute in UTC (koordinierte Weltzeit, überall dieselbe Uhrzeit), zum Beispiel `2026-10-24T18:30Z`, oder als bloßes Datum (der Beginn dieses Tages), und liegt nie in der Zukunft. Nur wer die Seite wirklich mit ihren Quellen verglichen hat, setzt es.

Die Schreibregeln sind: Jede Seite muss für jemanden verständlich sein, der nichts über das System weiß; ein Fachbegriff wird dort definiert, wo er zum ersten Mal vorkommt, und verlinkt, wenn er komplex ist, auf eine Definition (eine externe Quelle oder das [[glossary]]); ein Akronym wird bei der ersten Verwendung auf jeder Seite ausgeschrieben; und eine Skill-Seite trägt die eigene Definition der Skill in ihrem Abschnitt Steps, sodass die Seite genügt, um die Skill zu verstehen.

## How it does it
Links zwischen Seiten werden `[[id]]` geschrieben. Die Kopfzeilen `fed_by` und `feeds` sind die Pipeline-Kanten (was was speist) und müssen in beide Richtungen übereinstimmen. `sources` werden `repo:path` geschrieben, damit eine Quelle, die sich nach dem `reviewed`-Zeitpunkt der Seite geändert hat, die Seite als veraltet markiert ([[wiki-stale]]). Eine Übersetzung speichert einen Hash (einen kurzen Fingerabdruck) des englischen Textes, aus dem sie entstand, sodass eine veraltete Übersetzung erkannt wird. Seiten sagen, was es gibt; Regeln und Vorlieben liegen im Gedächtnis und werden über ihren `#code` verlinkt.

## Where it sits in the pipeline
Von [[claude-code]] am Ende jeder Aufgabe geschrieben ([[end-of-task]]); von [[wiki-check]] geprüft; von [[wiki-build]] in Daten verwandelt. Veröffentlicht wird mit `wiki publish`; die Sitzung übergibt ihre eigene Zeile `--co-author "Name <email>"` oder keine ([[wiki-cli]]).

## Who receives its output
[[wiki-check]] und [[wiki-build]].

## Notes

Bei einer Seite der Art `skill` sucht und liest der Verfasser zuerst die vollständige installierte `SKILL.md`. Die Seite behält ihre verständliche Erklärung und ihre Schritte und enthält danach in Notes die vollständige Originaldatei: Beschreibung im Kopf, alle Anweisungen, Beispiele, Grenzen und Referenzpfade. Getrennte Dateien für Claude und Codex werden getrennt kopiert. Die deutschen und portugiesischen Seiten behalten dieselben Originale mit Einleitungen in ihrer eigenen Sprache. Eine Zusammenfassung oder ein Link allein erfüllt diese Regel nicht. Zusätzliche Referenzdateien werden nicht automatisch übernommen. Jede Quelle steht in `sources`; ihre Kopie in einem Codeblock trägt einen SHA-256-Fingerabdruck (einen aus dem gesamten Text berechneten Wert, der Änderungen erkennbar macht). Die Kopie verwendet LF-Zeilenenden und ergänzt einen abschließenden Zeilenumbruch, wenn dieser fehlt. [[wiki-skill-source]] prüft die Kopien; `wiki check --local` vergleicht sie mit den installierten Dateien. Die Projektregel steht in `AGENTS.md`, wird aus `CLAUDE.md` verlinkt und in [[skill-wiki-page-writer]] sowie in der Erinnerung des [[wiki-hook-stop]] wiederholt.
