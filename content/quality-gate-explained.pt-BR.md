---
id: quality-gate-explained
lang: pt-BR
source_hash: 46e8c1d13baa
title: Quality gate, requisitos, mutação e fitness explicados
---

## What it is
Um quality gate (portão de qualidade) é um único script, `tools/quality_gate.sh`, que decide se um projeto "passa". Ele termina com 0 quando tudo está certo e com outro número (um código de saída) quando algo falha. É a única definição de "passou": o laptop, os scripts de publicação e a [[ci-explained]] rodam o mesmo arquivo ([[template-quality-gate]] é o formulário em branco).

## What it does
Um gate costuma ter três tipos de passo, explicados aqui uma vez:
- **Testes**: a suíte de testes do próprio projeto (unitários, de propriedades e de conformidade).
- **Rastreabilidade de requisitos**: cada promessa em `docs/REQUIREMENTS.md` tem um ID, e um teste leva a tag `REQ <ID>` ([[check-traceability]]). Uma promessa sem teste, ou uma tag de promessa que não existe, falha.
- **Verificação de mutação**: o script planta de propósito uma falha pequena em uma cópia do código (por exemplo, trocando um número) e exige que pelo menos um teste falhe; uma falha que sobrevive significa que falta um teste ([[mutation-check]]).
- **Funções de fitness**: limites automáticos para uma qualidade do projeto, como o maior arquivo, o tamanho do app ou o tempo do gate. Uma função de fitness avisa a partir de 80 % do limite e falha em 100 % ([[fitness-check]]).
- **Lint de shell**: o [ShellCheck](https://www.shellcheck.net/) lê os scripts de shell do projeto em busca de erros.
- **Números DORA**: DORA (DevOps Research and Assessment) são métricas de entrega calculadas a partir do git; são informadas, mas nunca falham ([[pipeline-check]]).

## How it does it
O gate chama `tools/pipeline-check.sh --traceability` e `--measure-only` para as verificações compartilhadas. O invólucro `pipeline-check` roda o gate uma vez e acrescenta as verificações que não estão dentro dele (imports de arquitetura, estado do GitHub). Uma `falha` faz o programa sair com 1; um `aviso` nunca; uma verificação que não pôde rodar é `pulado`, nunca `ok`. Quais passos cada projeto tem está em [[checker-catalog]].

## Where it sits in the pipeline
Passo 3 de [[code-security-pipeline]].

## Who receives its output
A [[ci-explained]], o hook de pre-push ([[branch-protection-explained]]) e, pelo `report.json`, o skill [[skill-revisao-manutencao]].
