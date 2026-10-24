---
id: skill-wiki-page-writer
lang: de
source_hash: 215a442a613f
title: Skill: wiki-page-writer
---

## What it is
Der Skill „wiki-page-writer“ ist die Methode, nach der [[claude-code]] die Seiten dieses Wikis schreibt oder aktualisiert. Ein Skill ist ein Paket aus Anweisungen, das Claude lädt, wenn eine Anfrage zu seiner Beschreibung passt, damit eine Art von Aufgabe jedes Mal gleich sorgfältig erledigt wird (siehe [[skills]] und das [[glossary]]). Dieser hier deckt genau eine Aufgabe ab: das, was in Giovannis Systemen existiert, in wahre Seiten zu verwandeln, die ein Fremder versteht, auf Englisch, Deutsch und brasilianischem Portugiesisch.

## What it does
Er wird nach jeder Aufgabe benutzt, die etwas an den Systemen verändert hat, wenn der Stop-Hook (ein kleines Programm, das läuft, wenn Claude einen Durchgang beendet, siehe [[wiki-hook-stop]]) „Wiki update needed“ meldet, oder wenn Giovanni eine Wiki-Seite verlangt. Die Beschreibung nennt auch, wofür er nicht gedacht ist: allgemeine Enzyklopädie-Artikel, Code-Kommentare, `DESIGN.md`, Entscheidungsprotokolle und Memory-Einträge. Seine Rolle ist „Prozess“: Er besitzt den Inhalt der Seiten und der drei Sprachfassungen; er richtet sich nach den Regeln des Wikis in [[wiki-content]] und nach dem Prüfer [[wiki-check]], der sie durchsetzt; und er beachtet die Regel zur Antwortsprache und die Regel zur einfachen Sprache. Der Skill erzeugt Seiten in `~/dev/wiki/content`, veröffentlicht mit `wiki publish`.

## How it does it
Eine `SKILL.md`-Datei in `~/.claude/skills/wiki-page-writer`; Claude lädt sie, wenn eine Anfrage passt. Sie kopiert die Formatregeln nicht: Der Prüfer kennt sie und schlägt bei einem Verstoß fehl, daher sagt der Skill Claude, jedes Mal die aktuellen Regeln zu lesen, statt dem Gedächtnis zu trauen. Er wurde mit [[skill-skill-forge]] aus drei konkurrierenden Fassungen gebaut. Die siegreiche Fassung wurde an zwei echten Aufgaben (eine Seite für eine neue Datei und eine veraltete Seite) in einer Sandbox-Kopie des Wikis getestet; ein Leser ohne Vorwissen konnte danach Fragen zur neuen Seite beantworten, das ist der „Paraphrase-Test“ der einfachen Sprache.

## Where it sits in the pipeline
Er ist der Schreibschritt innerhalb von [[end-of-task]]: nachdem die Arbeit bewiesen ist ([[skill-verification-before-completion]]) und vor dem Memory-Bericht. [[skill-revisao-manutencao]] nutzt ihn für die Seiten, die eine Wartungsprüfung ändert, und [[skill-skill-forge]] nutzt ihn, um die Seite jedes neuen Skills zu schreiben.

## Who receives its output
Der Wiki-Inhalt ([[wiki-content]]), den [[wiki-check]] anschließend prüft.

