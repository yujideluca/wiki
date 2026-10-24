---
id: remote-terminal
lang: pt-BR
source_hash: 2befda912399
title: Configuração do remote-terminal (SSH + Tailscale)
---

## What it is
O `~/dev/remote-terminal/setup-sudo.sh`: a configuração única, que pode ser repetida, para acessar o terminal do notebook pelo celular.

## What it does
Instala o servidor OpenSSH, o [[tailscale]] e o tmux de repositórios oficiais; configura o SSH só com chaves, só para o usuário `yuji`, sem root e sem senhas; adiciona a chave pública do celular, se informada.

## How it does it
Bash rodado com sudo pelo Giovanni (`sudo bash ~/dev/remote-terminal/setup-sudo.sh ["ssh-ed25519 … phone"]`); `set -euxo pipefail` e `sshd -t` antes de reiniciar. Desde 2026-10-24 é um repositório privado no GitHub (`yujideluca/remote-terminal`) com portão, CI e a verificação de pre-push do [[pipeline-check]].

## Where it sits in the pipeline
A base do acesso remoto ao [[acer-nitro]].

## Who receives its output
O [[tailscale]] e o serviço SSH.
