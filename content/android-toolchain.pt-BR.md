---
id: android-toolchain
lang: pt-BR
source_hash: 26d1a062b2f1
title: Ferramentas Android (env.sh)
---

## What it is
O que compila o [[quizapp]] no notebook: JDK 21, Gradle 9.8 e o Android SDK, todos descompactados em `~/dev`, mais o `~/dev/env.sh`, que os coloca no caminho.

## What it does
`source ~/dev/env.sh` define `JAVA_HOME`, `ANDROID_HOME`/`ANDROID_SDK_ROOT` e `PATH` (ferramentas de linha de comando do SDK, platform-tools com o adb, Gradle).

## How it does it
Instalações no espaço do usuário, sem sudo; o portão de qualidade carrega o arquivo sozinho.

## Where it sits in the pipeline
Por baixo de todo build do QuizApp e de todo comando adb.

## Who receives its output
O [[quizapp-quality-gate]], os builds do Gradle e a [[skill-adb-android-control]].
