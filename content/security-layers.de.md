---
id: security-layers
lang: de
source_hash: 02ba3cf24ef8
title: Sicherheitsschichten der Code-Pipeline
---

## What it is
Giovannis Systeme enthalten Schlüssel, Tokens und private Notizen, und einige Repositories sind öffentlich. Es gibt kein einzelnes Sicherheitsprodukt; stattdessen stoppt jede von mehreren kleinen Schichten eine Art von Leck oder Fehler. Diese Seite listet die Schichten, die in den Dateien existieren, damit niemand einen Schutz annimmt, der nicht da ist.

## Flow
trigger t1: Text, eine Datei oder ein Anmeldeversuch trifft ein | [[code-security-pipeline]]
step s1: Ein Besucher fragt das Wiki nach einer Seite; ohne verifizierte Google-Sitzung lautet die Antwort eine Attrappe | [[wiki-sign-in]], [[decoy-page]]
step s2: Inhalte werden vor dem Veröffentlichen oder Speichern gegen die gemeinsamen Datenschutzmuster geprüft | [[wiki-check]], [[mem-validator]]
step s3: Der Scanner von machine-bootstrap lehnt Dateien ab, die wie Geheimnisse aussehen | [[machine-bootstrap]]
step s4: Geheimnisse, die aufbewahrt werden müssen, wandern nur in einem verschlüsselten Archiv | [[machine-bootstrap]]
step s5: Codeänderungen bestehen das Gate, die Shell-Prüfung und die Prüfung deklarierter Abhängigkeiten | [[quality-gate-explained]]
step s6: Branch-Schutz oder der Pre-Push-Hook hält eine fehlschlagende Änderung von main fern | [[branch-protection-explained]]
decide d1: Hat eine Schicht ein Problem gefunden?
product p1: Eine Ablehnung, die die Art des Problems nennt, nie den Wert des Geheimnisses
product p2: Inhalt, der sicher gespeichert, veröffentlicht oder ausgeliefert werden kann

t1 -> s1
t1 -> s2
t1 -> s3
s3 -> s4
t1 -> s5
s5 -> s6
s1 -> d1
s2 -> d1
s4 -> d1
s6 -> d1
d1 -yes-> p1
d1 -no-> p2

## What it does
Die Schichten, von der spezifischsten zur allgemeinsten:
1. **Standardmäßig verweigern im Web** ([[wiki-router]]). Ohne Sitzung von Giovannis verifiziertem Google-Konto antwortet jeder Seitenpfad mit einer Attrappe und die Datenpfade mit 404 (Anforderungen AU-1 bis AU-6, DC-1). Jede Antwort ist als nicht zwischenspeicherbar markiert und trägt Sicherheits-Header; die Content Security Policy der Attrappe verbietet Netzwerkanfragen. OAuth (Open Authorization, der Standard hinter „Mit Google anmelden“): State und Nonce werden geprüft, und der Google-Client erlaubt nur einen Testnutzer.
2. **Eine Liste von Datenschutzmustern**. `mem/privacy-patterns.tsv` in [[workflow-memory]] listet 12 Geheimnisformen (privater Schlüsselblock, GitHub-, GitLab-, Slack-, Telegram-, Google- und AWS-Schlüssel, Bearer-Tokens, Passwortzuweisungen), 2 Telefonformen und 1 brasilianische CPF-Form (Cadastro de Pessoas Físicas, die Steuernummer). Das Gedächtnis verschiebt ein passendes Ereignis mit Begründung nach `quarantine/` ([[mem-validator]]); das Wiki nutzt dieselbe Liste in `wiki check` und veröffentlicht keine passende Seite (CO-4) und lehnt außerdem jede E-Mail-Adresse außer der von Giovanni und Anthropics No-Reply-Adresse ab. Das Wiki hält eine Kopie, und sein Gate schlägt auf dem Laptop fehl, wenn die beiden Dateien abweichen.
3. **Allow-List-Erfassung und ein Scanner in machine-bootstrap**. Nur die in `mb.toml` genannten Dateien werden gelesen; jede wird auf sieben Geheimnisformen gescannt, und eine markierte Datei wird mit Namen, nie mit Inhalt, abgelehnt; das Gate scannt `state/` erneut (`python3 -m mb scan`). Echte Geheimnisse wandern nur in einem mit Passphrase verschlüsselten Archiv, erstellt mit `gpg` und an zwei Orten aufbewahrt ([[checks-machine-bootstrap]]).
4. **Geheimnisdateien bleiben außerhalb von git**. Das Wiki liest seine Schlüssel aus `~/.config/wiki/oauth.env` und `secret.env` (Modus 600, nur für den Besitzer lesbar); die Regel lautet, sie nie auszugeben oder zu committen.
5. **Nur anhängendes Gedächtnis**. Der CI-Job `append-only` in [[workflow-memory]] schlägt fehl, wenn eine Ereignisdatei an Ort und Stelle geändert wird, sodass sich die Geschichte von Giovannis Entscheidungen nicht stillschweigend umschreiben lässt.
6. **Deklarierte Abhängigkeiten**. [[checks-radiology-crawler]] lässt das Gate fehlschlagen, wenn ein Drittanbieter-Import nicht deklariert ist oder CI etwas anderes als `requirements.txt` installiert.
7. **Shell-Lint und das Gate**: ShellCheck für jedes Shell-Skript ([[checker-catalog]]), dann Branch-Schutz oder der Pre-Push-Hook ([[branch-protection-explained]]). „Niemals Force-Push“ ist eine feste Präferenz im Gedächtnis.

In keiner Repository-Datei gefunden: automatische Prüfung von Abhängigkeiten auf Schwachstellen, Konfiguration des GitHub-Geheimnisscans und Code-Scanning-Workflows. Ob GitHub in seinen Einstellungen etwas davon eingeschaltet hat, wurde nicht geprüft.

## How it does it
Jede Schicht meldet die Art des Problems und die Stelle (eine Zeilennummer oder einen Dateinamen), nie den Wert, sodass das Protokoll selbst kein Geheimnis preisgeben kann. Die Scanner sind Sicherheitsnetze, keine Garantien: Die Arbeitsregeln besagen weiterhin, dass Claude solche Daten gar nicht erst schreiben darf ([[wiki-check]]).

## Where it sits in the pipeline
Sie läuft innerhalb der Schritte 4 und 5 von [[code-security-pipeline]].

## Who receives its output
Der Autor der Änderung (eine Ablehnung oder Warnung) und [[giovanni]], der über jede Ausnahme entscheidet.

## Steps
1. Ein Text oder eine Datei soll gespeichert oder veröffentlicht werden. Akteur: das Werkzeug des Projekts ([[mem-validator]], [[wiki-check]] oder der Scanner von machine-bootstrap). Ergebnis: bestanden oder eine Ablehnung mit der Art des Geheimnisses.
2. Ein Besucher erreicht das Wiki. Akteur: [[wiki-router]]. Ergebnis: die echte Seite für Giovanni, die Attrappe für alle anderen.
3. Code wird geändert. Akteur: das Gate des Projekts. Ergebnis: bestanden oder die erste fehlgeschlagene Prüfung, einschließlich ShellCheck und Abhängigkeitsprüfungen, wo das Projekt sie hat.
4. Ein Push erreicht `main`. Akteur: Branch-Schutz oder der Pre-Push-Hook. Ergebnis: angenommen oder gestoppt mit der fehlgeschlagenen Prüfung.
