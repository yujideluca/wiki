---
id: wiki-router
lang: de
source_hash: 6de46422dca8
title: Wiki-Router (Anmeldetor)
---

## What it is
Die einzige Tür zum Wiki (`Wiki.Web.Router`): standardmäßig verweigert.

## What it does
Ohne eine Sitzung mit Giovannis bestätigter Google-E-Mail antwortet jede Seite mit der [[decoy-page]] und jeder Pfad unter `/data` oder `/assets` mit 404. `/auth/google` startet die Anmeldung; der Rückruf akzeptiert genau `yujideluca@gmail.com` mit `email_verified: true` und einem State, der zum Anmeldestart dieses Browsers passt; `/logout` beendet die Sitzung.

## How it does it
Verschlüsseltes, signiertes Sitzungs-Cookie (HttpOnly, Secure, SameSite=Lax, 30 Tage), bei der Anmeldung erneuert. Jede Antwort ist `no-store` mit Sicherheitsheadern; die Content-Security-Policy der Attrappe verbietet jede Netzanfrage. Die Anmeldung selbst erledigt die Bibliothek Assent, nie Eigenbau. Tests mit AU-1…AU-6 markiert.

## Where it sits in the pipeline
In [[wiki-server]], hinter [[tailscale-funnel]]; das Herz von [[wiki-sign-in]].

## Who receives its output
Angemeldet: [[wiki-frontend]] und die Daten aus [[wiki-site]]. Alle anderen: [[decoy-page]].
