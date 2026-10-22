---
id: wiki-server
lang: de
source_hash: bb3f6b6eea93
title: Wiki-Server (Elixir)
---

## What it is
Das Backend des Wikis, in Elixir geschrieben (Giovannis Wahl): ein Mix-Projekt, das zugleich Webserver und der Befehl `wiki` ist.

## What it does
Liefert die Seite hinter der Google-Anmeldung aus ([[wiki-router]]) und enthält die Inhaltswerkzeuge ([[wiki-check]], [[wiki-build]], [[wiki-hook-stop]], [[wiki-cli]]).

## How it does it
Elixir 1.18 auf Erlang/OTP 27; Plug + Bandit (HTTP-Server), lauscht nur auf 127.0.0.1:4180; Assent für Google OpenID Connect. Geheimnisse kommen aus `~/.config/wiki/*.env` (Modus 600), nie aus git. Läuft als Release über [[wiki-service]]. Getestet mit ExUnit (`mix test`).

## Where it sits in the pipeline
Zwischen [[tailscale-funnel]] und [[wiki-site]].

## Who receives its output
Browser, über [[tailscale-funnel]].
