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
sources: [wiki:server/mix.exs, wiki:server/lib/wiki/application.ex, wiki:server/rel/env.sh.eex, wiki:server/mix.lock]
reviewed: 2026-10-26T22:42Z
---

## What it is
The server is the back end of the wiki: the program that runs on the laptop, answers the browser's requests and decides who may see what. It is written in [Elixir](https://elixir-lang.org/) (Giovanni's choice) and is one Mix project (Mix is Elixir's build tool) that is both the web server and the `wiki` command.

## What it does
It serves the site behind Google sign-in ([[wiki-router]]) and holds the content tools ([[wiki-check]], [[wiki-build]], [[wiki-hook-stop]], [[wiki-cli]]).

## How it does it
It runs on Elixir 1.18 and Erlang/OTP 27 (OTP is the Open Telecom Platform, Erlang's standard libraries and runtime) on top of the BEAM (the Erlang/OTP virtual machine). It uses Plug and [Bandit](https://github.com/mtrudel/bandit) (the HTTP server) listening only on 127.0.0.1 port 4180, which means that only the laptop itself can reach it directly; the outside world reaches it through [[tailscale-funnel]]. The library [Assent](https://hexdocs.pm/assent) handles Google OpenID Connect (the sign-in protocol). Secrets come from the files `~/.config/wiki/*.env` (readable only by the owner), never from git. It runs as a release (a self-contained packaged build) under the [[wiki-service]], and is tested with ExUnit (`mix test`).

Erlang distribution (the BEAM's built-in way for two Erlang/OTP nodes to find each other, over a port registered with `epmd`, and run code on one another once both present the same shared secret, the "cookie") is turned off, set in `server/rel/env.sh.eex` (`RELEASE_DISTRIBUTION=none`). This server never clusters with another node and is never driven from a remote console, so the port and the cookie file served no purpose; leaving them on had been an unused opening on the laptop's network, since by default a release listens for distribution on every interface, not only 127.0.0.1. With it off, the BEAM opens no port besides Bandit's 4180.

Hex (Elixir's package manager) dependency versions are checked with `mix hex.audit`, which compares them against the public security-advisory list; Bandit and plug_crypto (the library behind signed and encrypted session cookies, [[wiki-router]]) are kept at versions with no open advisory.

## Where it sits in the pipeline
Between [[tailscale-funnel]] and the [[wiki-site]].

## Who receives its output
Browsers, through [[tailscale-funnel]].
