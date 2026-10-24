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
To let people sign in with their Google account, a website must first be registered with Google. The result of that registration is the "Google login key" that Giovanni created in the [Google Cloud Console](https://console.cloud.google.com/) (project `wiki`): a web-application OAuth client (OAuth, Open Authorization, is the standard through which Google tells a website who is signing in, see [OAuth](https://en.wikipedia.org/wiki/OAuth)). Its only redirect address (where Google sends the browser back after sign-in) is `https://yuji-nitro.tailed3a22.ts.net/auth/google/callback`.

## What it does
It lets the [[wiki-router]] ask Google who is signing in. The project's audience is left in "Testing" mode with `yujideluca@gmail.com` as the only test user, which is a second lock: Google itself refuses other accounts.

## How it does it
The client id and the client secret (the "password" of the website towards Google) are stored only in `~/.config/wiki/oauth.env` (readable only by the owner, file mode 600) and are read by the [[wiki-service]]. They are never in git and never shown in chat.

## Where it sits in the pipeline
Outside the laptop, at Google.

## Who receives its output
The [[wiki-router]], through the sign-in redirect.
