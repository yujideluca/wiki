---
id: workflow-memory
lang: pt-BR
source_hash: ef53006f253a
title: workflow-memory (memória compartilhada)
---

## What it is
O workflow-memory é a memória compartilhada e duradoura de todos os assistentes Claude que o Giovanni usa. Uma conversa do Claude normalmente esquece tudo quando termina; este projeto faz com que uma preferência dita uma vez ("responda no idioma em que eu escrevi") ainda valha meses depois, em outra conversa, em outro aparelho. É um repositório público (`yujideluca/workflow-memory`, desde 2026-10-25) e fica em `~/dev/workflow-memory`. Não tem proteção de branch de propósito: sua tarefa `mem` envia arquivos derivados para o `main` e uma verificação obrigatória os rejeitaria, então a verificação local antes do push faz esse papel e o `pipeline-check.toml` registra a exceção ([[maintenance-pipeline]]). Substituiu o protocolo desativado descrito em [[retired-workflow-pipeline]].

## Flow
trigger t1: Giovanni declara uma correção ou preferência duradoura | [[giovanni]]
step s1: O Claude Code grava com o mem; o app Claude grava pelo conector | [[mem]], [[mem-github-connector]]
step s2: Um arquivo novo entra no log e nunca mais é editado | [[events-log]]
step s3: Uma ação do GitHub valida o arquivo e refaz as visões legíveis | [[mem-action]], [[memory-views]]
step s4: memory-fold lê o log e calcula o estado atual, a decisão mais recente vence | [[memory-fold]]
trigger t2: Um novo chat começa | [[claude-code]]
step s5: O hook de início imprime o resumo | [[hook-session-start]], [[session-brief]]
product p1: Toda instância do Claude segue a preferência em chats futuros
product p2: Um arquivo de revisão esperando o Giovanni | [[memory-views]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s3 -> p2
s4 -> s5
t2 -> s5
s5 -> p1

## Architecture
### Contexto
person g: Giovanni — diz preferências e correções | [[giovanni]]
external c: Claude Code — lê o resumo, escreve eventos | [[claude-code]]
external x: Codex — o mesmo, com seu próprio escopo de memória | [[codex]]
system w: workflow-memory — a memória compartilhada dos sistemas do Giovanni
external h: GitHub — roda as verificações e guarda o histórico | [[github]]

g -diz ao-> c
g -diz ao-> x
c -escreve eventos no e lê o resumo do-> w
x -escreve eventos no e lê o resumo do-> w
w -é conferido e reconstruído no-> h

### Contêineres
person g: Giovanni | [[giovanni]]
external c: Claude Code | [[claude-code]]
container hk: Hook de início de conversa — imprime o resumo | [[hook-session-start]]
container m: Comando mem — adiciona eventos, dobra-os, busca | [[mem]]
store ev: Registro de eventos — um arquivo por evento, só acrescenta | [[events-log]]
store vw: Visões — resumos derivados, nunca editados à mão | [[memory-views]]
container ci: Job do GitHub — reconstrói as visões, recusa edições em eventos antigos | [[mem-action]]

g -diz ao-> c
c -inicia o-> hk
c -executa o-> m
hk -pede o resumo ao-> m
m -acrescenta ao-> ev
m -reconstrói as-> vw
ci -confere o-> ev
ci -reconstrói as-> vw

## What it does
Guarda preferências, fatos, decisões e pendências (coisas ainda por fazer) e mostra as relevantes no início de toda conversa como o [[session-brief]]. É o único canal entre as diferentes instâncias do Claude ([[claude-code]], o [[remote-assistant]] e o [[claude-app]]); é a decisão ADR-0003 em [[memory-adrs]] (uma ADR, "architecture decision record", é uma nota curta que registra uma decisão e seus motivos).

## How it does it
A memória é um registro (log): cada entrada é um arquivo novo que nunca mais é editado, guardado em [[events-log]]. Uma função, o [[memory-fold]], lê o registro inteiro e calcula o estado atual (em cada assunto vale a decisão mais recente). Uma GitHub Action ([[mem-action]], uma tarefa automática no GitHub) regenera os arquivos legíveis em [[memory-views]]. O Claude Code escreve com o comando [[mem]] e com três hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); o app Claude escreve por [[mem-github-connector]]. Tudo é escrito em Python simples (só a biblioteca padrão) e o [[mem-validator]] mantém segredos e dados de contato de outras pessoas de fora.

## Where it sits in the pipeline
Sob todos os outros projetos: eles leem seus padrões daqui e informam de volta com `mem use`.

## Who receives its output
Toda instância do Claude, pelo brief; o [[giovanni]], pelo arquivo de revisão em [[memory-views]].

## Engineering practices
Como este projeto segue o caminho dourado do [[project-template]].

### Princípios
1. **Eventos só são acrescentados**: um job de integração contínua recusa a mudança de um arquivo de evento antigo.
2. **As visões são derivadas**: um teste falha quando uma visão foi editada à mão, e as visões são reconstruídas a cada push.
3. **A ordem de entrega nunca importa**: testes conferem que dobrar o registro dá o mesmo resultado em qualquer ordem.
4. **As palavras do próprio Giovanni valem mais que o coletor**: um teste confere que uma entrada automática nunca reescreve uma delas.
5. **Sem segredos nem dados de contato**: um teste de privacidade confere a fronteira, e um evento inválido vai para a quarentena.
6. **Este repositório é a única interface entre as instâncias do Claude**: nenhum protocolo novo.

### Decisões
Cinco registros de decisão de arquitetura (notas curtas que guardam os motivos de uma decisão) em `docs/adr/`, [[memory-adrs]]: 0002 um registro de eventos só de acréscimo, dobrado por uma função pura, em vez de um protocolo; 0003 os papéis do Giovanni e das instâncias do Claude; 0004 um programa mede e uma skill julga; 0005 enxugar o resumo de início e separar a memória por ferramenta. O projeto, as regras da dobra e os limites conhecidos estão em `docs/DESIGN.md` (ainda não há um `DESIGN.md` na raiz com registro de decisões).

### Requisitos
Não há lista de requisitos. Os princípios acima são fixados por testes nomeados em `tests/` (por exemplo os testes de independência de ordem, de privacidade e do coletor), executados pelo portão.

### Portão de qualidade
O portão tem dois passos: os testes unitários da memória (`python3 -m unittest discover`) e as verificações de aptidão do `pipeline-check`.

### Integração contínua
Integração contínua (CI) significa verificações automáticas a cada push. Dois workflows rodam no GitHub: `quality-gate.yml` roda o portão, e `mem.yml` confere que os eventos só são acrescentados e que as visões são reconstruídas ([[mem-action]]). Este repositório não tem proteção de branch de propósito: seu job envia os arquivos derivados para a `main`.

### Manutenção
A dívida técnica é registrada como issues do GitHub com o rótulo `debt` (P1 a P3), conforme a [[maintenance-policy]]. A [[monthly-architecture-review]] confere o projeto todo mês; a próxima vence em 2026-11-22.
