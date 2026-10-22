---
id: mem
lang: pt-BR
source_hash: ed035e7c48fb
title: mem (comando de memória)
---

## What it is
A ferramenta de linha de comando do [[workflow-memory]]: é como o Claude Code e o assistente leem e escrevem a memória compartilhada. Python 3, só biblioteca padrão.

## What it does
Grava um arquivo de evento novo para cada mudança ([[mem-add]], [[mem-use]], [[mem-task]], feedback, forget, done, claim…), imprime o resumo, busca ([[mem-search]]), valida, gera as [[memory-views]], sincroniza com o GitHub e instala seus próprios hooks do Claude Code.

## How it does it
O `mem/cli.py` lê o comando e chama os módulos: `events.py` (gravar/ler arquivos), [[memory-fold]] (`core.py`), [[mem-validator]], [[mem-harvester]], [[mem-pendency]], `search.py`, `project.py`, [[mem-sync]], `install.py`.

## Where it sits in the pipeline
A porta de escrita da memória no notebook; os hooks o chamam como `mem hook-session-start`, `hook-prompt`, `hook-stop`.

## Who receives its output
O [[events-log]] (arquivos novos) e o terminal (resumo, resultados de busca).

## Functions
- `mem add --type pref --owner user --key topic "rule"`: record a correction or lasting preference
- `mem feedback REF wrong|stale|helpful|not_helpful`: rate an entry
- `mem forget REF`, `mem done REF`, `mem archive REF`, `mem reopen REF`: close, solve, park, bring back
- `mem claim REF`: claim a task (earliest claim wins)
- `mem pending`, `mem scope`: list and scope open items
- `mem brief`, `mem search "words"`: print the brief, full-text search
- `mem check`, `mem quarantine`, `mem dismiss`: validity of event files
- `mem promote`, `mem compact [--apply]`: global habits; digest cold entries
- `mem build [--check]`: regenerate views
- `mem sync [--pull] [--push]`, `mem install-hooks`
