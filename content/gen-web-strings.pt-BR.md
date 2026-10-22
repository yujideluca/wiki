---
id: gen-web-strings
lang: pt-BR
source_hash: 9a7056c33b09
title: gen_web_strings.py
aliases: [gerador de textos web]
---

## What it is
Gera os textos da interface do gêmeo web a partir dos recursos de texto do app Android.

## What it does
Lê `res/values*/strings.xml` (inglês, alemão, português, espanhol) mais alguns textos só da web e escreve o `src/strings.js` do [[quizweb]], para os dois apps dizerem o mesmo em todos os idiomas.

## How it does it
Python; marcadores `{0}`, `{1}`…; o inglês é o padrão para o que faltar.

## Where it sits in the pipeline
Dos recursos do [[quizapp-app]] para o [[quizweb-i18n]].

## Who receives its output
O [[quizweb-i18n]].
