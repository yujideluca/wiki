---
id: mem
lang: pt-BR
source_hash: 1b470cac0e2a
title: mem (comando da memória)
---

## What it is
`mem` é a ferramenta de linha de comando do [[workflow-memory]] (uma ferramenta de linha de comando é um programa que se executa digitando seu nome e opções em um terminal). É por ela que o [[claude-code]] e o [[remote-assistant]] leem e escrevem a memória compartilhada. É escrita em Python 3 e não precisa de nada além da biblioteca padrão do Python.

## Architecture
### Contexto
person g: Giovanni — roda à mão de vez em quando | [[giovanni]]
person c: Claude Code — escreve eventos e lê o resumo | [[claude-code]]
person x: Codex — o mesmo, com escopo próprio | [[codex]]
person r: Assistente remoto — o mesmo, pelo celular | [[remote-assistant]]
system m: mem — o comando da memória
external e: Registro de eventos — os arquivos que ele lê e escreve | [[events-log]]
external h: GitHub — onde a memória é mantida em sincronia | [[github]]

g -executa o-> m
c -executa o-> m
x -executa o-> m
r -executa o-> m
m -lê e acrescenta ao-> e
m -sincroniza com o-> h

### Contêineres
person u: Giovanni ou um assistente
container cl: cli.py — lê a linha de comando e chama os módulos
container ev: Eventos — escrever e ler arquivos de evento
container fo: Dobra — transforma o registro nas entradas atuais | [[memory-fold]]
container ck: Verificações — validador, coletor e pendências | [[mem-validator]], [[mem-harvester]]
container se: Busca — acha entradas por palavras | [[mem-search]]
container sy: Sincronia e instalador — pull e push do GitHub, hooks do Claude Code | [[mem-sync]]
store lg: Registro de eventos — um arquivo por evento | [[events-log]]
store vw: Visões — os arquivos legíveis que ele gera | [[memory-views]]

u -executa o-> cl
cl -chama os-> ev
cl -chama a-> fo
cl -chama as-> ck
cl -chama a-> se
cl -chama a-> sy
ev -escreve e lê o-> lg
fo -gera as-> vw

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
