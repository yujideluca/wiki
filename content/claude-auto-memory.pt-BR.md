---
id: claude-auto-memory
lang: pt-BR
source_hash: beb58ec2ef19
title: Memória automática do Claude Code
---

## What it is
A pequena memória em arquivos do próprio Claude Code para sessões iniciadas na pasta pessoal: um fato por arquivo mais o índice `MEMORY.md`, carregado em toda sessão desse tipo.

## What it does
Guarda notas próprias do notebook: como verificar o assistente remoto, o projeto German Quiz, caminhos das ferramentas no espaço do usuário, a regra de depurar depois de programar, que o aviso do deutsch-gespraech não é para o Claude Code e que o fluxo antigo está aposentado.

## How it does it
Escrita pelo Claude Code no formato de memória (cabeçalho + fato + porquê + como aplicar). Regras compartilhadas entre instâncias ficam no [[workflow-memory]].

## Where it sits in the pipeline
Carregada no [[chat-start]] ao lado do [[global-claude-md]].

## Who receives its output
O [[claude-code]].
