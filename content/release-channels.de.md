---
id: release-channels
lang: de
source_hash: 7fa797bc5567
title: Release-Kanäle: stabil und Beta
aliases: [Beta]
---

## What it is
Die Regel, dass nichts den Spieler ohne vorherige Beta-App erreicht (ADR-0005), und wann eine Beta freigegeben werden darf (ADR-0011).

## What it does
Zwei Build-Varianten: `stable` (`dev.yuji.quiz`, „Deutsch B2“, folgt `main` von [[release-feed]]) und `beta` (`dev.yuji.quiz.beta`, „Deutsch B2 beta“, folgt `bleeding-edge`). Eine Beta wird freigabefähig, sobald sie die für ihre Änderung angepassten automatischen Tests übersteht; dann entscheidet Giovanni.

## How it does it
Durchgesetzt von [[publish-apk]] (`promote` führt das Tor mit [[mutation-check]] und [[check-tests-updated]] aus). Web-Portierungen warten auf einem Branch `web-<version>` von [[quizweb]] bis zur Freigabe.

## Where it sits in the pipeline
Regelt [[quizapp-release]].

## Who receives its output
[[update-client]] (welchem Branch er folgt).
