---
id: quizweb-service-worker
lang: pt-BR
source_hash: ba1e754f80af
title: Service worker do QuizWeb (cache offline)
---

## What it is
`sw.js` é o cache offline do [[quizweb]]. Um [service worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) é um script que o navegador executa em segundo plano para uma página web; ele pode responder a requisições com uma cópia guardada, e é isso que faz o quiz funcionar sem conexão depois de instalado.

## What it does
Guarda em cache todos os arquivos do app. Tenta a rede primeiro e usa o cache só como reserva offline, então uma publicação aparece na próxima abertura. A página recarrega uma vez quando um novo worker assume.

## How it does it
Quando qualquer arquivo em cache muda, a constante `VERSION` do arquivo precisa ser aumentada, para as cópias instaladas perceberem a mudança e se atualizarem. (É só uma chave de cache; o QuizWeb não tem versão própria.)

## Where it sits in the pipeline
Entre o [[github-pages]] e o navegador.

## Who receives its output
O navegador do iPhone do Giovanni.
