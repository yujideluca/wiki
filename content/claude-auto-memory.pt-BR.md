---
id: claude-auto-memory
lang: pt-BR
source_hash: cd7b746e912a
title: Auto-memória do Claude Code
---

## What it is
O Claude Code tem uma pequena memória própria, separada da compartilhada. É uma pasta de arquivos de texto curtos, um fato por arquivo, mais um arquivo de índice chamado `MEMORY.md`. É usada em conversas iniciadas na pasta pessoal, e o índice é carregado no começo de cada uma delas. Essa é a "auto-memory" descrita no [guia de memória do Claude Code](https://docs.claude.com/en/docs/claude-code/memory).

## What it does
Guarda notas que só importam neste notebook: como verificar o assistente remoto, o projeto German Quiz, onde estão instaladas as ferramentas de espaço de usuário, a regra de que o código deve ser depurado antes de ser dado como pronto, o fato de que um certo aviso sobre uma skill de conversação em alemão não é para o Claude Code, e o fato de que o pipeline antigo foi desativado.

## How it does it
O próprio Claude Code escreve esses arquivos, em um formato fixo (um pequeno cabeçalho, o fato, por que importa, como aplicar). Regras que precisam ser compartilhadas entre todas as instâncias do Claude não ficam aqui; vão para a memória compartilhada [[workflow-memory]].

## Where it sits in the pipeline
Carregada no início de uma conversa ([[chat-start]]), junto com as instruções de [[global-claude-md]].

## Who receives its output
O [[claude-code]].
