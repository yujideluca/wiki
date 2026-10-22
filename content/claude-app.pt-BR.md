---
id: claude-app
lang: pt-BR
source_hash: 09d495292e04
title: App do Claude (claude.ai)
---

## What it is
O Claude no app e no claude.ai (celular, navegador, projetos). Ele não acessa o notebook.

## What it does
Conversa, escrita e estudo: treino de alemão ([[skill-alemao-goethe-fsp]]), perguntas clínicas ([[skill-consulta-clinica]]), candidaturas na Alemanha ([[skill-candidatura-alemanha]]).

## How it does it
Um texto colado nas Configurações do claude.ai ([[claude-ai-settings-pointer]]) faz cada conversa ler `views/BRIEF.md` do [[workflow-memory]] pelo conector do GitHub; ele registra correções criando um arquivo de evento ([[mem-github-connector]]). Suas skills são as cópias do claude.ai listadas em [[claude-ai-skills]].

## Where it sits in the pipeline
Fora do notebook. Sua única interface compartilhada com as outras instâncias é o [[workflow-memory]] (ADR-0003).

## Who receives its output
O [[events-log]], pelo conector do GitHub.
