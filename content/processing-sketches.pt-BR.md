---
id: processing-sketches
lang: pt-BR
source_hash: fcc5f904671a
title: Sketches do Processing
---

## What it is
Pequenos programas de arte generativa (arte feita por código) escritos em [Processing](https://processing.org/), um ambiente de programação para desenho baseado em Java. Ficam em `~/dev/processing-sketches`. "Sketch" é como o Processing chama um programa.

## Flow
trigger t1: Giovanni escreve um sketch no Processing
step s1: Cada sketch é um arquivo .pde na sua própria pasta
step s2: Ao rodar, desenha a curva do dragão de Heighway
decide d1: Qual versão?
step s3: Exportado como app, ignorado pelo git | [[drachenkurve]]
step s4: Renderizado como ícone de lançamento do QuizApp | [[quizapp]]
trigger t2: Um push no repositório | [[pipeline-check]]
step s5: O quality gate e as verificações automáticas rodam
product p1: O ícone de lançamento do QuizApp | [[quizapp]]
product p2: Um segundo sketch da curva do dragão, só como programa | [[drachenfraktal]]
product p3: Sketches verificados no GitHub

t1 -> s1
s1 -> s2
s2 -> d1
d1 -drachenkurve-> s3
d1 -drachenfraktal-> p2
s3 -> s4
s4 -> p1
t2 -> s5
s5 -> p3

## What it does
Desenha a curva do dragão de Heighway em duas versões: [[drachenkurve]] (exportada como app; gerou o ícone de lançamento do QuizApp) e [[drachenfraktal]].

## How it does it
Cada sketch é um arquivo `.pde` em sua própria pasta; a `drachenkurve` também tem um build exportado. Desde 2026-10-24 a pasta é um repositório no GitHub (`yujideluca/processing-sketches`, público desde 2026-10-25) com portão de qualidade, CI (integração contínua, verificações automáticas a cada push) e a verificação [[pipeline-check]] antes do push; a saída do build é ignorada pelo git.

## Where it sits in the pipeline
À parte dos outros projetos; sua única ligação com eles é o ícone do [[quizapp]].

## Who receives its output
O [[quizapp]] (seu ícone de lançamento).
