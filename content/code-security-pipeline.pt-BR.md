---
id: code-security-pipeline
lang: pt-BR
source_hash: 2a30c6f89789
title: Estrutura do código e pipeline de segurança (comece aqui)
---

## What it is
Este é o nó de entrada de um pequeno conjunto de páginas que explicam como o software do Giovanni é construído e protegido. Todo projeto segue a mesma receita: um layout fixo de pastas ([[repository-layout]]), um script que decide se o código passa ([[quality-gate-explained]]), verificações automáticas a cada envio ([[ci-explained]]), decisões registradas por escrito ([[adr-explained]]) e uma rede de proteção contra vazamento de segredos ([[security-layers]]). As páginas abaixo explicam cada ideia do zero e depois listam os verificadores e as regras de cada projeto.

## Flow
trigger t1: Alguém altera código e faz push | [[branch-protection-explained]]
step s1: A verificação local de pre-push roda o gate antes de enviar main | [[branch-protection-explained]]
step s2: As verificações automáticas no GitHub rodam o mesmo gate | [[ci-explained]]
step s3: O gate roda testes, tags de requisitos, mutação e limites de tamanho | [[quality-gate-explained]]
step s4: Os scanners de segredos procuram chaves, tokens e dados pessoais | [[security-layers]]
decide d1: Alguma verificação falha?
step s5: O push ou merge é barrado e a alteração é corrigida
step s6: A alteração é aceita e toda decisão estrutural é registrada | [[adr-explained]]
product p1: Uma alteração que passou por todas as verificações do projeto | [[checker-catalog]]
product p2: Uma alteração barrada com o nome da verificação que falhou

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -yes-> s5
d1 -no-> s6
s5 -> p2
s6 -> p1

## What it does
Dá a quem chega um mapa em três camadas. A camada 1 explica as ideias compartilhadas: [[ci-explained]], [[adr-explained]], [[quality-gate-explained]], [[branch-protection-explained]] e [[security-layers]]. A camada 2 é a estrutura compartilhada: [[repository-layout]] e a lista completa de verificadores em [[checker-catalog]]. A camada 3 é uma página por projeto, com os verificadores e as regras que só aquele projeto tem: [[checks-quizapp]], [[checks-quizweb]], [[checks-wiki]], [[checks-workflow-memory]], [[checks-pipeline-check]], [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-remote-terminal]], [[checks-processing-sketches]], [[checks-radiology-crawler]], [[checks-status-quo]] e [[checks-project-template]].

## How it does it
A receita compartilhada vive em [[project-template]]; o programa de medição [[pipeline-check]] vive em um repositório próprio e cada projeto fixa uma versão dele. O processo em volta está descrito em [[maintenance-pipeline]] e [[maintenance-policy]].

## Where it sits in the pipeline
Fica acima das páginas dos projetos e ao lado de [[system-overview]], que mostra o sistema inteiro e não só a parte de engenharia.

## Who receives its output
[[giovanni]] e toda sessão do Claude que precise saber qual verificação protege o quê.

## Steps
1. Uma alteração é enviada com push. Ator: Giovanni ou uma sessão do Claude. Saída: um commit em um branch.
2. O hook de pre-push no laptop roda o gate do projeto antes de enviar `main`. Saída: um push barrado ou permitido.
3. O GitHub Actions roda o mesmo gate. Saída: uma marca verde ou vermelha e um `report.json` para os projetos que usam o [[pipeline-check]].
4. O gate roda os testes e os verificadores do projeto (veja [[checker-catalog]]). Saída: aprovado ou a primeira verificação que falhou.
5. Os scanners de segredos e de privacidade rodam no gate ou ao publicar conteúdo ([[security-layers]]). Saída: uma recusa que diz o tipo de segredo, nunca o valor.
6. Uma decisão estrutural vira um ADR (registro de decisão de arquitetura) e uma linha no log de decisões ([[adr-explained]]). Saída: um arquivo em `docs/adr/`.
