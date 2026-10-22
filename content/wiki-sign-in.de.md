---
id: wiki-sign-in
lang: de
source_hash: 62f6f45a7908
title: Anmeldung im Wiki
aliases: [Anmeldeablauf]
---

## What it is
Was zwischen dem Öffnen der Wiki-Adresse und dem Anblick der Karte passiert.

## What it does
Lässt genau ein Google-Konto hinein und zeigt allen anderen die Attrappe.

## How it does it
Google OpenID Connect über [[google-oauth-client]], geprüft von [[wiki-router]].

## Where it sits in the pipeline
Vor allem anderen im [[wiki]].

## Who receives its output
[[giovanni]] (die Karte) oder ein Besucher (die Attrappe).

## Steps
1. Der Browser öffnet `https://yuji-nitro.tailed3a22.ts.net`; [[tailscale-funnel]] leitet zum Laptop weiter.
2. [[wiki-router]] findet keine Sitzung und antwortet mit der [[decoy-page]].
3. „Sign in with Google“ führt zu `/auth/google`, das einen zufälligen State in der Sitzung speichert und zu Google weiterleitet ([[google-oauth-client]]).
4. Google fragt nach dem Konto; nur der Testnutzer darf weiter.
5. Google schickt den Browser zurück an `/auth/google/callback`; der Router prüft State, die Signatur der Google-Antwort, `email_verified` und dass die E-Mail genau yujideluca@gmail.com ist.
6. Ein frisches verschlüsseltes Sitzungs-Cookie wird gesetzt, und der Browser geht zu `/`.
7. Der Router liefert jetzt die Elm-App aus ([[wiki-frontend]]), die die Daten aus [[wiki-site]] lädt.
