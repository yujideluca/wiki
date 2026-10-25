---
id: processing-sketches
lang: pt-BR
source_hash: 78c1494ab4e9
title: Sketches do Processing
---

## What it is
Pequenos programas de arte generativa (arte feita por código) escritos em [Processing](https://processing.org/), um ambiente de programação para desenho baseado em Java. Ficam em `~/dev/processing-sketches`. "Sketch" é como o Processing chama um programa.

## What it does
Desenha a curva do dragão de Heighway em duas versões: [[drachenkurve]] (exportada como app; gerou o ícone de lançamento do QuizApp) e [[drachenfraktal]].

## How it does it
Cada sketch é um arquivo `.pde` em sua própria pasta; a `drachenkurve` também tem um build exportado. Desde 2026-10-24 a pasta é um repositório no GitHub (`yujideluca/processing-sketches`, público desde 2026-10-25) com portão de qualidade, CI (integração contínua, verificações automáticas a cada push) e a verificação [[pipeline-check]] antes do push; a saída do build é ignorada pelo git.

## Where it sits in the pipeline
À parte dos outros projetos; sua única ligação com eles é o ícone do [[quizapp]].

## Who receives its output
O [[quizapp]] (seu ícone de lançamento).
