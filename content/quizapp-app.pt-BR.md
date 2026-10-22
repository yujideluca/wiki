---
id: quizapp-app
lang: pt-BR
source_hash: 0fb1ee33cb85
title: Módulo :app do QuizApp
---

## What it is
A metade Android do [[quizapp]] (módulo Gradle `:app`, depende do [[quizapp-core]]): telas, armazenamento e adaptadores Android.

## What it does
Mostra as telas de estudo ([[study-view-model]]), guarda progresso e configurações ([[progress-store]], [[training-store]], [[settings-store]]), lê o vocabulário embutido ([[vocab-assets]]), verifica e instala atualizações ([[update-client]], [[apk-installer]]).

## How it does it
Jetpack Compose + Material 3 (ADR-0002). A `MainActivity` hospeda tudo, aplica o idioma escolhido, atualiza a tela inicial a cada retorno e inicia a verificação de atualização; o [[study-controller]] é a única fachada que a interface chama. Duas variantes de build, `stable` e `beta` ([[release-channels]]), assinadas com a chave própria do projeto ([[signing-key]]).

## Where it sits in the pipeline
A camada externa, entre o jogador e o [[quizapp-core]].

## Who receives its output
O Giovanni no [[phone]]: o APK é o que se instala.

## Functions
- `MainActivity`: hosts the UI, Back button, language, resume refresh, update check on start
- `ui/Screens.kt`: home, question, finished screens
- `ui/SettingsScreen.kt`, `ui/BackupSection.kt`: settings and backup
- `ui/CalendarCard.kt`: the streak calendar card
- `ui/UpdatePrompt.kt`, `ui/UpdateReducer.kt`: the update popup and its state
- `ui/ScreenScale.kt`: scales layout with screen height
- `android/LocaleContext.kt`, `data/AppLanguage.kt`: language choice
- `data/VocabularySource.kt`, `data/ContentTranslationSource.kt`: read assets
