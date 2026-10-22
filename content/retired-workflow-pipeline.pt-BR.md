---
id: retired-workflow-pipeline
lang: pt-BR
source_hash: 93de72edfc3a
title: Aposentado: fluxo claude-workflow-backup
aliases: [protocolo antigo]
---

## What it is
O jeito antigo de as instâncias do Claude compartilharem memória e se coordenarem: o repositório `claude-workflow-backup` com o gui-code-protocol (diários numerados, cursores de "visto", pastas por dono), scripts de sincronia, um projeto de memória por eventos e timers diários/de reversão. Aposentado.

## What it does
Nada mais. O repositório não existe; a cópia de trabalho órfã foi arquivada em 22/10/2026 em `~/archive/claude-workflow-dev-2026-10-22.tar.gz`. O único legado é que ele preenchia o `~/.claude/skills`.

## How it does it
Substituído pelo [[workflow-memory]] (uma única operação de escrita e uma função pura em vez de um protocolo), como registrado nos ADR-0002/0003 de lá. Suas regras (diários, sync.sh, sandbox_check.sh) nunca devem ser seguidas nem retomadas.

## Where it sits in the pipeline
Só história.

## Who receives its output
Ninguém; se a história for necessária, ler o arquivo compactado.
