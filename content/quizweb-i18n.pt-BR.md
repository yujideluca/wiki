---
id: quizweb-i18n
lang: pt-BR
source_hash: b64379cea94a
title: i18n.js e strings.js do QuizWeb
---

## What it is
i18n ("internacionalização": i, 18 letras, n) é o tratamento de vários idiomas. `i18n.js` e `strings.js` dão ao [[quizweb]] seu tratamento de idiomas, portado do app: qual idioma mostrar, busca de textos da interface, nomes do calendário e textos explicativos traduzidos.

## What it does
Uma escolha explícita do usuário vence; senão usa-se o primeiro idioma do navegador que for oferecido, senão inglês. As perguntas e opções de resposta continuam em alemão.

## How it does it
O `strings.js` é gerado pelo [[gen-web-strings]]; os arquivos `i18n/*.json` são cópias das traduções de conteúdo do app, comparadas pelo [[check-web-sync]].

## Where it sits in the pipeline
Usado pelo [[quizweb-app]].

## Who receives its output
O [[quizweb-app]].
