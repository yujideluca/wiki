---
id: retired-workflow-pipeline
lang: pt-BR
source_hash: 72e43d3ac29d
title: Desativado: pipeline claude-workflow-backup
---

## What it is
Esta é a forma antiga como as instâncias do Claude compartilhavam memória e coordenavam o trabalho, e está desativada: não deve ser usada nem retomada. Vivia num repositório chamado `claude-workflow-backup` e consistia em um protocolo chamado gui-code-protocol (diários numerados, marcadores de "visto" e pastas por dono), scripts de sincronização, um projeto de memória por eventos e temporizadores diários e de reversão.

## What it does
Nada mais. O repositório dela não existe mais; a cópia de desenvolvimento que sobrou foi arquivada em 2026-10-22 como `~/archive/claude-workflow-dev-2026-10-22.tar.gz` (um arquivo compactado). Seu único legado é que um dia preencheu a pasta `~/.claude/skills`.

## How it does it
Foi substituída pelo [[workflow-memory]], que usa uma única forma de escrever (acrescentar um arquivo novo) e uma única função que calcula o estado atual, em vez de um protocolo entre máquinas. A decisão está registrada nas ADR-0002 e ADR-0003 de lá (uma ADR, "architecture decision record", é uma nota curta que registra uma decisão e seus motivos). Suas regras (diários, `sync.sh`, `sandbox_check.sh`) nunca devem ser seguidas ou retomadas.

## Where it sits in the pipeline
Apenas história.

## Who receives its output
Ninguém; se o histórico for necessário um dia, leia o arquivo compactado.
