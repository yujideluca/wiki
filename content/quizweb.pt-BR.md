---
id: quizweb
lang: pt-BR
source_hash: 5c67003c0580
title: QuizWeb (German Quiz, web)
---

## What it is
O QuizWeb é a versão web do quiz de alemão, feita para funcionar em um iPhone. É um PWA (progressive web app: uma página web que pode ser instalada no celular como um app e continua funcionando offline, veja [PWA](https://en.wikipedia.org/wiki/Progressive_web_app)), servido pelo [[github-pages]]. O repositório é `yujideluca/german-quiz-web` e a pasta é `~/dev/QuizWeb`. É o "gêmeo web" do [[quizapp]].

## What it does
Tem os mesmos cinco modos, agendador, meta diária e calendário de sequência do [[quizapp]] e funciona offline. O progresso fica no navegador daquele aparelho e é separado do app Android; Configurações > Backup o salva e restaura.

## How it does it
É JavaScript simples em módulos ES (a forma padrão de dividir JavaScript em arquivos), sem etapa de build e sem dependências. As partes são: [[quizweb-domain]] (lógica pura), [[quizweb-content]], [[quizweb-controller]], [[quizweb-store]] e [[quizweb-app]] (os dois últimos são os únicos módulos que tocam o navegador), mais o cache offline [[quizweb-service-worker]]. O teste `tests/architecture.test.js` define quem pode importar quem, e a [[quizweb-ci]] executa `npm test` e os limites do [[pipeline-check]] a cada push.

## Where it sits in the pipeline
É o gêmeo do [[quizapp]] (decisão ADR-0006 lá; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão): lê os mesmos arquivos de vocabulário e os mesmos vetores de conformidade, e o [[check-web-sync]] no QuizApp os compara. A adaptação de recursos Android ainda em beta espera em um branch `web-<versão>` e é mesclada ao `main` quando o app é promovido.

## Who receives its output
O iPhone do Giovanni, ou qualquer navegador, por meio do [[github-pages]].

## Notes

A publicação independente de manutenção de 2026-10-26 inclui a busca com eszett, o cálculo de progresso para meta zero e verificações na importação de backup. Sua chave de cache offline é `v12`. Correções de manutenção podem sair independentemente de outra versão Android; adaptações de recursos Android ainda não lançados continuam aguardando o lançamento do app. O GitHub protege `main` exigindo a verificação `test`, inclusive para administradores, e impede sobrescritas forçadas e exclusão do branch. O commit de manutenção passou nos 81 testes e na publicação pelo GitHub Pages.
