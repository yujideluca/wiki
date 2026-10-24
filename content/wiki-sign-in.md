---
id: wiki-sign-in
title: Signing in to the wiki
aliases: [login flow, sign in]
kind: process
project: wiki
status: active
fed_by: []
feeds: []
sources: [wiki:server/lib/wiki/web/router.ex]
---

## What it is
This page follows what happens between opening the wiki's address and seeing the map.

## What it does
It lets exactly one Google account in and shows everyone else the decoy.

## How it does it
It uses Google OpenID Connect (OIDC, a standard way to sign in with an existing account; see [how it works](https://openid.net/developers/how-connect-works/)) through the [[google-oauth-client]], and the check is done by the [[wiki-router]].

## Where it sits in the pipeline
In front of everything in the [[wiki]].

## Who receives its output
[[giovanni]] (the map) or a visitor (the decoy).

## Steps
1. The browser opens `https://yuji-nitro.tailed3a22.ts.net`; [[tailscale-funnel]] forwards the request to the laptop.
2. The [[wiki-router]] finds no session and answers with the [[decoy-page]].
3. "Sign in with Google" goes to `/auth/google`, which saves a random "state" in the session and redirects to Google ([[google-oauth-client]]).
4. Google asks for the account; only the test user may continue.
5. Google sends the browser back to `/auth/google/callback`; the router checks the state, the signature of Google's answer, `email_verified`, and that the e-mail address is exactly yujideluca@gmail.com.
6. A fresh encrypted session cookie is set and the browser goes to `/`.
7. The router now serves the Elm app ([[wiki-frontend]]), which loads its data from the [[wiki-site]].
