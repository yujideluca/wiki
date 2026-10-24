---
id: wiki-content
lang: de
source_hash: 0f8ca2dbbce9
title: Wiki-Inhalt (Markdown-Seiten)
---

## What it is
Das sind die Seiten selbst: die Quelle der Wahrheit dieses Wikis. Es gibt eine [Markdown](https://en.wikipedia.org/wiki/Markdown)-Datei (eine Textdatei mit einfachen Zeichen für Überschriften, Listen und Links) pro Konzept im Ordner `content/`, auf Englisch, mit einer deutschen Fassung `<id>.de.md` und einer brasilianisch-portugiesischen `<id>.pt-BR.md`. Zwei weitere Dateien enthalten Einstellungen: `_kinds.json`, die offene Liste der Seitenarten und ihrer Farben, und `_acronyms.tsv`, die Liste der Akronyme, deren erste Verwendung auf einer Seite mit dem vollen Namen kommen muss.

## What it does
Jede Seite hat einen Kopf (`id, title, aliases, kind, project, status, location, fed_by, feeds, sources, memory, since, until, reviewed`) und feste Abschnitte: What it is, What it does, How it does it, Where it sits in the pipeline, Who receives its output, dazu optional Steps (für Abläufe und Skills), Functions und Notes.

Die Schreibregeln sind: Jede Seite muss für jemanden verständlich sein, der nichts über das System weiß; ein Fachbegriff wird dort definiert, wo er zum ersten Mal vorkommt, und verlinkt, wenn er komplex ist, auf eine Definition (eine externe Quelle oder das [[glossary]]); ein Akronym wird bei der ersten Verwendung auf jeder Seite ausgeschrieben; und eine Skill-Seite trägt die eigene Definition der Skill in ihrem Abschnitt Steps, sodass die Seite genügt, um die Skill zu verstehen.

## How it does it
Links zwischen Seiten werden `[[id]]` geschrieben. Die Kopfzeilen `fed_by` und `feeds` sind die Pipeline-Kanten (was was speist) und müssen in beide Richtungen übereinstimmen. `sources` werden `repo:path` geschrieben, damit eine Codeänderung die Seite als veraltet markieren kann. Eine Übersetzung speichert einen Hash (einen kurzen Fingerabdruck) des englischen Textes, aus dem sie entstand, sodass eine veraltete Übersetzung erkannt wird. Seiten sagen, was es gibt; Regeln und Vorlieben liegen im Gedächtnis und werden über ihren `#code` verlinkt.

## Where it sits in the pipeline
Von [[claude-code]] am Ende jeder Aufgabe geschrieben ([[end-of-task]]); von [[wiki-check]] geprüft; von [[wiki-build]] in Daten verwandelt.

## Who receives its output
[[wiki-check]] und [[wiki-build]].
