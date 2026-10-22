---
id: google-oauth-client
title: Google sign-in key (OAuth client)
aliases: [OAuth client, Google Cloud project wiki]
kind: external
project: wiki
status: active
fed_by: []
feeds: [wiki-router, wiki-service]
reviewed: 2026-10-22
---

## What it is
The "Google login key" Giovanni created in Google Cloud Console (project `wiki`): a Web-application OAuth client whose only redirect URI is `https://yuji-nitro.tailed3a22.ts.net/auth/google/callback`.

## What it does
Lets [[wiki-router]] ask Google who is signing in. Its audience is left in Testing with `yujideluca@gmail.com` as the only test user, a second lock: Google itself refuses other accounts.

## How it does it
Client id and secret are stored only in `~/.config/wiki/oauth.env` (mode 600), read by [[wiki-service]]; never in git, never in chat.

## Where it sits in the pipeline
Outside the laptop, at Google.

## Who receives its output
[[wiki-router]] (through the sign-in redirect).
