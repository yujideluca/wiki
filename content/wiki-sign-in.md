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
reviewed: 2026-10-22T16:33Z
---

## What it is
This page follows what happens between opening the wiki's address and seeing the map.

## Flow
trigger t1: A browser opens the wiki's address | [[tailscale-funnel]]
step s1: The funnel forwards the request to the laptop | [[tailscale-funnel]]
step s2: The router looks for a valid session | [[wiki-router]]
decide d1: Is there a valid session?
step s3: Answers with the decoy page | [[decoy-page]]
step s4: Sign in with Google: saves a random state and redirects to Google | [[google-oauth-client]]
decide d2: Is it exactly Giovanni's verified Google e-mail?
step s5: Sets a fresh encrypted session cookie and returns to the start
step s6: The router serves the Elm app, which loads its data | [[wiki-frontend]]
product p1: The map, in Giovanni's browser | [[wiki-site]]
product p2: Refused: only the decoy is ever shown

t1 -> s1
s1 -> s2
s2 -> d1
d1 -yes-> s6
d1 -no-> s3
s3 -> s4
s4 -> d2
d2 -yes-> s5
d2 -no-> p2
s5 -> s6
s6 -> p1

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
