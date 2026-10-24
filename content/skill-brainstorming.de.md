---
id: skill-brainstorming
lang: de
source_hash: ed56aad52fa4
title: Skill: brainstorming
---

## What it is
Die Skill „brainstorming“ ist der Prozess, dem Claude folgt, bevor es etwas Neues in Software baut: Sie findet heraus, was Giovanni wirklich will und warum, bevor Code existiert. Ihre Beschreibung (der Text, der entscheidet, wann sie geladen wird) sagt: vor dem Bauen von etwas Neuem in Software oder in der claude-workflow-Pipeline verwenden (eine App-Funktion, ein Werkzeug, eine mehrstufige Änderung): klärende Fragen stellen, den Umfang einschätzen und Giovannis Freigabe einholen, bevor Code geschrieben wird. Nicht für Schreibaufgaben (Lebenslauf, Briefe, Deutschübungen), klinische Fragen oder das Erstellen von Skills ([[skill-skill-forge]]). Sie wurde aus den Open-Source-Skills „superpowers“ (Version 7.0.0, MIT-Lizenz) angepasst, ohne deren dauerhaften Start-Hook.

## What it does
Claude stellt jeweils eine offene Frage, spiegelt sein Verständnis zurück, bietet einen visuellen Begleiter an (einen Browser-Tab mit Entwürfen), wenn Sehen mehr hilft als Lesen, schätzt den Umfang ein (schnelle Aufgabe, kleine Änderung oder Projekt mit schriftlichem Entwurf), lässt einen frischen Prüfer den Entwurf lesen und blockiert das Bauen, bis Giovanni zustimmt. Seit 2026-10-22 fragt sie auch, welche Programmiersprache benutzt werden soll ([[work-ask-language]]).

## How it does it
Eine `SKILL.md` in `~/.claude/skills/brainstorming`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt. Die Rolle der Skill ist „Prozess“; sie verweist auf [[skill-skill-forge]] (neue Skills), [[skill-revisao-manutencao]] (Wartungs-Reviews sind keine Brainstormings) und die CLAUDE.md des Projekts und beachtet die Regel zur Antwortsprache sowie die Regel, jeden Begriff bei erster Verwendung zu definieren.

## Where it sits in the pipeline
Teil des Entwicklungsprozesses in Claude Code, in jedem Projekt benutzt; sie speist [[new-project]].

## Who receives its output
Giovanni (die Fragen und das Entwurfsdokument) und der anschließende Bau.

## Steps
1. **Fragen, was bekannt ist.** Vor der Antwort fragt sich Claude, was es darüber weiß, was Giovanni will und warum. Steht alles Wichtige in der Anfrage („mach das Symbol kornblumenblau“), ist es eine schnelle, klare Aufgabe: erledigen und sagen, was getan wurde. Fehlt etwas Nicht-Triviales, beginnt das Gespräch.
2. **Erste Nachricht, zwei Teile.** Eine Zeile, dass Giovanni die Fragen überspringen und Claude einfach starten lassen kann (dann ist die Skill fertig, nachdem jede wesentliche Wahl wie Plattform oder Sprache in einer schlichten Zeile genannt wurde); und eine offene Frage, die Giovanni einen echten Moment oder ein konkretes Bild beschreiben lässt.
3. **Gespräch.** Jede Nachricht endet mit einer Frage (ein Satz, keine Liste von Beispielantworten), in einfacher Sprache knapp über Giovannis Niveau. Offene Fragen kommen zuerst; kurze Auswahllisten nur, wenn Giovanni nicht weiterkommt. Bei „rate einfach“ etwas Konkretes vorschlagen.
4. **Wie es gemacht wird.** Früh herausfinden, welche Entscheidungen über Medium, Werkzeuge und Material Giovanni selbst treffen will und welche er abgibt. Jede Wahl, die Claude trifft, kommt als Claudes Entscheidung in den Entwurf. Die Programmiersprache ist nie Claudes Entscheidung: für jeden Teil (Front End, Back End, Werkzeuge) fragen, bevor der Entwurf geschrieben wird (Gedächtnis-Key `work.ask-language`).
5. **Gelände abdecken** (nie als Fragebogen vorlesen): was für eine Sache das ist und was sie besonders macht; warum jetzt und woran sich Erfolg misst; Ziele, Nicht-Ziele und Anti-Ziele; Vorbilder; der Ist-Zustand; die Details, die Giovanni wichtig sind. Gute Fragen verankern sich im Konkreten („Erzähl mir vom letzten Mal…“). Erkundung anbieten (Codebasis, Dateien oder Web ansehen) und Giovanni entscheiden lassen.
6. **Privat weit denken; zeigen statt erzählen.** Mehrere Ideen entwickeln und schwache verwerfen. Den visuellen Begleiter beim ersten Mal anbieten, wenn Sehen helfen würde (ein Bildschirm, ein Layout, ein Ablauf, ein Diagramm), als eigene Nachricht und nur einmal; bei Ablehnung im Text bleiben. Einen Wegwerf-„Spike“ (ein schnelles Experiment) anbieten, wenn er der billigste Weg zum Lernen ist.
7. **Zurückspielen.** Sobald ein Teil verstanden ist, ihn in etwa 200–300 Wörtern zurückbeschreiben, Vermutungen als Vermutungen kennzeichnen und fragen, was falsch ist oder fehlt. Zurückspielen und Fragen wechseln sich ab.
8. **Umfang einschätzen.** Die Größe in einfachen Worten sagen: eine schnelle klare Aufgabe (erledigen), eine kleine Änderung (im Chat beschreiben, dann bauen) oder ein Projekt mit schriftlichem Entwurf (ein Entwurfsdokument mit nummeriertem Plan). Wächst es, eine Stufe höher gehen; sind es eigentlich mehrere Projekte, sie ordnen und eins nach dem anderen angehen.
9. **Entwurf schreiben (nur Projekte).** Ein schlichtes Dokument, aus dem ein fähiger Bauer planen kann: Absicht und Grund, Ziele/Nicht-Ziele/Anti-Ziele, Randbedingungen, die bereits entschiedenen Teile und was dem Bauer überlassen bleibt. In einem Software-Repository ist es `docs/YYYY-MM-DD-<Thema>-design.md`, committet.
10. **Bauer-Prüfung.** Ein frischer Hilfsassistent liest das Dokument wie der Bauer. Seine Fragen werden in drei Stapel sortiert: schon beantwortet, geringfügig (Claude entscheidet und kennzeichnet es als Claudes Entscheidung) und Giovannis (in einer Nachricht gefragt, das Wichtigste zuerst). Erst dann wird das Dokument übergeben.
11. **Harte Sperre.** Nichts wird gebaut (Produktcode, Gerüst, Abhängigkeiten installieren, Projekte anlegen), bis Giovanni die vollständige Beschreibung genehmigt: im Chat bei einer kleinen Änderung, das Dokument bei einem Projekt. Ausnahmen: Giovanni hat auf die Fragen verzichtet oder einem gekennzeichneten Wegwerf-Spike zugestimmt. Nach der Genehmigung kommt der Plan, als nummerierte Liste im selben Dokument.
12. **Warnzeichen.** Optionen „zur Entlastung“ anzubieten lenkt, statt zuzuhören; unausgesprochene Standardwerte lassen sich nicht ablehnen, also laut sagen; „klingt gut“ genehmigt nur, was gezeigt wurde; einen Spike zu behalten ist eine neue Anfrage.
