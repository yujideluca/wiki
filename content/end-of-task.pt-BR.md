---
id: end-of-task
lang: pt-BR
source_hash: 883c3c32604a
title: Fim de uma tarefa (cadeia de atualização do wiki)
---

## What it is
Esta página descreve o que o Claude faz toda vez que termina uma tarefa, para que a memória e este wiki nunca fiquem atrás do que foi realmente construído. O Giovanni decidiu em 2026-10-22 que a atualização do wiki está ligada ao relatório `mem use`.

## What it does
O Claude atualiza as páginas do wiki para tudo o que mudou (coisas novas, alteradas ou aposentadas, cada uma com sua tradução em alemão e português), publica-as passando pelas verificações de conteúdo e depois informa quais entradas da memória influenciaram o trabalho.

## How it does it
A regra está escrita em [[global-claude-md]]; as verificações que protegem a publicação estão em [[wiki-check]]; e uma rede de segurança, [[wiki-hook-stop]], lembra o Claude se ele esquecer.

## Where it sits in the pipeline
É o último passo de toda tarefa de programação, em qualquer projeto.

## Who receives its output
O conteúdo do wiki ([[wiki-content]]), o [[github]] (onde o wiki é guardado) e o registro de memória [[events-log]].

## Steps
1. O trabalho da tarefa está feito e comprovado por verificações executadas ([[skill-verification-before-completion]]).
2. O Claude atualiza ou cria as páginas em inglês em `~/dev/wiki/content` para o que mudou, depois as versões em alemão e português do Brasil ([[wiki-content]]). Uma página que foi comparada com suas fontes e achada certa recebe o `reviewed` com o horário UTC atual, que é o que a tira da lista do [[wiki-stale]].
3. Tudo o que passou do limite de tamanho de página ganha página própria (a regra de promoção, aplicada por [[wiki-check]]).
4. `wiki publish -m "…"` verifica o conteúdo, constrói o site, faz commit só da pasta `content/` e a envia ([[wiki-cli]]).
5. O site no ar serve os novos dados na hora ([[wiki-site]], [[wiki-router]]).
6. `mem use REF… --note "how"` informa as entradas de memória usadas ([[mem-use]]).
7. Quando a rodada termina, [[wiki-hook-stop]] confirma que nada foi esquecido e [[hook-stop]] envia os eventos de memória.
