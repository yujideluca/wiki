---
id: processing-sketches
lang: pt-BR
source_hash: a379c53d1133
title: Sketches do Processing
---

## What it is
Pequenos programas de arte generativa (arte feita por código) escritos em [Processing](https://processing.org/), um ambiente de programação para desenho baseado em Java. Ficam em `~/dev/processing-sketches`. "Sketch" é como o Processing chama um programa.

## Flow
trigger t1: Giovanni escreve um sketch no Processing
step s1: Cada sketch é um arquivo .pde na sua própria pasta
step s2: Ao rodar, desenha a curva do dragão de Heighway
decide d1: Qual versão?
step s3: Exportado como app, ignorado pelo git | [[drachenkurve]]
step s4: Renderizado como ícone de lançamento do QuizApp | [[quizapp]]
trigger t2: Um push no repositório | [[pipeline-check]]
step s5: O quality gate e as verificações automáticas rodam
product p1: O ícone de lançamento do QuizApp | [[quizapp]]
product p2: Um segundo sketch da curva do dragão, só como programa | [[drachenfraktal]]
product p3: Sketches verificados no GitHub

t1 -> s1
s1 -> s2
s2 -> d1
d1 -drachenkurve-> s3
d1 -drachenfraktal-> p2
s3 -> s4
s4 -> p1
t2 -> s5
s5 -> p3

## Architecture
### Contexto
person g: Giovanni — desenha e executa os sketches | [[giovanni]]
system s: processing-sketches — uma pasta de sketches pequenos do Processing
external p: Processing — a ferramenta que executa um sketch
external h: GitHub — guarda o histórico, privado | [[github]]

g -executa sketches com o-> p
g -mantém os sketches em-> s
s -é enviado ao-> h

### Contêineres
person g: Giovanni | [[giovanni]]
container dk: Sketch da curva do dragão | [[drachenkurve]]
container df: Sketch do fractal do dragão | [[drachenfraktal]]
store bo: build/ — jars gerados ao executar, nunca versionados
container qg: Portão de qualidade — cada sketch tem seu arquivo .pde e nenhuma saída de build é versionada

g -executa-> dk
g -executa-> df
dk -grava em-> bo
df -grava em-> bo
qg -confere-> dk
qg -confere-> df
qg -confere que nada está versionado em-> bo

## What it does
Desenha a curva do dragão de Heighway em duas versões: [[drachenkurve]] (exportada como app; gerou o ícone de lançamento do QuizApp) e [[drachenfraktal]].

## How it does it
Cada sketch é um arquivo `.pde` em sua própria pasta; a `drachenkurve` também tem um build exportado. Desde 2026-10-24 a pasta é um repositório no GitHub (`yujideluca/processing-sketches`, público desde 2026-10-25) com portão de qualidade, CI (integração contínua, verificações automáticas a cada push) e a verificação [[pipeline-check]] antes do push; a saída do build é ignorada pelo git.

## Where it sits in the pipeline
À parte dos outros projetos; sua única ligação com eles é o ícone do [[quizapp]].

## Who receives its output
O [[quizapp]] (seu ícone de lançamento).

## Engineering practices
Como este projeto segue o caminho dourado do [[project-template]].

### Princípios
1. **Uma pasta por sketch**: cada uma tem um arquivo `.pde` de mesmo nome; o portão falha quando falta.
2. **Saída de build nunca é versionada**: o portão falha quando um arquivo rastreado está dentro de uma pasta `build/`.
3. **O portão decide**: `tools/quality_gate.sh` é a única definição de “passou”, e a integração contínua a executa.
4. **As decisões vão no `DESIGN.md`.**

### Decisões
Ainda não há registros de decisão de arquitetura; o registro de decisões do `DESIGN.md` tem três linhas: o projeto foi posto sob git no GitHub (privado) com portão e CI, a primeira revisão de manutenção e a revisão mensal de 2026-10-25.

### Requisitos
Ainda não há lista de requisitos, porque os sketches não têm testes de comportamento (dívida técnica P3: mover a geometria da curva para uma função testada se os sketches crescerem).

### Portão de qualidade
O portão `tools/quality_gate.sh` confere que cada pasta de sketch tem seu arquivo `.pde` e que o git não rastreia saída de build. O `tools/pipeline-check.sh` acrescenta a medição completa.

### Integração contínua
Integração contínua (CI) significa verificações automáticas a cada push. O workflow `quality-gate.yml` roda o portão no GitHub a cada push, por meio do `pipeline-check` fixado em `pipeline-check.version`.

### Manutenção
A dívida técnica é registrada como issues do GitHub com o rótulo `debt` (P1 a P3), conforme a [[maintenance-policy]]. A [[monthly-architecture-review]] confere o projeto todo mês; a próxima vence em 2026-11-22.
