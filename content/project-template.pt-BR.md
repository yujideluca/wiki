---
id: project-template
lang: pt-BR
source_hash: 9bd6f4175ec4
title: project-template (caminho dourado)
---

## What it is
O project-template é o ponto de partida de todo novo projeto de software do Giovanni. É uma pasta pronta (`~/dev/project-template`, repositório `yujideluca/project-template`) que já contém os bons hábitos de trabalho, para que fazer do jeito certo também seja o jeito mais rápido. Foi escolhido na revisão de manutenção e evolução de 2026-10-22, e o [[quizapp]] foi o projeto de referência do qual ele foi extraído.

## Flow
trigger t1: Um novo projeto começa | [[new-project]]
step s1: A pasta do template é copiada para uma pasta de projeto nova
step s2: Traz princípios impostos, desenho, testes marcados, gate e política de dívida | [[template-quality-gate]], [[maintenance-policy]]
step s3: O Claude preenche CLAUDE.md, o desenho, os primeiros requisitos e os passos do gate
step s4: O repositório privado e seus rótulos são criados
step s5: O projeto fixa uma versão do pipeline-check; o programa em si não é copiado | [[pipeline-check]]
trigger t2: Um projeto em andamento encontra uma prática melhor | [[monthly-architecture-review]]
step s6: A melhoria é levada ao template
product p1: Um projeto novo que já começa com os bons hábitos | [[wiki]]
product p2: Um template melhor para o próximo projeto

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> p1
t2 -> s6
s6 -> p2

## Architecture
### Contexto
person g: Giovanni — pede um projeto novo e escolhe a linguagem | [[giovanni]]
person c: Claude Code — copia o modelo e o preenche | [[claude-code]]
system t: project-template — a pasta inicial com os bons hábitos embutidos
external n: Um projeto novo — uma cópia que já nasce com os hábitos
external p: pipeline-check — o programa de medição, buscado por versão | [[pipeline-check]]
external h: GitHub — um repositório privado para o projeto novo | [[github]]

g -pede um projeto a partir do-> t
c -copia e preenche o-> t
t -é copiado para-> n
n -fixa uma versão do-> p
n -é enviado ao-> h

### Contêineres
person c: Claude Code | [[claude-code]]
container cm: CLAUDE.md — princípios e regras de trabalho
container ds: DESIGN.md — diagramas C4 e registro de decisões
store ad: docs/adr — registros de decisão
store rq: REQUIREMENTS.md — promessas com IDs | [[check-traceability]]
store mt: MAINTENANCE.md — a política de dívida e a lista de revisão | [[maintenance-policy]]
container qg: quality_gate.sh — a única definição de “passou” | [[template-quality-gate]]
container ru: pipeline-check.sh — busca e roda a versão fixada
container ci: Workflow de verificação automática — roda o executor a cada push
external p: pipeline-check | [[pipeline-check]]

c -preenche o-> cm
c -preenche o-> ds
c -escreve-> ad
c -escreve-> rq
c -segue o-> mt
c -preenche os passos do-> qg
ci -inicia o-> ru
ru -roda o-> qg
ru -busca o-> p

## What it does
Desde o primeiro dia, um novo projeto recebe: princípios que são cada um aplicados por uma verificação; um arquivo de design com diagramas (no estilo do [modelo C4](https://c4model.com/), desenhados com [Mermaid](https://mermaid.js.org/)) e um registro de decisões; ADRs (architecture decision records, notas curtas que guardam os motivos das decisões); uma lista de requisitos com testes etiquetados ligados a eles ([[check-traceability]]); um portão de qualidade (um script que define "aprovado", [[template-quality-gate]]); CI (integração contínua: verificações automáticas a cada push) e a política de dívida técnica e revisões ([[maintenance-policy]]).

## How it does it
A pasta é copiada com `cp -r` para uma nova pasta de projeto. Na primeira sessão o Claude preenche o CLAUDE.md do projeto (seu arquivo de instruções), a seção 1 do arquivo de design, os primeiros requisitos, os passos do portão e a ADR-0002 para a tecnologia escolhida, e então cria o repositório privado no GitHub e seus rótulos ([[new-project]]). Antes de tudo isso, o Giovanni escolhe a linguagem de programação ([[work-ask-language]]). O programa de manutenção [[pipeline-check]] não é copiado para o projeto: a pasta traz o arquivo `pipeline-check.version` (`v0.4.0` em 2026-10-24), o executor `tools/pipeline-check.sh`, que baixa e compila essa versão de `yujideluca/pipeline-check` uma vez (a máquina precisa de Rust, `cargo` e git), os limites em `pipeline-check.toml` e uma verificação local antes do push em `tools/hooks/pre-push`, ativada com `git config core.hooksPath tools/hooks`.

## Where it sits in the pipeline
A montante de todo novo projeto. Este [[wiki]] foi o primeiro projeto iniciado a partir dele.

## Who receives its output
Novos projetos como o [[wiki]]; melhorias encontradas em projetos em andamento voltam ao modelo durante a [[monthly-architecture-review]].

## Engineering practices
### Princípios
1. **Requisito, depois teste, depois código**: um comportamento vira uma linha em `docs/REQUIREMENTS.md`, depois um teste marcado `REQ <ID>`; o passo de rastreabilidade do portão confere.
2. **A lógica não depende de framework**: cada projeto nomeia seu módulo puro e o que o garante (uma fronteira de módulo ou um teste de arquitetura).
3. **O portão decide**: `tools/quality_gate.sh` é a única definição de “passou”, e a integração contínua o roda por meio do `pipeline-check`.
4. **Uma ferramenta usada por mais de um projeto existe uma só vez**, em repositório próprio, consumida por versão fixada e nunca copiada.
5. **As decisões ficam onde está o código**: uma linha no registro de decisões do `DESIGN.md` com seu tipo e, para as estruturais, um registro de decisão de arquitetura.

### Decisões
Dois registros de decisão de arquitetura (notas curtas que guardam os motivos de uma decisão) em `docs/adr/`: 0001 registrar decisões como ADRs e 0003 um programa mede e uma skill julga (o 0002 fica reservado para a escolha de tecnologia de cada projeto novo). O `DESIGN.md` guarda o registro de decisões com o tipo de manutenção.

### Requisitos
O `docs/REQUIREMENTS.md` traz uma linha de exemplo (`XX-1`) que mostra o formato; um projeto novo a troca pelos seus próprios requisitos, cada um com um teste marcado `REQ <ID>` ([[check-traceability]]).

### Portão de qualidade
O [[template-quality-gate]] é um script com três passos de exemplo para preencher: build e testes, rastreabilidade dos requisitos e as funções de aptidão (limites em `pipeline-check.toml`).

### Integração contínua
Integração contínua (CI) significa verificações automáticas a cada push. O workflow `quality-gate.yml` roda o executor `tools/pipeline-check.sh` no GitHub a cada push; uma checagem local antes do push em `tools/hooks/pre-push` faz o papel da proteção de branch em um repositório privado.

### Manutenção
O modelo carrega a própria política: [[maintenance-policy]] (dívida técnica como issues do GitHub com o rótulo `debt`, P1 a P3, cerca de uma sessão em cinco gasta nela) e a lista da [[monthly-architecture-review]]. Uma melhoria achada em um projeto em andamento volta para cá; a próxima revisão vence em 2026-11-22.
