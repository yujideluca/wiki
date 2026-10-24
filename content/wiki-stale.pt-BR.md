---
id: wiki-stale
lang: pt-BR
source_hash: a2609bb04610
title: wiki stale (páginas atrás de suas fontes)
---

## What it is
`wiki stale` é o comando que lista as páginas da wiki que podem estar desatualizadas porque os arquivos que elas descrevem mudaram depois da página. É um dos comandos do [[wiki-cli]] e divide o arquivo de código com o hook Stop ([[wiki-hook-stop]]), mas faz uma pergunta diferente.

## What it does
Para cada página, ele olha cada arquivo citado no cabeçalho `sources` (escrito `repo:path`). Se algum deles tem um commit (uma mudança salva no git) mais novo que o último commit da própria página, a página é listada como "<fonte> changed after the page". Quando não há nada a listar, imprime "no stale pages".

## How it does it
Ele pergunta ao git o horário do último commit da página e de cada fonte e compara os dois horários. Olha só o tempo, não o que a página diz. Por isso, qualquer commit posterior da página, como uma reescrita em massa ou uma publicação, faz a página contar como em dia mesmo que o texto não mencione a mudança. Ele também não enxerga um arquivo novo que nenhuma página cobre, porque só segue arquivos que as páginas já citam. O hook Stop usa outro teste (mudanças desde o último `wiki publish`, mais arquivos novos não cobertos); os dois podem, portanto, discordar, como explicado em [[wiki-hook-stop]]. Nenhuma página tem data de revisão própria: nenhuma das 139 páginas com fontes tem o campo `reviewed:`, então o comando não distingue "revisada e correta" de "tocada".

## Where it sits in the pipeline
Uma verificação manual, rodada pelo Claude no início de [[skill-wiki-page-writer]] e sempre que o Giovanni quer saber quanto a wiki está atrás do código.

## Who receives its output
Quem o rodou (Claude ou Giovanni), pelo [[wiki-cli]].
