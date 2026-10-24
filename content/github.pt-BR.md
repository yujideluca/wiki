---
id: github
lang: pt-BR
source_hash: dc942668d021
title: GitHub
---

## What it is
O [GitHub](https://github.com/) é um site que guarda projetos de programadores online e mantém o histórico completo de cada mudança (é construído sobre o [Git](https://git-scm.com/), a ferramenta de controle de versão). Um projeto guardado assim se chama repositório. Todos os repositórios do Giovanni ficam na conta `yujideluca`: german-quiz, german-quiz-web, german-quiz-releases, workflow-memory, project-template e este wiki. Os que guardam algo pessoal são privados.

## What it does
Hospeda o código, executa as verificações automáticas chamadas CI (integração contínua) por meio do GitHub Actions, serve sites estáticos ([[github-pages]]) e é a ponte que permite ao [[claude-app]] escrever na memória ([[mem-github-connector]]).

## How it does it
O [[claude-code]] envia (push) por SSH (Secure Shell, um método de login criptografado que usa chaves em vez de senhas). Nunca faz force-push, que sobrescreveria o histórico no servidor; é uma preferência permanente do Giovanni.

## Where it sits in the pipeline
É o backup fora do notebook e o ponto de encontro de todo projeto.

## Who receives its output
As instâncias do Claude, o [[github-pages]] e a verificação de atualização do celular ([[update-client]]).
