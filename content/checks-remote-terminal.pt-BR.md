---
id: checks-remote-terminal
lang: pt-BR
source_hash: 24603f845d5d
title: remote-terminal: verificadores e regras
---

## What it is
Estes são os verificadores do [[remote-terminal]], um pequeno conjunto de scripts de shell (principalmente `setup-sudo.sh`) para alcançar o terminal do laptop à distância. Tem o gate mais leve entre os projetos com CI (integração contínua).

## What it does
O gate faz três coisas: `bash -n` (uma verificação de sintaxe sem executar) em todo script de shell rastreado e no hook de pre-push; ShellCheck no nível de aviso em `setup-sudo.sh` e no seu teste (pulado com uma mensagem quando o ShellCheck não está instalado); e um teste em sandbox, `tests/setup-sudo-sandbox.sh`, que roda a configuração do sudo em uma pasta isolada. Limites: o gate com no máximo 300 segundos. Não há lista de requisitos nem passo de rastreabilidade.

## How it does it
A CI roda `pipeline-check --mode ci` (no máximo 20 minutos). `pipeline-check.toml` nomeia o repositório e o job obrigatório `gate`. ADRs: nenhum em `docs/adr`; a pasta `docs` guarda só o registro dos testes de caça a bugs.

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
