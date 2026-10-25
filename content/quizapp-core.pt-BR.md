---
id: quizapp-core
lang: pt-BR
source_hash: f46e9385279e
title: Módulo :core do QuizApp
---

## What it is
O módulo `:core` é a metade "Kotlin puro" do [[quizapp]]: toda a lógica de estudo, sem nenhuma parte do Android. A "pureza" é imposta pelo build: um `import android.*` neste módulo simplesmente não compila (decisão ADR-0009; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). Um módulo Gradle é uma parte do projeto que é construída sozinha.

## What it does
Contém o domínio (as regras de estudo: cartas, progresso, o [[spaced-repetition-scheduler]], o [[answer-grader]], o [[study-pipeline]], a [[study-session]], a [[daily-goal]], o [[activity-calendar]] e o codec do [[progress-backup]]), a camada de conteúdo ([[card-factory]], [[distractor-factory]], os parsers e a verificação e escolha do pacote de perguntas, [[question-pack]]) e os canais de depuração ([[study-debug-log]]).

## How it does it
Pequenas funções puras são encadeadas em pipelines (uma função é "pura" quando a mesma entrada sempre dá a mesma saída e nada mais muda), os dados são imutáveis e o tempo é passado por um `Clock`, para os testes poderem controlá-lo. É coberto por testes unitários JVM simples (rodam na Java Virtual Machine, sem emulador nem celular) em `core/src/test`, que o [[quizapp-quality-gate]] executa; o [[fitness-check]] também garante que o módulo continue livre de Android.

## Where it sits in the pipeline
A camada interna: `ui → StudyController → domain/content/data`. Nada em `:core` depende do módulo app.

## Who receives its output
O [[quizapp-app]], sobretudo o [[study-controller]].

## Functions
- `Clock`: fonte de tempo injetada, para os testes controlarem o tempo
- `CardAvailability` / `foldForSearch`: quais cartas estão suspensas ou removidas; busca sem acentos ("stuhle" encontra "Stühle" e o ß conta como "ss": "strasse" encontra "Straße")
- `HeatColor`: gradiente de cores do calendário de sequência
- `AppUpdate` / `shouldCheckForUpdate`: regras de atualização (no máximo uma vez por 30 s)
- `SchedulerConfig`, `GraderConfig`: os números ajustáveis
- `ContentTranslations`: textos explicativos em inglês para de/pt/es
- `ContentPack`: o pacote de perguntas (manifesto, lista de arquivos, verificação de checksums, `prefersDownloaded`: um pacote baixado só substitui o embutido quando é mais novo)
- `VocabularyParsers`, `VocabularyModels`: vocabulário JSON (JavaScript Object Notation) para objetos Kotlin
