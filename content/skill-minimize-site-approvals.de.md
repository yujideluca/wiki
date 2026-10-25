---
id: skill-minimize-site-approvals
lang: de
source_hash: 01dc574f6b52
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

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

#### Claude: `home:.claude/skills/minimize-site-approvals/SKILL.md`

```skill-source home:.claude/skills/minimize-site-approvals/SKILL.md 0457c58dd26434a2fd12c54a615d53a3be66e279154eb478e7b7023e31beba8c
---
name: "minimize-site-approvals"
description: "Use before any browsing task to cut down site-approval clicks: plan the domains up front, request site-wide access once, and prefer tools that need no approval."
---

# Minimize site-approval clicks

Lineage: origin=gui; base=52547cd8127647409f6397067c9e7af5e903aa4c

Code version: adapted for Claude Code on the laptop from `gui/skills/minimize-site-approvals`. Edited only by Claude Code; the app keeps its own version.

Goal: the user should click "approve" as few times as possible. This skill never bypasses, disables, or works around approvals or the site safety check. It only reduces how many prompts get triggered.

## Before touching a browser

1. Prefer the cheapest path. For public pages, WebSearch and WebFetch avoid the browser, but in Claude Code they can still trigger a permission prompt, so they are not approval-free. Open Chrome only when the task needs a signed-in session, interaction, forms, or a page those tools cannot read.
2. List every domain the task will likely need (main site, login host, any subdomain the user mentioned). Do this once, up front.
3. Tell the user the full list in one line, so the approvals come in one go instead of one by one as pages come up.

## Approvals in Claude Code

- There is no `request_access` tool. Site access comes from the Claude in Chrome extension prompt: ask the user to choose "Always allow actions on this site" for trusted sites. Approved sites can be reviewed and revoked on the extension's Permissions page.
- Tool prompts (Bash, WebFetch, MCP tools) come from Claude Code's permission system. For repeated safe calls, offer to add an allow rule in settings (the `update-config` skill, or `/permissions`); never add one without the user's yes.
- If an approval is declined or pending, wait for it. Do not retry in a loop, and do not try another route to the same content. Bash can run curl, Python, wget or git here, so this rule matters more than in the app: never use them to reach a page that an approval prompt, the extension or a fetch tool refused.

## While working

- Prefer page-text and read tools over screenshots and repeated navigation; every extra site hop can trigger a new prompt.
- Stay on the approved domains. If the task needs a new domain, batch the new requests together and ask once.
- Act sequentially, one action at a time, and neutralize or handle page alert/confirm dialogs before batch actions so they never block the task (browser-automacao-segura).
- Do not reuse tab IDs from earlier sessions; call tabs_context_mcp first.

## Things to say honestly

- Some approvals cannot be removed: sites blocked or flagged by the extension's safety check, downloads, entering sensitive information, granting authorizations. Purchases, account creation, and permanent deletions stay with the user.
- Claude Code permission modes (for example auto mode, or broad allow rules) reduce prompts but also reduce review. Only the user changes them; mention the trade-off once if asked, and never push for it to save clicks on untrusted sites.

## Closing the task

Say which sites and tools were approved and how (once, always, or a settings rule) so the user knows what is now saved and can revoke it.
```


#### Codex: `home:.agents/skills/minimize-site-approvals/SKILL.md`

````skill-source home:.agents/skills/minimize-site-approvals/SKILL.md e7193b47923f6cfad90c9aa7be27c628aab10776af66073fe4654a7d9c9c459a
---
name: minimize-site-approvals
description: "Use before browsing to minimize repeated site-access requests while respecting the active host permission system."
---

# Minimize site approvals

Lineage: origin=claude; base=sha256:0457c58dd26434a2fd12c54a615d53a3be66e279154eb478e7b7023e31beba8c; adaptation=codex

Interop: role = cross-cutting; owns = choosing the least costly authorized web access; defers to = host permission rules, browser-automacao-segura, connected-service skills; honors = user language and persistent task authorization.

1. Prefer available connected-service tools for account data, public search/fetch tools for public information, and browser control for signed-in interaction or pages those tools cannot read.
2. Identify likely domains once. If the host requires site approval, batch necessary access requests and explain their scope. If access is already allowed, proceed without asking the user to approve it again.
3. Discover actual tools and read their schemas. Do not invent an access-request tool, a browser extension setting or a permission mode. Do not modify settings to reduce prompts unless explicitly requested.
4. If access is denied, do not retry in a loop or bypass the decision through shell downloads, another browser or another tool. A pending approval stays pending.
5. Read compact relevant page text and reuse verified results; avoid unnecessary screenshots and navigation. Obtain current tabs from the host rather than reusing old session identifiers.
6. Report only permissions actually requested or changed. Never claim site-wide access was saved merely because a page opened. A purchase or message send needs authorization for that action, even when site access is allowed.
````
