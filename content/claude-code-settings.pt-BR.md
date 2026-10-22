---
id: claude-code-settings
lang: pt-BR
source_hash: 1f64bfdb8efe
title: settings.json do Claude Code
---

## What it is
O `~/.claude/settings.json`: a configuração de usuário do Claude Code no notebook.

## What it does
Registra os hooks (SessionStart → [[hook-session-start]], UserPromptSubmit → [[hook-prompt]], Stop → [[hook-stop]] e [[wiki-hook-stop]]), a linha de status ([[pbar]]), o ambiente (`ANDROID_HOME`), os plugins ativos ([[claude-plugins]]), o modelo e o tema.

## How it does it
JSON lido pelo Claude Code na abertura; os hooks da memória vieram do `mem install-hooks` e o do wiki da instalação dele. Só é mudado de propósito.

## Where it sits in the pipeline
Lido no início de toda sessão do Claude Code ([[chat-start]]).

## Who receives its output
O próprio Claude Code.
