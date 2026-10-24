---
id: claude-code
lang: pt-BR
source_hash: b4eed29baa1a
title: Claude Code (notebook)
---

## What it is
O Claude Code é o assistente de IA da Anthropic para programar e roda no terminal (a janela de texto) do notebook ([[acer-nitro]]). Ele pode ler arquivos, executar comandos e editar código, sempre dentro das permissões que o Giovanni concede. Na divisão de papéis registrada na ADR-0003 (uma ADR, "architecture decision record", é uma nota curta que registra uma decisão e seus motivos), o Claude Code é o desenvolvedor. Veja a [documentação oficial](https://docs.claude.com/en/docs/claude-code/overview).

## What it does
Constrói, testa, documenta e lança o software em `~/dev`: [[quizapp]], [[quizweb]], [[workflow-memory]] e este [[wiki]]. Mantém, em cada projeto, as notas de decisão, a integração contínua (CI, verificações automáticas a cada push) e a lista de dívida técnica (atalhos que dificultam mudanças futuras). Registra o que aprende com o [[mem]] e atualiza o wiki no fim de cada tarefa ([[end-of-task]]).

## How it does it
Ao iniciar um chat, lê o [[session-brief]] impresso pelo [[hook-session-start]] e depois segue as instruções globais em [[global-claude-md]] e o CLAUDE.md de cada projeto. Trabalha com as ferramentas e permissões de [[claude-code-settings]] e termina com `wiki publish` e `mem use`.

## Where it sits in the pipeline
Entre o [[giovanni]] (que pede e aprova) e os repositórios que ele altera. Nunca fala diretamente com outras instâncias do Claude: tudo o que é compartilhado passa pelo [[workflow-memory]] ou pelos repositórios.

## Who receives its output
Os repositórios dos projetos, o registro de memória [[events-log]] e o conteúdo do wiki ([[wiki-content]]).
