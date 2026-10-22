---
id: laptop-setup
lang: pt-BR
source_hash: afc723b9ba7d
title: Configuração do notebook
---

## What it is
Tudo o que está instalado e configurado no notebook ([[acer-nitro]]) para as instâncias do Claude trabalharem: configurações e hooks do Claude Code, o assistente sempre ligado, ferramentas no espaço do usuário, as ferramentas de Android e o acesso remoto.

## What it does
Fornece a base de todos os projetos: [[claude-code-settings]] e [[global-claude-md]], o serviço [[claude-assistant]], a linha de status [[pbar]], o enviador do Telegram [[tg-send]], as ferramentas de build Android ([[android-toolchain]]), as ferramentas extras em `~/.local` ([[user-space-tools]]), o [[tailscale]] e a configuração de SSH ([[remote-terminal]]).

## How it does it
A maioria das instalações fica no espaço do usuário (sem sudo) em `~/.local` e `~/dev`; os passos que exigem sudo ficam com o Giovanni. Fatos duradouros sobre a configuração ficam na [[claude-auto-memory]] e no [[workflow-memory]].

## Where it sits in the pipeline
Por baixo de todos os projetos: o QuizApp compila com suas ferramentas, o wiki roda como seu serviço, o assistente vive no seu systemd.

## Who receives its output
O [[claude-code]], o [[remote-assistant]] e todos os projetos em `~/dev`.
