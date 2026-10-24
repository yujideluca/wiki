---
id: mem
lang: pt-BR
source_hash: cc93e389c143
title: mem (comando da memória)
---

## What it is
`mem` é a ferramenta de linha de comando do [[workflow-memory]] (uma ferramenta de linha de comando é um programa que se executa digitando seu nome e opções em um terminal). É por ela que o [[claude-code]] e o [[remote-assistant]] leem e escrevem a memória compartilhada. É escrita em Python 3 e não precisa de nada além da biblioteca padrão do Python.

## What it does
Escreve um novo arquivo de evento a cada mudança ([[mem-add]], [[mem-use]], [[mem-task]], e também feedback, esquecer, concluir, reivindicar e semelhantes), imprime o brief, pesquisa a memória ([[mem-search]]), verifica problemas nos arquivos, gera os arquivos legíveis em [[memory-views]], sincroniza com o GitHub e instala seus próprios hooks do Claude Code.

## How it does it
O arquivo `mem/cli.py` lê a linha de comando e chama os módulos: `events.py` (escrever e ler arquivos de evento), [[memory-fold]] (`core.py`), [[mem-validator]], [[mem-harvester]], [[mem-pendency]], `search.py`, `project.py`, [[mem-sync]] e `install.py`.

## Where it sits in the pipeline
É a porta pela qual a memória é escrita no notebook. Os hooks também a chamam, como `mem hook-session-start`, `mem hook-prompt` e `mem hook-stop`.

## Who receives its output
[[events-log]] (os arquivos novos) e o terminal (brief, resultados de busca).

## Functions
- `mem add --type pref --owner user --key topic "rule"`: registrar uma correção ou preferência duradoura
- `mem feedback REF wrong|stale|helpful|not_helpful`: avaliar uma entrada
- `mem forget REF`, `mem done REF`, `mem archive REF`, `mem reopen REF`: apagar, concluir, guardar, trazer de volta
- `mem claim REF`: reivindicar uma tarefa (vale a reivindicação mais antiga)
- `mem pending`, `mem scope`: listar e delimitar pendências
- `mem brief`, `mem search "words"`: imprimir o brief, busca em texto completo
- `mem check`, `mem quarantine`, `mem dismiss`: validade dos arquivos de evento
- `mem promote`, `mem compact [--apply]`: tornar hábitos globais; resumir entradas antigas
- `mem build [--check]`: regenerar as visões
- `mem sync [--pull] [--push]`, `mem install-hooks`
