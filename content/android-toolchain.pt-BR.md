---
id: android-toolchain
lang: pt-BR
source_hash: ea3982d57f8e
title: Ferramentas Android (env.sh)
---

## What it is
A "toolchain" (cadeia de ferramentas) é o conjunto de programas necessários para transformar o código-fonte do [[quizapp]] em um app Android instalável. Aqui ela é formada pelo [JDK 21](https://en.wikipedia.org/wiki/Java_Development_Kit) (Java Development Kit, o compilador e o ambiente de execução do Java), o [Gradle](https://gradle.org/) 9.8 (a ferramenta de build que executa compilação e testes) e o Android SDK (software development kit: as bibliotecas oficiais do Android e as ferramentas de linha de comando). Tudo está descompactado em `~/dev`, mais um pequeno script, `~/dev/env.sh`, que diz ao shell onde encontrar tudo.

## What it does
Executar `source ~/dev/env.sh` define as variáveis de ambiente `JAVA_HOME`, `ANDROID_HOME` e `ANDROID_SDK_ROOT` (elas indicam onde estão o Java e o SDK) e amplia o `PATH` (a lista de pastas onde o shell procura programas) com as ferramentas de linha de comando do SDK, as platform-tools (que incluem o [adb](https://developer.android.com/tools/adb), a Android Debug Bridge para conversar com um celular) e o Gradle.

## How it does it
Tudo é instalado sem direitos de administrador. O portão de qualidade ([[quizapp-quality-gate]]) carrega o arquivo sozinho, então ninguém precisa lembrar. Se ele não for carregado, comandos como `adb` ou `gradle` simplesmente "não são encontrados".

## Where it sits in the pipeline
Por baixo de todo build do QuizApp e de todo comando adb.

## Who receives its output
O [[quizapp-quality-gate]], os builds do Gradle e a skill [[skill-adb-android-control]].
