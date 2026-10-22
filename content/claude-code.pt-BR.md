---
id: claude-code
lang: pt-BR
source_hash: 92ea6bcda322
title: Claude Code (notebook)
aliases: [desenvolvedor]
---

## What it is
O Claude rodando no terminal do notebook ([[acer-nitro]]). Nos papéis do ADR-0003 ele é o desenvolvedor.

## What it does
Constrói, testa, documenta e publica o software em `~/dev`: [[quizapp]], [[quizweb]], [[workflow-memory]] e este [[wiki]]. Mantém os ADRs, a CI e a lista de dívidas de cada projeto, registra o que aprende com o [[mem]] e atualiza o wiki no fim de cada tarefa ([[end-of-task]]).

## How it does it
Lê o [[session-brief]] impresso pelo [[hook-session-start]] quando a conversa começa, segue o [[global-claude-md]] e o CLAUDE.md de cada projeto, usa as ferramentas do [[claude-code-settings]] e termina com `wiki publish` e `mem use`.

## Where it sits in the pipeline
Entre o [[giovanni]] (que pede e aprova) e os repositórios que altera. Nunca fala diretamente com outras instâncias do Claude: o que é compartilhado passa pelo [[workflow-memory]] ou pelos repositórios.

## Who receives its output
Os repositórios dos projetos, o [[events-log]] (eventos de memória) e o [[wiki-content]].