## Steps
1. **Den Arbeitsbaum absichern.** Immer `git status` in `~/dev/wiki` ausführen. `wiki publish` übernimmt alles in `content/`; eine Änderung, die Claude nicht selbst gemacht hat (eine andere Claude-Sitzung oder Giovanni), darf es nie veröffentlichen. Fremde Änderungen in Seiten, die die Aufgabe nicht berührt: die Seiten schreiben, aber nicht veröffentlichen, und Giovanni Bescheid geben. Fremde Änderungen in Seiten, die die Aufgabe braucht: anhalten und fragen. Ein Prüfungsfehler, der von ihrer Änderung kommt, wird gemeldet, nicht behoben.
2. **Die aktuellen Regeln lesen.** Die `CLAUDE.md` des Wikis, die Seite [[wiki-content]], die Liste der Arten und die Liste der Akronyme lesen und einmal `wiki check --local` ausführen, um den Ausgangszustand zu sehen.
3. **Die Arbeit finden.** Aus der Anfrage oder aus `wiki stale` und der Hook-Meldung. Der Hook vergleicht den Code mit der letzten Veröffentlichung und kann deshalb Seiten melden, die `wiki stale` als aktuell ansieht; dann das `git log` des Quell-Repositorys seit der letzten Änderung der Seite lesen. Entscheiden, ob das Thema eine eigene Seite oder eine Zeile in einer Modulseite bekommt; eine bestehende Seite bearbeiten, statt ein Beinahe-Duplikat anzulegen.
4. **Vor dem Schreiben prüfen.** Jeder Satz stammt aus etwas, das in dieser Sitzung gelesen oder ausgeführt wurde: Code, Konfiguration, `git log`, Tests, ein echter Lauf. Alter Seitentext wird neu geprüft, weil festgelegte Versionen, Anforderungsbereiche und Dateinamen veralten. Was sich nicht prüfen lässt, wird als „not verified“ geschrieben oder weggelassen.
5. **Für einen Fremden schreiben.** Zuerst der Zweck in Alltagssprache, dann der Mechanismus; Präsens, Aktiv, kurze Wörter. Die erste Erwähnung eines Fachbegriffs, Werkzeugs, internen Namens oder Akronyms trägt seine Bedeutung (Akronyme mit vollem Namen) und einen Link zur Wiki-Seite, zum Glossar oder zu einer offiziellen Seite, die geöffnet wurde. Begriffe, die neue Leser am häufigsten übersehen (Gate, Anforderungs-Tag, Statuswörter, Namen von Konfigurationsdateien), werden auf jeder Seite erklärt, die sie benutzt.
6. **Die Seite formen.** Der Kopf und die fünf Abschnitte aus [[wiki-content]]; `fed_by` und `feeds` stimmen in beide Richtungen überein; jede Quelldatei steht in `sources`; eine neue Seite wird von mindestens zwei anderen verlinkt. Skill-Seiten halten die eigenen Regeln oder Schritte des Skills in einem Abschnitt `## Steps`; Prozessseiten listen ihre Schritte der Reihe nach auf.
7. **Privatsphäre wahren.** Keine Geheimnisse und keine Daten über andere Menschen.
8. **Verständlichkeit prüfen.** Die Seite lesen, als wüsste man nichts; bei einer neuen Seite beantwortet ein Leser ohne Vorwissen vier Fragen dazu, und jedes Wort, das er nicht erschließen konnte, wird behoben.
9. **Übersetzen.** Die deutschen und portugiesischen Seiten behalten die englischen Überschriften und Links, übersetzen den Text und die Definitionen und tragen den `source_hash` des englischen Textes.
10. **Prüfen und beheben.** `wiki check --local`, bis es besteht; die Prüfung nie lockern oder umgehen.
11. **Veröffentlichen.** `wiki publish -m "what changed"`. „review: no page change“ nur, nachdem die gemeldeten Seiten geprüft und für richtig befunden wurden.
12. **Abschließen.** `mem use` für die Memory-Einträge, die die Arbeit geprägt haben, dann eine kurze Antwort: geänderte Seiten, alles Ungeprüfte, die Ergebnisse von Prüfung und Veröffentlichung und eine Zeile `Verified by:`.

## Notes
- In Tests gefundene Grenzen: Die Regel zum Absichern musste „immer ausführen“ sagen, weil Läufer sie übersprangen, wenn sie einen sauberen Baum erwarteten; frische Leser übersahen noch einige Begriffe (Gate, Befundcodes), deshalb listet der Skill die üblichen Lücken auf.
- Bekannte Lücke: Die Wiki-Seite [[skills]] hat keine Registertabelle, obwohl [[skill-skill-forge]] sagt, eine zu aktualisieren.
