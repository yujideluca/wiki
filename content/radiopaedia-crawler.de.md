---
id: radiopaedia-crawler
lang: de
source_hash: 2b4d39cf3707
title: Radiopaedia-Crawler (crawl.py)
---

## What it is
Ein Kommandozeilenprogramm, das die Artikel- und Fallseiten von Radiopaedia (einer freien radiologischen Referenzseite) langsam und höflich herunterlädt, von jeder Seite eine Rohkopie aufbewahrt und daraus sauberen Text in eine Datenbank extrahiert. Ein „Crawler“ ist ein Programm, das Webseiten nacheinander besucht; „Extrahieren“ heißt, Titel, Überschriften und Haupttext herauszuziehen und Menüs und Skripte wegzulassen. Es ist Teil von [[radiology-report-matcher]].

## Architecture
### Context
person g: Giovanni — startet und stoppt die Downloads | [[giovanni]]
system s: crawl.py — lädt Radiopaedia-Seiten herunter und extrahiert ihren Text
external r: Radiopaedia — die freie Referenzseite
external t: Befund-Übersetzer — liest die extrahierten Artikel | [[report-translator]]

g -führt aus-> s
s -lädt Seiten von-> r
s -übergibt Artikel an-> t

### Containers
person g: Giovanni | [[giovanni]]
container cm: Befehle — sitemap, fetch, extract, run, stats
store u: Tabelle urls — jede Adresse und ihr Status
store raw: Rohseiten — komprimierte Kopie jeder Seite
store a: Tabellen articles und cases — der extrahierte Text
store pj: progress-data.js — Live-Zahlen für die Planungsseite
external r: Radiopaedia

g -führt aus-> cm
cm -liest Listen und Seiten von-> r
cm -verfolgt jede Seite in-> u
cm -bewahrt Kopien auf in-> raw
cm -schreibt Text in-> a
cm -überschreibt alle paar Sekunden-> pj

## What it does
Es hat fünf Befehle, ausgeführt als `python3 -I crawl.py <Befehl>` in `~/dev/radiology-crawler`:

- `sitemap` liest die Sitemap der Website (die eigene Seitenliste der Website) und speichert jede Artikel- und Fall-Adresse in der Tabelle `urls` mit dem Status `pending`.
- `fetch` lädt ausstehende Seiten herunter, eine alle 10 bis 12 Sekunden, und speichert jede als komprimierte Datei in `data/raw/`. Optionen: `--kind articles|cases`, `--limit N`. Innerhalb jeder Art werden die Seiten in einer festen Pseudozufallsreihenfolge geholt (nicht alphabetisch); ein vorzeitig beendeter Download enthält daher eine faire Stichprobe aller Diagnosen.
- `extract` verwandelt gespeicherte Seiten in Zeilen der Tabellen `articles` und `cases` in `data/radiopaedia.sqlite` (SQLite ist eine Datenbank in einer einzigen Datei). Bereits extrahierte Seiten werden übersprungen, außer mit `--all`.
- `run` führt alles oben nacheinander aus (Sitemap, Artikel, Fälle, Extraktion) und wiederholt sich, solange ein Durchlauf die Liste der ausstehenden Seiten noch verkleinert. Während es arbeitet, überschreibt es alle 5 Sekunden `progress-data.js` im Ordner der Planungsseite `~/Documents/Radiology Report Matcher/` (der Code steht in `progress.py`), sodass die Fortschrittsbalken der Planungsseite live bleiben. Es endet mit Erfolg, wenn nichts mehr übrig ist, mit Fehler, wenn Seiten übrig sind (zum Beispiel ohne Netz), und mit Code 75 nach wiederholten Sperren. Wird der Crawl mit `run_all.sh` gestartet, startet dieses Skript auch den Hintergrunddienst `radiology-plan-updater` (systemd, die Linux-Dienstverwaltung, Benutzerebene), der dieselbe Datei aktuell hält und sich nach Absturz oder Neustart selbst neu startet.
- `stats` zeigt, wie viele Seiten ausstehend, fertig oder verschwunden sind, und die verbleibenden Tage.

