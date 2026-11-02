---
id: checks-radiology-crawler
lang: pt-BR
source_hash: a64c9b7582f0
title: radiology-crawler: verificadores e regras
---

## What it is
Estes são os verificadores do repositório do rastreador de radiologia (`radiology-crawler`, chamado `radiology-report-matcher` na sua configuração), as ferramentas em Python que coletam e analisam textos públicos de radiologia para o futuro comparador de laudos ([[radiology-report-matcher]], [[radiopaedia-crawler]]).

## What it does
O gate tem quatro passos: (0) `check_dependencies.py`: todo import de terceiros aparece em `requirements.txt` (ou em `requirements-optional.txt`, quando só é usado dentro de um bloco try com alternativa), e todo `pip install` em um workflow é `pip install -r requirements.txt` (princípio 11, acrescentado depois de uma execução de CI falhar por um pacote ausente); (1) `compileall` e os testes com pytest; (2) rastreabilidade de requisitos (os grupos AN, CW, DP, LG, TL, WS); (3) limites de fitness: nenhum arquivo Python com mais de 800 linhas, o gate com no máximo 1200 segundos. Regras no `CLAUDE.md`, cada uma com os testes que a verificam: o rastreador obedece ao `robots.txt` (CW-1 a CW-3); cada chamada ao Codex é uma sessão nova com menos de 250.000 tokens (TL-2, TL-5); nenhum dado pessoal ou de pacientes no repositório nem nos logs; páginas e bancos baixados nunca vão para o git; o andamento da análise estatística fica em `docs/analysis-status.json`.

## How it does it
A CI (integração contínua) instala a partir de `requirements.txt` e roda `pipeline-check --mode ci` (no máximo 60 minutos). Seu `pipeline-check.toml` não tem seção GitHub, então a proteção de branch não é lida ali. Existem três ADRs.

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
