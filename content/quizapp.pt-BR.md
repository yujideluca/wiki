---
id: quizapp
lang: pt-BR
source_hash: 777c8903bb32
title: QuizApp (German Quiz, Android)
---

## What it is
O QuizApp ("German Quiz") é um app Android que o Giovanni usa para treinar alemão no nível B2 do exame Goethe. Funciona offline e usa repetição espaçada no estilo do [Anki](https://apps.ankiweb.net/): um método em que as perguntas respondidas bem voltam depois de intervalos cada vez maiores, e as erradas voltam logo ([repetição espaçada](https://en.wikipedia.org/wiki/Spaced_repetition)). O repositório é `yujideluca/german-quiz`, a pasta é `~/dev/QuizApp` e o nome de pacote do app é `dev.yuji.quiz`. É também o projeto de referência de como os projetos do Giovanni são construídos.

## Flow
trigger t1: Giovanni abre o app no celular | [[phone]]
step s1: Escolhe um dos cinco modos de estudo | [[game-modes]]
step s2: O agendador escolhe a próxima pergunta do banco | [[spaced-repetition-scheduler]]
step s3: O Giovanni responde; o corretor confere | [[answer-grader]]
decide d1: Certo e rápido?
step s4: O cartão vai para dias, semanas, meses
step s5: O cartão volta logo
step s6: Meta diária e calendário de sequência são atualizados | [[daily-goal]], [[activity-calendar]]
trigger t2: Um novo pacote de perguntas é publicado | [[question-pack]]
step s7: O app busca o pacote, sem nova versão do app
trigger t3: Giovanni pede uma mudança | [[giovanni]]
step s8: A mudança segue o caminho de release, beta antes da estável | [[quizapp-release]]
product p1: Progresso de estudo, com backup sob demanda | [[progress-backup]]
product p2: Um app beta ou estável novo no celular | [[update-client]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -sim-> s4
d1 -não-> s5
s4 -> s6
s5 -> s6
s6 -> p1
t2 -> s7
s7 -> s2
t3 -> s8
s8 -> p2

## Architecture
### Contexto
person p: Jogador — estuda vocabulário de alemão | [[giovanni]]
system a: App German Quiz — quiz de repetição espaçada para Android
external w: German Quiz web — o mesmo quiz no navegador | [[quizweb]]
external f: Feed de versões — última versão, arquivo assinado do app, pacote de perguntas | [[release-feed]]
external d: Armazenamento do celular ou Google Drive — guarda o arquivo de backup | [[phone]]

p -estuda com-> a
p -estuda com-> w
a -compartilha perguntas e vetores de teste com-> w
a -baixa atualizações e perguntas do-> f
a -salva backups em-> d

### Contêineres
person p: Jogador | [[giovanni]]
container ui: Telas — o que o jogador vê e toca
container ct: Controlador de estudo — a única porta das telas | [[quizapp-app]]
container co: Módulo núcleo — agendador, avaliador, fila; sem Android | [[quizapp-core]]
container da: Camada de dados — progresso, ajustes, atualizador
store v: Arquivos de vocabulário — embutidos no app | [[vocab-assets]]
store dl: Pacote de perguntas baixado — perguntas mais novas
external f: Feed de versões | [[release-feed]]

p -toca-> ui
ui -chama-> ct
ct -roda as regras no-> co
ct -salva por meio da-> da
da -lê-> v
da -lê e grava-> dl
da -baixa do-> f

## What it does
Oferece cinco modos de estudo sobre um conjunto selecionado de conteúdo B2 ([[game-modes]]): der/die/das, preposições, formas de plural, Präteritum (o passado simples do alemão) e "Fehler finden" (achar o erro). Respostas erradas ou lentas voltam logo; cartas conhecidas se afastam para dias, semanas e meses ([[spaced-repetition-scheduler]]). Tem meta diária e calendário de sequência ([[daily-goal]], [[activity-calendar]]), cópia de segurança do progresso ([[progress-backup]]) e atualizações de dentro do app ([[update-client]]). Desde 2026-10-22 o conjunto de perguntas pode crescer sem um novo lançamento do app: novos [[question-pack]]s chegam pelo feed de atualização ([[question-pool-updater]], [[publish-content]]).

## How it does it
É escrito em [Kotlin](https://kotlinlang.org/) com [Jetpack Compose](https://developer.android.com/compose) (a forma moderna do Android de desenhar telas), dividido em dois módulos Gradle (partes construídas separadamente): [[quizapp-core]] (lógica em Kotlin puro: agendador, avaliador, fila, sessão, conteúdo) e [[quizapp-app]] (telas Android, armazenamento, atualizações). O conteúdo é construído a partir de arquivos de texto separados por tabulação pelo [[build-vocab]]. Toda mudança segue requisito → teste → código, passa pelo [[quizapp-quality-gate]] e chega ao celular primeiro pelo canal beta ([[release-channels]], [[quizapp-release]]). O design e suas decisões estão em [[quizapp-design-doc]] e [[quizapp-adrs]].

## Where it sits in the pipeline
É a principal ferramenta de estudo do Giovanni. Seu gêmeo web é o [[quizweb]], que deve se comportar igual ([[check-web-sync]]). Os lançamentos saem pelo [[release-feed]].

## Who receives its output
O Giovanni, no [[phone]]; o [[quizweb]] recebe suas regras, vetores de teste e traduções.

## Engineering practices
Como este projeto segue o caminho dourado do [[project-template]].

### Princípios
1. **As regras de espaçamento vêm primeiro** (são requisitos, fixados por testes): os testes das regras de espaçamento e da simulação, os vetores compartilhados e as verificações com falhas plantadas de propósito.
2. **A lógica não depende de framework**: agendador, avaliador, fila e sessão ficam no módulo núcleo, que não tem Android; um `import android.*` ali não compila.
3. **Requisito, depois teste, depois código**: conferido pelo passo de rastreabilidade do portão.
4. **Nada chega ao jogador sem passar antes pelo app beta**, e uma versão pode ser promovida quando sobrevive aos testes automáticos atualizados para o que ela muda; aí promover é decisão do Giovanni.
5. **O gêmeo web se comporta como o app**: vetores de teste compartilhados, uma checagem de sincronia e as duas execuções de integração contínua.
6. **As decisões ficam onde está o código**: registro de decisões com o tipo, registro de decisão de arquitetura para as estruturais, e os diagramas C4 do `DESIGN.md` mudam no mesmo commit.

### Decisões
13 registros de decisão de arquitetura (notas curtas que guardam os motivos de uma decisão) em `docs/adr/`, [[quizapp-adrs]]: Kotlin com Jetpack Compose; um agendador puro com relógio injetado; um feed de atualização com atualizador dentro do app; dois canais de lançamento (beta primeiro); um gêmeo web; regras de espaçamento como requisitos; requisitos primeiro; um módulo núcleo puro; backup do progresso em um arquivo; promoção após testes atualizados; um banco de perguntas baixável; um programa que mede e uma skill que julga. O `DESIGN.md` também guarda o registro de decisões.

### Requisitos
33 requisitos em `docs/REQUIREMENTS.md` ([[quizapp-requirements]]), agrupados por prefixo (regras de espaçamento SP, agendamento e meta diária DG, banco de perguntas QP, backup PE, atualizações UP e outros). Cada um tem um teste marcado `REQ <ID>`, e a verificação de rastreabilidade ([[check-traceability]]) falha quando algum não tem.

### Portão de qualidade
O [[quizapp-quality-gate]] é um script com sete passos: testes do núcleo e do app com cobertura; limites de cobertura dos pacotes de lógica; os testes web; os vetores de conformidade idênticos no app e na web; a rastreabilidade dos requisitos; o lint do Android; as funções de aptidão e o manifesto do banco de perguntas. Antes de uma promoção roda também uma checagem de mutação (falhas plantadas de propósito precisam ser pegas).

### Integração contínua
Integração contínua (CI) significa verificações automáticas a cada push. O workflow `quality-gate.yml` roda o portão no GitHub a cada push ([[quizapp-ci]]); depois do push, a execução precisa ficar verde.

### Manutenção
A dívida técnica é registrada como issues do GitHub com o rótulo `debt` (P1 a P3), conforme a [[maintenance-policy]]. A [[monthly-architecture-review]] confere o projeto todo mês; a próxima vence em 2026-11-22.
