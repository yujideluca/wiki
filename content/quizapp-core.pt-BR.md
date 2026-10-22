---
id: quizapp-core
lang: pt-BR
source_hash: 188f62b22781
title: Módulo :core do QuizApp
---

## What it is
A metade em Kotlin puro do [[quizapp]] (módulo Gradle `:core`): toda a lógica de estudo, sem Android no classpath, de modo que um `import android.*` ali não compila (ADR-0009).

## What it does
Contém o domínio (cartas, progresso, [[spaced-repetition-scheduler]], [[answer-grader]], [[study-pipeline]], [[study-session]], [[daily-goal]], [[activity-calendar]], codec do [[progress-backup]]), a camada de conteúdo ([[card-factory]], [[distractor-factory]], leitores) e os canais de depuração ([[study-debug-log]]).

## How it does it
Funções pequenas e puras encadeadas em fluxos; dados imutáveis; o tempo entra por `Clock`. Coberto por testes unitários JVM simples em `core/src/test`, rodados sem emulador pelo [[quizapp-quality-gate]]; o [[fitness-check]] também confere que continua sem Android.

## Where it sits in the pipeline
A camada interna: `ui → StudyController → domain/content/data`. Nada nele depende do módulo do app.

## Who receives its output
O [[quizapp-app]], principalmente o [[study-controller]].

## Functions
- `Clock`: fonte de tempo injetada, para os testes controlarem o tempo
- `CardAvailability` / `foldForSearch`: quais cartas estão suspensas ou removidas; busca sem acentos
- `HeatColor`: escala de cores do calendário
- `AppUpdate` / `shouldCheckForUpdate`: regras de atualização (no máximo a cada 30 s)
- `SchedulerConfig`, `GraderConfig`: os números ajustáveis
- `ContentTranslations`: textos de explicação em inglês para de/pt/es
- `VocabularyParsers`, `VocabularyModels`: vocabulário JSON para objetos Kotlin
