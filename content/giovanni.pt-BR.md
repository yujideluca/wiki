---
id: giovanni
lang: pt-BR
source_hash: b02e24161573
title: Giovanni
---

## What it is
Giovanni é o dono de todos os sistemas descritos neste wiki e a pessoa para quem tudo é construído. Giovanni é médico de emergência pré-hospitalar no Brasil (médico que atende emergências fora do hospital, por exemplo em ambulâncias) e se prepara para o exame Goethe B2 de alemão (novembro de 2026) e depois para a FSP (Fachsprachprüfung, a prova alemã de linguagem médica), a fim de trabalhar como médico na Alemanha.

## Flow
trigger t1: Giovanni quer algo construído, respondido ou estudado
decide d1: Onde o Giovanni está?
step s1: Digita no terminal do notebook | [[claude-code]]
step s2: Escreve ao assistente sempre ligado pelo celular | [[remote-assistant]]
step s3: Conversa no claude.ai (celular ou navegador) | [[claude-app]]
step s4: O Claude trabalha; o Giovanni aprova tudo que vai para fora ou não tem volta
step s5: Uma correção ou preferência duradoura vira uma entrada na memória | [[mem]]
product p1: Trabalho pronto e respostas
product p2: Regras que todo chat futuro lê primeiro | [[workflow-memory]]
trigger t2: Giovanni quer praticar alemão
step s6: Estuda com os aplicativos de quiz | [[quizapp]], [[quizweb]]
product p3: Progresso de estudo guardado pelos aplicativos
trigger t3: Giovanni quer entender como as peças se encaixam
step s7: Lê esta wiki | [[wiki]]
product p4: Uma resposta à dúvida de arquitetura

t1 -> d1
d1 -notebook-> s1
d1 -celular-> s2
d1 -claude.ai-> s3
s1 -> s4
s2 -> s4
s3 -> s4
s4 -> p1
s4 -> s5
s5 -> p2
t2 -> s6
s6 -> p3
t3 -> s7
s7 -> p4

## What it does
Giovanni decide o que é construído e aprova tudo o que chega ao mundo exterior ou não pode ser desfeito. Correções e preferências que Giovanni declara viram entradas na memória compartilhada ([[mem]]). Giovanni estuda alemão com o [[quizapp]] e o [[quizweb]] e lê este [[wiki]] para entender como as peças se encaixam.

## How it does it
Giovanni conversa com o [[claude-code]] no terminal do notebook, com o [[remote-assistant]] pelo celular e com o [[claude-app]] no claude.ai. As regras permanentes (responder no idioma da mensagem, explicar em linguagem simples, perguntar antes de ações voltadas ao exterior) ficam no [[workflow-memory]], não neste wiki.

## Where it sits in the pipeline
No começo e no fim de toda cadeia de trabalho: Giovanni é a fonte dos requisitos (o que precisa ser construído) e o aprovador final. A decisão que dá forma a esse papel é a ADR-0003 no [[workflow-memory]] (uma ADR, "architecture decision record", é uma nota curta que registra uma decisão importante e seus motivos).

## Who receives its output
As instâncias do Claude recebem as instruções do Giovanni; o sistema de memória recebe as correções do Giovanni.
