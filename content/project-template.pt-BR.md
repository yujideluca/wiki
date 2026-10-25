---
id: project-template
lang: pt-BR
source_hash: 0fd304447a02
title: project-template (caminho dourado)
---

## What it is
O project-template é o ponto de partida de todo novo projeto de software do Giovanni. É uma pasta pronta (`~/dev/project-template`, repositório `yujideluca/project-template`) que já contém os bons hábitos de trabalho, para que fazer do jeito certo também seja o jeito mais rápido. Foi escolhido na revisão de manutenção e evolução de 2026-10-22, e o [[quizapp]] foi o projeto de referência do qual ele foi extraído.

## What it does
Desde o primeiro dia, um novo projeto recebe: princípios que são cada um aplicados por uma verificação; um arquivo de design com diagramas (no estilo do [modelo C4](https://c4model.com/), desenhados com [Mermaid](https://mermaid.js.org/)) e um registro de decisões; ADRs (architecture decision records, notas curtas que guardam os motivos das decisões); uma lista de requisitos com testes etiquetados ligados a eles ([[check-traceability]]); um portão de qualidade (um script que define "aprovado", [[template-quality-gate]]); CI (integração contínua: verificações automáticas a cada push) e a política de dívida técnica e revisões ([[maintenance-policy]]).

## How it does it
A pasta é copiada com `cp -r` para uma nova pasta de projeto. Na primeira sessão o Claude preenche o CLAUDE.md do projeto (seu arquivo de instruções), a seção 1 do arquivo de design, os primeiros requisitos, os passos do portão e a ADR-0002 para a tecnologia escolhida, e então cria o repositório privado no GitHub e seus rótulos ([[new-project]]). Antes de tudo isso, o Giovanni escolhe a linguagem de programação ([[work-ask-language]]). O programa de manutenção [[pipeline-check]] não é copiado para o projeto: a pasta traz o arquivo `pipeline-check.version` (`v0.4.0` em 2026-10-24), o executor `tools/pipeline-check.sh`, que baixa e compila essa versão de `yujideluca/pipeline-check` uma vez (a máquina precisa de Rust, `cargo` e git), os limites em `pipeline-check.toml` e uma verificação local antes do push em `tools/hooks/pre-push`, ativada com `git config core.hooksPath tools/hooks`.

## Where it sits in the pipeline
A montante de todo novo projeto. Este [[wiki]] foi o primeiro projeto iniciado a partir dele.

## Who receives its output
Novos projetos como o [[wiki]]; melhorias encontradas em projetos em andamento voltam ao modelo durante a [[monthly-architecture-review]].
