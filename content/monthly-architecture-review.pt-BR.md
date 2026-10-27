---
id: monthly-architecture-review
lang: pt-BR
source_hash: 7cb37dd5f3ea
title: Revisão mensal de arquitetura
---

## What it is
Uma vez por mês, uma sessão de trabalho olha todos os projetos do Giovanni em conjunto, no papel que um staff engineer (um engenheiro sênior que cuida da coerência do todo) teria numa empresa. A ideia vem da decisão ADR-0003 do [[workflow-memory]] (uma ADR é um architecture decision record, uma nota curta que registra uma decisão e seus motivos). Fica guardada como pendência na memória, então toda conversa a mostra até ela ser feita.

## Flow
trigger t1: O item aberto da revisão mensal vence | [[maintenance-policy]]
step s1: A skill de revisão roda o pipeline-check e lê o report.json | [[skill-revisao-manutencao]], [[pipeline-check]]
step s2: Confere o gate, as execuções automáticas, as métricas de entrega e as funções de aptidão | [[fitness-check]]
step s3: Julga: diagramas e ADRs batem com o código, atualizações testadas num branch
decide d1: Há uma dívida P1 com mais de um mês?
step s4: Agenda agora
step s5: Olha entre projetos: o mesmo problema resolvido duas vezes? | [[project-template]]
step s6: Confere se as entradas da memória ainda valem, marca as velhas como stale | [[workflow-memory]]
step s7: Informa o que moldou a revisão | [[mem-use]]
product p1: Uma linha Preventive no registro de decisões por projeto
product p2: Uma lista de dívidas verdadeira e priorizada
product p3: A melhor solução levada ao template | [[project-template]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -sim-> s4
d1 -não-> s5
s4 -> s5
s4 -> p2
s5 -> p3
s5 -> s6
s6 -> s7
s7 -> p1

## What it does
Percorre o checklist da [[maintenance-policy]] para cada projeto ativo em `~/dev` e registra o resultado. Desde 2026-10-24 é executada pela skill [[skill-revisao-manutencao]], com base no relatório do [[pipeline-check]] ([[maintenance-pipeline]]).

## How it does it
Usa o portão de qualidade de cada projeto, métricas de entrega (o bloco `dora` do relatório do [[pipeline-check]]), funções de aptidão, o arquivo de design (DESIGN.md), as ADRs e a lista de dívidas. A skill [[skill-revisao-manutencao]] roda `tools/pipeline-check.sh` e lê `build/pipeline-check/report.json`; os passos 1 a 3 abaixo são o que o programa já mediu, e o resto é julgamento.

## Where it sits in the pipeline
Mensal, em todo o [[quizapp]], [[quizweb]], [[workflow-memory]], [[wiki]] e o modelo.

## Who receives its output
O registro de decisões de cada projeto (uma linha Preventiva) e o [[project-template]] (as melhores soluções são levadas para lá).

## Steps
1. O portão passa localmente e as últimas execuções de CI (integração contínua) estão verdes.
2. Métricas: com que frequência as mudanças são lançadas, quanto demoram, quanto trabalho é refeito e a parcela preventiva (meta cerca de 20 %).
3. Funções de aptidão: qual está mais perto do limite? Agir antes de cruzar ([[fitness-check]]).
4. Os diagramas do DESIGN.md e as ADRs ainda correspondem ao código; toda mudança estrutural tem uma ADR.
5. Manutenção adaptativa: atualizações de ferramentas, SDKs (software development kits) e dependências são testadas em um branch e passam pelo portão.
6. Lista de dívidas: ainda verdadeira, prioridade certa; um P1 com mais de um mês é agendado agora ([[maintenance-policy]]).
7. Entre projetos: o mesmo problema foi resolvido duas vezes de formas diferentes? Levar a melhor solução para o [[project-template]].
8. Memória: as entradas ainda são verdadeiras (`mem search <projeto>`)? As desatualizadas recebem `mem feedback REF stale` ([[workflow-memory]]).
9. Registrar uma linha Preventiva no registro de decisões de cada projeto e informar com [[mem-use]].
