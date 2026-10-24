---
id: wiki-hook-stop
lang: pt-BR
source_hash: 889b2229c8fc
title: Hook Stop do wiki (rede de segurança)
---

## What it is
Um "hook Stop" é um pequeno programa que o [[claude-code]] executa automaticamente sempre que termina uma resposta ([hooks explicados](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Este, `wiki hook-stop`, é a rede de segurança da cadeia de atualização do wiki: pega uma atualização esquecida na mesma sessão, enquanto o Claude ainda lembra o que fez.

## What it does
Quando o Claude termina uma rodada, ele olha os repositórios sob `~/dev` que alguma página do wiki cita como fonte. Se desde o último `wiki publish` houve commits que tocaram fontes de uma página, ou arquivos novos que nenhuma página cobre, ele bloqueia o término (código de saída 2) e diz ao Claude quais páginas atualizar. Nunca bloqueia antes da primeira publicação, para repositórios que o wiki não cobre, duas vezes na mesma sessão pelas mesmas mudanças, nem quando um hook Stop já está ativo, então não pode entrar em laço. Nunca dispara em conversas em alemão, clínicas ou outras sem código.

## How it does it
Usa git somente de leitura e guarda seu estado em `~/.local/state/wiki/` (o momento da última publicação e as sessões já bloqueadas). Pastas de dados que mudam o tempo todo (eventos e visões da memória, backups do quiz, o feed de lançamentos) estão listadas em `content/_ignore.txt` e não são vigiadas arquivo a arquivo. Se nenhuma página precisa mudar, o Claude ainda executa `wiki publish -m "review: no page change"` para registrar que conferiu.

## Where it sits in the pipeline
Roda no fim de cada rodada, ao lado do [[hook-stop]] da memória.

## Who receives its output
O [[claude-code]] (a mensagem).
