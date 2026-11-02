---
id: ci-explained
lang: pt-BR
source_hash: 60c4899b6e84
title: CI (integração contínua) explicada
---

## What it is
CI (integração contínua) significa que, a cada alteração enviada, um computador que não é o do autor roda as verificações de novo, a partir de um estado limpo ([integração contínua](https://pt.wikipedia.org/wiki/Integra%C3%A7%C3%A3o_cont%C3%ADnua)). Isso pega o caso "na minha máquina funciona" e dá uma marca verde ou vermelha à alteração. Os projetos do Giovanni usam o [GitHub Actions](https://docs.github.com/en/actions), que roda jobs descritos em arquivos sob `.github/workflows/` nos computadores do GitHub.

## What it does
Em quase todo projeto, o workflow `quality-gate.yml` tem um job chamado `gate`. Ele roda a cada push e pull request (uma proposta de incorporar uma alteração) e também pode ser iniciado à mão (`workflow_dispatch`). O job instala as ferramentas do projeto e então roda `tools/pipeline-check.sh --mode ci`, que roda o gate do projeto uma vez e acrescenta as verificações compartilhadas do [[pipeline-check]]; ele envia o `report.json` como artefato (um arquivo guardado com a execução). Os limites de tempo dos jobs variam: 20 minutos em [[checks-remote-terminal]] e [[checks-processing-sketches]], 30 em [[checks-wiki]] e [[checks-pipeline-check]], 60 em [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-radiology-crawler]] e [[checks-status-quo]], 120 em [[checks-quizapp]].

Quatro projetos diferem. [[checks-pipeline-check]] não pode se verificar com uma cópia fixada de si mesmo, então seu job roda `tools/quality_gate.sh` diretamente. [[checks-quizweb]] chama seu job de `test` e roda a suíte de testes pura. [[checks-quizapp]] também roda toda semana (às segundas) com a lenta verificação de mutação. [[checks-workflow-memory]] tem dois workflows: `quality-gate.yml` para o código das ferramentas da memória e `mem.yml`, que processa eventos da memória e tem um job extra chamado `append-only`.

## How it does it
O GitHub lê o arquivo do workflow no repositório; o script do gate é o mesmo do laptop, então a CI e uma execução no laptop nunca discordam sobre o que é "passar". Uma execução de CI sozinha não barra um merge; [[branch-protection-explained]] explica o que torna o job obrigatório.

## Where it sits in the pipeline
Passo 2 de [[code-security-pipeline]], depois da verificação local de pre-push e antes de a alteração ser aceita. Detalhes por projeto estão em [[quizapp-ci]] e [[quizweb-ci]].

## Who receives its output
O [[github]] (a marca no commit) e a sessão do Claude, que deve conferir que a execução no seu commit exato está verde.
