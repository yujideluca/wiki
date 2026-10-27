---
id: skill-browser-automacao-segura
lang: pt-BR
source_hash: 9208c8496d7c
title: Skill: browser-automacao-segura (automação de navegador segura)
---

## What it is
A skill "browser-automacao-segura" ("automação de navegador segura") guarda as regras de segurança para qualquer ação em um navegador (o navegador embutido do app ou o Claude in Chrome), especialmente ações em lote, remoções, edições em massa e scripts em páginas. É escrita em português. Sua descrição diz: usar sempre que for executar ações em qualquer navegador, especialmente ações em lote, remoções, edições em massa e scripts JavaScript em páginas.

## Flow
trigger t1: Qualquer ação num navegador, em especial ações em lote, remoções, edições em massa ou scripts de página
trigger t2: Um alerta já está aberto
step s1: Neutraliza alertas antes de um lote e os registra para ler depois
step s2: Roda um laço por vez e espera o efeito real após cada ação | [[skill-click-protocol]]
decide d1: A ação é destrutiva ou irreversível?
step s3: Pergunta ao Giovanni antes de agir | [[giovanni]]
step s4: Laços longos rodam em segundo plano e têm o progresso conferido
step s5: Para o laço anterior e limpa o alerta aberto
step s6: Recarrega a página para verificar o estado final
product p1: Um resultado verificado na página
product p2: Nenhuma sessão travada e nada destrutivo sem um sim

t1 -> s1
s1 -> s2
s2 -> d1
d1 -sim-> s3
d1 -não-> s4
s3 -> s4
s4 -> s6
t2 -> s5
s5 -> s6
s6 -> p1
s3 -> p2

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

## Notes

O Codex agora usa a versão mantida separadamente em [[codex-skills]]. A fonte completa abaixo contém as regras de execução do Codex; o procedimento Claude acima continua sendo a versão Claude. Navegador, memória e conexões podem funcionar de formas diferentes.

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/browser-automacao-segura/SKILL.md`

````skill-source home:.claude/skills/browser-automacao-segura/SKILL.md b7af9b1c5de7150838245fff92b0c66952fe5162e7cea162b7050b067b300132
---
name: "browser-automacao-segura"
description: "Use sempre que for executar ações em qualquer navegador (navegador embutido do app ou Claude in Chrome), especialmente ações em lote, remoções, edições em massa ou scripts JS em páginas."
---

# Automação de navegador segura

Lineage: origin=gui; base=5b02179bdeb6f1c75930350dbdd74cf0992d71eb

Objetivo: evitar que alertas/diálogos do site (alert, confirm) ou ações sobrepostas travem a tarefa. Vale para os dois navegadores (embutido e Claude in Chrome); para reduzir cliques de aprovação de sites, veja também a skill minimize-site-approvals. Para a mecânica dos cliques (refs, verificação a cada passo, menus, diálogos, players de mídia), siga também a skill click-protocol; as regras de segurança abaixo prevalecem.

## Por que isso importa
Um `alert()` nativo aberto bloqueia TODAS as ferramentas do navegador (screenshot, JS, cliques) até alguém clicar em OK. Ele costuma surgir quando duas ações concorrentes atingem o mesmo item (ex.: dois laços clicando em "remover" na mesma linha), e o servidor recusa a segunda.

Armadilha conhecida: quando o `javascript_tool` falha por tempo esgotado, o script **continua rodando na página**. Iniciar outro laço depois disso cria execução paralela.

## Regras
1. **Nunca rode laços sobrepostos** na mesma página. Antes de iniciar um novo laço, pare o anterior (flag `window.stopRem = true`) e confirme que terminou.
2. **Sequencial e com espera real**: após cada ação, espere o efeito acontecer (ex.: a linha sumir do DOM) em vez de um intervalo fixo. Pule itens em processamento (sem botão de ação / com spinner).
3. **Neutralize alertas antes de ações em lote** e registre-os para leitura posterior:
   ```js
   window.alertLog = [];
   window.alert = m => window.alertLog.push(String(m));
   ```
   Não sobrescreva `confirm` para retornar `true` automaticamente, pois isso pode aprovar ações destrutivas não pedidas. Se um `confirm` for esperado para a ação que o usuário pediu, trate-o pontualmente.
4. **Laços longos em segundo plano**: inicie com uma IIFE assíncrona sem `await` no topo, que retorna imediatamente, e consulte o progresso em chamadas separadas:
   ```js
   window.stopRem = false; window.doneRem = false;
   (async () => {
     for (let i = 0; i < 500 && !window.stopRem; i++) {
       const alvo = encontrarProximo();          // só itens com botão ativo
       if (!alvo) break;
       const linha = alvo.closest('tr');
       alvo.click();
       for (let t = 0; t < 40 && linha.isConnected; t++)  // espera a linha sumir (até ~10 s)
         await new Promise(r => setTimeout(r, 250));
     }
     window.doneRem = true;
   })(); 'iniciado'
   ```
5. **Se um alerta já estiver aberto**: as ferramentas falham. Tente `key Return` uma vez; se continuar bloqueado, peça ao usuário para clicar em OK e explique o motivo. Depois pare laços (`window.stopRem = true`) e instale o override de alert.
6. **Verifique no final recarregando a página** e contando de novo. O DOM local pode não refletir o servidor. Leia `window.alertLog` para ver erros ocorridos.
7. Ações destrutivas (remover, enviar, comprar) só com pedido explícito do usuário. Teste em 1 item primeiro, confira o resultado e só então rode o lote.
````


#### Codex: `home:.agents/skills/browser-automacao-segura/SKILL.md`

````skill-source home:.agents/skills/browser-automacao-segura/SKILL.md 13853b38c3eb189733876aabe72c8b3f61570d474b84e6e10c42fc377a9201b9
---
name: browser-automacao-segura
description: "Use when controlling a browser in Codex, especially multi-step changes, batch edits, removals or page scripts."
---

# Safe browser automation

Lineage: origin=claude; base=sha256:93af23975c340f1b49850a522a06f32810163e27da6787527ab91f8dd12f740b; adaptation=codex

Interop: role = cross-cutting; owns = sequential browser actions and verified effects; defers to = host browser documentation, click-protocol (target selection), minimize-site-approvals (access), domain skills (format); honors = user language and existing authorization.

1. Prefer a connected service tool when it can complete the task. For browser control, initialize the actual browser tool exactly as documented, read its returned instructions, and use only the APIs it exposes. In the CUA REPL, the first call contains exactly one documented entrypoint.
2. Inspect the current page before acting. Use visible, uniquely identified controls and observed page state. Never infer selectors from memory of a previous site version.
3. One mutation at a time. After each action, read fresh state and verify the expected effect before continuing. Batch only independent reads. For a batch change, test one authorized item, verify it, then continue sequentially.
4. A timeout does not prove cancellation. Inspect whether the previous action finished; do not start a duplicate loop. Use only documented cancellation or dialog APIs. Do not replace page alert/confirmation handlers, auto-accept dialogs, inject detached loops, or use page JavaScript for hidden state, network calls, or mutations when the host does not permit it.
5. Handle an expected confirmation individually, within the user's authorization. If a native dialog blocks every available tool and there is no documented handler, explain the specific block and ask for that manual step.
6. End by reloading or revisiting the target and checking server-backed state, quantities and errors. Local page changes and toasts alone are insufficient proof.
7. Authorization persists within scope. Do not ask repeatedly for routine reversible work already requested; ask for an unapproved destructive action, purchase, message send or required technical permission. A skill cannot grant it.
````
