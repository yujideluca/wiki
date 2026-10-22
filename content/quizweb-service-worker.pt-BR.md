---
id: quizweb-service-worker
lang: pt-BR
source_hash: d2d86f142552
title: Service worker do QuizWeb (cache offline)
aliases: [offline]
---

## What it is
O `sw.js`: o cache offline que deixa o quiz web funcionar sem conexão depois de instalado.

## What it does
Guarda todos os arquivos do app; rede primeiro, cache só como reserva offline; a página recarrega uma vez quando um worker novo assume, então uma publicação aparece na próxima abertura.

## How it does it
Quando um arquivo do cache muda, é preciso aumentar o `VERSION` para as cópias instaladas atualizarem.

## Where it sits in the pipeline
Entre o [[github-pages]] e o navegador.

## Who receives its output
O navegador do iPhone do Giovanni.
