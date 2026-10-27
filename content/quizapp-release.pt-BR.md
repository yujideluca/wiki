---
id: quizapp-release
lang: pt-BR
source_hash: 66c38a45b9c1
title: Lançamento do QuizApp (beta → estável)
---

## What it is
Esta página descreve o caminho que uma mudança no [[quizapp]] percorre da ideia até o celular do Giovanni. O caminho é construído para que nada chegue ao jogador sem especificação, sem teste ou sem ter sido experimentado.

## Flow
trigger t1: Giovanni descreve um comportamento que o app deve ter | [[giovanni]]
step s1: Vira uma linha nos requisitos | [[quizapp-requirements]]
step s2: O Claude escreve o teste marcado com o requisito, depois o código | [[quizapp-core]], [[quizapp-app]]
step s3: Depuração: testes, instalar no celular, exercitar o fluxo, ler o logcat | [[phone]], [[skill-adb-android-control]]
step s4: O quality gate passa localmente; push; as verificações automáticas precisam passar | [[quizapp-quality-gate]], [[quizapp-ci]]
step s5: Uma beta é publicada no branch bleeding-edge do feed de releases | [[publish-apk]], [[release-feed]]
step s6: O app beta oferece a atualização; o Giovanni testa | [[update-client]]
decide d1: O Giovanni manda promover?
step s7: O gate de promoção com checagem de mutação e de testes atualizados publica o app estável | [[mutation-check]], [[check-tests-updated]]
step s8: O port do QuizWeb que esperava é integrado ao main | [[quizweb]]
trigger t2: Só entram perguntas novas | [[question-pool-updater]]
step s9: Edita os arquivos de perguntas e roda o build-vocab | [[build-vocab]]
step s10: Publica a beta e depois promove quando o pipeline automático passa | [[publish-content]]
product p1: O app estável no celular do Giovanni | [[quizapp]]
product p2: A versão continua beta e espera
product p3: Perguntas novas entregues sem um novo arquivo do app

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> s6
s6 -> d1
d1 -sim-> s7
d1 -não-> p2
s7 -> s8
s7 -> p1
s8 -> p1
t2 -> s9
s9 -> s10
s10 -> p3

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
