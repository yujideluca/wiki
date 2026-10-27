---
id: end-of-task
lang: pt-BR
source_hash: 5521ba05f6ea
title: Fim de uma tarefa (cadeia de atualização do wiki)
---

## What it is
Esta página descreve o que o Claude faz toda vez que termina uma tarefa, para que a memória e este wiki nunca fiquem atrás do que foi realmente construído. O Giovanni decidiu em 2026-10-22 que a atualização do wiki está ligada ao relatório `mem use`.

## Flow
trigger t1: O Claude termina uma tarefa de programação | [[claude-code]]
trigger t2: O Claude tenta parar após mudar código sem publicar | [[wiki-hook-stop]]
step s1: Comprova o trabalho rodando verificações | [[skill-verification-before-completion]]
step s2: Escreve ou atualiza as páginas em inglês, depois em alemão e português | [[wiki-content]]
step s3: Dá página própria ao que ficou grande demais | [[wiki-check]]
decide d1: A verificação do conteúdo passa?
step s3b: Corrige o que a verificação aponta
step s4: Roda wiki publish: verifica, monta o site, faz commit de content/ e envia | [[wiki-cli]]
step s5: O site no ar serve as páginas novas na hora | [[wiki-site]]
step s6: Informa quais entradas da memória moldaram o trabalho | [[mem-use]]
product p1: Uma wiki que corresponde ao que foi construído | [[wiki]]
product p2: As páginas guardadas no GitHub | [[github]]
product p3: Uso da memória registrado no log | [[events-log]]

t1 -> s1
s1 -> s2
t2 -> s2
s2 -> s3
s3 -> d1
d1 -sim-> s4
d1 -não-> s3b
s3b -> s4
s4 -> s5
s4 -> p2
s5 -> p1
s5 -> s6
s6 -> p3

## What it does
O Claude atualiza as páginas do wiki para tudo o que mudou (coisas novas, alteradas ou aposentadas, cada uma com sua tradução em alemão e português), publica-as passando pelas verificações de conteúdo e depois informa quais entradas da memória influenciaram o trabalho.

## How it does it
A regra está escrita em [[global-claude-md]]; as verificações que protegem a publicação estão em [[wiki-check]]; e uma rede de segurança, [[wiki-hook-stop]], lembra o Claude se ele esquecer.

## Where it sits in the pipeline
É o último passo de toda tarefa de programação, em qualquer projeto.

## Who receives its output
O conteúdo do wiki ([[wiki-content]]), o [[github]] (onde o wiki é guardado) e o registro de memória [[events-log]].

## Steps
1. O trabalho da tarefa está feito e comprovado por verificações executadas ([[skill-verification-before-completion]]).
2. O Claude atualiza ou cria as páginas em inglês em `~/dev/wiki/content` para o que mudou, depois as versões em alemão e português do Brasil ([[wiki-content]]). Uma página que foi comparada com suas fontes e achada certa recebe o `reviewed` com o horário UTC atual, que é o que a tira da lista do [[wiki-stale]].
3. Tudo o que passou do limite de tamanho de página ganha página própria (a regra de promoção, aplicada por [[wiki-check]]).
4. `wiki publish -m "…"` verifica o conteúdo, constrói o site, faz commit só da pasta `content/` e a envia ([[wiki-cli]]). A sessão acrescenta `--co-author "Name <email>"` com a própria linha de atribuição, ou o omite.
5. O site no ar serve os novos dados na hora ([[wiki-site]], [[wiki-router]]).
6. `mem use REF… --note "how"` informa as entradas de memória usadas ([[mem-use]]).
7. Quando a rodada termina, [[wiki-hook-stop]] confirma que nada foi esquecido e [[hook-stop]] envia os eventos de memória.
