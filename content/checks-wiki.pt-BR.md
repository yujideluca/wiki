---
id: checks-wiki
lang: pt-BR
source_hash: 04e6fb3724bc
title: Wiki: verificadores e regras
---

## What it is
Estes são os verificadores da [[wiki]], o site que você está lendo. É escrita em Elixir (back end) e Elm (front end) e é o projeto com mais regras de conteúdo.

## What it does
O gate tem cinco passos: (1) testes em Elixir (verificador, build, desatualização, hook, publicação, porta de login, isca); (2) testes em Elm e um build otimizado do Elm; (3) rastreabilidade de requisitos com a matriz commitada; (4) `wiki check` no conteúdo real, depois de comparar o arquivo de padrões de privacidade com o do workflow-memory; (5) limites de fitness: nenhum arquivo Elixir ou Elm com mais de 800 linhas, o pacote Elm comprimido (`app.js`) com no máximo 200.000 bytes, o gate com no máximo 1200 segundos.

O `wiki check` ([[wiki-check]]) exige: os campos de cabeçalho e as cinco seções em toda página; links e a simetria de `fed_by` e `feeds`; páginas órfãs; a varredura de privacidade ([[security-layers]]); a promoção de uma função citada por duas páginas a página própria; um horário `reviewed` que não esteja no futuro; fontes existentes; siglas explicadas no primeiro uso; `Steps` nas páginas de skill; a cópia completa do `SKILL.md` com sua impressão digital SHA-256 (Secure Hash Algorithm 256) nas páginas de skill; um diagrama de Flow nas páginas de ator, projeto, processo e skill; Architecture e Engineering practices nas páginas de projeto; e traduções com a mesma estrutura e o `source_hash` certo. As regras de acesso AU-1 a AU-6 e DC-1 são testes em `server/test/router_test.exs` e `decoy_test.exs`.

## How it does it
A CI (integração contínua) roda o gate no modo `ci`, que pula as verificações que precisam de outros repositórios privados ([[wiki-quality-gate]]). O job `gate` é uma verificação obrigatória na `main`. A publicação usa `wiki publish`, que recusa diante de qualquer problema do `wiki check` ([[wiki-cli]]).

## Where it sits in the pipeline
É uma página da camada 3 de [[code-security-pipeline]]: as ideias compartilhadas estão em [[quality-gate-explained]] e a lista completa em [[checker-catalog]].

## Who receives its output
Leitores que precisam saber o que protege este projeto e a sessão que o altera.
