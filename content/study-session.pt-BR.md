---
id: study-session
lang: pt-BR
source_hash: 99fe926c4491
title: StudyEngine / StudySession
---

## What it is
A sessão de estudo em andamento do [[quizapp]], guardada como estado imutável com transições puras.

## What it does
Sabe a carta atual, o retorno da resposta e o que vem depois; uma carta em aprendizado mostrada de novo conta de novo para a [[daily-goal]].

## How it does it
Cada evento (responder, próxima, suspender) devolve um novo valor de sessão; a ordem dos botões é embaralhada a cada repetição, mas fica fixa enquanto o retorno aparece.

## Where it sits in the pipeline
Entre o [[study-pipeline]] (a fila) e o [[study-controller]] (que avalia e salva).

## Who receives its output
O [[study-controller]] e, por ele, o [[study-view-model]].
