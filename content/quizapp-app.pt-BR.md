---
id: quizapp-app
lang: pt-BR
source_hash: ccb5f8b02f0c
title: Módulo :app do QuizApp
---

## What it is
O módulo `:app` é a metade Android do [[quizapp]]. Depende do [[quizapp-core]] e contém o que só existe em um celular: as telas, o armazenamento e os adaptadores (pedaços finos de código que ligam a lógica pura ao Android).

## What it does
Mostra as telas de estudo ([[study-view-model]]), guarda progresso e configurações ([[progress-store]], [[training-store]], [[settings-store]]), lê o conjunto de perguntas, o embutido ([[vocab-assets]]) ou um mais novo baixado do feed de atualização ([[question-pool-updater]]) e verifica e instala atualizações ([[update-client]], [[apk-installer]]).

## How it does it
As telas usam [Jetpack Compose](https://developer.android.com/compose) e [Material 3](https://m3.material.io/) (o sistema de design do Google), escolhidos na decisão ADR-0002 (uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). A `MainActivity` (uma [Activity](https://developer.android.com/guide/components/activities/intro-activities) é um componente de um app Android que hospeda uma tela) hospeda tudo, aplica o idioma escolhido, atualiza a tela inicial toda vez que o app é retomado e inicia a verificação de atualização. O [[study-controller]] é o ponto de entrada único que as telas chamam. Há dois sabores de build, `stable` e `beta` ([[release-channels]]), ambos assinados com a chave própria do projeto ([[signing-key]]).

## Where it sits in the pipeline
A camada externa, entre o jogador e o [[quizapp-core]].

## Who receives its output
O Giovanni no [[phone]]: o APK (Android Package, o arquivo instalável) construído a partir deste módulo é o que é instalado.

## Functions
- `MainActivity`: hospeda a interface de usuário (UI), botão Voltar, idioma, atualização ao retomar, verificação de atualização ao iniciar
- `ui/Screens.kt`: telas inicial, de pergunta e de término
- `ui/SettingsScreen.kt`, `ui/BackupSection.kt`: configurações e backup
- `ui/CalendarCard.kt`: o cartão do calendário de sequência
- `ui/UpdatePrompt.kt`, `ui/UpdateReducer.kt`: o popup de atualização e seu estado
- `ui/UiState.kt`, `ui/AppUpdater.kt`: os estados das telas e o fluxo de atualização (perguntar ao feed, o popup, baixar o APK), tirado do ViewModel
- `ui/QuestionPool.kt`, `data/ContentStore.kt`, `data/ContentUpdater.kt`: o conjunto de perguntas em uso, o pacote baixado guardado em `files/content` e a verificação que só instala um pacote mais novo quando ele é válido
- `ui/ScreenScale.kt`: escala o layout conforme a altura da tela
- `android/LocaleContext.kt`, `data/AppLanguage.kt`: escolha de idioma
- `data/VocabularySource.kt`, `data/ContentTranslationSource.kt`: leitura dos assets
