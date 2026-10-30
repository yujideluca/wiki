---
id: radiology-report-matcher
lang: de
source_hash: 8f41df2638c2
title: Radiology Report Matcher (geplante Website)
---

## What it is
Ein Projekt für eine Website, auf der ein Radiologe den Freitextbefund einer bildgebenden Untersuchung eingibt, angibt, um welche Untersuchung und Technik es sich handelte, die Basisdaten der Patientin oder des Patienten und die klinische Vorgeschichte ergänzt und dann Folgendes erhält: eine gereihte Liste wahrscheinlicher Diagnosen mit den Befundwörtern, die jede einzelne ausgelöst haben, Links zu Artikeln, die den Fall erklären, und strukturierte Scores (ein „strukturierter Score“ ist ein festes Punktesystem, das beschriebene Befunde in eine Risikokategorie übersetzt; der erste geplante ist ACR TI-RADS, ein Score für Schilddrüsenknoten im Ultraschall). Das Matching ist reines Zählen und Rechnen mit Wörtern, kein Modell der künstlichen Intelligenz. Es soll für Befunde auf Englisch, Deutsch und brasilianischem Portugiesisch funktionieren. Giovanni will es auf einem eigens dafür gekauften Desktop-Computer betreiben, und es kann später ein kommerzielles Werkzeug werden.

Stand 2026-10-27 gibt es nur den Teil zur Datensammlung: einen Crawler ([[radiopaedia-crawler]]) und einen Übersetzer ([[report-translator]]). Die Suche, die Score-Berechnung und die Website sind geplant, nicht gebaut. Der Plan mit Diagrammen und einem Entwicklungsprotokoll ist eine Offline-Website in `~/Documents/Radiology Report Matcher/`; das Skript `site_src/build.py` baut sie mit aktuellen Zahlen aus der Datenbank neu. `python3 -I site_src/build.py watch` schreibt alle 5 Sekunden eine kleine Datendatei (`progress-data.js`); alle geöffneten Seiten laden sie neu und bewegen ihre Fortschrittsbalken und die Zähler in den Übersichtskästen: heruntergeladene Artikel und Fälle, extrahierte Artikel, ins Deutsche und Portugiesische übersetzte Artikel, durchschnittliche Übersetzungsdauer. Läuft der Aktualisierer nicht, sagt die Seite, dass ihre Zahlen alt sind.

## Flow
trigger t1: Giovanni bittet um das Projekt und den nächsten Schritt | [[claude-code]]
step s1: Die Seiten der Referenzwebsite langsam herunterladen | [[radiopaedia-crawler]]
step s2: Jede Seite mit Lehrbuch-Wortwahl ins Deutsche und Portugiesische übersetzen | [[report-translator]], [[codex]]
step s3: Aus den Seiten Begriffstabellen und einen Suchindex bauen (geplant)
step s4: Einen eingegebenen Befund mit Artikeln und Diagnosen abgleichen (geplant)
decide d1: Beschreibt der Befund alle Merkmale eines Scores?
step s5: Den Score aus einer festen Punktetabelle berechnen (geplant)
step s6: Sagen, welches Merkmal fehlt, nie raten (geplant)
product p1: Gereihte Vorschläge, Artikellinks und Score auf einer Webseite (geplant)
product p2: Die Offline-Planwebsite mit dem Entwicklungsprotokoll

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -yes-> s5
d1 -no-> s6
s5 -> p1
s6 -> p1
t1 -> p2

## Architecture
### Context
person g: Giovanni — fordert jeden Schritt an und liest den Plan | [[giovanni]]
system s: Radiology Report Matcher — sammelt, übersetzt und (später) gleicht Befunde ab
external r: Radiopaedia — die freie Referenzseite, von der die Seiten stammen
external c: Codex — schreibt die deutschen und portugiesischen Fassungen | [[codex]]
external b: Referenzlehrbücher — Leitfäden für die deutsche und portugiesische Wortwahl

