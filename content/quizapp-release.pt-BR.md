---
id: quizapp-release
lang: pt-BR
source_hash: 31e1fe43f277
title: Publicação do QuizApp (beta → estável)
aliases: [processo de publicação]
---

## What it is
O caminho que uma mudança no [[quizapp]] percorre da ideia até o celular do Giovanni.

## What it does
Garante que toda mudança é especificada, testada, experimentada no beta e só promovida quando o Giovanni decide.

## How it does it
Primeiro o requisito ([[quizapp-requirements]]), depois o teste, depois o código; o portão decide; beta antes do estável ([[release-channels]]).

## Where it sits in the pipeline
Passa por [[quizapp-requirements]], [[quizapp-quality-gate]], [[publish-apk]], [[release-feed]] e [[update-client]].

## Who receives its output
O Giovanni, no [[phone]].

## Steps
1. O Giovanni descreve um comportamento; ele vira uma linha em [[quizapp-requirements]].
2. O Claude escreve o teste marcado `REQ <ID>`, depois o código, no [[quizapp-core]] ou no [[quizapp-app]].
3. A primeira rodada de depuração: testes, instalar no [[phone]], percorrer o fluxo, ler o logcat ([[skill-adb-android-control]]).
4. O [[quizapp-quality-gate]] passa localmente; push; a [[quizapp-ci]] precisa ficar verde.
5. O [[publish-apk]] publica um beta no branch `bleeding-edge` do [[release-feed]].
6. O [[update-client]] do app beta oferece a atualização; o Giovanni experimenta.
7. `publish_apk.sh promote` (portão com [[mutation-check]] e [[check-tests-updated]]) leva ao estável `main` quando o Giovanni decide.
8. A versão do [[quizweb]] que esperava em `web-<versão>` entra no `main`.
