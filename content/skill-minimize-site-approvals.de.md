---
id: skill-minimize-site-approvals
lang: de
source_hash: a2b0a008490a
title: Skill: minimize-site-approvals
---

## What it is
Die Skill „minimize-site-approvals“ ist ein Planungsschritt vor dem Surfen, damit Giovanni so selten wie möglich auf „Genehmigen“ klicken muss. Ihre Beschreibung sagt: vor jeder Browseraufgabe verwenden, um Freigabeklicks für Websites zu verringern: die Domains vorab planen, einmal seitenweiten Zugriff anfordern und Werkzeuge bevorzugen, die keine Freigabe brauchen. Die Fassung für Claude Code wird nur dort bearbeitet; die Claude-App behält ihre eigene Fassung ([[claude-ai-skills]]).

## What it does
Sie plant die Domains vorab, bittet einmal um seitenweiten Zugriff und bevorzugt Werkzeuge ohne Freigabe. Sie umgeht, deaktiviert oder unterläuft nie Freigaben oder die Sicherheitsprüfung der Seite; sie verringert nur, wie viele Abfragen ausgelöst werden. Sie läuft zusammen mit [[skill-browser-automacao-segura]] und [[skill-click-protocol]].

## How it does it
Eine `SKILL.md` in `~/.claude/skills/minimize-site-approvals`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Vor und während jeder Browser-Automatisierung.

## Who receives its output
Die Browser-Sitzung und Giovanni (weniger Abfragen).

## Steps
Bevor ein Browser berührt wird:
1. **Den billigsten Weg bevorzugen.** Für öffentliche Seiten vermeiden Websuche und Seitenabruf den Browser, können in Claude Code aber trotzdem eine Berechtigungsabfrage auslösen, sind also nicht freigabefrei. Chrome nur öffnen, wenn die Aufgabe eine angemeldete Sitzung, Interaktion, Formulare oder eine Seite braucht, die diese Werkzeuge nicht lesen können.
2. **Jede Domain auflisten**, die die Aufgabe wahrscheinlich braucht (Hauptseite, Login-Host, jede vom Nutzer genannte Subdomain), einmal, vorab.
3. **Dem Nutzer die ganze Liste in einer Zeile nennen**, damit die Freigaben auf einmal kommen statt nacheinander.

Freigaben in Claude Code:
4. Es gibt kein Werkzeug „Zugriff anfordern“. Der Seitenzugriff kommt von der Abfrage der Erweiterung Claude in Chrome: Den Nutzer bitten, für vertrauenswürdige Seiten „Aktionen auf dieser Website immer erlauben“ zu wählen; freigegebene Seiten lassen sich auf der Berechtigungsseite der Erweiterung prüfen und widerrufen.
5. Werkzeugabfragen (Shell-Befehle, Seitenabruf, Connector-Werkzeuge) kommen vom Berechtigungssystem von Claude Code. Für wiederholte sichere Aufrufe anbieten, eine Erlaubnisregel in den Einstellungen hinzuzufügen (die Skill update-config oder der Befehl `/permissions`); nie eine ohne das Ja des Nutzers hinzufügen.
6. Ist eine Freigabe abgelehnt oder offen, warten. Nicht in einer Schleife wiederholen und keinen anderen Weg zum selben Inhalt suchen. Die Shell kann hier curl, Python, wget oder git ausführen, das ist also wichtig: Sie nie benutzen, um eine Seite zu erreichen, die eine Freigabeabfrage, die Erweiterung oder ein Abrufwerkzeug verweigert hat.

Bei der Arbeit:
7. Seitentext- und Lesewerkzeuge gegenüber Screenshots und wiederholter Navigation bevorzugen; jeder zusätzliche Seitenwechsel kann eine neue Abfrage auslösen.
8. Auf den freigegebenen Domains bleiben. Braucht die Aufgabe eine neue Domain, die neuen Anfragen bündeln und einmal fragen.
9. Nacheinander handeln, eine Aktion nach der anderen, und Seitenwarnungen und Bestätigungsdialoge vor Stapelaktionen neutralisieren oder behandeln ([[skill-browser-automacao-segura]]).
10. Tab-IDs aus früheren Sitzungen nicht wiederverwenden; zuerst den aktuellen Tab-Kontext lesen.

Ehrlich zu sagen:
11. Manche Freigaben lassen sich nicht entfernen: von der Sicherheitsprüfung der Erweiterung gesperrte oder markierte Seiten, Downloads, Eingabe sensibler Informationen, Erteilen von Autorisierungen. Käufe, Kontoerstellung und endgültige Löschungen bleiben beim Nutzer.
12. Berechtigungsmodi von Claude Code (zum Beispiel Auto-Modus oder breite Erlaubnisregeln) verringern Abfragen, aber auch die Kontrolle. Nur der Nutzer ändert sie; den Zielkonflikt einmal nennen, wenn gefragt, und nie darauf drängen, um Klicks auf nicht vertrauenswürdigen Seiten zu sparen.

Aufgabe abschließen:
13. Sagen, welche Seiten und Werkzeuge freigegeben wurden und wie (einmal, immer oder per Einstellungsregel), damit der Nutzer weiß, was nun gespeichert ist, und es widerrufen kann.
