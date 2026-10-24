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
The router (Elixir module `Wiki.Web.Router`) is the only door to the wiki, and it follows the rule "default deny": nothing is shown unless the visitor has proven who they are.

## What it does
Without a session that holds Giovanni's verified Google e-mail address, every page answers with the [[decoy-page]] and every `/data` or `/assets` path answers "404 not found". The path `/auth/google` starts the sign-in; the callback accepts exactly `yujideluca@gmail.com` with `email_verified: true` and a "state" that matches the one saved when this browser started the sign-in; `/logout` ends the session.

## How it does it
The session is kept in a cookie ([cookie](https://en.wikipedia.org/wiki/HTTP_cookie): a small piece of data the browser sends back with each request) that is encrypted, signed, HttpOnly (page scripts cannot read it), Secure (sent only over HTTPS, Hypertext Transfer Protocol Secure, the encrypted web protocol) and SameSite=Lax (not sent along with requests started by other sites); it lasts 30 days and is renewed at login. Every response is marked `no-store` (do not cache) and carries security headers; the decoy's CSP (Content Security Policy, a rule telling the browser what a page may load) forbids any network request. The sign-in itself is done by the Assent library and was never written by hand. It is covered by the tests AU-1 to AU-6.

## Where it sits in the pipeline
Inside the [[wiki-server]], behind the [[tailscale-funnel]]; it is the core of [[wiki-sign-in]].

## Who receives its output
When logged in: the [[wiki-frontend]] and the data of the [[wiki-site]]. Anyone else: the [[decoy-page]].
