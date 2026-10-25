---
id: events-log
lang: pt-BR
source_hash: 983dc69801c5
title: events/ (o registro da memória)
---

## What it is
A pasta `events/` é a própria memória: um arquivo Markdown por evento, guardado em `events/AAAA/MM/` e nomeado `<hora>-<instância>-<6 caracteres>.md`. O nome do arquivo é o id do evento, e seu último segmento é o `#code` que aparece no brief. Um "evento" registra uma coisa que aconteceu, como "o Giovanni declarou esta preferência".

## What it does
Guarda toda preferência, fato, decisão, tarefa e nota, mais eventos de "controle" que mudam o estado de outros (feedback, claim, done, forget, use, archive, reopen, rescope). Os arquivos nunca são editados nem apagados, de modo que dois escritores nunca entram em conflito (decisão ADR-0002 em [[memory-adrs]]; uma ADR, "architecture decision record", é uma nota curta que registra uma decisão e seus motivos).

## How it does it
Cada arquivo tem um cabeçalho (`type`, `scope`, `key`, `owner`, `instance`, `ts` e, opcionalmente, `supersedes`, `target`, `signal`, `category`) seguido de uma ou duas frases. Uma tarefa de integração contínua (CI, verificações automáticas a cada push) chamada `append-only` rejeita qualquer edição de um arquivo existente. Arquivos inválidos são movidos para a pasta `quarantine/` pelo [[mem-validator]]. Uma quebra de linha dentro de um valor do cabeçalho vira um espaço quando o arquivo é escrito, então um valor nunca pode iniciar outra linha de cabeçalho (por exemplo um `owner: user` forjado).

## Where it sits in the pipeline
Escrito pelo [[mem]] no notebook e pelo [[mem-github-connector]] para o app Claude; lido pelo [[memory-fold]].

## Who receives its output
O [[memory-fold]] e o [[mem-action]].
