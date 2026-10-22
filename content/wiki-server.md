---
id: wiki-server
title: Wiki server (Elixir)
aliases: [Elixir app, Bandit]
kind: program
project: wiki
status: active
location: wiki:server
fed_by: [tailscale-funnel, wiki-service]
feeds: [wiki-router]
sources: [wiki:server/mix.exs, wiki:server/lib/wiki/application.ex]
---

## What it is
The back end of the wiki, written in Elixir (Giovanni's choice): one Mix project that is both the web server and the `wiki` command.

## What it does
Serves the site behind Google sign-in ([[wiki-router]]) and holds the content tools ([[wiki-check]], [[wiki-build]], [[wiki-hook-stop]], [[wiki-cli]]).

## How it does it
Elixir 1.18 on Erlang/OTP 27; Plug + Bandit (HTTP server) listening only on 127.0.0.1:4180; Assent for Google OpenID Connect. Secrets come from `~/.config/wiki/*.env` (mode 600), never from git. Run as a release by [[wiki-service]]. Tested with ExUnit (`mix test`).

## Where it sits in the pipeline
Between [[tailscale-funnel]] and [[wiki-site]].

## Who receives its output
Browsers, through [[tailscale-funnel]].
