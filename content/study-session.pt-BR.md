---
id: study-session
lang: pt-BR
source_hash: 99d86b9cf98f
title: StudyEngine / StudySession
---

## What it is
A `StudySession` (o "motor de sessão") é uma sessão de estudo em andamento no [[quizapp]]. É mantida como estado imutável (um valor que nunca é alterado no lugar) com transições puras (cada evento produz um valor novo em vez de alterar o antigo).

## What it does
Conhece a carta atual, o retorno sobre a última resposta e o que vem a seguir. Uma carta em aprendizado que aparece de novo conta de novo para a [[daily-goal]].

## How it does it
Cada evento (uma resposta, "próximo", uma suspensão) devolve um novo valor de sessão. A ordem dos botões de resposta é embaralhada a cada repetição, mas fica congelada enquanto o retorno está na tela, para que um botão nunca se mova sob o dedo do jogador.

## Where it sits in the pipeline
Entre o [[study-pipeline]] (que dá a fila) e o [[study-controller]] (que aplica avaliação e salvamento).

## Who receives its output
O [[study-controller]] e, por ele, o [[study-view-model]].
