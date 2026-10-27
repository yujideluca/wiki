---
id: claude-code
lang: pt-BR
source_hash: 8ac4f3cfcb07
title: Claude Code (notebook)
---

## What it is
O Claude Code é o assistente de IA da Anthropic para programar e roda no terminal (a janela de texto) do notebook ([[acer-nitro]]). Ele pode ler arquivos, executar comandos e editar código, sempre dentro das permissões que o Giovanni concede. Na divisão de papéis registrada na ADR-0003 (uma ADR, "architecture decision record", é uma nota curta que registra uma decisão e seus motivos), o Claude Code é o desenvolvedor. Veja a [documentação oficial](https://docs.claude.com/en/docs/claude-code/overview).

## Flow
trigger t1: Giovanni digita um pedido no terminal | [[giovanni]]
step s1: O chat começa: um hook imprime o resumo da memória | [[hook-session-start]], [[session-brief]]
step s2: Lê as regras globais e o CLAUDE.md do próprio projeto | [[global-claude-md]]
step s3: Faz a tarefa com suas ferramentas, dentro das permissões recebidas | [[claude-code-settings]]
decide d1: Mudou algo nos sistemas do Giovanni?
step s4: Escreve as páginas da wiki em três idiomas e as publica | [[wiki-content]]
step s5: Informa quais entradas da memória moldaram o trabalho | [[mem]]
product p1: Código e documentos alterados nos projetos | [[quizapp]], [[workflow-memory]]
product p2: A wiki, atualizada | [[wiki]]
product p3: O registro da memória com novas lições e uso | [[events-log]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> p1
s3 -> d1
d1 -sim-> s4
d1 -não-> s5
s4 -> s5
s4 -> p2
s5 -> p3

## What it does
Constrói, testa, documenta e lança o software em `~/dev`: [[quizapp]], [[quizweb]], [[workflow-memory]] e este [[wiki]]. Mantém, em cada projeto, as notas de decisão, a integração contínua (CI, verificações automáticas a cada push) e a lista de dívida técnica (atalhos que dificultam mudanças futuras). Registra o que aprende com o [[mem]] e atualiza o wiki no fim de cada tarefa ([[end-of-task]]).

## How it does it
Ao iniciar um chat, lê o [[session-brief]] impresso pelo [[hook-session-start]] e depois segue as instruções globais em [[global-claude-md]] e o CLAUDE.md de cada projeto. Trabalha com as ferramentas e permissões de [[claude-code-settings]] e termina com `wiki publish` e `mem use`.

## Where it sits in the pipeline
Entre o [[giovanni]] (que pede e aprova) e os repositórios que ele altera. Nunca fala diretamente com outras instâncias do Claude: tudo o que é compartilhado passa pelo [[workflow-memory]] ou pelos repositórios.

## Who receives its output
Os repositórios dos projetos, o registro de memória [[events-log]] e o conteúdo do wiki ([[wiki-content]]).
