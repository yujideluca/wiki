---
id: wiki-hook-stop
lang: pt-BR
source_hash: eed4aff55ffd
title: Hook Stop do wiki (rede de segurança)
---

## What it is
A rede de segurança da cadeia de atualização: um hook Stop do Claude Code (`wiki hook-stop`) que pega uma atualização do wiki esquecida na mesma sessão.

## What it does
Quando o Claude termina uma rodada, ele olha os repositórios em `~/dev` que alguma página cita como fonte. Se, desde o último `wiki publish`, algum commit mexeu nas fontes de uma página ou criou arquivos que nenhuma página cobre, ele bloqueia o fim (exit 2) e diz ao Claude quais páginas atualizar. Nunca bloqueia antes da primeira publicação, em repositórios que o wiki não cobre, duas vezes na mesma sessão pelas mesmas mudanças, nem quando um hook Stop já está ativo; então não entra em laço e nunca dispara em conversas de alemão, clínica ou outras sem código.

## How it does it
Git só de leitura; estado em `~/.local/state/wiki/` (hora da última publicação, sessões já bloqueadas). Pastas de dados que mudam o tempo todo (eventos e views da memória, backups do quiz, o canal de versões) ficam em `content/_ignore.txt` e não são vigiadas arquivo por arquivo. Se nenhuma página precisa mudar, o Claude ainda roda `wiki publish -m "review: no page change"` para registrar que conferiu.

## Where it sits in the pipeline
Roda no fim de cada rodada, ao lado do [[hook-stop]] da memória.

## Who receives its output
O [[claude-code]] (a mensagem).
