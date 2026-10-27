---
id: workflow-memory
lang: pt-BR
source_hash: 1bbd85413101
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

## What it does
Guarda preferências, fatos, decisões e pendências (coisas ainda por fazer) e mostra as relevantes no início de toda conversa como o [[session-brief]]. É o único canal entre as diferentes instâncias do Claude ([[claude-code]], o [[remote-assistant]] e o [[claude-app]]); é a decisão ADR-0003 em [[memory-adrs]] (uma ADR, "architecture decision record", é uma nota curta que registra uma decisão e seus motivos).

## How it does it
A memória é um registro (log): cada entrada é um arquivo novo que nunca mais é editado, guardado em [[events-log]]. Uma função, o [[memory-fold]], lê o registro inteiro e calcula o estado atual (em cada assunto vale a decisão mais recente). Uma GitHub Action ([[mem-action]], uma tarefa automática no GitHub) regenera os arquivos legíveis em [[memory-views]]. O Claude Code escreve com o comando [[mem]] e com três hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); o app Claude escreve por [[mem-github-connector]]. Tudo é escrito em Python simples (só a biblioteca padrão) e o [[mem-validator]] mantém segredos e dados de contato de outras pessoas de fora.

## Where it sits in the pipeline
Sob todos os outros projetos: eles leem seus padrões daqui e informam de volta com `mem use`.

## Who receives its output
Toda instância do Claude, pelo brief; o [[giovanni]], pelo arquivo de revisão em [[memory-views]].