g -fordert Schritte an und liest den Plan von-> s
s -lädt Seiten von-> r
s -bittet um Übersetzungen von-> c
s -übernimmt Wortwahl aus-> b

### Containers
person g: Giovanni | [[giovanni]]
container cr: Crawler — lädt Seiten herunter und extrahiert sie | [[radiopaedia-crawler]]
container tr: Übersetzer — deutsche und portugiesische Fassungen | [[report-translator]]
container ps: Planseiten-Generator — baut die Offline-Planwebsite neu
store raw: Rohseiten — komprimierte Kopien jeder heruntergeladenen Seite
store db: SQLite-Datenbank — urls, articles, cases, translations
store ix: Buchpassagen-Index — Lehrbuchpassagen nach Vier-Buchstaben-Stücken
external r: Radiopaedia
external c: Codex | [[codex]]

g -startet-> cr
g -liest den Plan von-> ps
cr -lädt herunter von-> r
cr -bewahrt Kopien auf in-> raw
cr -schreibt Zeilen in-> db
tr -liest Artikel und speichert Übersetzungen in-> db
tr -findet Lehrbuchpassagen in-> ix
tr -bittet um Übersetzungen von-> c
ps -liest aktuelle Zahlen aus-> db

## Engineering practices
Wie dieses Projekt dem Goldenen Weg von [[project-template]] folgt.

### Principles
1. **Anforderung, dann Test, dann Code**: Ein Versprechen wird zu einer Zeile in `docs/REQUIREMENTS.md`, dann zu einem Test mit dem Tag `REQ <ID>`, dann zu Code.
2. **Sprachen von Giovanni entschieden (2026-10-27)**: kleine Werkzeuge in Python; Web-Back-End in Elixir; Front End in Elm; die statistische Mathematik und der Abgleich eines Befunds mit den Seiten in schnellem numerischem Python (Cython, NumPy, C-Bibliotheken), niemals Schleifen in reinem Python, die zu langsam sind. Der erste Commit der Engine fügt eine Geschwindigkeitsanforderung hinzu, damit ein Test dies erzwingt.
3. **Das Tor entscheidet**: `tools/quality_gate.sh` ist die einzige Definition von „bestanden“.
4. **Höfliche und rechtmäßige Sammlung**: Der Crawler befolgt `robots.txt`; heruntergeladene Seiten, Datenbanken und Lehrbücher gelangen nie in Git.
5. **Codex-Nutzung ist begrenzt**: neue Sitzungen unter 250.000 Tokens, das günstigere Modell für Übersetzungen.
6. **Entscheidungen stehen dort, wo der Code ist**: ein Entscheidungsprotokoll in `DESIGN.md` und ein Architecture Decision Record (ADR) für strukturelle Entscheidungen.

### Decisions
Vier Architecture Decision Records (ADRs, kurze Notizen, die die Gründe einer Entscheidung festhalten) in `docs/adr/`: Entscheidungen festhalten (0001), der Stack und die Regel für die Mathematik (0002), das Wartungsprogramm misst und der Review-Skill urteilt (0003), dazu die leere Vorlage (0000).

### Requirements
Dreizehn Anforderungen in `docs/REQUIREMENTS.md`: fünf für den Crawler (Präfix CW), sechs für den Übersetzer (TL) und zwei für die Planwebsite (WS). Jede hat einen Test mit dem Tag `REQ <ID>`; der Rückverfolgbarkeitsschritt schlägt fehl, wenn eine keinen hat.

### Quality gate
`tools/quality_gate.sh` hat drei Schritte: den Code kompilieren und die 13 Tests ausführen; Rückverfolgbarkeit der Anforderungen; die Fitnessfunktionen von `pipeline-check` (dem Wartungsprogramm, siehe [[pipeline-check]]): Architekturregel, Lint der Shell-Skripte, eine Grenze von 800 Zeilen pro Python-Datei und die Dauer des Tors.

