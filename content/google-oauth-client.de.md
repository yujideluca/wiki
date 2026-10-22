---
id: google-oauth-client
lang: de
source_hash: 7d5a996047e7
title: Google-Anmeldeschlüssel (OAuth-Client)
---

## What it is
Der „Google-Anmeldeschlüssel“, den Giovanni in der Google Cloud Console angelegt hat (Projekt `wiki`): ein OAuth-Client vom Typ Webanwendung mit der einzigen Weiterleitungs-URI `https://yuji-nitro.tailed3a22.ts.net/auth/google/callback`.

## What it does
Lässt [[wiki-router]] Google fragen, wer sich anmeldet. Seine Zielgruppe bleibt auf Testing mit `yujideluca@gmail.com` als einzigem Testnutzer, ein zweites Schloss: Google selbst lehnt andere Konten ab.

## How it does it
Client-ID und Geheimnis liegen nur in `~/.config/wiki/oauth.env` (Modus 600), gelesen von [[wiki-service]]; nie in git, nie im Chat.

## Where it sits in the pipeline
Außerhalb des Laptops, bei Google.

## Who receives its output
[[wiki-router]] (über die Anmelde-Weiterleitung).
