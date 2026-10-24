---
id: wiki-router
lang: de
source_hash: bbcf4cfc2c84
title: Wiki-Router (Anmelde-Tor)
---

## What it is
Der Router (Elixir-Modul `Wiki.Web.Router`) ist die einzige Tür zum Wiki, und er folgt der Regel „standardmäßig verweigern“: Nichts wird gezeigt, wenn der Besucher nicht bewiesen hat, wer er ist.

## What it does
Ohne eine Sitzung mit Giovannis verifizierter Google-E-Mail-Adresse antwortet jede Seite mit der [[decoy-page]], und jeder Pfad unter `/data` oder `/assets` antwortet „404 nicht gefunden“. Der Pfad `/auth/google` startet die Anmeldung; der Callback akzeptiert genau `yujideluca@gmail.com` mit `email_verified: true` und einem „State“, der zu dem passt, der beim Start der Anmeldung in diesem Browser gespeichert wurde; `/logout` beendet die Sitzung.

## How it does it
Die Sitzung liegt in einem Cookie ([Cookie](https://en.wikipedia.org/wiki/HTTP_cookie): ein kleines Datenstück, das der Browser bei jeder Anfrage zurückschickt), das verschlüsselt, signiert, HttpOnly (Seitenskripte können es nicht lesen), Secure (nur über HTTPS, Hypertext Transfer Protocol Secure, das verschlüsselte Webprotokoll, gesendet) und SameSite=Lax (nicht bei Anfragen anderer Seiten mitgesendet) ist; es gilt 30 Tage und wird bei der Anmeldung erneuert. Jede Antwort ist mit `no-store` (nicht zwischenspeichern) markiert und trägt Sicherheits-Header; die CSP (Content Security Policy, eine Regel, die dem Browser sagt, was eine Seite laden darf) des Köders verbietet jede Netzwerkanfrage. Die Anmeldung selbst erledigt die Bibliothek Assent und wurde nie von Hand geschrieben. Abgedeckt ist es durch die Tests AU-1 bis AU-6.

## Where it sits in the pipeline
Im [[wiki-server]], hinter dem [[tailscale-funnel]]; es ist der Kern von [[wiki-sign-in]].

## Who receives its output
Wenn angemeldet: das [[wiki-frontend]] und die Daten der [[wiki-site]]. Alle anderen: die [[decoy-page]].
