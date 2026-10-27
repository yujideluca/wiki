---
id: android-toolchain
lang: pt-BR
source_hash: cafc764f3c8f
title: Ferramentas Android (env.sh)
---

## What it is
A "toolchain" (cadeia de ferramentas) é o conjunto de programas necessários para transformar o código-fonte do [[quizapp]] em um app Android instalável. Aqui ela é formada pelo [JDK 21](https://en.wikipedia.org/wiki/Java_Development_Kit) (Java Development Kit, o compilador e o ambiente de execução do Java), o [Gradle](https://gradle.org/) 9.8 (a ferramenta de build que executa compilação e testes) e o Android SDK (software development kit: as bibliotecas oficiais do Android e as ferramentas de linha de comando). Tudo está descompactado em `~/dev`, mais um pequeno script, `~/dev/env.sh`, que diz ao shell onde encontrar tudo.

## Architecture
### Contexto
person g: Giovanni — carrega ao compilar à mão | [[giovanni]]
system t: Cadeia de ferramentas Android — Java, Gradle e as ferramentas Android em ~/dev
external q: Portão de qualidade do QuizApp — carrega sozinho | [[quizapp-quality-gate]]
external a: QuizApp — o código que ele transforma em app | [[quizapp]]
external p: O celular — alcançado com o adb | [[phone]]

g -carrega o env.sh da-> t
q -carrega a-> t
t -compila o app a partir do-> a
t -conversa com-> p

### Contêineres
person g: Giovanni ou o portão de qualidade
container en: env.sh — define as variáveis e o caminho de busca
container jd: Java Development Kit 21 — o compilador e o ambiente Java
container gr: Gradle 9.8 — roda os passos de compilar e testar
container sd: Kit de desenvolvimento Android — bibliotecas e ferramentas de linha de comando
container ad: adb — a Android Debug Bridge
external p: O celular | [[phone]]

g -carrega o-> en
en -aponta para o-> jd
en -põe no caminho de busca o-> gr
en -aponta para o-> sd
en -põe no caminho de busca o-> ad
ad -conversa com-> p

## What it does
Executar `source ~/dev/env.sh` define as variáveis de ambiente `JAVA_HOME`, `ANDROID_HOME` e `ANDROID_SDK_ROOT` (elas indicam onde estão o Java e o SDK) e amplia o `PATH` (a lista de pastas onde o shell procura programas) com as ferramentas de linha de comando do SDK, as platform-tools (que incluem o [adb](https://developer.android.com/tools/adb), a Android Debug Bridge para conversar com um celular) e o Gradle.

## How it does it
Tudo é instalado sem direitos de administrador. O portão de qualidade ([[quizapp-quality-gate]]) carrega o arquivo sozinho, então ninguém precisa lembrar. Se ele não for carregado, comandos como `adb` ou `gradle` simplesmente "não são encontrados".

## Where it sits in the pipeline
Por baixo de todo build do QuizApp e de todo comando adb.

## Who receives its output
O [[quizapp-quality-gate]], os builds do Gradle e a skill [[skill-adb-android-control]].

## Notes
O arquivo é um trecho carregado pelo Bash, identificado por `# shellcheck shell=bash`. Os valores são atribuídos antes de exportar para que `export` não esconda uma falha de comando. Caminhos da pasta pessoal ficam entre aspas. O [[machine-bootstrap]] captura o mesmo arquivo para restauração. A análise do shell e um teste com espaços no caminho pessoal passaram em 2026-10-26.