### Continuous integration
Continuous Integration (CI) bedeutet automatische Prüfungen bei jedem Push. Der Workflow `quality-gate.yml` führt das Tor auf GitHub aus; eine lokale Prüfung vor dem Push führt es aus, bevor `main` hochgeladen wird. Am 2026-10-27 scheiterte der erste Lauf, weil eine frische Kopie des Repositorys keinen Ordner `data/` hat und die Log-Funktion des Crawlers einen voraussetzte; die Korrektur bestand.

### Maintenance
Technische Schulden werden als GitHub-Issues mit dem Label `debt` und den Prioritäten P1 bis P3 nach der [[maintenance-policy]] geführt; die Labels existieren. Ein monatlicher Review ist geplant.

## What it does
Heute sammelt und bereitet es Text auf. Die geplante Website verwandelt einen eingegebenen Befund in Beobachtungen (ein Befund, wo er liegt, seine Größe und ob er vorhanden, nicht vorhanden, unsicher oder alt ist), vergleicht sie mit den gesammelten Artikeln mit BM25 (eine Standardformel, die einen Text danach reiht, wie viele seltene, aussagekräftige Wörter er mit der Anfrage teilt) und zeigt die Belege. Bereits getroffene Entscheidungen: Die erste Version deckt ein enges Gebiet ab (Schilddrüsen-Ultraschall mit TI-RADS); es werden keine Patientendaten gespeichert; der Computer hat keine Grafikkarte und muss mehrere Personen gleichzeitig bedienen; Claude und Codex schreiben den Code, Giovanni prüft und testet ihn.

## How it does it
Quelle der Inhalte: Radiopaedia, eine freie radiologische Referenzseite. Ihre Seiten sind nur auf Englisch; die Sitemap nennt keine deutschen oder portugiesischen Fassungen. Ihre Datei `robots.txt` (die Datei, in der eine Website automatischen Besuchern sagt, was sie dürfen) erlaubt Artikel- und Fallseiten mit 10 Sekunden Abstand zwischen den Anfragen und enthält einen Vorbehalt gegen die Nutzung zum Training von KI-Modellen. Die Seiten stehen unter CC BY-NC-SA (Creative Commons, nicht kommerziell, Weitergabe unter gleichen Bedingungen). Giovanni hat entschieden fortzufahren: Das Produkt zeigt keinen Radiopaedia-Text an, es baut eine statistische Zuordnung und kein KI-Modell, weitere Quellen kommen hinzu, und Giovanni spricht mit Radiopaedia, falls es Einwände gibt. Ob das für eine kommerzielle Nutzung genügt, ist eine Rechtsfrage, die nicht beantwortet ist.

Die Methode wurde aus einem Forschungsbericht gewählt, den [[codex]] am 2026-10-27 geschrieben hat: BM25 plus ein Begriffslexikon, Verneinungsregeln und eine feste Score-Tabelle, mit gelerntem Neuranking und Embeddings (Zahlen, die die Bedeutung eines Textes darstellen) nur, wenn ein Test zeigt, dass sie helfen. Der Bericht selbst sagte, dass keine veröffentlichte Studie belegt, dass eine Methode genau dieses Ziel erfüllt; deshalb ist ein Testsatz aus von Ärzten geschriebenen Befunden nötig.

Der Code liegt im privaten Repository `yujideluca/radiology-report-matcher` (Ordner `~/dev/radiology-crawler`, unter diesem Namen belassen, weil lange Jobs darin laufen). Die Planwebsite ist außerdem offen, ohne Anmeldung, über Tailscale Funnel auf Port 8443 veröffentlicht (das Wiki behält den Hauptport hinter seiner Anmeldung); ein kleiner statischer Server, `radiology-plan-site.service`, liefert den Ordner `~/Documents/Radiology Report Matcher/` von diesem Laptop aus, sie ist also online, solange der Laptop läuft. Von Giovanni am 2026-10-27 entschiedene Sprachen: Werkzeuge in Python, Back End in Elixir, Front End in Elm und die Matching-Mathematik in schnellem numerischem Python (Cython, NumPy, C-Bibliotheken), niemals Schleifen in reinem Python.

