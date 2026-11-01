---
id: wiki-stale
lang: pt-BR
source_hash: daea1f943729
title: wiki stale (páginas atrás de suas fontes)
---

## What it is
`wiki stale` é o comando que lista as páginas da wiki que podem estar desatualizadas porque um arquivo que elas descrevem mudou depois que a página foi comparada com ele pela última vez. É um dos comandos do [[wiki-cli]] e divide o arquivo de código com o hook Stop ([[wiki-hook-stop]]), mas faz outra pergunta.

## What it does
Cada página registra no campo `reviewed` do cabeçalho quando foi comparada com suas fontes pela última vez: data e minuto em UTC (tempo universal coordenado, o mesmo horário em qualquer lugar), como `2026-10-24T18:30Z`, ou só uma data, que significa o início desse dia. Para cada página com fontes, o comando olha cada arquivo ou pasta citado em `sources` (escrito `repo:path`). Se algum deles mudou depois do horário de `reviewed`, a página é listada com a fonte mais recente e os dois horários, por exemplo `quizapp: QuizApp:DESIGN.md changed 2026-10-24 16:43 UTC, after the review of 2026-10-22 16:33 UTC`. Uma página com fontes e sem `reviewed` utilizável é listada como nunca comparada. Quando não há nada a listar, imprime "no stale pages" e sai com 0; caso contrário sai com 1, para que um script possa testar o resultado (requisitos ST-1, ST-2 e ST-3).

## How it does it
Para uma fonte dentro de um repositório git (git é a ferramenta que guarda cada mudança como um commit), "mudou" significa o horário do último commit que toca o arquivo ou a pasta. Para uma fonte fora do git, como uma skill ou um script na pasta pessoal, significa o horário de modificação mais recente do arquivo, ou da pasta e de tudo o que está dentro dela. Os commits do próprio arquivo da página nunca são usados: reescrever muitas páginas, corrigir uma tradução ou publicar, por si só, não comprova revisão. Só quem de fato comparou a página com suas fontes define um novo horário de `reviewed`, e isso tira a página da lista.

A primeira versão comparava o horário do último commit da fonte com o do último commit do arquivo da página. Em 2026-10-24 um commit reescreveu as 154 páginas, então essa versão não listava nada enquanto 38 das 140 páginas com fontes tinham uma mudança de fonte que ninguém conferiu, e ela nunca podia listar as 34 páginas cujas fontes estão fora do git. O registro de decisão `docs/adr/0006-review-time-in-the-page.md` explica a mudança.

O comando olha o horário, não o que a página diz: uma mudança numa fonte que a página não descreve ainda deixa a página listada até alguém revisá-la. Uma revisão em um dado minuto cobre esse minuto inteiro, então uma mudança nesse minuto não é vista; também não são vistas edições ainda não commitadas em um repositório, nem um arquivo novo que nenhuma página cita (quem vigia arquivos novos é o hook Stop).

Desde 2026-11-01 (ADR-0009, um registro de decisão de arquitetura: uma nota curta que guarda as razões de uma decisão) três regras exatas, sem prazo de tolerância, cobrem fontes que vivem no repositório da própria wiki. Uma página que lista o próprio arquivo como fonte não é listada por isso. Uma fonte que é ela mesma uma página da wiki só conta como alterada quando mais do que as linhas `reviewed` ou `since` mudou. E, como o horário da revisão é digitado antes do commit que o carrega, uma fonte cujo texto foi alterado pelo mesmo commit que por último definiu a linha `reviewed` da página está coberta; uma fonte alterada por qualquer outro commit, mesmo um minuto depois da revisão, mantém a página na lista até ser comparada de novo. O `wiki publish` também confere cada linha `reviewed` que vai enviar: se uma fonte que já existia é mais nova que a revisão, ele recusa, nomeia a página e a fonte e não envia nada (requisitos ST-4, ST-5 e ST-6).

## Where it sits in the pipeline
Uma verificação manual, rodada por um assistente no início e no fim do trabalho de [[skill-wiki-page-writer]] e sempre que o Giovanni quer saber quanto a wiki está atrás do código.

## Who receives its output
Quem o rodou (um assistente ou Giovanni), pelo [[wiki-cli]].

## Notes
A auditoria de 2026-11-01 encontrou tanto revisões esquecidas quanto falsos avisos de desatualização. Uma marca de publicação compartilhada podia esconder pendências de outra sessão, e a publicação não validava novas declarações de revisão. Fontes que apontavam para a própria página, mudanças apenas de datas, estado ausente ou corrompido, cópias de trabalho vinculadas e mudanças no mesmo segundo exigiram tratamento separado. Nove páginas precisaram de correções no texto; seis correspondiam às fontes e precisavam registrar a revisão. As evidências e a conciliação estão em `docs/2026-11-01-wiki-stale-audit.md`.

As alterações de fonte do verificador, da visualização de fluxos, do validador da memória e das ferramentas de progresso têm Claude Sonnet 5.5 como coautor (`3c12c76`, `12b5342`, `6a57d87`, `f2b0389` nos respectivos repositórios). Isso identifica commits de fonte associados ao assistente, não todas as sessões posteriores. Esta conversa do Codex também confirmou sua própria falta de verificação final após `5b3ff90`. Configuração sem versionamento não permite atribuir com segurança a sessão exata; o autor configurado no Git não prova uma ação pessoal de Giovanni.

Em uma cópia de trabalho isolada, fontes `wiki:` são resolvidas por `WIKI_ROOT`, a pasta que está sendo verificada e publicada. Outras fontes continuam usando a raiz de desenvolvimento declarada. Assim arquivos de fonte novos podem ser verificados antes de chegar à cópia principal. Remover uma fonte válida apenas para passar na verificação não é a correção. Arquivos de estado usam nomes temporários com identidade do processo e contador da execução antes da renomeação atômica (troca do destino em uma única operação do sistema de arquivos); processos independentes dos assistentes não colidem.
