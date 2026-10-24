---
id: claude-ai-skills
lang: pt-BR
source_hash: 32270b9e9b24
title: Skills no app Claude (claude.ai)
---

## What it is
Uma skill é um conjunto empacotado de instruções que o Claude carrega quando surge uma tarefa desse tipo (veja [[skills]]). Esta página trata das skills que existem dentro do [[claude-app]]; o [[claude-code]] as vê listadas com o prefixo `anthropic-skills:`. A maioria são as versões do próprio app das skills locais do notebook, mas algumas existem só no app.

## What it does
As que existem só no app são: docs, docx, pdf, pptx, xlsx e google-workspace (criar e editar documentos e arquivos do Google), import-memory (trazer a exportação de memória de outro assistente), morning (um resumo da manhã), setup-writing-style (aprender como o Giovanni escreve), skill-creator (criar e testar skills) e deutsch-gespraech-memory (a memória do projeto de conversação em alemão, [[deutsch-gespraech]]). Uma skill chamada gui-code-protocol ainda aparece listada lá, mas pertence ao pipeline desativado ([[retired-workflow-pipeline]]) e deve ser ignorada.

## How it does it
São gerenciadas dentro do app Claude, e cada lado mantém sua própria versão: as cópias do notebook só são editadas pelo Claude Code, e o app guarda a sua. Como o Claude Code não vê essas skills mudarem, esta página traz uma data de revisão em vez de uma lista de arquivos de origem, e o wiki a mostra como "pode estar desatualizada" 30 dias depois dessa data.

## Where it sits in the pipeline
Fora do notebook, dentro do app Claude.

## Who receives its output
O [[claude-app]].
