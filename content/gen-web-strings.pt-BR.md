---
id: gen-web-strings
lang: pt-BR
source_hash: ef08b395f9e5
title: gen_web_strings.py
---

## What it is
`gen_web_strings.py` gera o texto da interface do gêmeo web a partir dos recursos de strings do app Android. Um recurso de strings é um arquivo em que um app Android guarda todo o seu texto de tela, um arquivo por idioma.

## What it does
Lê `res/values*/strings.xml` (inglês, alemão, português, espanhol) mais alguns textos só da web e escreve o `src/strings.js` do [[quizweb]], para os dois apps dizerem a mesma coisa em todos os idiomas.

## How it does it
Um script [Python](https://www.python.org/). Marcadores como `{0}` e `{1}` indicam onde um valor entra numa frase; o inglês é o recurso de reserva para o que faltar.

## Where it sits in the pipeline
Dos recursos do [[quizapp-app]] ao [[quizweb-i18n]].

## Who receives its output
O [[quizweb-i18n]].
