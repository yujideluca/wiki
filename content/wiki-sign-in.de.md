---
id: wiki-sign-in
lang: de
source_hash: 70055bc714fd
title: Anmeldung am Wiki
---

## What it is
Diese Seite folgt dem, was zwischen dem Öffnen der Wiki-Adresse und dem Anblick der Karte geschieht.

## Flow
trigger t1: Ein Browser öffnet die Adresse des Wikis | [[tailscale-funnel]]
step s1: Der Funnel leitet die Anfrage an den Laptop weiter | [[tailscale-funnel]]
step s2: Der Router sucht nach einer gültigen Sitzung | [[wiki-router]]
decide d1: Gibt es eine gültige Sitzung?
step s3: Antwortet mit der Attrappen-Seite | [[decoy-page]]
step s4: Mit Google anmelden: speichert einen Zufallswert und leitet zu Google weiter | [[google-oauth-client]]
decide d2: Ist es genau Giovannis verifizierte Google-E-Mail?
step s5: Setzt ein frisches verschlüsseltes Sitzungs-Cookie und kehrt zum Start zurück
step s6: Der Router liefert die Elm-App aus, die ihre Daten lädt | [[wiki-frontend]]
product p1: Die Karte, im Browser von Giovanni | [[wiki-site]]
product p2: Abgelehnt: gezeigt wird nur die Attrappe

t1 -> s1
s1 -> s2
s2 -> d1
d1 -ja-> s6
d1 -nein-> s3
s3 -> s4
s4 -> d2
d2 -ja-> s5
d2 -nein-> p2
s5 -> s6
s6 -> p1

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
