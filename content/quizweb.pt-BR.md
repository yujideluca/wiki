---
id: quizweb
lang: pt-BR
source_hash: 54da115249d9
title: QuizWeb (German Quiz, web)
---

## What it is
O QuizWeb é a versão web do quiz de alemão, feita para funcionar em um iPhone. É um PWA (progressive web app: uma página web que pode ser instalada no celular como um app e continua funcionando offline, veja [PWA](https://en.wikipedia.org/wiki/Progressive_web_app)), servido pelo [[github-pages]]. O repositório é `yujideluca/german-quiz-web` e a pasta é `~/dev/QuizWeb`. É o "gêmeo web" do [[quizapp]].

## Flow
trigger t1: Giovanni abre o QuizWeb num navegador, por exemplo no iPhone | [[github-pages]]
step s1: O service worker guarda o app em cache para funcionar offline | [[quizweb-service-worker]]
step s2: O controlador conduz uma sessão de estudo com a lógica pura | [[quizweb-controller]], [[quizweb-domain]]
step s3: Perguntas e traduções são carregadas | [[quizweb-content]]
step s4: O progresso é salvo no navegador daquele aparelho | [[quizweb-store]]
product p1: Sessões de estudo que funcionam offline; Configurações > Backup guarda o progresso
trigger t2: O app Android estável muda perguntas, traduções ou modos | [[quizapp]]
step s5: check-web-sync compara arquivos, modos e o estado enviado do clone web | [[check-web-sync]]
decide d1: O gêmeo web combina?
step s6: Porta a mudança, sobe a versão do cache, roda os testes e faz push
trigger t3: Um push no repositório | [[quizweb-ci]]
step s7: Os testes rodam, inclusive quem pode importar quem, mais os limites do pipeline-check | [[pipeline-check]]
decide d2: Tudo passou?
step s8: O GitHub Pages publica o push em cerca de um minuto | [[github-pages]]
product p2: Os gêmeos estão em sincronia
product p3: Uma versão nova para todo navegador
product p4: Nada é publicado

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> p1
t2 -> s5
s5 -> d1
d1 -sim-> p2
d1 -não-> s6
s6 -> s7
t3 -> s7
s7 -> d2
d2 -sim-> s8
d2 -não-> p4
s8 -> p3

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
