---
id: checks-quizapp
lang: pt-BR
source_hash: 6b96d3d0dc2c
title: QuizApp: verificadores e regras
---

## What it is
Estes são os verificadores e as regras do [[quizapp]], o app Android de estudo (repositório `german-quiz`, pasta `QuizApp`). Tem o maior gate de todos os projetos e as únicas verificações que protegem uma versão que vai para um celular.

## What it does
O gate tem sete passos mais um oitavo opcional, nesta ordem: (1) testes do core e do app com cobertura; (2) limiares de cobertura, 90 % das linhas nos pacotes de lógica e nenhum arquivo abaixo de 80 % (`tools/check_coverage.py`); (3) os testes do gêmeo web; (4) os vetores de conformidade `scheduler` e `daily_bar` devem ser idênticos byte a byte no app e na web ([[quizweb-conformance]]); (5) rastreabilidade de requisitos, que também falha se a `docs/TRACEABILITY.md` regenerada não estiver commitada; (6) lint do Android, em que erros reprovam; (7) funções de fitness e a verificação do manifesto do banco de perguntas ([[content-manifest]]); um limite de 1200 segundos encerra o gate; (8) com `--mutation`, as falhas plantadas de propósito no agendador, corretor, fila, sessão, stores e gêmeo web devem ser todas detectadas: em 2026-11-02, 36 falhas no app e 9 no gêmeo web, uma mudança cada, restauradas após a execução ([[mutation-check]]). A última mudança nessa lista (2026-11-02, commit 5667133) apenas reescreveu a falha web da meta diária para casar com a linha protegida `goal > 0 ? clamp(answered / goal, 0, 1)`; ela continua significando "a barra pode passar de cheia".

Limites em `pipeline-check.toml`: nenhum arquivo Kotlin com mais de 400 linhas (em `core/src` e `app/src`), o APK (Android Package) de release com no máximo 3.000.000 de bytes, o gate com no máximo 1200 segundos, e nenhum import de `android` ou `androidx` no módulo `core` (a regra do núcleo puro, ADR-0009, registro de decisão de arquitetura). Regras de release: uma versão só pode ser promovida de beta para estável depois do gate com mutação e de `tools/check_tests_updated.sh` (o código mudou, então um teste também precisa ter mudado, ADR-0011), e `tools/check_web_sync.sh` confirma que o gêmeo web combina ([[check-web-sync]], [[check-tests-updated]]). A verificação de texto `check_errors_languagetool.py` tem página própria ([[check-errors-languagetool]]). As regras de espaçamento (ADR-0007) vêm primeiro e são guardadas por testes nomeados. Treze ADRs estão listados em [[quizapp-adrs]].

## How it does it
A CI (integração contínua) roda o mesmo gate pelo `pipeline-check` a cada push e pull request, e toda segunda-feira com a verificação de mutação ([[quizapp-ci]]). Ela baixa o branch web `web-<versionName>` quando existe, senão `main`. O job de CI `gate` é uma verificação obrigatória na `main` ([[maintenance-pipeline]]). Mais detalhes: [[quizapp-quality-gate]], [[quizapp-requirements]].

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
