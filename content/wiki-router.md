---
id: wiki-router
title: Wiki router (login gate)
aliases: [Router, auth]
kind: function
project: wiki
status: active
location: wiki:server/lib/wiki/web/router.ex
fed_by: [google-oauth-client, wiki-server, wiki-site]
feeds: [decoy-page, wiki-frontend]
sources: [wiki:server/lib/wiki/web/router.ex]
---

## What it is
The only door to the wiki (`Wiki.Web.Router`): default deny.

## What it does
Without a session holding Giovanni's verified Google e-mail, every page answers with the [[decoy-page]] and every `/data` or `/assets` path answers 404. `/auth/google` starts sign-in; the callback accepts exactly `yujideluca@gmail.com` with `email_verified: true` and a state matching this browser's sign-in start; `/logout` ends the session.

## How it does it
Encrypted, signed, HttpOnly, Secure, SameSite=Lax session cookie (30 days), renewed at login. Every response is `no-store` with security headers; the decoy's Content-Security-Policy forbids any network request. Auth itself is done by the Assent library, never hand-rolled. Tests tagged AU-1…AU-6.

## Where it sits in the pipeline
Inside [[wiki-server]], behind [[tailscale-funnel]]; the core of [[wiki-sign-in]].

## Who receives its output
Logged-in: [[wiki-frontend]] and [[wiki-site]] data. Anyone else: [[decoy-page]].
