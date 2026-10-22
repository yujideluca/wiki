---
id: quizweb-app
lang: pt-BR
source_hash: 44a76e50bfb6
title: app.js do QuizWeb (interface)
---

## What it is
A camada de interface do [[quizweb]]: desenha as telas e liga os toques ao controlador.

## What it does
Início (calendário, meta diária, modos), perguntas com retorno e avanço automático em 0,5 s, configurações, backup, lista de cartas removidas com busca.

## How it does it
DOM simples; junto com o [[quizweb-store]] é o único código que mexe no navegador (um teste de arquitetura garante isso). Toda a lógica fica no [[quizweb-domain]].

## Where it sits in the pipeline
O topo do gêmeo web, servido pelo [[github-pages]].

## Who receives its output
O Giovanni, no navegador.
