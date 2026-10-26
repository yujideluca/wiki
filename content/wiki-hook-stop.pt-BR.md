---
id: wiki-hook-stop
lang: pt-BR
source_hash: 8ed83beaba2b
title: Hook Stop do wiki (rede de segurança)
---

## What it is
Um "hook Stop" é um pequeno programa que o [[claude-code]] executa automaticamente sempre que termina uma resposta ([hooks explicados](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Este, `wiki hook-stop`, é a rede de segurança da cadeia de atualização do wiki: pega uma atualização esquecida na mesma sessão, enquanto o Claude ainda lembra o que fez.

## What it does
Quando o Claude termina uma rodada, ele olha os repositórios sob `~/dev` que alguma página do wiki cita como fonte. Se desde o último `wiki publish` houve commits que tocaram fontes de uma página, ou arquivos novos que nenhuma página cobre, ele bloqueia o término (código de saída 2) e diz ao Claude quais páginas atualizar. Nunca bloqueia antes da primeira publicação, para repositórios que o wiki não cobre, duas vezes na mesma sessão pelas mesmas mudanças, nem quando um hook Stop já está ativo, então não pode entrar em laço. Uma conversa que não altera código coberto não cria um novo gatilho próprio; mudanças anteriores ainda não publicadas podem disparar o lembrete.

## How it does it
Usa git somente de leitura e guarda seu estado em `~/.local/state/wiki/` (o momento da última publicação e as sessões já bloqueadas). Pastas de dados que mudam o tempo todo (eventos e visões da memória, backups do quiz, o feed de lançamentos) estão listadas em `content/_ignore.txt` e não são vigiadas arquivo a arquivo. A mensagem que ele imprime diz ao Claude para registrar uma página que conferiu e achou certa definindo o `reviewed` dela (a edição é a revisão, veja [[wiki-stale]]), e para rodar `wiki publish -m "review: no page change"` só quando o que mudou não é descrito por nenhuma página, por exemplo um arquivo de dados.

## Where it sits in the pipeline
Roda no fim de cada rodada, ao lado do [[hook-stop]] da memória.

## Who receives its output
O [[claude-code]] (a mensagem).

## Notes
O `wiki stale` e este hook respondem a duas perguntas diferentes, por isso uma página pode ser listada por um e não pelo outro. O `wiki stale` pergunta, página por página: "uma fonte mudou depois do horário em que a página diz ter sido conferida pela última vez (o campo `reviewed`)?" Ele não depende de publicar. O hook pergunta: "desde o último `wiki publish`, algum projeto ganhou commits que tocam as fontes de uma página ou adicionou arquivos que nenhuma página cobre?" Ele é a rede de segurança para o que o `wiki stale` não consegue ver: uma mudança no mesmo minuto de uma revisão, um arquivo novo que nenhuma página cita e o trabalho da sessão atual. Quando o hook aponta uma página, leia o `git log` do repositório da fonte e compare com o texto da página; se a página está certa, defina o `reviewed` dela. Antes de 2026-10-24 o `wiki stale` comparava o horário do commit da fonte com o do arquivo da página, então reescrever muitas páginas escondia toda mudança anterior e este hook era a única coisa que ainda as via (veja [[wiki-stale]]).

O lembrete encaminha explicitamente páginas de skills para a regra de fontes completas: localizar e ler o `SKILL.md` inteiro, incluir sua descrição completa e todas as instruções com uma impressão digital na página em inglês e nas duas traduções e rodar `wiki check --local`. Ele aponta para `AGENTS.md` e [[skill-wiki-page-writer]]. O hook lembra quem escreve; não gera o texto da página sozinho.
