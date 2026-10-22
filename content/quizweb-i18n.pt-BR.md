---
id: quizweb-i18n
lang: pt-BR
source_hash: 62f87536c25f
title: i18n.js e strings.js do QuizWeb
aliases: [idiomas da web]
---

## What it is
O tratamento de idiomas do gêmeo web, portado do app: qual idioma mostrar, busca dos textos da interface, nomes do calendário e textos de explicação traduzidos.

## What it does
Uma escolha explícita vence; senão, o primeiro idioma do navegador que ele oferece; senão, inglês. Perguntas e opções continuam em alemão.

## How it does it
O `strings.js` é gerado pelo [[gen-web-strings]]; os `i18n/*.json` são cópias das traduções de conteúdo do app, comparadas pelo [[check-web-sync]].

## Where it sits in the pipeline
Usado pelo [[quizweb-app]].

## Who receives its output
O [[quizweb-app]].
