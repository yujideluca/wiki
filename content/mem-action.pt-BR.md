---
id: mem-action
lang: pt-BR
source_hash: ab40ef21c256
title: GitHub Action do mem (mem.yml)
---

## What it is
O workflow do GitHub Actions que mantém a memória consistente sem nenhuma máquina do Giovanni ligada.

## What it does
A cada push em eventos ou código e uma vez por dia (a relevância decai com o tempo): roda os testes, põe em quarentena eventos inválidos, promove hábitos vistos em dois projetos, refaz as [[memory-views]] e faz commit. Também garante que os eventos só sejam acrescentados.

## How it does it
Python 3.12; nunca mescla arquivos derivados: se perder a corrida, volta ao `main` mais novo e deriva de novo (até cinco tentativas).

## Where it sits in the pipeline
No GitHub, depois que o [[events-log]] muda.

## Who receives its output
As [[memory-views]] (commitadas de volta no `main`).
