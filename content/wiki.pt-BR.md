---
id: wiki
lang: pt-BR
source_hash: cd94dada8617
title: Wiki (este site)
---

## What it is
Este site é um wiki: uma enciclopédia de todos os projetos, programas, skills e processos dos sistemas do Giovanni, com um mapa que mostra como eles se ligam. Cada assunto tem sua própria página, escrita para que um leitor que não sabe nada sobre o sistema nem sobre sua linguagem técnica consiga acompanhar. Uma palavra nova? Abra o [[glossary]], que explica os termos usados nas páginas. O repositório `yujideluca/wiki` é público (desde 2026-10-25), a pasta é `~/dev/wiki` e o projeto foi iniciado em 2026-10-22 a partir do [[project-template]].

## Flow
trigger t1: O Claude termina uma tarefa que mudou um sistema | [[end-of-task]]
step s1: Escreve páginas em Markdown, cada uma com um pequeno cabeçalho | [[wiki-content]]
step s2: wiki check aplica as regras de conteúdo | [[wiki-check]]
decide d1: As regras passam?
step s3: wiki build transforma as páginas em dados | [[wiki-build]]
step s4: Só content/ é commitado e enviado | [[github]]
step s5: O servidor serve o site: a conta Google do Giovanni entra, os demais veem uma isca | [[wiki-router]], [[decoy-page]]
trigger t2: Giovanni abre a wiki | [[giovanni]]
step s6: Busca, passa o mouse no mapa, clica num ponto | [[wiki-frontend]]
product p1: Publicação recusada, com a lista dos problemas
product p2: Uma página que responde à dúvida de arquitetura

t1 -> s1
s1 -> s2
s2 -> d1
d1 -não-> p1
d1 -sim-> s3
s3 -> s4
s4 -> s5
t2 -> s5
s5 -> s6
s6 -> p2

## Architecture
### Contexto
person g: Giovanni — lê as páginas no notebook ou no celular | [[giovanni]]
person c: Claude Code — escreve as páginas no fim de cada tarefa | [[claude-code]]
system w: Wiki — as páginas, o mapa e as verificações
external f: Tailscale Funnel — o endereço público na web | [[tailscale-funnel]]
external o: Login do Google — prova que é o Giovanni | [[google-oauth-client]]
external h: GitHub — guarda o histórico das páginas | [[github]]

g -abre-> f
f -repassa os pedidos para-> w
c -publica páginas no-> w
w -pergunta quem está lá-> o
w -envia as páginas ao-> h

### Contêineres
person g: Giovanni — no navegador | [[giovanni]]
person c: Claude Code — no fim de uma tarefa | [[claude-code]]
container fe: Front end em Elm — o mapa e os artigos | [[wiki-frontend]]
container sv: Servidor em Elixir — portão de login, página falsa, arquivos | [[wiki-server]]
container cli: O comando wiki — verificar, publicar, hook | [[wiki-cli]]
store pg: Páginas — arquivos Markdown em três idiomas | [[wiki-content]]
store st: Site gerado — os arquivos de dados que o front end lê | [[wiki-site]]
external o: Login do Google | [[google-oauth-client]]

g -usa-> fe
g -entra por meio do-> sv
fe -lê-> st
sv -entrega-> st
sv -pergunta ao-> o
c -executa-> cli
cli -lê e verifica-> pg
cli -gera-> st

## What it does
Permite ao Giovanni responder uma pergunta de arquitetura com uma busca e no máximo dois cliques: busca com sugestões enquanto digita, passar o mouse sobre um ponto do mapa para ver o que é em quatro caixas, clicar no ponto para a página completa ([[wiki-frontend]]). No celular o mapa ocupa a tela com uma barra de busca no alto e tocar em um ponto abre um balão com sua descrição; no desktop o mapa é visto por uma lente e seus pontos se esticam elasticamente quando arrastados ([[wiki-map-view]]). É mantido em dia automaticamente no fim de cada tarefa ([[end-of-task]]). Para o sistema inteiro numa página, comece por [[system-overview]].

## How it does it
O conteúdo são arquivos de texto Markdown, cada um com um pequeno cabeçalho ([[wiki-content]]); são verificados pelo [[wiki-check]] e transformados em dados JSON (JavaScript Object Notation) pelo [[wiki-build]]. A parte que se vê é escrita em Elm ([[wiki-frontend]]); o servidor é escrito em Elixir ([[wiki-server]]) e deixa entrar só uma conta Google, mostrando uma isca a todos os outros ([[wiki-router]], [[decoy-page]]). Na internet é alcançado pelo [[tailscale-funnel]]. Os idiomas são inglês, alemão e português do Brasil.

## Where it sits in the pipeline
Ao lado do [[workflow-memory]]: a memória guarda regras e preferências, enquanto o wiki descreve o que existe e como funciona, e aponta para entradas da memória em vez de copiá-las.

## Who receives its output
O [[giovanni]], no navegador do notebook ou do celular.

## Engineering practices
Como este projeto segue o caminho dourado do [[project-template]].

### Princípios
1. **Requisito, depois teste, depois código**: toda promessa é uma linha em `docs/REQUIREMENTS.md`, conferida pela verificação de rastreabilidade do portão.
2. **Negar por padrão**: sem a sessão Google verificada do Giovanni nada real é entregue; os testes do portão de login e da página falsa conferem isso.
3. **O conteúdo segue as regras antes de ser publicado**: `wiki check` recusa uma página ruim e `wiki publish` não roda com um problema.
4. **O portão decide**: `tools/quality_gate.sh` é a única definição de “passou”, e a integração contínua roda o mesmo script.
5. **As decisões ficam onde está o código**: uma linha no registro de decisões do `DESIGN.md` e, para as estruturais, um registro de decisão de arquitetura.

### Decisões
O arquivo de projeto `DESIGN.md` guarda os diagramas C4 e um registro de decisões, a mais nova primeiro, cada linha com seu tipo de manutenção. Registros de decisão de arquitetura (notas curtas que guardam os motivos de uma decisão) em `docs/adr/`: 0002 front end em Elm e back end em Elixir; 0003 um portão de login com página falsa para todos os outros; 0004 páginas em Markdown com cabeçalho, verificadas antes de publicar; 0005 um programa mede e uma skill julga; 0006 o horário da revisão fica na página; 0007 a seção de fluxograma. Veja também a [[monthly-architecture-review]].

### Requisitos
71 requisitos em `docs/REQUIREMENTS.md`, agrupados por um prefixo de duas letras (login AU, página falsa DC, conteúdo CO, fluxogramas FL, páginas de projeto PJ, mapa MP, layout de celular MB e outros). Cada um tem um teste marcado `REQ <ID>`, e a verificação de rastreabilidade ([[check-traceability]]) falha quando algum não tem.

### Portão de qualidade
O [[wiki-quality-gate]] é um script com cinco passos: os testes de Elixir; os testes de Elm e o build otimizado; a rastreabilidade dos requisitos; as regras de conteúdo (`wiki check`); as funções de aptidão (maior arquivo, tempo do portão, tamanho do pacote).

### Integração contínua
Integração contínua (CI) significa verificações automáticas a cada push. O workflow `quality-gate.yml` no GitHub instala Erlang, Elixir, Node e Elm e roda o portão por meio do `pipeline-check` a cada push e pull request. Um commit só chega à `main` depois que o portão está verde nesse mesmo commit.

### Manutenção
A dívida técnica é registrada como issues do GitHub com o rótulo `debt` (P1 a P3), conforme a [[maintenance-policy]]. A [[monthly-architecture-review]] confere o projeto todo mês; a próxima vence em 2026-11-22.
