---
id: end-of-task
lang: pt-BR
source_hash: a93720e775ec
title: Fim de uma tarefa (cadeia de atualização do wiki)
aliases: [cadeia de atualização]
---

## What it is
O que o Claude faz toda vez que termina uma tarefa, para memória e wiki nunca ficarem atrás do que foi construído (decidido pelo Giovanni em 22/10/2026: a atualização do wiki fica ligada ao `mem use`).

## What it does
Atualiza as páginas do que mudou (conceitos novos, alterados e aposentados, com as traduções), publica passando pelas verificações e depois informa quais entradas de memória guiaram o trabalho.

## How it does it
Uma regra no [[global-claude-md]]; as verificações no [[wiki-check]]; a rede de segurança [[wiki-hook-stop]].

## Where it sits in the pipeline
O último passo de toda tarefa de programação em qualquer projeto.

## Who receives its output
O [[wiki-content]], o [[github]] e o [[events-log]].

## Steps
1. O trabalho da tarefa está feito e verificado ([[skill-verification-before-completion]]).
2. O Claude atualiza ou cria as páginas em inglês em `~/dev/wiki/content` para o que mudou, depois as versões de e pt-BR ([[wiki-content]]).
3. O que cresceu além do limite ganha página própria (regra de promoção, [[wiki-check]]).
4. `wiki publish -m "…"` verifica localmente, gera, faz commit só do content/ e push ([[wiki-cli]]).
5. O site no ar passa a servir os dados novos na hora ([[wiki-site]], [[wiki-router]]).
6. `mem use REF… --note "como"` informa as entradas de memória usadas ([[mem-use]]).
7. Quando a rodada termina, o [[wiki-hook-stop]] confirma que nada foi esquecido e o [[hook-stop]] faz push dos eventos de memória.
