---
id: memory-adrs
lang: pt-BR
source_hash: 4827125208c7
title: ADRs do workflow-memory
aliases: [papéis e fronteiras]
---

## What it is
As decisões registradas do [[workflow-memory]]: 0001 registrar decisões, 0002 o registro de eventos, 0003 papéis do Giovanni e das instâncias do Claude.

## What it does
ADR-0002: a memória é um registro só de acréscimos, dobrado por uma função pura, não um protocolo entre máquinas. ADR-0003: o Giovanni decide e aprova; o [[claude-code]] constrói; o [[remote-assistant]] faz tarefas curtas com as mesmas regras; o [[claude-app]] conversa e só grava eventos de memória. As instâncias nunca falam diretamente; o workflow-memory é a única interface compartilhada, e projetos novos começam do [[project-template]].

## How it does it
Cada princípio é garantido por um teste ou job de CI citado no CLAUDE.md do repositório.

## Where it sits in the pipeline
Por trás de toda regra sobre quem pode fazer o quê neste wiki.

## Who receives its output
Todas as instâncias do Claude e o Giovanni.