Modellierungsplan, von Giovanni am 2026-10-30 beschlossen (Volltext in `docs/modelling-directives.md` im Repository): Sobald der Download der Artikel beendet ist, werden vier konkurrierende mathematische Modelle gebaut und gleich bewertet, im Stil des Skills [[skill-skill-forge]] (mehrere Versionen, verglichen durch Tests). Version 1 ist Claudes eigene Analyse aller Artikel ohne Vorannahmen; Version 2 ist dieselbe Aufgabe durch Codex; Version 3 ist ein vollständig akademischer Ansatz nach gründlicher Recherche, bei dem Claude und Codex diskutieren; Version 4 ist Giovannis eigene Idee. Seine Idee arbeitet in Schichten: zuerst harte Filter, die Diagnosen entfernen, die nicht passen können (Patientengruppe wie Kind oder Erwachsener und Geschlecht, Bildgebungsverfahren, Ort im Körper), dann weichere Filter, die eine Diagnose nur abwerten (Textur, Helligkeit oder Dichte des Befunds, Seite, Größe und Rand, Kontrastmittelaufnahme und Durchblutung, Anamnese), und zuletzt ein rein statistischer Schritt über die subjektiven Formulierungen des Befunds, der Füllwörtern, die ein unsicherer Radiologe benutzt, wenig Gewicht gibt. Fehlende Angaben entfernen nie eine Diagnose; stattdessen fragt ein „Akinator-artiger“ Ablauf (wie das Ratespiel stellt er die Frage, die die meisten Kandidaten ausschließt) den Nutzer, der jede Frage überspringen oder Text eingeben kann. Die Seite beginnt mit der Wahl zwischen geführter Suche und offenem Textfeld. Jeder Artikel wird von Codex und von Wortlisten markiert, und beide werden verglichen. Für jede Diagnose tuned die Hälfte ihrer echten Fälle das Modell und die andere Hälfte testet es; Diagnosen mit zu wenigen Fällen erhalten Fälle aus der Fachliteratur. Die schwere Rechnung (jetzt die Analyse, später die Matching-Engine) muss mehrere Prozessor-Threads und die Grafikkarte (GPU) nutzen, wenn der Rechner eine hat, und sonst mit dem Prozessor allein dieselben Ergebnisse liefern (Giovanni, 29.10.2026). Stand der Analyse (30.10.2026): Das Fundament und alles, was kein Codex braucht, ist gebaut und getestet: eine eingefrorene Kopie der 17.361 Artikel, eine Hardwareschicht (alle Prozessor-Threads, GPU falls vorhanden), die Bewertungsumgebung (je Diagnose die Hälfte zum Abstimmen, die Hälfte zum Testen), der Wortlisten-Tagger, die Filterschichten mit der Fragenauswahl, die Wortlautschicht mit Verneinung, Abschwächung und Füllwörtern sowie Version 1. Es fehlen noch die Fälle (sie werden in zufälliger Reihenfolge geladen, insgesamt etwa 9 Tage) und Giovannis Zustimmung zu einem Codex-Budget für das Codex-Tagging und die Versionen 2 und 3. Die aktuelle Schritt-für-Schritt-Liste ist die Startseite der Planungsseite und die Datei `docs/analysis-status.json` im Repository; wer die Arbeit fortsetzt, liest sie zuerst und aktualisiert sie nach jedem Schritt mit `tools/analysis_status.py`.

## Where it sits in the pipeline
Es steht am Anfang der Kette: [[radiopaedia-crawler]] → [[report-translator]] → (geplant) Index-Erstellung → (geplant) Website.

## Who receives its output
Giovanni, jetzt über die Planwebsite und später über die geplante Website.
