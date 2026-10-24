---
id: answer-grader
lang: pt-BR
source_hash: 8db6708f5c54
title: AnswerGrader
---

## What it is
A repetição espaçada no estilo Anki precisa de uma "nota" para cada resposta (Again, Hard, Good, Easy). Em um app de flashcards o jogador se avalia sozinho; em um quiz isso não dá, porque o app já sabe se a resposta estava certa. O `AnswerGrader` transforma, portanto, uma resposta de múltipla escolha em nota automaticamente.

## What it does
- Resposta errada → AGAIN.
- Em uma carta que já está na fase REVIEW: certa em 10 s ou mais → HARD; certa em 2,5 s ou menos → EASY.
- Caso contrário → GOOD.
HARD e EASY nunca são dados a cartas ainda em aprendizado (ou reaprendizado). Motivo: um chute de sorte (um em três) não pode fazer uma carta pular o aprendizado, e uma resposta certa lenta ali sempre passa (requisito GR-1).

## How it does it
É uma função pura (a mesma entrada sempre dá a mesma saída) de três coisas: se a resposta estava certa, o tempo de resposta e a fase da carta. Os limites de tempo ficam em `GraderConfig`.

## Where it sits in the pipeline
O primeiro passo depois que o jogador responde, antes do [[spaced-repetition-scheduler]].

## Who receives its output
O [[spaced-repetition-scheduler]].
