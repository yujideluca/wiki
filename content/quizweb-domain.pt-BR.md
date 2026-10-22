---
id: quizweb-domain
lang: pt-BR
source_hash: 0e14c608a0a7
title: domain.js do QuizWeb
---

## What it is
A lógica pura do [[quizweb]], portada do pacote domain do app Android: agendador, avaliador, fila, sessão, meta diária e calendário.

## What it does
Comporta-se exatamente como o [[spaced-repetition-scheduler]], o [[answer-grader]] e o [[study-pipeline]]; `MODES` lista os cinco modos.

## How it does it
Sem DOM, sem armazenamento, sem acesso ao relógio; a igualdade com o app é provada pelos vetores compartilhados do [[quizweb-conformance]] e pelo [[mutation-check]].

## Where it sits in the pipeline
A camada interna do gêmeo web; só o [[quizweb-controller]] a chama.

## Who receives its output
O [[quizweb-controller]].
