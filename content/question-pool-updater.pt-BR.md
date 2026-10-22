---
id: question-pool-updater
lang: pt-BR
source_hash: 00d51f3bc0c9
title: Atualizador do banco de perguntas (ContentStore, ContentUpdater)
---

## What it is
A parte do [[quizapp-app]] que baixa pacotes de perguntas mais novos e decide qual pacote o app usa.

## What it does
A cada verificação de atualização (app em primeiro plano, no máximo a cada 30 s) ele lê o `content/content.json` do próprio branch do canal (beta: `bleeding-edge`, estável: `main`), baixa um pacote só se o schema for o do app e a versão for maior que a do pacote em uso, e só o instala se a validação do [[question-pack]] passar. Na abertura, usa o pacote baixado só enquanto ele for mais novo que o embutido; um desatualizado ou ilegível é apagado. O baralho é trocado na hora na tela inicial ou nas Configurações; durante uma sessão de estudo, só quando o jogador volta ao início. Um aviso diz quantas perguntas entraram, e as Configurações mostram a versão e a origem do banco.

## How it does it
O `ContentUpdater` busca pelo [[update-client]] (API de conteúdo do GitHub); o `ContentStore` grava em `files/content/staging` e renomeia para `files/content/current`, então uma instalação interrompida nunca deixa meio pacote. O `ui/QuestionPool.kt` faz a troca e o aviso. O progresso não é tocado, porque os ids das cartas vêm do conteúdo. Um download que falha, é recusado ou está offline é silencioso e não muda nada. Testado pelo `ContentUpdaterTest`. Builds de depuração podem ler um canal local por `adb reverse` (uma configuração de rede só de depuração permite HTTP para 127.0.0.1).

## Where it sits in the pipeline
Entre o [[release-feed]] e as telas ([[study-view-model]]).

## Who receives its output
O [[study-view-model]] (o baralho novo e o aviso).
