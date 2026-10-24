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
reviewed: 2026-10-22T16:33Z
---

## What it is
The server is the back end of the wiki: the program that runs on the laptop, answers the browser's requests and decides who may see what. It is written in [Elixir](https://elixir-lang.org/) (Giovanni's choice) and is one Mix project (Mix is Elixir's build tool) that is both the web server and the `wiki` command.

## What it does
It serves the site behind Google sign-in ([[wiki-router]]) and holds the content tools ([[wiki-check]], [[wiki-build]], [[wiki-hook-stop]], [[wiki-cli]]).

## How it does it
It runs on Elixir 1.18 and Erlang/OTP 27 (OTP is the Open Telecom Platform, Erlang's standard libraries and runtime). It uses Plug and [Bandit](https://github.com/mtrudel/bandit) (the HTTP server) listening only on 127.0.0.1 port 4180, which means that only the laptop itself can reach it directly; the outside world reaches it through [[tailscale-funnel]]. The library [Assent](https://hexdocs.pm/assent) handles Google OpenID Connect (the sign-in protocol). Secrets come from the files `~/.config/wiki/*.env` (readable only by the owner), never from git. It runs as a release (a self-contained packaged build) under the [[wiki-service]], and is tested with ExUnit (`mix test`).

## Where it sits in the pipeline
Between [[tailscale-funnel]] and the [[wiki-site]].

## Who receives its output
Browsers, through [[tailscale-funnel]].
