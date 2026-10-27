---
id: system-overview
lang: pt-BR
source_hash: a920ee143759
title: O sistema inteiro num relance
---

## What it is
Esta página é o panorama dos sistemas do Giovanni: um diagrama que acompanha um pedido desde a pergunta do Giovanni até o trabalho, a wiki e a memória ficarem em dia. Cada caixa liga à página que a explica, então o diagrama também é um índice da wiki.

## Flow
trigger t1: Giovanni pede algo | [[giovanni]]
decide d1: Qual assistente o Giovanni usa?
step s1: Claude Code, no terminal do notebook | [[claude-code]]
step s2: Codex, no terminal do notebook | [[codex]]
step s3: O assistente sempre ligado, pelo celular | [[remote-assistant]]
step s4: O app Claude no claude.ai | [[claude-app]]
step s5: Todo chat começa lendo o resumo da memória compartilhada | [[chat-start]], [[workflow-memory]]
step s6: Uma skill é carregada quando o pedido combina com sua descrição | [[skills]]
step s7: O trabalho acontece num projeto: os apps de quiz, a wiki, ferramentas | [[quizapp]], [[wiki]]
step s8: Um quality gate e as verificações automáticas precisam passar | [[maintenance-pipeline]], [[quizapp-quality-gate]]
decide d2: É uma mudança no app Android?
step s9: Primeiro beta, estável só quando o Giovanni disser | [[quizapp-release]]
step s10: Fim da tarefa: páginas da wiki atualizadas em três idiomas | [[end-of-task]]
step s11: As entradas da memória que moldaram o trabalho são informadas | [[mem]]
product p1: Um app funcionando no celular do Giovanni | [[phone]]
product p2: Uma wiki que explica como tudo se encaixa | [[wiki]]
product p3: Memória que todo chat futuro lê primeiro | [[events-log]]

t1 -> d1
d1 -Claude Code-> s1
d1 -Codex-> s2
d1 -celular-> s3
d1 -claude.ai-> s4
s1 -> s5
s2 -> s5
s3 -> s5
s4 -> s5
s5 -> s6
s6 -> s7
s7 -> s8
s8 -> d2
d2 -sim-> s9
d2 -não-> s10
s9 -> s10
s9 -> p1
s10 -> s11
s10 -> p2
s11 -> p3

## What it does
Mostra, em ordem, qual assistente recebe o pedido ([[claude-code]], [[codex]], o [[remote-assistant]] ou o [[claude-app]]), o que cada um lê primeiro ([[workflow-memory]]), como uma skill entra ([[skills]]), onde o trabalho acontece (um projeto como o [[quizapp]] ou a [[wiki]]), o que precisa passar antes de valer como pronto ([[maintenance-pipeline]]) e o que fica no final. Para a cadeia de um único conceito, abra a página dele e leia o fluxograma.

## How it does it
É uma seção Flow escrita à mão, como a de toda página de conceito ([[wiki-flow-view]]), curta de propósito: nomeia as estações principais e deixa os detalhes para as páginas ligadas. O mapa ([[wiki]]) mostra as mesmas páginas como pontos e ligações; esta página as mostra como um caminho no tempo.

## Where it sits in the pipeline
Fica acima de todas as outras páginas, como ponto de partida para quem ainda não sabe qual página abrir.

## Who receives its output
O [[giovanni]] e qualquer pessoa nova que precise entender como as peças se encaixam.
