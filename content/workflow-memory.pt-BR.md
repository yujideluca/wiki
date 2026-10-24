---
id: workflow-memory
lang: pt-BR
source_hash: 7c137c5a7ace
title: workflow-memory (memória compartilhada)
---

## What it is
O workflow-memory é a memória compartilhada e duradoura de todos os assistentes Claude que o Giovanni usa. Uma conversa do Claude normalmente esquece tudo quando termina; este projeto faz com que uma preferência dita uma vez ("responda no idioma em que eu escrevi") ainda valha meses depois, em outra conversa, em outro aparelho. É um repositório privado (`yujideluca/workflow-memory`) e fica em `~/dev/workflow-memory`. Substituiu o protocolo desativado descrito em [[retired-workflow-pipeline]].

## What it does
Guarda preferências, fatos, decisões e pendências (coisas ainda por fazer) e mostra as relevantes no início de toda conversa como o [[session-brief]]. É o único canal entre as diferentes instâncias do Claude ([[claude-code]], o [[remote-assistant]] e o [[claude-app]]); é a decisão ADR-0003 em [[memory-adrs]] (uma ADR, "architecture decision record", é uma nota curta que registra uma decisão e seus motivos).

## How it does it
A memória é um registro (log): cada entrada é um arquivo novo que nunca mais é editado, guardado em [[events-log]]. Uma função, o [[memory-fold]], lê o registro inteiro e calcula o estado atual (em cada assunto vale a decisão mais recente). Uma GitHub Action ([[mem-action]], uma tarefa automática no GitHub) regenera os arquivos legíveis em [[memory-views]]. O Claude Code escreve com o comando [[mem]] e com três hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); o app Claude escreve por [[mem-github-connector]]. Tudo é escrito em Python simples (só a biblioteca padrão) e o [[mem-validator]] mantém segredos e dados de contato de outras pessoas de fora.

## Where it sits in the pipeline
Sob todos os outros projetos: eles leem seus padrões daqui e informam de volta com `mem use`.

## Who receives its output
Toda instância do Claude, pelo brief; o [[giovanni]], pelo arquivo de revisão em [[memory-views]].
