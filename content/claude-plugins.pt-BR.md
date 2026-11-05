---
id: claude-plugins
lang: pt-BR
source_hash: b814dccdcc9f
title: Plugins do Claude Code
---

## What it is
Um plugin é um pacote complementar do Claude Code que traz capacidades extras ([documentação de plugins](https://docs.claude.com/en/docs/claude-code/plugins)). Esta página lista os plugins instalados no notebook e diz quais estão ligados.

## What it does
- pyright-lsp e kotlin-lsp dão ao Claude "inteligência de código" para as linguagens Python e Kotlin (LSP é o Language Server Protocol, um padrão para um editor ou assistente perguntar a uma ferramenta de linguagem sobre erros e definições).
- session-report gera um relatório de uso de sessões passadas.
- claude-md-management ajuda a manter os arquivos CLAUDE.md (arquivos de instruções) em ordem.
- security-guidance avisa sobre código arriscado.
- feature-dev e pr-review-toolkit oferecem agentes de revisão e planejamento (assistentes auxiliares para uma tarefa específica).
- claude-code-setup recomenda automações.
- android-test-pilot analisa apps Android e executa testes no aparelho; vem do marketplace `panicgit/android-test-pilot`.
- rust-analyzer-lsp dá ao Claude "inteligência de código" para a linguagem Rust (versão 1.0.0).

## How it does it
Estão instalados em `~/.claude/plugins` (a lista fica em `installed_plugins.json`) e ligados ou desligados em [[claude-code-settings]]. Ligados: pyright-lsp, kotlin-lsp, rust-analyzer-lsp, security-guidance e android-test-pilot. Instalados, mas desligados: session-report, claude-md-management, feature-dev, pr-review-toolkit e claude-code-setup.

## Where it sits in the pipeline
Dentro de toda sessão do Claude Code.

## Who receives its output
O [[claude-code]].
