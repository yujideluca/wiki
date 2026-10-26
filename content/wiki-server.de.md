---
id: wiki-server
lang: de
source_hash: e99c4e9ac6d7
title: Wiki-Server (Elixir)
---

## What it is
Der Server ist das Back End des Wikis: das Programm, das auf dem Laptop läuft, die Anfragen des Browsers beantwortet und entscheidet, wer was sehen darf. Er ist in [Elixir](https://elixir-lang.org/) geschrieben (Giovannis Wahl) und ein einziges Mix-Projekt (Mix ist das Build-Werkzeug von Elixir), das zugleich Webserver und der Befehl `wiki` ist.

## What it does
Er liefert die Seite hinter der Google-Anmeldung aus ([[wiki-router]]) und enthält die Inhaltswerkzeuge ([[wiki-check]], [[wiki-build]], [[wiki-hook-stop]], [[wiki-cli]]).

## How it does it
Er läuft auf Elixir 1.18 und Erlang/OTP 27 (OTP ist die Open Telecom Platform, die Standardbibliotheken und Laufzeit von Erlang) auf der BEAM (der virtuellen Maschine von Erlang/OTP). Er nutzt Plug und [Bandit](https://github.com/mtrudel/bandit) (den HTTP-Server), der nur auf 127.0.0.1 Port 4180 lauscht, das heißt, nur der Laptop selbst erreicht ihn direkt; die Außenwelt erreicht ihn über [[tailscale-funnel]]. Die Bibliothek [Assent](https://hexdocs.pm/assent) erledigt Google OpenID Connect (das Anmeldeprotokoll). Geheimnisse stammen aus den Dateien `~/.config/wiki/*.env` (nur für den Eigentümer lesbar), nie aus Git. Er läuft als Release (ein in sich geschlossener gepackter Build) unter dem [[wiki-service]] und wird mit ExUnit getestet (`mix test`).

Die Erlang-Distribution (die eingebaute Art, wie zwei Erlang/OTP-Knoten sich über einen bei `epmd` registrierten Port finden und, sobald beide das gleiche gemeinsame Geheimnis vorweisen, den "Cookie", Code aufeinander ausführen) ist abgeschaltet, eingestellt in `server/rel/env.sh.eex` (`RELEASE_DISTRIBUTION=none`). Dieser Server bildet nie einen Cluster mit einem anderen Knoten und wird nie über eine entfernte Konsole gesteuert, also hatten der Port und die Cookie-Datei keinen Zweck; sie offen zu lassen war eine ungenutzte Öffnung im Netz des Laptops, da ein Release standardmäßig auf jeder Schnittstelle auf Distribution lauscht, nicht nur auf 127.0.0.1. Ohne sie öffnet die BEAM keinen Port außer Bandits 4180.

Hex (der Paketmanager von Elixir) prüft Abhängigkeitsversionen mit `mix hex.audit`, das sie mit der öffentlichen Liste von Sicherheitshinweisen vergleicht; Bandit und plug_crypto (die Bibliothek hinter signierten und verschlüsselten Sitzungs-Cookies, [[wiki-router]]) werden auf Versionen ohne offenen Hinweis gehalten.

## Where it sits in the pipeline
Zwischen [[tailscale-funnel]] und der [[wiki-site]].

## Who receives its output
Browser, über [[tailscale-funnel]].
