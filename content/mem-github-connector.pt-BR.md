---
id: mem-github-connector
lang: pt-BR
source_hash: 7de72cda1769
title: Escrevendo na memória pelo app Claude
---

## What it is
O [[claude-app]] não consegue executar programas, então não pode usar o comando `mem`. Esta página explica como ele mesmo assim lê e escreve a memória compartilhada: pelo conector do GitHub, um complemento que dá ao app ferramentas para ler e escrever arquivos em repositórios do GitHub.

## Flow
trigger t1: Um chat começa no app Claude | [[claude-app]]
step s1: O ponteiro nas configurações do claude.ai manda carregar as ferramentas do GitHub | [[claude-ai-settings-pointer]]
step s2: Lê views/BRIEF.md do workflow-memory, branch main | [[memory-views]]
trigger t2: Giovanni dá uma correção no chat | [[giovanni]]
step s3: Cria um arquivo de evento em events/, no formato do fim do resumo | [[events-log]]
step s4: O push dispara uma ação que valida o arquivo e refaz as visões | [[mem-action]], [[mem-validator]]
step s5: A próxima sessão do Claude Code baixa as novas visões | [[hook-session-start]]
product p1: Um chat que conhece as preferências fixas do Giovanni
product p2: Visões da memória refeitas | [[memory-views]]
product p3: A correção no próximo resumo do Claude Code | [[session-brief]]

t1 -> s1
s1 -> s2
s2 -> p1
t2 -> s3
s3 -> s4
s4 -> p2
s4 -> s5
s5 -> p3

## What it does
No início de cada conversa lê `views/BRIEF.md`; quando o Giovanni o corrige, registra a correção criando um novo arquivo de evento.

## How it does it
As ferramentas do GitHub ficam "adiadas" (deferred) no app, ou seja, precisam ser carregadas pelo nome antes de poder ser usadas; o texto-ponteiro nas configurações do app ([[claude-ai-settings-pointer]]) manda fazer isso. Depois ele segue o passo a passo impresso no fim do BRIEF.md. Foi testado no app do celular, em conversas simples e em conversas de projeto.

## Where it sits in the pipeline
O lado do app Claude no [[workflow-memory]].

## Who receives its output
[[events-log]].

## Steps
1. A conversa começa; o ponteiro nas configurações do claude.ai ([[claude-ai-settings-pointer]]) manda carregar as ferramentas do GitHub.
2. Lê `views/BRIEF.md` de `yujideluca/workflow-memory` (branch main) — veja [[memory-views]].
3. O Giovanni faz uma correção; a conversa cria um arquivo de evento em `events/` no formato descrito no fim do brief ([[events-log]]).
4. O push dispara o [[mem-action]], que valida o arquivo ([[mem-validator]]) e reconstrói o [[memory-views]].
5. A próxima sessão do Claude Code o baixa e o mostra no seu brief ([[hook-session-start]]).
