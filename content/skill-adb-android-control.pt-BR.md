---
id: skill-adb-android-control
lang: pt-BR
source_hash: 14c7eece1c47
title: Skill: adb-android-control
---

## What it is
A referência de comandos para trabalhar com o celular do Giovanni (Motorola edge 50 fusion) por adb durante o desenvolvimento.

## What it does
Instalar um APK, abrir o app, tocar, deslizar e digitar para percorrer um fluxo, tirar capturas de tela, ler o logcat atrás de travamentos, dumpsys, permissões: a primeira rodada de depuração depois de programar o [[quizapp]].

## How it does it
Um `SKILL.md` em `~/.claude/skills/adb-android-control`; o Claude a carrega quando um pedido combina com a descrição dela.

## Where it sits in the pipeline
Parte do processo de desenvolvimento no Claude Code, usada em todo projeto.

## Who receives its output
O [[phone]]; a saída do logcat ([[study-debug-log]]) volta para o Claude.
