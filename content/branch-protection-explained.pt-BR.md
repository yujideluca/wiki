---
id: branch-protection-explained
lang: pt-BR
source_hash: 0a0bff868819
title: Proteção de branch e hook de pre-push explicados
---

## What it is
Um branch é uma linha de trabalho no Git; `main` é a linha que conta como a versão oficial. A proteção de branch é uma configuração do GitHub que recusa alterações em `main` até que verificações nomeadas estejam verdes (aqui: o job de CI `gate`, CI = integração contínua). Um hook é um programa pequeno que roda sozinho em um evento; o hook de pre-push roda logo antes de o `git push` enviar os commits.

## What it does
Dois guardas protegem `main`. No GitHub, o job `gate` é uma verificação obrigatória ([[ci-explained]]). No laptop, `tools/hooks/pre-push` roda `pipeline-check --pre-push`, que roda o gate e barra o push de `main` quando uma verificação falha; `[pre_push] guard` em `pipeline-check.toml` lista prefixos de caminho, para que um push que só toca outros arquivos não seja verificado. Ele é ligado uma vez por clone com `git config core.hooksPath tools/hooks` e contornado de propósito com `git push --no-verify`. A regra mais ampla "nunca force-push" é uma preferência fixa na memória.

## How it does it
A proteção de branch só é gratuita em repositórios públicos (o GitHub Free a recusa em privados com o erro 403), então os privados dependem do hook. A verificação do relatório `protecao-de-branch` lê a configuração real com o comando `gh`. Um projeto que não pode ter a proteção registra o motivo em `protection_exception` no seu `pipeline-check.toml`, e a verificação passa a informar `aviso`, nunca `ok`. Hoje dois projetos declaram exceção: [[checks-workflow-memory]] (seu job `mem` envia para `main` com o token embutido do GitHub, que uma verificação obrigatória rejeitaria) e [[checks-codex-pbar]] (repositório privado no plano gratuito).

## Where it sits in the pipeline
Passo 1 de [[code-security-pipeline]], com a política mais ampla em [[maintenance-pipeline]].

## Who receives its output
A pessoa ou sessão que faz o push: um push recusado diz qual verificação falhou.
