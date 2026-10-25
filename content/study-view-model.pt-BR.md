---
id: study-view-model
lang: pt-BR
source_hash: f058106c75c3
title: StudyViewModel (estado da UI)
---

## What it is
Um [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel) é a parte de um app Android que prepara dados para as telas e sobrevive a rotações de tela. O StudyViewModel é o único ViewModel do [[quizapp]]; ele expõe um `UiState` "selado" (UI significa interface de usuário; selado significa que só pode ser um dentre uma lista fixa de casos: `ModeSelect`, `Studying`, `Finished`, `Settings`, `Failed`) às telas Compose.

## What it does
Transforma os resultados do [[study-controller]] no que as telas mostram: a tela inicial (calendário, meta diária, cartões de modo), a pergunta com retorno (verde ou vermelho, a explicação, avanço automático após 0,5 s exceto no Fehler finden), as configurações e o popup de atualização.

## How it does it
Sobrevive à recriação da tela que acontece quando o idioma é trocado. O texto que ele mesmo produz passa pelo auxiliar `t()`, que escolhe o idioma certo. Os tipos `UiState` ficam em `UiState.kt` e o fluxo de atualização (perguntar ao feed, o popup, baixar o APK, Android Package, o arquivo instalável do app) em `AppUpdater.kt`, de modo que o ViewModel fica abaixo de 300 linhas; um conjunto de perguntas baixado pelo fluxo de atualização é devolvido a ele, e ele decide quando o baralho pode ser trocado ([[question-pool-updater]]). As telas escalam com a altura da tela (`ScreenScale`), e um teste de "encaixe de tela" verifica que nada fica escondido abaixo da dobra em celulares altos.

## Where it sits in the pipeline
O topo do app: `ui → StudyController`.

## Who receives its output
O Giovanni no [[phone]].
