---
id: session-brief
lang: pt-BR
source_hash: 6a4031cc027c
title: Resumo de sessão (memória no início da conversa)
---

## What it is
O resumo de sessão (session brief) é o bloco de texto que uma conversa do [[claude-code]] vê primeiro. Começa com "Memory (workflow-memory)…" e tem quatro partes: as poucas regras que sempre valem, impressas por inteiro (cada uma com um `#code` curto para poder ser citada); um índice de todas as outras regras, agrupadas pelo tipo de tarefa em que importam (uma tag, como `deploy` ou `git`), com o número de regras e uma linha de "use when"; as pendências; e como registrar uma nova preferência, informar o que foi usado e dar feedback.

## What it does
Define os padrões da sessão. Ele nunca autoriza nada sozinho: a ordem de precedência é a instrução atual primeiro, depois o arquivo de regras do repositório, depois a memória do projeto, depois o perfil geral. Em outras palavras, o que o Giovanni diz agora sempre vale mais do que o que a memória diz.

## How it does it
O [[hook-session-start]] o imprime. As regras `always` e o índice vêm das tags guardadas em `mem/tags.toml` (a lista de tags conhecidas, cada uma com sua linha "use when"); as pendências seguem as regras do [[mem-pendency]]. A parte antes das pendências fica abaixo de 1.900 caracteres, porque o programa que roda o hook mostra a uma conversa só os primeiros 2 KB do que o hook imprime; um teste falha se a memória real a deixar mais longa. Antes de uma tarefa de um dos tipos listados, o Claude roda o [[mem-rules]] com a tag para ler o texto completo dessas regras. Quando o download da memória mais recente falhou, o resumo diz "memory may be stale". Depois de `/clear` ou de uma compactação o resumo é o mesmo, porque já é curto. Regras que dizem respeito só ao Codex têm o escopo `instance:codex` e não aparecem no brief do Claude Code.

## Where it sits in the pipeline
É a primeira entrada de toda sessão do Claude Code ([[chat-start]]).

## Who receives its output
O [[claude-code]] e o [[remote-assistant]].
