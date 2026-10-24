---
id: spaced-repetition-scheduler
lang: pt-BR
source_hash: ff1ac9e54dfb
title: SpacedRepetitionScheduler
---

## What it is
O agendador (scheduler) é o coração do [[quizapp]]: uma função pura `(progress, grade, now, config) → progress` que decide quando uma carta volta. É uma variante do algoritmo SM-2 (SuperMemo 2, um método inicial de [repetição espaçada](https://en.wikipedia.org/wiki/SuperMemo) usado por muitos programas de flashcards) com os parâmetros padrão do [Anki](https://apps.ankiweb.net/).

## What it does
Move uma carta por fases: NEW → LEARNING → REVIEW (RELEARNING depois de um lapso, isto é, um erro numa carta já conhecida). A primeira resposta certa leva a carta a 3 dias; cada resposta certa seguinte multiplica o intervalo pela "facilidade" (ease), de modo que fica 3 → 8 → 20 → 50 → 125 dias. Um erro em uma carta nova se repete após 10 minutos, nunca antes (decisão ADR-0007, "as regras de espaçamento"; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão).

## How it does it
Nunca lê o relógio sozinho e não tem "fuzz" aleatório nos intervalos, sendo totalmente determinístico (decisão ADR-0003). A facilidade inicial é 2,5, a mínima 1,3, o bônus de fácil 1,3 e o fator de difícil 1,2 (tudo em `SchedulerConfig`). O comportamento é fixado pelos testes `SpacingRulesTest` e `PeriodizationSimulationTest`, por vetores de conformidade compartilhados com o [[quizweb-domain]] e pelo [[mutation-check]].

## Where it sits in the pipeline
Logo depois do [[answer-grader]] no pipeline de respostas; sua saída é o novo `CardProgress` que o [[study-controller]] salva.

## Who receives its output
O [[study-controller]] (e, por ele, o [[progress-store]]).
