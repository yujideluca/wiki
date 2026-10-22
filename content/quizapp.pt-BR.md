---
id: quizapp
lang: pt-BR
source_hash: dcad0403eab5
title: QuizApp (German Quiz, Android)
---

## What it is
Um app Android offline para treinar alemão B2 com repetição espaçada no estilo do Anki. Repositório `yujideluca/german-quiz`, pasta `~/dev/QuizApp`, pacote `dev.yuji.quiz`. É o projeto de referência de como os projetos do Giovanni são construídos.

## What it does
Cinco modos de estudo sobre um conjunto fixo de B2 ([[game-modes]]): der/die/das, preposições, plurais, Präteritum e Fehler finden. Respostas erradas ou lentas voltam logo; cartas conhecidas vão para dias, semanas e meses ([[spaced-repetition-scheduler]]). Meta diária e calendário de sequência ([[daily-goal]], [[activity-calendar]]), backup ([[progress-backup]]) e atualização dentro do app ([[update-client]]).

## How it does it
Kotlin + Jetpack Compose em dois módulos Gradle: [[quizapp-core]] (Kotlin puro: agendador, avaliador, fila, sessão, conteúdo) e [[quizapp-app]] (interface Android, armazenamento, atualizações). O conteúdo é gerado a partir de arquivos TSV pelo [[build-vocab]]. Toda mudança segue requisito → teste → código, passa pelo [[quizapp-quality-gate]] e chega ao celular primeiro pelo canal beta ([[release-channels]], [[quizapp-release]]). Desenho e decisões: [[quizapp-design-doc]] e [[quizapp-adrs]].

## Where it sits in the pipeline
A principal ferramenta de estudo do Giovanni; seu gêmeo web é o [[quizweb]], que precisa se comportar igual ([[check-web-sync]]). As versões saem pelo [[release-feed]].

## Who receives its output
O Giovanni no [[phone]]; o [[quizweb]] recebe as regras, os vetores de teste e as traduções.
