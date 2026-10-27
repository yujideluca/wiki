---
id: quizweb
lang: pt-BR
source_hash: 31b9a69077cc
title: QuizWeb (German Quiz, web)
---

## What it is
O QuizWeb é a versão web do quiz de alemão, feita para funcionar em um iPhone. É um PWA (progressive web app: uma página web que pode ser instalada no celular como um app e continua funcionando offline, veja [PWA](https://en.wikipedia.org/wiki/Progressive_web_app)), servido pelo [[github-pages]]. O repositório é `yujideluca/german-quiz-web` e a pasta é `~/dev/QuizWeb`. É o "gêmeo web" do [[quizapp]].

## Flow
trigger t1: Giovanni abre o QuizWeb num navegador, por exemplo no iPhone | [[github-pages]]
step s1: O service worker guarda o app em cache para funcionar offline | [[quizweb-service-worker]]
step s2: O controlador conduz uma sessão de estudo com a lógica pura | [[quizweb-controller]], [[quizweb-domain]]
step s3: Perguntas e traduções são carregadas | [[quizweb-content]]
step s4: O progresso é salvo no navegador daquele aparelho | [[quizweb-store]]
product p1: Sessões de estudo que funcionam offline; Configurações > Backup guarda o progresso
trigger t2: O app Android estável muda perguntas, traduções ou modos | [[quizapp]]
step s5: check-web-sync compara arquivos, modos e o estado enviado do clone web | [[check-web-sync]]
decide d1: O gêmeo web combina?
step s6: Porta a mudança, sobe a versão do cache, roda os testes e faz push
trigger t3: Um push no repositório | [[quizweb-ci]]
step s7: Os testes rodam, inclusive quem pode importar quem, mais os limites do pipeline-check | [[pipeline-check]]
decide d2: Tudo passou?
step s8: O GitHub Pages publica o push em cerca de um minuto | [[github-pages]]
product p2: Os gêmeos estão em sincronia
product p3: Uma versão nova para todo navegador
product p4: Nada é publicado

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> p1
t2 -> s5
s5 -> d1
d1 -sim-> p2
d1 -não-> s6
s6 -> s7
t3 -> s7
s7 -> d2
d2 -sim-> s8
d2 -não-> p4
s8 -> p3

## Architecture
### Contexto
person p: Jogador — estuda no iPhone ou em qualquer navegador | [[giovanni]]
system w: German Quiz web — quiz de cinco modos que funciona offline
external g: GitHub Pages — entrega o site | [[github-pages]]
external a: App Android German Quiz — origem das perguntas e dos vetores de teste | [[quizapp]]
external b: Armazenamento do navegador no aparelho — guarda o progresso

p -estuda no-> w
g -entrega-> w
a -compartilha perguntas e vetores de teste com-> w
w -guarda o progresso no-> b

### Contêineres
person p: Jogador | [[giovanni]]
container ui: Telas — botões, cartas, calendário | [[quizweb-app]]
container ct: Controlador — a única porta das telas | [[quizweb-controller]]
container dm: Domínio — agendador, avaliador, fila; sem navegador | [[quizweb-domain]]
container ch: Conteúdo — transforma palavras em cartas | [[quizweb-content]]
container i: Textos — a interface em três idiomas | [[quizweb-i18n]]
container sv: Armazenamento — salva e carrega o progresso | [[quizweb-store]]
store ls: Armazenamento do navegador — o progresso fica aqui
store vw: Listas de palavras — os mesmos arquivos do app | [[vocab-tsv]]
container sw: Service worker — mantém uma cópia offline | [[quizweb-service-worker]]

p -toca-> ui
ui -chama-> ct
ui -lê textos de-> i
ct -aplica as regras do-> dm
ct -monta cartas com-> ch
ct -salva por meio do-> sv
ch -lê-> vw
sv -grava no-> ls
sw -guarda uma cópia das-> ui

## What it does
Tem os mesmos cinco modos, agendador, meta diária e calendário de sequência do [[quizapp]] e funciona offline. O progresso fica no navegador daquele aparelho e é separado do app Android; Configurações > Backup o salva e restaura.

## How it does it
É JavaScript simples em módulos ES (a forma padrão de dividir JavaScript em arquivos), sem etapa de build e sem dependências. As partes são: [[quizweb-domain]] (lógica pura), [[quizweb-content]], [[quizweb-controller]], [[quizweb-store]] e [[quizweb-app]] (os dois últimos são os únicos módulos que tocam o navegador), mais o cache offline [[quizweb-service-worker]]. O teste `tests/architecture.test.js` define quem pode importar quem, e a [[quizweb-ci]] executa `npm test` e os limites do [[pipeline-check]] a cada push.

## Where it sits in the pipeline
É o gêmeo do [[quizapp]] (decisão ADR-0006 lá; uma ADR é um architecture decision record, uma nota curta que guarda os motivos de uma decisão): lê os mesmos arquivos de vocabulário e os mesmos vetores de conformidade, e o [[check-web-sync]] no QuizApp os compara. A adaptação de recursos Android ainda em beta espera em um branch `web-<versão>` e é mesclada ao `main` quando o app é promovido.

## Who receives its output
O iPhone do Giovanni, ou qualquer navegador, por meio do [[github-pages]].

## Engineering practices
Como este projeto segue o caminho dourado do [[project-template]].

### Princípios
1. **O domínio continua puro**: agendador, avaliador e fila não sabem nada do navegador. Só `app.js` e `store.js` podem tocá-lo, e `tests/architecture.test.js` guarda essas regras de dependência.
2. **A web se comporta como o app**: vetores de conformidade compartilhados com o app Android, conferidos por `tests/conformance.test.js`.
3. **O portão decide**: `tools/quality_gate.sh` roda os testes e as verificações de aptidão, e a integração contínua roda o mesmo script.
4. **Um port espera o app**: a web porta a última versão lançada do app; uma versão ainda em beta espera em um branch.

### Decisões
Ainda não há arquivo de projeto nem a pasta `docs/adr/`; as escolhas estão no `README.md` (sem etapa de build e sem dependências, módulos ES puros; o service worker tenta a rede primeiro; uma versão de manutenção avulsa pode sair com correções sem esperar o app). A revisão mensal lista o arquivo de projeto que falta como pendência. As decisões correspondentes do app estão em [[quizapp-adrs]].

### Requisitos
Ainda não há lista de requisitos. O comportamento é fixado pelos arquivos de teste em `tests/` (domínio, conteúdo, controlador, textos, regras de arquitetura, testes de caça a bugs) e pelos vetores de conformidade compartilhados com o app ([[quizweb-conformance]]).

### Portão de qualidade
O portão `tools/quality_gate.sh` tem dois passos: `npm test` (toda a suíte de testes web) e as verificações de aptidão do `pipeline-check`, que escrevem um relatório em `build/pipeline-check/report.json`.

### Integração contínua
Integração contínua (CI) significa verificações automáticas a cada push. O workflow `test.yml` roda o portão no GitHub a cada push e pull request ([[quizweb-ci]]); Node 22 e nenhuma outra dependência.

### Manutenção
A dívida técnica é registrada como issues do GitHub com o rótulo `debt` (P1 a P3), conforme a [[maintenance-policy]]. A [[monthly-architecture-review]] confere o projeto todo mês; a próxima vence em 2026-11-22.

## Notes

A publicação independente de manutenção de 2026-10-26 inclui a busca com eszett, o cálculo de progresso para meta zero e verificações na importação de backup. Sua chave de cache offline é `v12`. Correções de manutenção podem sair independentemente de outra versão Android; adaptações de recursos Android ainda não lançados continuam aguardando o lançamento do app. O GitHub protege `main` exigindo a verificação `test`, inclusive para administradores, e impede sobrescritas forçadas e exclusão do branch. O commit de manutenção passou nos 81 testes e na publicação pelo GitHub Pages.
