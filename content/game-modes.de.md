---
id: game-modes
lang: de
source_hash: 0ccc7c1e2438
title: Die fünf Spielmodi
---

## What it is
Das sind die fünf Arten, wie [[quizapp]] und [[quizweb]] Deutsch auf B2-Niveau abfragen. Alle greifen auf einen kuratierten Pool dessen zurück, was jeder B2-Sprecher wissen sollte; der Pool kann ohne App-Update wachsen ([[question-pack]]), und die Zahlen unten sind die des in die App eingebauten Pools (Inhaltsversion 1). Ein „Spielmodus“ ist eine Art von Frage.

## What it does
- **Der · Die · Das**: den Artikel von 484 Nomen wählen (der Artikel hängt vom Geschlecht des Nomens ab).
- **Präpositionen**: in 309 Sätzen die fehlende Präposition ergänzen.
- **Pluralformen**: den Plural derselben Nomen bilden.
- **Präteritum**: die er/sie/es-Form von 253 Verben bilden.
- **Fehler finden**: in 121 Sätzen im Stil von Forumsbeiträgen oder formellen E-Mails den einen falschen Teil antippen, gebaut aus den Fehlern, die Giovanni in korrigierten B2-Probeprüfungen gemacht hat.

## How it does it
Jeder Modus ist ein `GameMode`-Wert mit einer Speicher-ID. Alle erzeugen über die [[card-factory]] dieselbe `Card`-Form, sodass ein neuer Modus eine kleine Änderung ist. Nur Fehler finden wartet auf einen Tipp auf „Weiter“ (`autoAdvances = false`); die anderen gehen nach dem Feedback von selbst weiter.

## Where it sits in the pipeline
Das Menü des Startbildschirms. Der gewählte Modus bestimmt, welche Inhaltsdateien die [[card-factory]] speisen.

## Who receives its output
Die [[card-factory]].
