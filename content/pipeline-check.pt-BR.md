---
id: pipeline-check
lang: pt-BR
source_hash: 982d0c28d29d
title: pipeline-check
aliases: [report.json]
---

## What it is
Um programa em Rust que mede um projeto e faz a máquina, e não o hábito do Claude, recusar um merge ruim (ADR-0013). Substitui o `fitness_check.py`. A linguagem foi escolha do Giovanni.

## What it does
Escreve `build/pipeline-check/report.json` (projeto, data, modo `local` ou `ci`, verificações com status `ok`/`aviso`/`falha`/`pulado`, valor e limite, e um bloco `dora`) e sai com 1 se alguma verificação for `falha`; um aviso nunca falha. Verificações: o portão do projeto ([[quizapp-quality-gate]]) roda uma vez; a verificação de arquitetura (nenhum import de `android.*` ou `androidx.*` no `:core`, lido do código-fonte); funções de aptidão com aviso a partir de 80 % do limite e falha a 100 %; números DORA do git, do feed de releases e do registro de decisões; e, só no modo local, se a última execução do CI está verde e se a proteção de branch exige o job `gate` (somente leitura, via `gh`). Uma verificação que não pôde rodar é `pulado`, nunca `ok`; se for obrigatória, é `falha`.

## How it does it
Rust com `serde`, `toml` e `clap`; `git` e `gh` são chamados como processos. Os limites ficam em `pipeline-check.toml` e só mudam pelo Giovanni, com uma linha no registro de decisões. O `tools/pipeline-check.sh` compila e executa; o portão o chama com `--measure-only` (sem recursão). Requisitos PC-1..PC-11, testes marcados com `REQ`. Passou primeiro pelo próprio processo: a skill [[skill-gerar-teste-automatizado]] escreveu testes de caça a bugs (`tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`) que acharam seis defeitos, todos corrigidos, e uma verificação de mutação feita à mão (`mutants.py`) pega toda falha plantada.

## Where it sits in the pipeline
O CI o executa no lugar do portão puro ([[quizapp-ci]]); o Claude o executa no início de toda [[skill-revisao-manutencao]]. Parte do [[maintenance-pipeline]]. O programa existe uma só vez, em um repositório público próprio (`yujideluca/pipeline-check`); [[project-template]], [[quizapp]], [[wiki]], [[quizweb]], [[workflow-memory]], [[remote-terminal]] e [[processing-sketches]] fixam uma tag em `pipeline-check.version` (agora v0.2.0) e guardam só o próprio `pipeline-check.toml` e um pequeno script de execução. Ele também roda como hook de pre-push do git (`--pre-push`), que impede o push da `main` quando uma verificação falha, porque a proteção de branch não existe em repositórios privados do plano gratuito. Por que um repositório e não cópias: ADR-0003 desse repositório.

## Who receives its output
O [[quizapp-ci]] (marca vermelha ou verde) e a [[skill-revisao-manutencao]] (lê o `report.json`, nunca mede de novo).

## Functions
- `classify`: ok abaixo da fração de aviso, aviso até o limite, falha a partir do limite
- `arch::check`: varredura de imports do módulo puro e do seu arquivo de build
- `dora::compute`: frequência, lead time, retrabalho e parcela preventiva, `null` sem dados
