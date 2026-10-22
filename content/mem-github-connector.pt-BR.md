---
id: mem-github-connector
lang: pt-BR
source_hash: 4d554d53348a
title: Gravando memória pelo app do Claude
aliases: [conector do GitHub]
---

## What it is
Como o [[claude-app]], que não pode rodar o `mem`, ainda lê e grava a memória compartilhada.

## What it does
Lê o `views/BRIEF.md` no início de cada conversa e registra uma correção criando um arquivo de evento novo.

## How it does it
Pelo conector do GitHub (as ferramentas ficam adiadas no app e precisam ser carregadas pelo nome), seguindo o passo a passo do fim do BRIEF.md. Testado no app do celular (conversa simples e de projeto).

## Where it sits in the pipeline
O lado do app do Claude no [[workflow-memory]].

## Who receives its output
O [[events-log]].

## Steps
1. A conversa começa; o texto nas Configurações do claude.ai ([[claude-ai-settings-pointer]]) manda carregar as ferramentas do GitHub.
2. Ela lê o `views/BRIEF.md` de `yujideluca/workflow-memory` (branch main) — [[memory-views]].
3. O Giovanni dá uma correção; a conversa cria um arquivo de evento em `events/` no formato do passo a passo ([[events-log]]).
4. O push dispara a [[mem-action]], que valida o arquivo ([[mem-validator]]) e refaz as [[memory-views]].
5. A próxima sessão do Claude Code traz isso no resumo ([[hook-session-start]]).
