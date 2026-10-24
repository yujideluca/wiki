---
id: wiki-sign-in
lang: de
source_hash: c3dabaf9143a
title: Anmeldung am Wiki
---

## What it is
Diese Seite folgt dem, was zwischen dem Öffnen der Wiki-Adresse und dem Anblick der Karte geschieht.

## What it does
Sie lässt genau ein Google-Konto hinein und zeigt allen anderen den Köder.

## How it does it
Sie nutzt Google OpenID Connect (OIDC, ein Standardverfahren, sich mit einem vorhandenen Konto anzumelden; siehe [so funktioniert es](https://openid.net/developers/how-connect-works/)) über den [[google-oauth-client]], und die Prüfung erledigt der [[wiki-router]].

## Where it sits in the pipeline
Vor allem anderen im [[wiki]].

## Who receives its output
[[giovanni]] (die Karte) oder ein Besucher (der Köder).

## Steps
1. Der Browser öffnet `https://yuji-nitro.tailed3a22.ts.net`; [[tailscale-funnel]] leitet die Anfrage an den Laptop weiter.
2. Der [[wiki-router]] findet keine Sitzung und antwortet mit der [[decoy-page]].
3. „Mit Google anmelden“ führt zu `/auth/google`, das einen zufälligen „State“ in der Sitzung speichert und zu Google weiterleitet ([[google-oauth-client]]).
4. Google fragt nach dem Konto; nur der Testnutzer darf fortfahren.
5. Google schickt den Browser zurück zu `/auth/google/callback`; der Router prüft den State, die Signatur von Googles Antwort, `email_verified` und dass die E-Mail-Adresse genau yujideluca@gmail.com ist.
6. Ein frisches verschlüsseltes Sitzungs-Cookie wird gesetzt, und der Browser geht zu `/`.
7. Der Router liefert nun die Elm-App aus ([[wiki-frontend]]), die ihre Daten aus der [[wiki-site]] lädt.
