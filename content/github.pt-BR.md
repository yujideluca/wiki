---
id: github
lang: pt-BR
source_hash: de00c5204bb2
title: GitHub
---

## What it is
Onde ficam todos os repositórios do Giovanni (conta `yujideluca`): german-quiz, german-quiz-web, german-quiz-releases, workflow-memory, project-template e wiki (privados quando guardam algo pessoal).

## What it does
Hospeda o código, roda a CI (GitHub Actions), serve o [[github-pages]] e é a ponte que o [[claude-app]] usa para gravar memória ([[mem-github-connector]]).

## How it does it
O Claude Code faz push por SSH; nunca force-push (uma preferência permanente).

## Where it sits in the pipeline
O backup fora do notebook e o ponto de encontro de todos os projetos.

## Who receives its output
As instâncias do Claude, o [[github-pages]] e a verificação de atualização do celular ([[update-client]]).
