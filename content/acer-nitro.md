---
id: acer-nitro
title: The laptop (Acer Nitro, yuji-nitro)
aliases: [laptop, yuji-nitro, Kubuntu]
kind: external
project: laptop-setup
status: active
fed_by: []
feeds: []
reviewed: 2026-10-22
---

## What it is
Giovanni's laptop: an Acer Nitro with an Nvidia card running Kubuntu (KDE Plasma), host name `yuji-nitro`. Everything in `~/dev` lives here.

## What it does
Runs Claude Code, the always-on [[claude-assistant]], the builds of every project and this wiki's server ([[wiki-service]]).

## How it does it
User account with linger enabled, so user services keep running without a login; repairs follow [[skill-reparo-kubuntu]] and are made permanent across reboots.

## Where it sits in the pipeline
The machine under [[laptop-setup]].

## Who receives its output
Every Claude instance that runs locally.
