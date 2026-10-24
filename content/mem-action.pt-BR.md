---
id: mem-action
lang: pt-BR
source_hash: 20d2313cf60f
title: GitHub Action da memória (mem.yml)
---

## What it is
Este é o workflow do GitHub Actions `.github/workflows/mem.yml` do [[workflow-memory]]. O [GitHub Actions](https://docs.github.com/en/actions) é o serviço do GitHub que executa tarefas automáticas em computadores próprios, de modo que nenhuma máquina do Giovanni precisa estar ligada.

## What it does
Roda a cada push nos eventos ou no código, e também uma vez por dia (porque a relevância das entradas antigas diminui com o tempo). Cada execução: roda os testes, move eventos inválidos para a quarentena, promove hábitos vistos em dois projetos a preferências globais, reconstrói o [[memory-views]] e faz commit do resultado. Também garante que os eventos sejam só de acréscimo (arquivos existentes nunca são editados).

## How it does it
Usa Python 3.12. Nunca mescla arquivos gerados: se outro push chega ao mesmo tempo e o seu próprio envio é recusado, volta ao `main` mais recente e gera de novo (até cinco tentativas).

## Where it sits in the pipeline
No GitHub, depois que o [[events-log]] muda.

## Who receives its output
O [[memory-views]] (devolvido ao `main` por commit).
