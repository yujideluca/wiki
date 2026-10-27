---
id: radiology-report-matcher
lang: de
source_hash: beb2b2ad70dc
title: Radiology Report Matcher (geplante Website)
---

## What it is
Ein Projekt für eine Website, auf der ein Radiologe den Freitextbefund einer bildgebenden Untersuchung eingibt, angibt, um welche Untersuchung und Technik es sich handelte, die Basisdaten der Patientin oder des Patienten und die klinische Vorgeschichte ergänzt und dann Folgendes erhält: eine gereihte Liste wahrscheinlicher Diagnosen mit den Befundwörtern, die jede einzelne ausgelöst haben, Links zu Artikeln, die den Fall erklären, und strukturierte Scores (ein „strukturierter Score“ ist ein festes Punktesystem, das beschriebene Befunde in eine Risikokategorie übersetzt; der erste geplante ist ACR TI-RADS, ein Score für Schilddrüsenknoten im Ultraschall). Das Matching ist reines Zählen und Rechnen mit Wörtern, kein Modell der künstlichen Intelligenz. Es soll für Befunde auf Englisch, Deutsch und brasilianischem Portugiesisch funktionieren. Giovanni will es auf einem eigens dafür gekauften Desktop-Computer betreiben, und es kann später ein kommerzielles Werkzeug werden.

Stand 2026-10-27 gibt es nur den Teil zur Datensammlung: einen Crawler ([[radiopaedia-crawler]]) und einen Übersetzer ([[report-translator]]). Die Suche, die Score-Berechnung und die Website sind geplant, nicht gebaut. Der Plan mit Diagrammen und einem Entwicklungsprotokoll ist eine Offline-Website in `~/Documents/Radiology Report Matcher/`; das Skript `site_src/build.py` baut sie mit aktuellen Zahlen aus der Datenbank neu.

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

## What it does
Heute sammelt und bereitet es Text auf. Die geplante Website verwandelt einen eingegebenen Befund in Beobachtungen (ein Befund, wo er liegt, seine Größe und ob er vorhanden, nicht vorhanden, unsicher oder alt ist), vergleicht sie mit den gesammelten Artikeln mit BM25 (eine Standardformel, die einen Text danach reiht, wie viele seltene, aussagekräftige Wörter er mit der Anfrage teilt) und zeigt die Belege. Bereits getroffene Entscheidungen: Die erste Version deckt ein enges Gebiet ab (Schilddrüsen-Ultraschall mit TI-RADS); es werden keine Patientendaten gespeichert; der Computer hat keine Grafikkarte und muss mehrere Personen gleichzeitig bedienen; Claude und Codex schreiben den Code, Giovanni prüft und testet ihn.

## How it does it
Quelle der Inhalte: Radiopaedia, eine freie radiologische Referenzseite. Ihre Seiten sind nur auf Englisch; die Sitemap nennt keine deutschen oder portugiesischen Fassungen. Ihre Datei `robots.txt` (die Datei, in der eine Website automatischen Besuchern sagt, was sie dürfen) erlaubt Artikel- und Fallseiten mit 10 Sekunden Abstand zwischen den Anfragen und enthält einen Vorbehalt gegen die Nutzung zum Training von KI-Modellen. Die Seiten stehen unter CC BY-NC-SA (Creative Commons, nicht kommerziell, Weitergabe unter gleichen Bedingungen). Giovanni hat entschieden fortzufahren: Das Produkt zeigt keinen Radiopaedia-Text an, es baut eine statistische Zuordnung und kein KI-Modell, weitere Quellen kommen hinzu, und Giovanni spricht mit Radiopaedia, falls es Einwände gibt. Ob das für eine kommerzielle Nutzung genügt, ist eine Rechtsfrage, die nicht beantwortet ist.

Die Methode wurde aus einem Forschungsbericht gewählt, den [[codex]] am 2026-10-27 geschrieben hat: BM25 plus ein Begriffslexikon, Verneinungsregeln und eine feste Score-Tabelle, mit gelerntem Neuranking und Embeddings (Zahlen, die die Bedeutung eines Textes darstellen) nur, wenn ein Test zeigt, dass sie helfen. Der Bericht selbst sagte, dass keine veröffentlichte Studie belegt, dass eine Methode genau dieses Ziel erfüllt; deshalb ist ein Testsatz aus von Ärzten geschriebenen Befunden nötig.

Der Ordner `~/dev/radiology-crawler` ist noch kein Git-Repository (Git ist das Werkzeug, das jede Änderung als Commit speichert) und hat kein automatisches Qualitätstor und keine kontinuierliche Integration; beides ist geplant, bevor die Website gebaut wird.

## Where it sits in the pipeline
Es steht am Anfang der Kette: [[radiopaedia-crawler]] → [[report-translator]] → (geplant) Index-Erstellung → (geplant) Website.

## Who receives its output
Giovanni, jetzt über die Planwebsite und später über die geplante Website.
