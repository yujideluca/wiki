---
id: settings-store
lang: pt-BR
source_hash: ea2eef65a238
title: SettingsStore (tema e idioma)
---

## What it is
Um pequeno armazenamento para duas configurações do QuizApp: o tema (seguir o sistema, claro ou noturno) e o idioma (padrão do sistema, English, Deutsch, Português (Brasil), Español).

## What it does
Lembra as duas escolhas. O idioma padrão segue o idioma do celular e volta para o inglês quando o idioma do celular não é oferecido (`AppLanguage.effective`).

## How it does it
Usa SharedPreferences (um pequeno armazenamento chave-valor embutido no Android). `MainActivity.attachBaseContext` envolve o contexto do app com o idioma guardado, e a tela se recria quando o idioma muda. O conteúdo de estudo continua em alemão em qualquer idioma da interface.

## Where it sits in the pipeline
Lido no início pelo módulo [[quizapp-app]]; alterado na tela de configurações.

## Who receives its output
O [[study-view-model]] e todas as telas.
