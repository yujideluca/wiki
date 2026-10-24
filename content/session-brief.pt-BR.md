---
id: session-brief
lang: pt-BR
source_hash: eb21f1167079
title: Resumo de sessão (memória no início da conversa)
---

## What it is
O resumo de sessão (session brief) é o bloco de texto que uma conversa do [[claude-code]] vê primeiro. Começa com "Memory (workflow-memory)…" e lista as preferências permanentes do Giovanni (cada uma marcada com um `#code` curto para poder ser citada), as pendências e como registrar uma nova preferência, informar o que foi usado e dar feedback.

## What it does
Define os padrões da sessão. Ele nunca autoriza nada sozinho: a ordem de precedência é a instrução atual primeiro, depois o arquivo de regras do repositório, depois a memória do projeto, depois o perfil geral. Em outras palavras, o que o Giovanni diz agora sempre vale mais do que o que a memória diz.

## How it does it
O [[hook-session-start]] o imprime, usando a classificação do [[memory-fold]] e as regras de pendências do [[mem-pendency]], cada um dentro de um orçamento de tamanho para o resumo ficar curto. Quando o download da memória mais recente falhou, o resumo diz "memory may be stale".

## Where it sits in the pipeline
É a primeira entrada de toda sessão do Claude Code ([[chat-start]]).

## Who receives its output
O [[claude-code]] e o [[remote-assistant]].
