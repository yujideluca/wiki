---
id: question-pool-updater
lang: pt-BR
source_hash: 54ee99ea9be7
title: Atualizador do conjunto de perguntas (ContentStore, ContentUpdater)
---

## What it is
É a parte do módulo [[quizapp-app]] que baixa pacotes de perguntas mais novos e decide qual pacote o app usa. No código é formada por `ContentUpdater`, `ContentStore` e `QuestionPool`.

## What it does
A cada verificação de atualização (quando o app vai para o primeiro plano, no máximo a cada 30 segundos), lê `content/content.json` do próprio branch do feed (beta: `bleeding-edge`, estável: `main`). Só baixa um pacote se o esquema dele for o que o app entende e a versão for mais alta que a do pacote em uso, e só o instala se a validação do [[question-pack]] passar. Ao iniciar, usa o pacote baixado apenas enquanto for mais novo que o embutido; um pacote desatualizado ou ilegível é apagado. O baralho é trocado na hora na tela inicial ou nas Configurações, e durante uma sessão de estudo só quando o jogador volta ao início. Um popup informa quantas perguntas foram acrescentadas, e as Configurações mostram a versão do conjunto e sua origem.

## How it does it
O `ContentUpdater` busca pelo [[update-client]] (a API de conteúdo do GitHub, application programming interface: uma interface web para ler arquivos de repositório). O `ContentStore` escreve em `files/content/staging` e depois renomeia essa pasta para `files/content/current`, então uma instalação interrompida nunca deixa meio pacote. `ui/QuestionPool.kt` aplica a troca e mostra o popup. O progresso fica intocado, porque os ids das cartas vêm do conteúdo. Um download que falha, é recusado ou ocorre offline é silencioso e não muda nada. É testado pelo `ContentUpdaterTest`. Builds de depuração podem ler um feed local por `adb reverse` (redirecionamento de porta do celular para o notebook; uma configuração de rede só de depuração permite HTTP simples para 127.0.0.1).

## Where it sits in the pipeline
Entre o [[release-feed]] e as telas ([[study-view-model]]).

## Who receives its output
O [[study-view-model]] (o novo baralho e o popup).
