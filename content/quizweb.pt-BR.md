---
id: quizweb
lang: pt-BR
source_hash: e4103e50ee47
title: QuizWeb (German Quiz, web)
aliases: [gêmeo web]
---

## What it is
A versão web do quiz de alemão, pensada para iPhone: uma PWA (uma página que pode ser instalada como app) servida pelo [[github-pages]]. Repositório `yujideluca/german-quiz-web`, pasta `~/dev/QuizWeb`.

## What it does
Os mesmos cinco modos, o mesmo agendador, a meta diária e o calendário de sequência do [[quizapp]], offline. O progresso fica no navegador daquele aparelho e é separado do app Android; Configurações > Backup salva e restaura.

## How it does it
Módulos ES simples, sem etapa de build e sem dependências: [[quizweb-domain]] (lógica pura), [[quizweb-content]], [[quizweb-controller]], [[quizweb-store]] e [[quizweb-app]] (os únicos que mexem no navegador), mais o cache offline [[quizweb-service-worker]]. `tests/architecture.test.js` define quem pode importar quem; a [[quizweb-ci]] roda `npm test` a cada push.

## Where it sits in the pipeline
O gêmeo do [[quizapp]] (ADR-0006 de lá): lê os mesmos arquivos de vocabulário e os mesmos vetores de conformidade, e o [[check-web-sync]] do QuizApp os compara. A versão web de um app ainda em beta espera num branch `web-<versão>` e entra no `main` quando o app é promovido.

## Who receives its output
O iPhone do Giovanni ou qualquer navegador, pelo [[github-pages]].