`run_all.sh` ist der ältere manuelle Weg: es führt sitemap aus, dann fetch für Artikel, dann fetch für Fälle, dann extract, und kann einfach erneut gestartet werden, um fortzufahren. Am 2026-10-27 nannten die Sitemaps 17.359 Artikel und 70.535 Fälle, bei dieser Geschwindigkeit etwa 11 Tage Download. Die geladenen Artikel speisen auch die statistische Analyse: `analysis/codex_tags.py` (Codex, wiederaufnehmbar) und `analysis/haiku_batches.py` (Haiku-Unterinstanzen in Wellen) taggen jeden Artikel mit demselben geschlossenen Vokabular; sie lesen die eingefrorene Kopie der Datenbank, nie die Dateien des Crawlers.

## How it does it
- Es liest zuerst `robots.txt` und überspringt jede Adresse, die diese Datei sperrt (Suche, Tags, Playlists, die Programmierschnittstelle, Admin-Seiten). Die Pause von 10 Sekunden ist der Wert `Crawl-delay` in dieser Datei; dazu kommen zufällige 0 bis 2 Sekunden.
- Es sendet eine ehrliche User-Agent-Zeile (den Namen, den ein Programm einer Website nennt), die sagt, dass es ein privater Forschungs-Crawler ist, und Giovannis Kontaktadresse nennt, dazu normale Accept-Kopfzeilen. Ohne sie antwortete die Website beim ersten Test mit HTTP 406 („nicht akzeptabel“).
- Eine Antwort 429 oder 503 (zu viele Anfragen, ausgelastet) lässt es warten und bis zu dreimal wiederholen. Eine Antwort 404 oder 410 markiert die Seite als `gone`. Dreimal 403 oder 406 (abgelehnt) beenden den ganzen Lauf; es versucht nicht, eine Sperre zu umgehen.
- Der Status jeder Seite steht in der Datenbank, sodass ein gestoppter Lauf dort weitermacht, wo er aufgehört hat. Die Rohseiten bleiben erhalten, damit die Extraktion verbessert werden kann, ohne erneut herunterzuladen.
- Ein Artikel wird mit Titel, Synonym- und Tag-Liste, Autor, Änderungsdatum, nach Überschriften gegliedertem Haupttext und Links zu anderen Artikeln gespeichert. Ein Fall wird mit Titel, Vorstellungsgrund, Alter und Geschlecht, dem Befundtext jeder Bildserie mit ihrer Modalität, Tags und verlinkten Artikeln gespeichert. Die Sprache wird als `en` gespeichert; Radiopaedia hat keine andere.
- Die Datenbankdatei wird im Write-Ahead-Modus geöffnet (ein SQLite-Modus, der mehreren Programmen die Nutzung einer Datei erlaubt), damit Crawler, Extraktor und [[report-translator]] gleichzeitig laufen können.

## Where it sits in the pipeline
Erster Schritt der Datenkette von [[radiology-report-matcher]]. Es läuft im Hintergrund auf dem Laptop ([[acer-nitro]]), solange es arbeitet, ist der Ruhezustand gesperrt.

Der Benutzerdienst `radiology-crawler.service` (systemd, das Linux-Programm, das Hintergrunddienste startet) führt `python3 -I crawl.py run` bei jedem Start des Laptops aus. Nach einem Fehler startet er nach 10 Minuten neu; nach Erfolg (alles geladen und extrahiert) oder nach Code 75 (gesperrt) bleibt er gestoppt. Die Balken der Planungsseite melden „the crawler is not running“, wenn die Zahlen älter als eine Minute sind. Prüfen mit `systemctl --user status radiology-crawler`.

## Who receives its output
[[report-translator]] liest die Tabelle `articles`. Die geplante Index-Erstellung liest beide Tabellen.
