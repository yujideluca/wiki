---
id: pipeline-check
lang: pt-BR
source_hash: d42bfd911fcd
title: pipeline-check
---

## What it is
O pipeline-check é um programa escrito em [Rust](https://www.rust-lang.org/) (a linguagem foi escolha do Giovanni) que mede um projeto de software e faz uma máquina, e não o bom hábito do Claude, recusar um merge ruim (decisão ADR-0013 no QuizApp; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão). Substituiu o script Python mais antigo `fitness_check.py`.

## What it does
Escreve `build/pipeline-check/report.json`: o projeto, a data, o modo (`local` ou `ci`), uma lista de verificações, cada uma com um status (`ok`, `aviso` = alerta, `falha` = falha, `pulado` = ignorado), um valor e um limite, mais um bloco `dora` de métricas de entrega (DORA: DevOps Research and Assessment). Sai com código 1 se qualquer verificação for `falha`; um aviso nunca reprova. As verificações são:
- o portão de qualidade do próprio projeto ([[quizapp-quality-gate]]), executado uma vez;
- a verificação de arquitetura: nenhum import `android.*` ou `androidx.*` pode aparecer no módulo `:core`, lido do código-fonte;
- funções de aptidão (limites automáticos, como o tamanho de arquivos), com aviso a partir de 80 % de um limite e falha em 100 %;
- números DORA, tirados do git, do feed de lançamentos e do registro de decisões;
- e, só no modo local, se a última execução da integração contínua (CI, verificações automáticas no GitHub) está verde e se a proteção de branch exige a tarefa `gate` (somente leitura, pelo comando `gh` do GitHub).
- quando o projeto tem uma seção `[shellcheck]` no seu `pipeline-check.toml`: se seus scripts de shell passam no `shellcheck` (um programa que encontra erros em scripts de shell). Ele é aplicado a todo arquivo `.sh` que o git acompanha, mais os arquivos extras listados ali, com a severidade escolhida (requisito PC-15, versão v0.4.0). Uma execução limpa é `ok`, um achado é `falha` e cita o primeiro, e uma máquina sem `shellcheck` dá `pulado`.
Uma verificação que não pôde rodar é `pulado`, nunca `ok`; se era obrigatória, conta como `falha`.

Além do relatório, o programa tem mais dois modos: `--traceability` confere se todo requisito tem um teste ([[check-traceability]], PC-14) e `--pre-push` é o hook do git descrito abaixo (PC-13). Com `--no-github` ele nunca consulta o GitHub (PC-12).

## How it does it
É Rust com as bibliotecas `serde`, `toml` e `clap`, e executa `git` e `gh` como processos separados. Os limites ficam no `pipeline-check.toml` de cada projeto e só o Giovanni os altera, com uma linha no registro de decisões. O script `tools/pipeline-check.sh` o compila e executa; o portão o chama com `--measure-only` para não rodar o portão de novo (sem recursão). Seus próprios requisitos (PC-1 a PC-15) têm testes etiquetados com `REQ`. Passou primeiro pelo seu próprio processo: a skill [[skill-gerar-teste-automatizado]] escreveu testes caçadores de bugs (registro em `tools/pipeline-check/docs/TESTES-AUTOMATIZADOS.md`) que acharam seis defeitos, todos corrigidos, e uma verificação de mutação feita à mão (`mutants.py`, que planta falhas de propósito) pega todas as falhas plantadas.

## Where it sits in the pipeline
A CI o executa no lugar do portão simples ([[quizapp-ci]]), e o Claude o executa no início de cada [[skill-revisao-manutencao]]; faz parte da [[maintenance-pipeline]]. O programa existe uma só vez, em seu próprio repositório público (`yujideluca/pipeline-check`). [[project-template]], [[quizapp]], o [[wiki]], [[quizweb]], [[workflow-memory]], [[remote-terminal]] e [[processing-sketches]] fixam, cada um, uma tag de versão em um arquivo `pipeline-check.version` (v0.4.0 em todos os projetos, exceto a [[wiki]], que ainda fixa a v0.3.1) e mantêm apenas o próprio `pipeline-check.toml` e um pequeno script executor. Também roda como hook pre-push do git (`--pre-push`), que impede o push do `main` quando uma verificação falha, porque a proteção de branch não está disponível em repositórios privados do plano gratuito. Por que um repositório e não cópias: ADR-0003 naquele repositório.

## Who receives its output
A [[quizapp-ci]] (a marca vermelha ou verde) e a [[skill-revisao-manutencao]] (que lê o `report.json` e nunca mede de novo).

## Functions
- `classify`: ok abaixo da parcela de aviso, aviso até o limite, falha a partir do limite
- `arch::check`: varredura de imports do módulo puro e de seu arquivo de build
- `dora::compute`: frequência, tempo de entrega, retrabalho e parcela preventiva, `null` sem dados
