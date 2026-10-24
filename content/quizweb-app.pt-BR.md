---
id: quizweb-app
lang: pt-BR
source_hash: 8ddd998275e8
title: app.js do QuizWeb (UI)
---

## What it is
`app.js` é a camada de interface de usuário do [[quizweb]]: desenha as telas e liga os toques ao controller. (Junto com `index.html` e `style.css` é o que o navegador de fato mostra.)

## What it does
Mostra a tela inicial (calendário, meta diária, modos), as perguntas com retorno e avanço automático de 0,5 segundo, as configurações, o backup e a lista de cartas removidas com caixa de busca.

## How it does it
Trabalha direto no DOM (Document Object Model: o modelo vivo do navegador para uma página web, veja [a documentação](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)), sem framework. Junto com o [[quizweb-store]] é o único código que toca o navegador, e um teste de arquitetura garante isso. Toda a lógica fica em [[quizweb-domain]].

## Where it sits in the pipeline
O topo do gêmeo web, servido pelo [[github-pages]].

## Who receives its output
O Giovanni, no navegador.
