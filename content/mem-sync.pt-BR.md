---
id: mem-sync
lang: pt-BR
source_hash: c28cf962daf0
title: mem sync (pull e push)
---

## What it is
`mem sync` mantém a cópia do repositório da memória no notebook em dia com o GitHub. A cópia se chama clone; o original fica no GitHub.

## What it does
`pull` baixa a versão mais recente antes de a memória ser lida (no início de uma sessão). `push` envia os novos eventos depois de escritos (no hook Stop), com novas tentativas. Nunca mescla os arquivos derivados (as visões geradas), porque eles sempre podem ser regenerados.

## How it does it
Usa Git com limites de tempo. Antes de enviar, baixa as mudanças remotas e reaplica os commits locais sobre elas (rebase). Se houver conflito em um evento, informa `conflict after pull, nothing pushed:` e para antes de tentar um envio. Mantém os arquivos em conflito disponíveis para inspeção. Nunca faz force-push.

O teste de integração usa repositórios Git locais reais. Cria um evento compartilhado datado de 2001 antes de um novo evento datado de 2000 e seleciona o novo pelo caminho impresso por `mem add`. Essas datas fixas detectam a seleção pela ordem dos arquivos sem depender do relógio. O teste exige a mensagem de conflito, a referência do histórico remoto inalterada, nenhuma tentativa de envio e um arquivo de evento não resolvido. As chamadas ao Git são registradas e encaminhadas ao programa real; seus resultados não são simulados.

## Where it sits in the pipeline
Entre o clone local e o [[github]].

## Who receives its output
O [[github]] e o [[hook-session-start]].
