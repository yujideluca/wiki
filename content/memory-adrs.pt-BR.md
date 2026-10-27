---
id: memory-adrs
lang: pt-BR
source_hash: 4b485ead0520
title: ADRs do workflow-memory
---

## What it is
ADRs ("architecture decision records") são notas curtas, uma por decisão importante, que guardam os motivos de uma decisão para que ninguém precise adivinhar depois. Esta página trata das ADRs do [[workflow-memory]]: 0001 registrar decisões desta forma; 0002 o registro de eventos; 0003 os papéis do Giovanni e das instâncias do Claude; 0004 um programa mede e uma skill julga.

## What it does
A ADR-0002 diz que a memória é um registro só de acréscimo (apenas arquivos novos entram, os antigos nunca mudam) que uma função pura transforma no estado atual, em vez de um protocolo entre máquinas. A ADR-0003 diz que o Giovanni decide e aprova; o [[claude-code]] constrói; o [[remote-assistant]] faz tarefas curtas com as mesmas regras; o [[claude-app]] conversa e escreve apenas eventos de memória. As instâncias nunca conversam diretamente: o workflow-memory é a única interface compartilhada, e novos projetos nascem do [[project-template]]. O ADR-0004 diz que um programa determinístico, o [[pipeline-check]], mede e bloqueia, enquanto a skill [[skill-revisao-manutencao]] lê o relatório dele e só propõe; o programa vive em um repositório próprio e cada projeto fixa uma versão dele em vez de copiá-lo ([[maintenance-pipeline]]). O ADR-0005 (26/10/2026) enxuga o brief de início: o harvester ignora prompts gerados, o Codex usa seu próprio escopo `instance:codex`, e o brief é mais curto depois de `/clear`.

## How it does it
Cada princípio é aplicado por um teste ou uma tarefa de integração contínua citada no CLAUDE.md do repositório, de modo que as decisões são verificadas e não apenas escritas.

## Where it sits in the pipeline
Por trás de toda regra deste wiki sobre quem pode fazer o quê.

## Who receives its output
Todas as instâncias do Claude e o Giovanni.
