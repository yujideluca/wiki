---
id: quizweb-domain
lang: pt-BR
source_hash: a77bf1dd1df3
title: domain.js do QuizWeb
---

## What it is
`domain.js` é a lógica pura do [[quizweb]], portada do pacote de domínio do app Android: agendador, avaliador, pipeline da fila, motor de sessão, meta diária e calendário. "Pura" significa que a mesma entrada sempre dá a mesma saída e nada mais é tocado.

## What it does
Comporta-se exatamente como o [[spaced-repetition-scheduler]], o [[answer-grader]] e o [[study-pipeline]] do app. `MODES` lista os cinco modos.

## How it does it
Não tem DOM (Document Object Model, o modelo do navegador para uma página web), nem armazenamento, nem acesso ao relógio. Que ela é igual à do app é provado pelos vetores compartilhados de [[quizweb-conformance]] e pelo [[mutation-check]].

## Where it sits in the pipeline
A camada interna do gêmeo web; só o [[quizweb-controller]] a chama.

## Who receives its output
O [[quizweb-controller]].

## Notes

`foldForSearch` converte `ß` em `ss`, permitindo que `strasse` encontre `Straße`. Para meta diária zero, `dailyProgress` retorna fração 0 sem respostas e 1 após qualquer resposta, evitando divisão por zero. Os testes de regressão da publicação cobrem ambos os casos.
