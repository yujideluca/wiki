---
id: processing-sketches
lang: pt-BR
source_hash: 081a1bc48616
title: Esboços em Processing
---

## What it is
Pequenos programas de arte generativa escritos em Processing (uma linguagem de desenho baseada em Java) em `~/dev/processing-sketches`.

## What it does
Desenha a curva do dragão de Heighway em duas versões: [[drachenkurve]] (exportada como app, gerou o ícone do QuizApp) e [[drachenfraktal]].

## How it does it
Cada esboço é um arquivo `.pde` na sua própria pasta; o `drachenkurve` tem um build exportado. Desde 2026-10-24 a pasta é um repositório privado no GitHub (`yujideluca/processing-sketches`) com portão, CI e a verificação de pre-push do [[pipeline-check]]; os arquivos de build são ignorados.

## Where it sits in the pipeline
À parte dos outros projetos; a única ligação é o ícone do [[quizapp]].

## Who receives its output
O [[quizapp]] (o ícone dele).
