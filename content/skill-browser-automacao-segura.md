---
id: skill-browser-automacao-segura
title: Skill: browser-automacao-segura (safe browser automation)
aliases: [browser-automacao-segura]
kind: skill
project: skills
status: active
location: home:.claude/skills/browser-automacao-segura
fed_by: []
feeds: []
sources: [home:.claude/skills/browser-automacao-segura/SKILL.md, home:.agents/skills/browser-automacao-segura/SKILL.md]
reviewed: 2026-10-25T14:46Z
---

## What it is
The skill "browser-automacao-segura" ("safe browser automation") holds the safety rules for any action in a web browser (the app's built-in browser or Claude in Chrome), especially batch actions, removals, mass edits and scripts on pages. It is written in Portuguese. Its description says: use it always when executing actions in any browser, especially batch actions, removals, mass edits and JavaScript scripts on pages.

## What it does
It prevents dialogs that freeze the session, overlapping loops and destructive mistakes, and it asks before anything irreversible. For the mechanics of clicking it defers to [[skill-click-protocol]], and for reducing approval clicks to [[skill-minimize-site-approvals]]; where they disagree, the safety rules of this skill win.

## How it does it
A `SKILL.md` in `~/.claude/skills/browser-automacao-segura`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Before and during any browser automation.

## Who receives its output
The browser session; [[skill-click-protocol]] and [[skill-minimize-site-approvals]] defer to it for alerts and destructive actions.

## Steps
Why it matters: a native `alert()` dialog that is open blocks all browser tools (screenshot, JavaScript, clicks) until someone clicks OK. It often appears when two concurrent actions hit the same item (for example two loops clicking "remove" on the same row and the server refusing the second). A known trap: when the `javascript_tool` fails by timeout, the script keeps running on the page, and starting another loop creates a parallel run.
1. **Never run overlapping loops** on the same page. Before starting a new loop, stop the previous one (a flag such as `window.stopRem = true`) and confirm it finished.
2. **Sequential, with real waiting.** After each action, wait for the effect to happen (for example the row disappearing from the page) instead of a fixed interval. Skip items that are being processed (no action button, or a spinner).
3. **Neutralise alerts before batch actions** and log them for later reading: `window.alertLog = []; window.alert = m => window.alertLog.push(String(m));`. Do not override `confirm` to return `true` automatically, since that could approve destructive actions nobody asked for; if a `confirm` is expected for the action the user asked, handle it individually.
4. **Long loops in the background.** Start them with an asynchronous immediately-invoked function without `await` at the top, which returns at once, and check progress in separate calls; the loop checks the stop flag each round, clicks the next item that has an active button, and waits (up to about 10 seconds) until its row is gone before the next.
5. **If an alert is already open**, the tools fail. Try pressing Return once; if still blocked, ask the user to click OK and explain why. Then stop loops (`window.stopRem = true`) and install the alert override.
6. **Verify at the end by reloading the page** and counting again; the local page may not reflect the server. Read `window.alertLog` to see the errors that occurred.
7. **Destructive actions** (remove, send, buy) only on the user's explicit request. Test on one item first, check the result and only then run the batch.

## Notes

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

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

````skill-source home:.agents/skills/browser-automacao-segura/SKILL.md 81b21c5cd2f78261a2302ff4d2957e38675f187359b836248c49b7b87d6a0b21
---
name: "browser-automacao-segura"
description: "Use sempre que for executar ações em qualquer navegador (navegador embutido do app ou Codex in Chrome), especialmente ações em lote, remoções, edições em massa ou scripts JS em páginas."
---

# Automação de navegador segura

Lineage: origin=gui; base=5b02179bdeb6f1c75930350dbdd74cf0992d71eb

Objetivo: evitar que alertas/diálogos do site (alert, confirm) ou ações sobrepostas travem a tarefa. Vale para os dois navegadores (embutido e Codex in Chrome); para reduzir cliques de aprovação de sites, veja também a skill minimize-site-approvals. Para a mecânica dos cliques (refs, verificação a cada passo, menus, diálogos, players de mídia), siga também a skill click-protocol; as regras de segurança abaixo prevalecem.

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
