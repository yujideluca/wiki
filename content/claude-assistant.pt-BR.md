---
id: claude-assistant
lang: pt-BR
source_hash: b32979a126fb
title: Serviço claude-assistant
aliases: [serviço Remote Control]
---

## What it is
O serviço de usuário do systemd que mantém o [[remote-assistant]] rodando (configurado em 10/10/2026): `claude-assistant.service` → `~/.local/bin/claude-assistant start`.

## What it does
Inicia um servidor tmux próprio (socket `claude`, sessão `assistant`) que roda `claude remote-control --name yuji-nitro-assistant` num laço de reinício a partir de `~/assistant`. Uma entrada de autostart do KDE abre uma janela do Konsole ligada a ele.

## How it does it
O laço espera o DNS (`getent hosts api.anthropic.com`) antes de cada início, porque no boot o serviço sobe antes do Wi-Fi. O tmux é instalado no espaço do usuário. Verificar com `systemctl --user status claude-assistant` e `tmux -L claude capture-pane -p -t assistant`.

## Where it sits in the pipeline
No [[acer-nitro]], ativado no boot (linger ligado).

## Who receives its output
O [[remote-assistant]].
