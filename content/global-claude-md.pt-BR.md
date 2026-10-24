---
id: global-claude-md
lang: pt-BR
source_hash: dcfe9682ac70
title: CLAUDE.md global
---

## What it is
`~/.claude/CLAUDE.md` é o arquivo de instruções privado do Giovanni para toda sessão do Claude Code no notebook. Um arquivo CLAUDE.md é texto simples que o Claude Code lê automaticamente no início de uma sessão e trata como instruções permanentes ([documentação](https://docs.claude.com/en/docs/claude-code/memory)). Este é "global": vale em todos os projetos, enquanto cada projeto também tem o seu.

## What it does
Indica o [[workflow-memory]] como memória compartilhada e explica como registrar uma correção (`mem add`), como informar quais entradas da memória influenciaram uma tarefa (`mem use`) e como marcar uma entrada errada. Proíbe editar à mão as pastas `events/` e `views/` e guardar dados clínicos, secretos ou de contato de outras pessoas. Também faz da atualização do wiki parte de terminar qualquer tarefa ([[end-of-task]]).

## How it does it
É carregado automaticamente no contexto de toda sessão, junto com o resumo da memória ([[session-brief]]). Nenhum comando é necessário.

## Where it sits in the pipeline
Lido no início de cada conversa ([[chat-start]]).

## Who receives its output
O [[claude-code]] e o [[remote-assistant]].
