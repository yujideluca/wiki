---
id: maintenance-pipeline
lang: pt-BR
source_hash: 66c2e90145c8
title: Pipeline de manutenção (medir, depois julgar)
---

## What it is
É a forma como os projetos de software do Giovanni são mantidos sustentáveis: um programa mede e bloqueia, uma skill julga e propõe, e os dois conversam apenas por um arquivo, o `report.json`. A divisão é de propósito (ADR-0013 no QuizApp; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão): números devem vir de uma máquina que não se deixa convencer, e o julgamento deve vir do Claude, que pode ponderá-los.

## Flow
trigger t1: Alguém faz push no repositório de um projeto | [[quizapp-ci]]
step s1: O job de verificação gate roda o pipeline-check | [[pipeline-check]]
decide d1: Alguma verificação falha (falha)?
step s2: A proteção de branch, ou a checagem local pré-push, barra o merge | [[maintenance-policy]]
step s3: Avisos (aviso) aparecem no report.json, mas nunca reprovam
trigger t2: A revisão mensal vence | [[monthly-architecture-review]]
step s4: A skill de revisão transforma avisos e falhas em propostas de dívida priorizadas | [[skill-revisao-manutencao]]
step s5: O Giovanni decide o que fazer | [[giovanni]]
product p1: Uma mudança que passou em todas as verificações
product p2: Um push bloqueado
product p3: Issues de dívida e uma linha Preventive no registro de decisões

t1 -> s1
s1 -> d1
d1 -sim-> s2
d1 -não-> s3
s2 -> p2
s3 -> p1
s3 -> s4
t2 -> s4
s4 -> s5
s5 -> p3

## What it does
Transforma as regras da [[maintenance-policy]] em algo que uma máquina aplica: a tarefa de CI (integração contínua, verificações automáticas a cada push) falha diante de uma `falha`, e a revisão mensal lê os mesmos números em vez de medir à mão.

## How it does it
O [[pipeline-check]] roda na CI e no notebook; a [[skill-revisao-manutencao]] lê o relatório dele. O programa não é copiado para os projetos: vive em um repositório próprio, `yujideluca/pipeline-check`, e cada projeto fixa uma versão em `pipeline-check.version`. Para realmente bloquear um merge, a proteção de branch do GitHub precisa exigir a tarefa de CI, e só o Giovanni muda isso. Em um repositório privado de um plano gratuito do GitHub essa proteção não está disponível (o GitHub responde com erro 403), então uma verificação local antes do push (`pipeline-check --pre-push`, ativada com `git config core.hooksPath tools/hooks`) impede o push do `main` quando uma verificação falha. O Giovanni escolheu a verificação local em 2026-10-24. Em 2026-10-25 o Giovanni decidiu, em vez disso, tornar públicos os repositórios que precisam de proteção, porque o GitHub aceita a proteção de branch (uma configuração que recusa mudanças no `main` até que verificações indicadas passem) em repositórios públicos do plano gratuito. Desde então a tarefa de CI `gate` é uma verificação obrigatória no `main` do german-quiz (o projeto QuizApp), do remote-terminal, do wiki e do processing-sketches, e o `pipeline-check` informa `protecao-de-branch` como `ok` nesses repositórios (`ok`: a verificação passou). O workflow-memory continua sem proteção de propósito: um teste em um branch descartável mostrou que o GitHub rejeita o envio da sua tarefa `mem` (ela manda arquivos derivados direto para o `main` com o token embutido do GitHub) quando `gate` é obrigatório, e que o GitHub não deixa esse token embutido contornar uma regra em uma conta pessoal. O Giovanni escolheu manter ali a verificação local antes do push. Desde o pipeline-check v0.5.0 o `pipeline-check.toml` do workflow-memory registra isso com `protection_exception`, e o relatório mostra `protecao-de-branch` como `aviso` (um alerta que não faz a execução falhar) com o motivo. Foi aplicada primeiro ao [[quizapp]], depois copiada para os outros projetos e para o [[project-template]].

## Where it sits in the pipeline
Entre cada push e a revisão mensal: [[quizapp-ci]], depois [[monthly-architecture-review]].

## Who receives its output
O Giovanni.

## Steps
1. Um push executa a tarefa de CI `gate`, que roda o [[pipeline-check]].
2. Qualquer `falha` reprova a tarefa; a proteção de branch (ou a verificação local antes do push) impede o merge.
3. Um `aviso` nunca reprova, mas aparece no relatório.
4. Na revisão mensal, a [[skill-revisao-manutencao]] transforma avisos e falhas em propostas `debt` priorizadas.
5. O Giovanni decide; a skill registra uma linha Preventiva no registro de decisões e publica o wiki.
