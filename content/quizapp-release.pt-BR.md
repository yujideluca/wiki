---
id: quizapp-release
lang: pt-BR
source_hash: 094ad2e7e9e9
title: Lançamento do QuizApp (beta → estável)
---

## What it is
Esta página descreve o caminho que uma mudança no [[quizapp]] percorre da ideia até o celular do Giovanni. O caminho é construído para que nada chegue ao jogador sem especificação, sem teste ou sem ter sido experimentado.

## What it does
Garante que toda mudança seja especificada, testada, experimentada em uma versão beta e promovida à versão estável somente quando o Giovanni disser.

## How it does it
O requisito vem primeiro ([[quizapp-requirements]]), depois o teste, depois o código; o portão de qualidade decide; a versão beta vem antes da estável ([[release-channels]]).

## Where it sits in the pipeline
Abrange [[quizapp-requirements]], [[quizapp-quality-gate]], [[publish-apk]], [[release-feed]] e [[update-client]].

## Who receives its output
O Giovanni, no [[phone]].

## Steps
1. O Giovanni declara um comportamento; ele vira uma linha em [[quizapp-requirements]].
2. O Claude escreve o teste etiquetado `REQ <ID>`, depois o código, em [[quizapp-core]] ou [[quizapp-app]].
3. A verificação de depuração de primeira linha: testes, instalação no [[phone]], percorrer o fluxo, ler o logcat ([[skill-adb-android-control]]).
4. O [[quizapp-quality-gate]] passa localmente; push; a [[quizapp-ci]] precisa estar verde.
5. O [[publish-apk]] publica um beta no branch `bleeding-edge` do [[release-feed]] (um APK, Android Package, é o arquivo instalável do app).
6. O [[update-client]] do app beta oferece a atualização; o Giovanni a experimenta.
7. `publish_apk.sh promote` (o portão com [[mutation-check]] e [[check-tests-updated]]) publica o app estável no `main` quando o Giovanni decide, e só se o `bleeding-edge` tiver exatamente este commit.
8. A portabilidade do [[quizweb]] que espera no branch `web-<versão>` é mesclada ao `main`.
9. Só perguntas novas não precisam de APK: editar os arquivos TSV (valores separados por tabulação), executar o [[build-vocab]], commitar, depois [[publish-content]] `beta` e `promote` assim que o pipeline automático (o gate e o [[mutation-check]]) passar: desde 25 de outubro de 2026, a permissão permanente do Giovanni cobre atualizações do banco de perguntas, sem precisar de novo aval. Releases do app continuam esperando o Giovanni.
