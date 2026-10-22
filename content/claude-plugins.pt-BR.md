---
id: claude-plugins
lang: pt-BR
source_hash: 636185c44be4
title: Plugins do Claude Code
---

## What it is
Os plugins do Claude Code ativos no notebook.

## What it does
pyright-lsp e kotlin-lsp (inteligência de código para Python e Kotlin), session-report (relatório de uso), claude-md-management, security-guidance, feature-dev, pr-review-toolkit (agentes de revisão), claude-code-setup e android-test-pilot (análise e testes de apps Android no aparelho, do marketplace `panicgit/android-test-pilot`).

## How it does it
Instalados e listados em `~/.claude/plugins`, ativados no [[claude-code-settings]].

## Where it sits in the pipeline
Dentro de toda sessão do Claude Code.

## Who receives its output
O [[claude-code]].
