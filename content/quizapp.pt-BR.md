---
id: quizapp
lang: pt-BR
source_hash: 6017163b5528
title: QuizApp (German Quiz, Android)
---

## What it is
O QuizApp ("German Quiz") é um app Android que o Giovanni usa para treinar alemão no nível B2 do exame Goethe. Funciona offline e usa repetição espaçada no estilo do [Anki](https://apps.ankiweb.net/): um método em que as perguntas respondidas bem voltam depois de intervalos cada vez maiores, e as erradas voltam logo ([repetição espaçada](https://en.wikipedia.org/wiki/Spaced_repetition)). O repositório é `yujideluca/german-quiz`, a pasta é `~/dev/QuizApp` e o nome de pacote do app é `dev.yuji.quiz`. É também o projeto de referência de como os projetos do Giovanni são construídos.

## Flow
trigger t1: Giovanni abre o app no celular | [[phone]]
step s1: Escolhe um dos cinco modos de estudo | [[game-modes]]
step s2: O agendador escolhe a próxima pergunta do banco | [[spaced-repetition-scheduler]]
step s3: O Giovanni responde; o corretor confere | [[answer-grader]]
decide d1: Certo e rápido?
step s4: O cartão vai para dias, semanas, meses
step s5: O cartão volta logo
step s6: Meta diária e calendário de sequência são atualizados | [[daily-goal]], [[activity-calendar]]
trigger t2: Um novo pacote de perguntas é publicado | [[question-pack]]
step s7: O app busca o pacote, sem nova versão do app
trigger t3: Giovanni pede uma mudança | [[giovanni]]
step s8: A mudança segue o caminho de release, beta antes da estável | [[quizapp-release]]
product p1: Progresso de estudo, com backup sob demanda | [[progress-backup]]
product p2: Um app beta ou estável novo no celular | [[update-client]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -sim-> s4
d1 -não-> s5
s4 -> s6
s5 -> s6
s6 -> p1
t2 -> s7
s7 -> s2
t3 -> s8
s8 -> p2

## What it does
Oferece cinco modos de estudo sobre um conjunto selecionado de conteúdo B2 ([[game-modes]]): der/die/das, preposições, formas de plural, Präteritum (o passado simples do alemão) e "Fehler finden" (achar o erro). Respostas erradas ou lentas voltam logo; cartas conhecidas se afastam para dias, semanas e meses ([[spaced-repetition-scheduler]]). Tem meta diária e calendário de sequência ([[daily-goal]], [[activity-calendar]]), cópia de segurança do progresso ([[progress-backup]]) e atualizações de dentro do app ([[update-client]]). Desde 2026-10-22 o conjunto de perguntas pode crescer sem um novo lançamento do app: novos [[question-pack]]s chegam pelo feed de atualização ([[question-pool-updater]], [[publish-content]]).

## How it does it
É escrito em [Kotlin](https://kotlinlang.org/) com [Jetpack Compose](https://developer.android.com/compose) (a forma moderna do Android de desenhar telas), dividido em dois módulos Gradle (partes construídas separadamente): [[quizapp-core]] (lógica em Kotlin puro: agendador, avaliador, fila, sessão, conteúdo) e [[quizapp-app]] (telas Android, armazenamento, atualizações). O conteúdo é construído a partir de arquivos de texto separados por tabulação pelo [[build-vocab]]. Toda mudança segue requisito → teste → código, passa pelo [[quizapp-quality-gate]] e chega ao celular primeiro pelo canal beta ([[release-channels]], [[quizapp-release]]). O design e suas decisões estão em [[quizapp-design-doc]] e [[quizapp-adrs]].

## Where it sits in the pipeline
É a principal ferramenta de estudo do Giovanni. Seu gêmeo web é o [[quizweb]], que deve se comportar igual ([[check-web-sync]]). Os lançamentos saem pelo [[release-feed]].

## Who receives its output
O Giovanni, no [[phone]]; o [[quizweb]] recebe suas regras, vetores de teste e traduções.
