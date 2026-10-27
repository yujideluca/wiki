---
id: mem-harvester
lang: pt-BR
source_hash: 79ffe59f2902
title: Colhedor de preferências (harvest.py)
---

## What it is
O harvester ("harvest" significa colher) recolhe preferências das próprias palavras do Giovanni nas mensagens que ele envia, para que uma regra dita uma vez não se perca só porque ninguém executou `mem add`. Fica em `mem/harvest.py`.

## What it does
Só vale o texto da própria mensagem do usuário (nunca saída de ferramentas nem texto do Claude), em inglês e português, e só frases que enunciam uma regra e nomeiam uma ação. Por padrão uma preferência colhida vale só para o projeto atual; um hábito visto em dois projetos, ou formulado como "em todos os meus projetos", torna-se global (esse passo se chama `promote`).

## How it does it
Os ids de evento são determinísticos (a mesma entrada sempre produz o mesmo id), então uma chamada de hook repetida escreve o mesmo arquivo em vez de um duplicado. Uma entrada colhida nunca sobrescreve uma com `owner: user` (as palavras registradas do próprio Giovanni); em vez disso, vira uma proposta listada no arquivo de revisão para o Giovanni decidir. O texto é ignorado quando a mensagem inteira tem mais de 1500 caracteres (um documento colado ou um prompt escrito por um programa, não uma preferência rápida) e quando uma frase começa como um título ou um item de lista numerada. Isso foi acrescentado depois que prompts de sugestão gerados pelo Codex foram gravados como 17 preferências falsas.

## Where it sits in the pipeline
Chamado pelo [[hook-prompt]] a cada mensagem que o Giovanni envia ao Claude Code.

## Who receives its output
[[events-log]].
