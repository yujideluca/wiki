---
id: settings-store
lang: pt-BR
source_hash: 3a96c21f4463
title: SettingsStore (tema e idioma)
aliases: [configuração de idioma]
---

## What it is
O pequeno armazenamento de tema (sistema / claro / noturno) e idioma (padrão do sistema, English, Deutsch, Português (Brasil), Español) do QuizApp.

## What it does
Lembra os dois; o idioma padrão segue o celular e cai para inglês (`AppLanguage.effective`).

## How it does it
SharedPreferences. `MainActivity.attachBaseContext` aplica o idioma salvo e a activity se recria quando ele muda. O conteúdo de estudo continua em alemão em qualquer idioma.

## Where it sits in the pipeline
Lido na abertura pelo [[quizapp-app]], alterado nas Configurações.

## Who receives its output
O [[study-view-model]] e todas as telas.
