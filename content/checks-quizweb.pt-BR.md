---
id: checks-quizweb
lang: pt-BR
source_hash: aea4741f3451
title: QuizWeb: verificadores e regras
---

## What it is
Estes são os verificadores do [[quizweb]], o gêmeo web do app de quiz: uma página web instalável como PWA (aplicativo web progressivo) que deve se comportar como o app Android.

## What it does
O gate tem dois passos: `npm test` (o executor de testes puro do Node, sem dependências) e `pipeline-check --measure-only`. Os arquivos de teste são domain, controller, daily-bar, content, i18n, conformance, bughunt e architecture. O teste de arquitetura é uma função de fitness escrita como teste: cada módulo-fonte tem uma entrada em uma lista de quem pode importar quem, então um arquivo novo exige uma entrada consciente; só o `app.js` pode tocar a página e só o `store.js` o armazenamento do navegador. Limites: nenhum arquivo JavaScript com mais de 600 linhas em `src/`, o gate com no máximo 300 segundos. Os vetores de conformidade são compartilhados com o app; o gate do app os compara byte a byte ([[quizweb-conformance]]).

## How it does it
O workflow de CI (integração contínua) se chama `test` (não `gate`), e a verificação obrigatória em `pipeline-check.toml` é `test` ([[quizweb-ci]]). O projeto web não tem seção de rastreabilidade: suas promessas são acompanhadas na lista do QuizApp, cujo passo de rastreabilidade lê a pasta de testes web (rótulo `web`, pasta indicada por `QUIZWEB_TESTS`). Aumentar a versão em `sw.js` (o service worker, [[quizweb-service-worker]]) faz parte de toda portagem.

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
