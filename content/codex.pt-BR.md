---
id: codex
lang: pt-BR
source_hash: 1b73cde614c6
title: Codex (notebook)
---

## What it is
O Codex é um assistente de programação que roda no terminal (a janela de texto) do notebook ([[acer-nitro]]), ao lado do [[claude-code]]. Ele pode ler arquivos, executar comandos e editar código dentro das permissões que o Giovanni permite. O Giovanni o usa como segundo assistente nos mesmos projetos, e ele segue as mesmas preferências fixas.

## Flow
trigger t1: Giovanni inicia o codex num terminal | [[giovanni]]
step s1: O lançador envolve a sessão em tmux; um rodapé mostra o progresso da tarefa e o uso | [[codex-pbar]], [[codex-status-line]]
step s2: Um hook de início imprime o resumo da memória para a instância codex | [[hook-session-start]], [[session-brief]]
step s3: Lê suas instruções globais e o AGENTS.md do próprio projeto | [[global-codex-agents]]
decide d1: A tarefa combina com a descrição de alguma skill instalada?
step s4: Carrega essa skill e a segue | [[codex-skills]]
step s5: Trabalha sem skill
step s6: Faz a tarefa e mantém honesta a contagem de passos do rodapé | [[codex-pbar]]
decide d2: Mudou algo nos sistemas do Giovanni?
step s7: Escreve as páginas da wiki em três idiomas e as publica | [[wiki-content]]
step s8: Informa quais entradas da memória moldaram o trabalho | [[mem-use]]
product p1: Código e documentos alterados nos projetos
product p2: Uma wiki que corresponde ao que foi construído | [[wiki]]
product p3: Uso da memória registrado no log sob a instância codex | [[events-log]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -sim-> s4
d1 -não-> s5
s4 -> s6
s5 -> s6
s6 -> p1
s6 -> d2
d2 -sim-> s7
d2 -não-> s8
s7 -> s8
s7 -> p2
s8 -> p3

## What it does
Ele constrói, testa e documenta software em `~/dev` como o [[claude-code]]. Lê a memória compartilhada do Giovanni ([[workflow-memory]]) no início de cada sessão, registra correções com [[mem]] e atualiza esta wiki ao fim de uma tarefa ([[end-of-task]]).

## How it does it
Seu próprio arquivo de instruções é o [[global-codex-agents]]. Seus hooks de memória rodam o comando `mem --instance codex`, então cada entrada de memória diz qual assistente a escreveu; uma preferência que só o Codex precisa é guardada com o escopo `instance:codex`, enquanto entradas globais também são lidas pelo Claude Code. Suas skills são as adaptações para Codex em [[codex-skills]], instaladas pelo [[codex-skillsctl]]. No terminal, o [[codex-pbar]] desenha a linha de progresso e a [[codex-status-line]] mostra as cotas de uso e o tamanho do contexto.

## Where it sits in the pipeline
Entre o [[giovanni]] e os repositórios dos projetos, em paralelo ao [[claude-code]]. Nunca fala direto com outros assistentes: tudo que é compartilhado passa pelo [[workflow-memory]] ou pelos repositórios.

## Who receives its output
Os repositórios dos projetos, o log da memória [[events-log]] e o conteúdo da wiki ([[wiki-content]]).
