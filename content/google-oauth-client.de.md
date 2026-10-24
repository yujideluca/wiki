---
id: google-oauth-client
lang: de
source_hash: a2577a5f3b30
title: Google-Anmeldeschlüssel (OAuth-Client)
---

## What it is
Damit sich Menschen mit ihrem Google-Konto anmelden können, muss eine Website zuerst bei Google registriert werden. Ergebnis dieser Registrierung ist der „Google-Login-Schlüssel“, den Giovanni in der [Google Cloud Console](https://console.cloud.google.com/) angelegt hat (Projekt `wiki`): ein OAuth-Client für Webanwendungen (OAuth, Open Authorization, ist der Standard, über den Google einer Website mitteilt, wer sich anmeldet, siehe [OAuth](https://en.wikipedia.org/wiki/OAuth)). Seine einzige Weiterleitungsadresse (wohin Google den Browser nach der Anmeldung zurückschickt) ist `https://yuji-nitro.tailed3a22.ts.net/auth/google/callback`.

## What it does
Er lässt den [[wiki-router]] Google fragen, wer sich anmeldet. Die Zielgruppe des Projekts steht im Modus „Testing“ mit `yujideluca@gmail.com` als einzigem Testnutzer, das ist ein zweites Schloss: Google selbst lehnt andere Konten ab.

## How it does it
Client-ID und Client-Secret (das „Passwort“ der Website gegenüber Google) liegen nur in `~/.config/wiki/oauth.env` (nur für den Eigentümer lesbar, Dateimodus 600) und werden vom [[wiki-service]] gelesen. Sie stehen nie in Git und werden nie im Chat gezeigt.

## Where it sits in the pipeline
Außerhalb des Laptops, bei Google.

## Who receives its output
Der [[wiki-router]], über die Weiterleitung bei der Anmeldung.
