---
id: wiki-service
lang: pt-BR
source_hash: 538b5e944626
title: wiki.service (systemd)
---

## What it is
A unidade de usuário do systemd que mantém o [[wiki-server]] rodando no notebook.

## What it does
Inicia o release Elixir no boot (o linger está ligado, então não precisa de login), reinicia se ele parar e carrega os segredos de `~/.config/wiki/oauth.env` e `secret.env`.

## How it does it
`systemctl --user status wiki` para verificar; logs com `journalctl --user -u wiki`.

## Where it sits in the pipeline
No [[acer-nitro]], por baixo do [[tailscale-funnel]].

## Who receives its output
O [[wiki-server]].
