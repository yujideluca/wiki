---
id: skill-browser-automacao-segura
lang: pt-BR
source_hash: 4b327b0609e6
title: Skill: browser-automacao-segura (automação de navegador segura)
---

## What it is
A skill "browser-automacao-segura" ("automação de navegador segura") guarda as regras de segurança para qualquer ação em um navegador (o navegador embutido do app ou o Claude in Chrome), especialmente ações em lote, remoções, edições em massa e scripts em páginas. É escrita em português. Sua descrição diz: usar sempre que for executar ações em qualquer navegador, especialmente ações em lote, remoções, edições em massa e scripts JavaScript em páginas.

## What it does
Evita diálogos que travam a sessão, laços sobrepostos e erros destrutivos, e pergunta antes de qualquer coisa irreversível. Para a mecânica dos cliques remete à [[skill-click-protocol]], e para reduzir cliques de aprovação à [[skill-minimize-site-approvals]]; onde discordam, as regras de segurança desta skill prevalecem.

## How it does it
Um `SKILL.md` em `~/.claude/skills/browser-automacao-segura`; o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
Antes e durante qualquer automação de navegador.

## Who receives its output
A sessão do navegador; a [[skill-click-protocol]] e a [[skill-minimize-site-approvals]] remetem a ela para alertas e ações destrutivas.

## Steps
Por que importa: um diálogo nativo `alert()` aberto bloqueia TODAS as ferramentas do navegador (captura de tela, JavaScript, cliques) até alguém clicar em OK. Costuma surgir quando duas ações concorrentes atingem o mesmo item (por exemplo dois laços clicando em "remover" na mesma linha e o servidor recusando o segundo). Uma armadilha conhecida: quando o `javascript_tool` falha por tempo esgotado, o script continua rodando na página, e iniciar outro laço cria uma execução paralela.
1. **Nunca rodar laços sobrepostos** na mesma página. Antes de iniciar um novo laço, parar o anterior (uma flag como `window.stopRem = true`) e confirmar que terminou.
2. **Sequencial e com espera real.** Depois de cada ação, esperar o efeito acontecer (por exemplo a linha sumir da página) em vez de um intervalo fixo. Pular itens em processamento (sem botão de ação ou com spinner).
3. **Neutralizar alertas antes de ações em lote** e registrá-los para leitura posterior: `window.alertLog = []; window.alert = m => window.alertLog.push(String(m));`. Não sobrescrever `confirm` para retornar `true` automaticamente, pois isso pode aprovar ações destrutivas não pedidas; se um `confirm` for esperado para a ação que o usuário pediu, tratá-lo pontualmente.
4. **Laços longos em segundo plano.** Iniciar com uma função assíncrona de execução imediata sem `await` no topo, que retorna na hora, e consultar o progresso em chamadas separadas; o laço confere a flag de parada a cada volta, clica no próximo item que tem botão ativo e espera (até cerca de 10 segundos) a linha sumir antes do seguinte.
5. **Se um alerta já estiver aberto**, as ferramentas falham. Tentar Return uma vez; se continuar bloqueado, pedir ao usuário que clique em OK e explicar o motivo. Depois parar os laços (`window.stopRem = true`) e instalar a substituição do alert.
6. **Verificar no fim recarregando a página** e contando de novo; a página local pode não refletir o servidor. Ler `window.alertLog` para ver os erros ocorridos.
7. **Ações destrutivas** (remover, enviar, comprar) só a pedido explícito do usuário. Testar em um item primeiro, conferir o resultado e só então rodar o lote.
