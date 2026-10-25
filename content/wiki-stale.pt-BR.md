---
id: wiki-stale
lang: pt-BR
source_hash: 61901bbb2fef
title: wiki stale (páginas atrás de suas fontes)
---

## What it is
`wiki stale` é o comando que lista as páginas da wiki que podem estar desatualizadas porque um arquivo que elas descrevem mudou depois que a página foi comparada com ele pela última vez. É um dos comandos do [[wiki-cli]] e divide o arquivo de código com o hook Stop ([[wiki-hook-stop]]), mas faz outra pergunta.

## What it does
Cada página registra no campo `reviewed` do cabeçalho quando foi comparada com suas fontes pela última vez: data e minuto em UTC (tempo universal coordenado, o mesmo horário em qualquer lugar), como `2026-10-24T18:30Z`, ou só uma data, que significa o início desse dia. Para cada página com fontes, o comando olha cada arquivo ou pasta citado em `sources` (escrito `repo:path`). Se algum deles mudou depois do horário de `reviewed`, a página é listada com a fonte mais recente e os dois horários, por exemplo `quizapp: QuizApp:DESIGN.md changed 2026-10-24 16:43 UTC, after the review of 2026-10-22 16:33 UTC`. Uma página com fontes e sem `reviewed` utilizável é listada como nunca comparada. Quando não há nada a listar, imprime "no stale pages" e sai com 0; caso contrário sai com 1, para que um script possa testar o resultado (requisitos ST-1, ST-2 e ST-3).

## How it does it
Para uma fonte dentro de um repositório git (git é a ferramenta que guarda cada mudança como um commit), "mudou" significa o horário do último commit que toca o arquivo ou a pasta. Para uma fonte fora do git, como uma skill ou um script na pasta pessoal, significa o horário de modificação mais recente do arquivo, ou da pasta e de tudo o que está dentro dela. Os commits do próprio arquivo da página nunca são usados: reescrever muitas páginas, corrigir uma tradução ou publicar não é uma revisão. Só quem de fato comparou a página com suas fontes define um novo horário de `reviewed`, e isso tira a página da lista.

A primeira versão comparava o horário do último commit da fonte com o do último commit do arquivo da página. Em 2026-10-24 um commit reescreveu as 154 páginas, então essa versão não listava nada enquanto 38 das 140 páginas com fontes tinham uma mudança de fonte que ninguém conferiu, e ela nunca podia listar as 34 páginas cujas fontes estão fora do git. O registro de decisão `docs/adr/0006-review-time-in-the-page.md` explica a mudança.

O comando olha o horário, não o que a página diz: uma mudança numa fonte que a página não descreve ainda deixa a página listada até alguém revisá-la. Uma revisão em um dado minuto cobre esse minuto inteiro, então uma mudança nesse minuto não é vista; também não são vistas edições ainda não commitadas em um repositório, nem um arquivo novo que nenhuma página cita (quem vigia arquivos novos é o hook Stop).

## Where it sits in the pipeline
Uma verificação manual, rodada pelo Claude no início e no fim do trabalho de [[skill-wiki-page-writer]] e sempre que o Giovanni quer saber quanto a wiki está atrás do código.

## Who receives its output
Quem o rodou (Claude ou Giovanni), pelo [[wiki-cli]].
