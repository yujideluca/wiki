---
id: skill-ligamagic-replicar-carrinho-nas-lojas
title: Skill: ligamagic-replicar-carrinho-nas-lojas
aliases: [ligamagic-replicar-carrinho-nas-lojas]
kind: skill
project: skills
status: active
location: home:.claude/skills/ligamagic-replicar-carrinho-nas-lojas
fed_by: [skill-ligamagic-listas]
feeds: []
sources: [home:.claude/skills/ligamagic-replicar-carrinho-nas-lojas/SKILL.md, home:.agents/skills/ligamagic-replicar-carrinho-nas-lojas/SKILL.md]
reviewed: 2026-10-25T20:41Z
---

## What it is
The skill "ligamagic-replicar-carrinho-nas-lojas" rebuilds LigaMagic's per-store cart on each store's own website and reconciles the two before checkout. It is written in Portuguese. Its description says: it redoes the per-store cart of LigaMagic on each store's own site (the same card, edition, language, condition, extras and quantity) and reconciles both before checkout; use it when Giovanni asks to check the LigaMagic carts and build or check them on the stores' sites, without using LigaMagic's links. It comes from a task on 12 October 2026 (5 stores, 90 items) and prevents the errors found then: a foil or promo item skipped when reading, stock read as quantity, a duplicate copy from a repeated click, a similar edition chosen instead of the right one, and a check done only by item count.

## Flow
trigger t1: Giovanni asks to check the LigaMagic carts and rebuild them on the stores' own sites | [[giovanni]]
step s1: Reads the LigaMagic cart, read-only: the expected list per store; asks for site access once | [[skill-minimize-site-approvals]]
step s2: Reads each store's own cart before touching it
step s3: Adds each item: search, buy button, correct quantity, one item at a time | [[skill-browser-automacao-segura]], [[skill-click-protocol]]
step s4: Reconciles the store's cart with the expected list
decide d1: Does the store's cart match?
step s5: Fixes the difference and reconciles again
step s6: Reports; it never logs in, pays or presses the cart's checkout button
product p1: A matching cart in each store, left for Giovanni to pay

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -yes-> s6
d1 -no-> s5
s5 -> s6
s6 -> p1

## What it does
It copies the same card, edition, language, condition, extras and quantity into each store's cart, without using LigaMagic's links; the purchases themselves need Giovanni's approval. Its role is "domain": it owns the flow from LigaMagic to the store, the scripts that read the per-store cart and the product page, the reconciliation and the final report; it defers to [[skill-ligamagic-listas]], to [[skill-browser-automacao-segura]] (alerts, loops, destructive actions: this one prevails), to [[skill-click-protocol]] (click mechanics) and to [[skill-minimize-site-approvals]] (domains).

## How it does it
A `SKILL.md` in `~/.claude/skills/ligamagic-replicar-carrinho-nas-lojas`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Giovanni's Magic: The Gathering hobby.

## Who receives its output
Giovanni, before paying.

## Steps
Fixed rules:
1. LigaMagic is read-only. Never click `.btn-circle.remove` (it removes the item or a whole store).
2. In the store: search, BUY (the product's "COMPRAR" button) and correct the quantity. Never log in, create an account, pay, fill forms or press the cart's "COMPRAR" button (checkout).
3. Items that were already in the store's cart stay (his default: keep and add). Ask only if he has not said.
4. Do not reach the stores through LigaMagic's links.
5. Before adding, install the alert log (rule 3 of [[skill-browser-automacao-segura]]). One item at a time; never two clicks without a check between them.
6. A short progress message every 5 items and at every store change.
7. `navigate` alone, outside batches. Batches of at most 4 harmless actions, ending in a check ([[skill-click-protocol]]).

Checklist (copy and tick): S1 read LigaMagic (script A) → the expected list E per store, list the domains and ask for access at once; S2 for each store read R0 (the cart before touching it); S3 add each item of E (script B + the choice rule); S4 reconcile the store until it passes; S5 report.

S1. **The LigaMagic cart** (`?view=mp/carrinho&open=1`). Script A (tested on 12 Oct 2026; 90 lines, 5 stores) reads, for each store block: the store name, the number of items in the header, the total, and for each row the card name (the English name after the last " / "), edition (from the edition icon's title), language, condition, extras (Foil, Promo, Pre-release, Textless, Etched, signed, altered, oversize), quantity (the quantity input), stock and subtotal. Validate before using: the header count equals the number of lines of each store and no edition, language or condition field is empty; if it fails (the site changed), read row by row from the page. Read the items in slices; the tool cuts long output and blocks URLs. "N unids." is STOCK, never quantity; quantity is the input's value. If a quantity is above 1, ask whether it is intended before copying it (an extra copy was once made by mistake). The shopping list (a table with selects) belongs to [[skill-ligamagic-listas]]; do not confuse it with the per-store cart. To find the store's website, click the store's name; confirmed domains: primemtg.com.br and tavernagamehouse.com.br.

S2. **R0 of the store.** Open `https://<store>/?view=ecom/carrinho` and read the page text: keep the lines, the subtotal and the `txt_qty_*` fields (inputs whose name starts with that). Without "Olá, <name>" at the top, the cart is a guest cart: warn at the end.

S3. **Adding one item.** (a) Direct search: `https://<store>/?view=ecom/itens&busca=<English name>`; one result opens the product; with several, art cards, "with signature" and tokens are other products, so open candidates until the edition is found. (b) Script B (product page; tested on Prime MTG, the same platform as the other stores) lists the purchasable rows with edition, language, condition, extras, stock and price; if no rows are found, hover over each row's edition icon and zoom in. (c) Choice rule (stop at the first filter that gives 1 row): rows with the same edition, language, condition and extras as LigaMagic → buy that one; plus equal stock and a final price equal to LigaMagic's unit price breaks ties; 0 rows → the variant is missing: do not substitute, record it. Stores use LigaMagic's system, so edition, language, stock and price come with the same text; similar editions are different rows (for example "FINAL FANTASY Commander (Extended Art)" is the right one and "FINAL FANTASY Commander" is another on the same page). (d) BUY on row i, one click only; for the first item of the session test the click by script, and if the cart counter does not rise, use `find` (the ref of that row's BUY) or, if `find` fails, scroll the row to the centre, take a screenshot and click the BUY of the central row; use whichever path worked for the rest of the store. (e) Expected change: the cart counter (the number next to the cart icon at the top right) rises by exactly 1; any other value → stop and read the cart before clicking again. Two failures on the same step → screenshot, report, ask.

S4. **Reconcile the store** (cheapest to most expensive; stop at the first that fails). (1) Counter (counts units) = units of R0 + sum of the quantities of E. (2) Cart subtotal = subtotal of R0 + LigaMagic's total. (3) The `txt_qty_*` of the new items = the quantities of E; a row subtotal different from the unit price reveals quantity 2. (4) If all is right, the store is done; otherwise compare by key `name | edition | language | condition | extras` (expected = R0 + E) and fix: missing → S3; extra quantity from this session → triple-click the field, type the value, Tab, click "Alterar", reload and check; a wrong row added in this session → ask before removing. (5) Reload and repeat until it passes; without a reload it is not checked.

S5. **Report** (in the language of Giovanni's message): a table of store | items | LigaMagic total | subtotal in the store; then only what applies: earlier items kept (and their value), a guest cart, missing variants, quantities above 1 coming from LigaMagic, a header mismatch explained. Say that it stopped before checkout. With `!!`: only the table and the caveats. With `***`: include the reconciliation by key for each store.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/ligamagic-replicar-carrinho-nas-lojas/SKILL.md`

````skill-source home:.claude/skills/ligamagic-replicar-carrinho-nas-lojas/SKILL.md 60a05b266877b38d5f46218c8665c3c8fcb90b0d516eedc4919cefbcf9ff1a7c
---
name: "ligamagic-replicar-carrinho-nas-lojas"
description: "Refaz o carrinho por loja da LigaMagic no site próprio de cada loja (mesma carta, edição, idioma, qualidade, extras e quantidade) e concilia os dois antes do checkout. Use quando o Giovanni pedir para conferir os carrinhos da LigaMagic e montá-los ou conferi-los nos sites das lojas, sem usar os links da Liga."
---

# Carrinho LigaMagic → sites das lojas

Lineage: origin=gui; base=d489ee85219ba7d7e9b4eaec3b69b34afc1470a3

Interop: role = domain; owns = fluxo Liga→loja, scripts de leitura do carrinho por loja e da página de produto, conciliação e relatório final; defers to = ligamagic-listas (Lista de Compras e Compra por Lista), browser-automacao-segura (alertas, laços, ações destrutivas: prevalece), click-protocol (mecânica de clique), minimize-site-approvals (domínios); honors = idioma da mensagem, flags !! *** ...

Origem: tarefa de 12/10/2026 (5 lojas, 90 itens). Erros que esta skill previne: item Foil/Promo pulado na leitura, estoque lido como quantidade, cópia duplicada por clique repetido, edição parecida escolhida no lugar da certa, conferência só pelo número de itens.

## Regras fixas
1. LigaMagic só leitura. Nunca clique em `.btn-circle.remove` (remove o item ou a loja inteira).
2. Na loja: buscar, COMPRAR e corrigir quantidade. Nada de login, conta, pagamento, formulário ou o botão COMPRAR do carrinho (checkout).
3. Itens que já estavam no carrinho da loja ficam (padrão dele: manter e acrescentar). Pergunte só se ele não tiver dito.
4. Não chegue às lojas pelos links da Liga.
5. Antes de adicionar, instale o registro de alertas (`browser-automacao-segura`, regra 3). Um item por vez; nunca dois cliques sem verificação entre eles.
6. Mensagem curta de progresso a cada 5 itens e a cada troca de loja.
7. `navigate` sozinho, fora de `browser_batch`. Lotes de no máximo 4 ações inofensivas, terminando em verificação (click-protocol).

## Checklist (copie e marque)
- [ ] S1 Ler a Liga (script A) → E por loja; listar domínios e pedir acesso de uma vez
- [ ] S2 Para cada loja: ler R0 (carrinho antes de mexer)
- [ ] S3 Adicionar cada item de E (script B + regra de escolha)
- [ ] S4 Conciliar a loja até passar
- [ ] S5 Relatório

## S1. Carrinho da Liga (?view=mp/carrinho&open=1)
Script A (testado em 12/10/2026; 90 linhas, 5 lojas):
```js
(()=>{const t=e=>e?e.innerText.replace(/\s+/g,' ').trim():'';
window.LM=[...document.querySelectorAll('.pad-bot-10')].filter(b=>b.querySelector('input.qty')).map(b=>{const f=t(b.querySelector('.footer'));return {loja:t(b.querySelector('.loja-titulo')),hdr:+(f.match(/(\d+) itens?/)||[])[1],total:(f.match(/Valor Total:.*?(R\$ [\d.,]+)\s*(R\$ [\d.,]+)\s*(R\$ [\d.,]+)/)||[])[3]||'',
itens:[...b.querySelectorAll('input.qty')].map(q=>{const r=q.closest('div.row');const a=[...r.querySelectorAll('table.listasimples td')].map(td=>(td.querySelector('img')||{}).title||t(td)).filter(x=>x&&x.length<40);
return {nome:t(r.querySelector('a.pretoG')).split(' / ').pop(),ed:(r.querySelector('img.icon-edicao')||{}).title||'',lang:a.find(x=>/Portugu|Ingl|Japon|Alem|Espanh|Franc|Italian|Russ|Chin|Corean/.test(x))||'',qual:a.find(x=>/^(M|NM|SP|MP|HP|D)$/.test(x))||'',extras:a.filter(x=>/^(Foil|Promo|Pre-?release|Textless|Etched|Assinad|Alterad|Oversize)/i.test(x)).join(','),qty:+q.value,est:(t(r).match(/(\d+) unids?\./)||[])[1]||'',sub:t(r.querySelector('.item-total'))}})}});
return LM.map(s=>s.loja+' | hdr '+s.hdr+' | linhas '+s.itens.length+' | soma '+s.itens.reduce((x,i)=>x+i.qty,0)+' | '+s.total).join('\n')})()
```
- Valide antes de usar: `hdr` = linhas de cada loja e nenhum campo `ed`, `lang` ou `qual` vazio. Se falhar (o site mudou), leia linha a linha pela página: `div.row` com `input.qty`, edição no `title` do ícone, Foil/Promo na própria linha.
- Leia os itens em fatias (`LM[k].itens.slice(0,12)`). O `javascript_tool` corta saídas longas e bloqueia URLs.
- "N unids." é ESTOQUE (`est`), nunca quantidade. Quantidade é `input.qty` (`qty`).
- `qty` > 1: pergunte se é intencional antes de replicar (já houve cópia extra por engano).
- Mesma página, outra estrutura: a "Lista de Compras" (tabela com selects) é da skill ligamagic-listas; não a confunda com o carrinho por loja.
- Site da loja: clique no nome da loja (`.loja-titulo`) e o link aparece. Domínios confirmados: primemtg.com.br, tavernagamehouse.com.br.

## S2. R0 da loja
`https://<loja>/?view=ecom/carrinho` + `get_page_text`: guarde linhas, subtotal e os campos `txt_qty_*` (JS: inputs cujo `name` começa com `txt_qty_`). Sem "Olá, <nome>" no topo: carrinho de visitante, avise no fim.

## S3. Adicionar um item
1. Busca direta: `https://<loja>/?view=ecom/itens&busca=<nome EN>`. Um resultado abre o produto. Vários: Art Card, "com assinatura" e tokens são outros produtos; abra candidatos até achar a edição.
2. Script B (página do produto; testado na Prime MTG, mesma plataforma das outras lojas):
```js
(()=>{const t=e=>e?e.innerText.replace(/\s+/g,' ').trim():'';
window.V=[...document.querySelectorAll('.table-cards-body .table-cards-row')].map((r,i)=>{const c=r.children;return {i,ed:(c[0].querySelector('img')||{}).title||t(c[0]),lang:(c[1].querySelector('img')||{}).title||t(c[1]),q:t(c[2]),x:t(c[3]).replace(/^-$/,''),st:t(c[4]),p:t(c[5]),buy:!!r.querySelector('button.product--btn')}});
return V.filter(v=>v.buy).map(v=>[v.i,v.ed,v.lang,v.q,v.x,v.st,v.p].join(' | ')).join('\n')})()
```
   Se não achar linhas: passe o mouse no ícone de edição de cada linha e dê zoom (a dica aparece acima do ícone da linha sob o cursor).
3. Regra de escolha (pare na primeira que der 1 linha):
   | Filtro nas linhas com `buy` | Resultado |
   |---|---|
   | `ed`, `lang`, `q` e extras iguais aos da Liga | 1 linha: comprar |
   | + estoque = `est` e preço final = unitário da Liga | desempata |
   | 0 linhas | variante ausente: não substitua, registre |
   As lojas usam o sistema da Liga: edição, idioma, estoque e preço vêm com o mesmo texto. Edições parecidas são linhas diferentes. Exemplo: Blitzball Stadium tinha "FINAL FANTASY Commander (Extended Art)" (a certa) e "FINAL FANTASY Commander" na mesma página.
4. COMPRAR na linha `i`, um clique só. No primeiro item da sessão, teste o clique por JS: `document.querySelectorAll('.table-cards-body .table-cards-row')[i].querySelector('button.product--btn').click()`. Se o contador não subir, use `find` (ref do COMPRAR daquela linha) ou, se `find` falhar, `scrollIntoView({block:'center'})` na linha + screenshot + clique no COMPRAR da linha central. Use o caminho que funcionou no resto da loja.
5. Mudança esperada: o contador do carrinho (número ao lado do ícone, no topo à direita; screenshot a 0.5 lê) = anterior + 1. Qualquer outro valor: pare e leia o carrinho antes de clicar de novo. Duas falhas no mesmo passo: screenshot, relate, pergunte.

## S4. Conciliar a loja (do mais barato ao mais caro; pare no primeiro que falhar)
1. Contador (conta unidades) = unidades de R0 + soma de `qty` de E.
2. Subtotal do carrinho = subtotal de R0 + total da Liga.
3. `txt_qty_*` dos itens novos = `qty` de E. Subtotal da linha ≠ unitário revela quantidade 2.
4. Tudo certo: loja pronta. Senão, compare por chave `nome | edição | idioma | qualidade | extras` (esperado = R0 + E) e corrija:
   - Falta: S3.
   - Quantidade a mais desta sessão: triple-click no campo, digite o valor, Tab, clique "Alterar" (aparece embaixo do campo), recarregue, confira `txt_qty_*`.
   - Linha errada posta nesta sessão: pergunte antes de remover.
5. Recarregue e repita até passar. Sem recarga, não está conferido.

## S5. Relatório (no idioma da mensagem dele)
Tabela: loja | itens | total Liga | subtotal na loja. Depois, só o que houver: itens prévios mantidos (e valor), carrinho de visitante, variantes ausentes, quantidades > 1 vindas da Liga, divergência de cabeçalho explicada. Diga que parou antes do checkout. `!!`: só a tabela e as ressalvas. `***`: inclua a conciliação por chave de cada loja.
````


#### Codex: `home:.agents/skills/ligamagic-replicar-carrinho-nas-lojas/SKILL.md`

````skill-source home:.agents/skills/ligamagic-replicar-carrinho-nas-lojas/SKILL.md 392830fa60233256808c81596c1908be71f8be438a47121c23f817d6e8f5cbba
---
name: "ligamagic-replicar-carrinho-nas-lojas"
description: "Refaz o carrinho por loja da LigaMagic no site próprio de cada loja (mesma carta, edição, idioma, qualidade, extras e quantidade) e concilia os dois antes do checkout. Use quando o Giovanni pedir para conferir os carrinhos da LigaMagic e montá-los ou conferi-los nos sites das lojas, sem usar os links da Liga."
---

# Carrinho LigaMagic → sites das lojas

Lineage: origin=claude; base=sha256:21b562c3f42e4e30e6c22fd771e3363de67b30db3c56d59d7cf8ebc71adacff7; adaptation=codex

Interop: role = domain; owns = fluxo Liga→loja, scripts de leitura do carrinho por loja e da página de produto, conciliação e relatório final; defers to = ligamagic-listas (Lista de Compras e Compra por Lista), browser-automacao-segura (alertas, laços, ações destrutivas: prevalece), click-protocol (mecânica de clique), minimize-site-approvals (domínios); honors = idioma da mensagem, flags !! *** ...

Origem: tarefa de 12/10/2026 (5 lojas, 90 itens). Erros que esta skill previne: item Foil/Promo pulado na leitura, estoque lido como quantidade, cópia duplicada por clique repetido, edição parecida escolhida no lugar da certa, conferência só pelo número de itens.

## Regras fixas
1. LigaMagic só leitura. Nunca clique em `.btn-circle.remove` (remove o item ou a loja inteira).
2. Na loja: buscar, COMPRAR e corrigir quantidade. Nada de login, conta, pagamento, formulário ou o botão COMPRAR do carrinho (checkout).
3. Itens que já estavam no carrinho da loja ficam (padrão dele: manter e acrescentar). Pergunte só se ele não tiver dito.
4. Não chegue às lojas pelos links da Liga.
5. Antes de adicionar, leia browser-automacao-segura. Trate diálogos com APIs documentadas, sem substituir handlers. Um item por vez, com verificação entre cliques.
6. Mensagem curta de progresso a cada 5 itens e a cada troca de loja.
7. Navegue com a API documentada do navegador; uma ação por vez, seguida de leitura e verificação (click-protocol).

## Checklist (copie e marque)
- [ ] S1 Ler a Liga (script A) → E por loja; listar domínios e pedir acesso de uma vez
- [ ] S2 Para cada loja: ler R0 (carrinho antes de mexer)
- [ ] S3 Adicionar cada item de E (script B + regra de escolha)
- [ ] S4 Conciliar a loja até passar
- [ ] S5 Relatório

## S1. Carrinho da Liga (?view=mp/carrinho&open=1)
Script A (testado em 12/10/2026; 90 linhas, 5 lojas):
```js
(()=>{const t=e=>e?e.innerText.replace(/\s+/g,' ').trim():'';
const LM=[...document.querySelectorAll('.pad-bot-10')].filter(b=>b.querySelector('input.qty')).map(b=>{const f=t(b.querySelector('.footer'));return {loja:t(b.querySelector('.loja-titulo')),hdr:+(f.match(/(\d+) itens?/)||[])[1],total:(f.match(/Valor Total:.*?(R\$ [\d.,]+)\s*(R\$ [\d.,]+)\s*(R\$ [\d.,]+)/)||[])[3]||'',
itens:[...b.querySelectorAll('input.qty')].map(q=>{const r=q.closest('div.row');const a=[...r.querySelectorAll('table.listasimples td')].map(td=>(td.querySelector('img')||{}).title||t(td)).filter(x=>x&&x.length<40);
return {nome:t(r.querySelector('a.pretoG')).split(' / ').pop(),ed:(r.querySelector('img.icon-edicao')||{}).title||'',lang:a.find(x=>/Portugu|Ingl|Japon|Alem|Espanh|Franc|Italian|Russ|Chin|Corean/.test(x))||'',qual:a.find(x=>/^(M|NM|SP|MP|HP|D)$/.test(x))||'',extras:a.filter(x=>/^(Foil|Promo|Pre-?release|Textless|Etched|Assinad|Alterad|Oversize)/i.test(x)).join(','),qty:+q.value,est:(t(r).match(/(\d+) unids?\./)||[])[1]||'',sub:t(r.querySelector('.item-total'))}})}});
return LM.map(s=>s.loja+' | hdr '+s.hdr+' | linhas '+s.itens.length+' | soma '+s.itens.reduce((x,i)=>x+i.qty,0)+' | '+s.total).join('\n')})()
```
- Valide antes de usar: `hdr` = linhas de cada loja e nenhum campo `ed`, `lang` ou `qual` vazio. Se falhar (o site mudou), leia linha a linha pela página: `div.row` com `input.qty`, edição no `title` do ícone, Foil/Promo na própria linha.
- Se a API permitir leitura do DOM, retorne apenas o trecho necessário do resultado, sem gravar variáveis na página. Os scripts abaixo são modelos de extração para adaptar à leitura permitida; não são APIs do host. Leia os itens em fatias. O a ferramenta de leitura disponível corta saídas longas e bloqueia URLs.
- "N unids." é ESTOQUE (`est`), nunca quantidade. Quantidade é `input.qty` (`qty`).
- `qty` > 1: pergunte se é intencional antes de replicar (já houve cópia extra por engano).
- Mesma página, outra estrutura: a "Lista de Compras" (tabela com selects) é da skill ligamagic-listas; não a confunda com o carrinho por loja.
- Site da loja: leia o domínio exibido sem seguir links de redirecionamento da Liga; abra o domínio independentemente. Domínios confirmados: primemtg.com.br, tavernagamehouse.com.br.

## S2. R0 da loja
`https://<loja>/?view=ecom/carrinho` + a leitura de texto disponível: guarde linhas, subtotal e os campos `txt_qty_*` (JS: inputs cujo `name` começa com `txt_qty_`). Sem "Olá, <nome>" no topo: carrinho de visitante, avise no fim.

## S3. Adicionar um item
1. Busca direta: `https://<loja>/?view=ecom/itens&busca=<nome EN>`. Um resultado abre o produto. Vários: Art Card, "com assinatura" e tokens são outros produtos; abra candidatos até achar a edição.
2. Script B (página do produto; testado na Prime MTG, mesma plataforma das outras lojas):
```js
(()=>{const t=e=>e?e.innerText.replace(/\s+/g,' ').trim():'';
const V=[...document.querySelectorAll('.table-cards-body .table-cards-row')].map((r,i)=>{const c=r.children;return {i,ed:(c[0].querySelector('img')||{}).title||t(c[0]),lang:(c[1].querySelector('img')||{}).title||t(c[1]),q:t(c[2]),x:t(c[3]).replace(/^-$/,''),st:t(c[4]),p:t(c[5]),buy:!!r.querySelector('button.product--btn')}});
return V.filter(v=>v.buy).map(v=>[v.i,v.ed,v.lang,v.q,v.x,v.st,v.p].join(' | ')).join('\n')})()
```
   Se não achar linhas: passe o mouse no ícone de edição de cada linha e dê zoom (a dica aparece acima do ícone da linha sob o cursor).
3. Regra de escolha (pare na primeira que der 1 linha):
   | Filtro nas linhas com `buy` | Resultado |
   |---|---|
   | `ed`, `lang`, `q` e extras iguais aos da Liga | 1 linha: comprar |
   | + estoque = `est` e preço final = unitário da Liga | desempata |
   | 0 linhas | variante ausente: não substitua, registre |
   As lojas usam o sistema da Liga: edição, idioma, estoque e preço vêm com o mesmo texto. Edições parecidas são linhas diferentes. Exemplo: Blitzball Stadium tinha "FINAL FANTASY Commander (Extended Art)" (a certa) e "FINAL FANTASY Commander" na mesma página.
4. Localize o botão COMPRAR na linha cuja variante foi conferida, por referência ou localizador semântico observado. Clique uma vez com a API documentada; não dispare cliques por JavaScript. Se necessário e permitido, use screenshot atual para uma coordenada observada.
5. Mudança esperada: o contador do carrinho (número ao lado do ícone, no topo à direita; screenshot a 0.5 lê) = anterior + 1. Qualquer outro valor: pare e leia o carrinho antes de clicar de novo. Duas falhas no mesmo passo: screenshot, relate, pergunte.

## S4. Conciliar a loja (do mais barato ao mais caro; pare no primeiro que falhar)
1. Contador (conta unidades) = unidades de R0 + soma de `qty` de E.
2. Subtotal do carrinho = subtotal de R0 + total da Liga.
3. `txt_qty_*` dos itens novos = `qty` de E. Subtotal da linha ≠ unitário revela quantidade 2.
4. Tudo certo: loja pronta. Senão, compare por chave `nome | edição | idioma | qualidade | extras` (esperado = R0 + E) e corrija:
   - Falta: S3.
   - Quantidade a mais desta sessão: triple-click no campo, digite o valor, Tab, clique "Alterar" (aparece embaixo do campo), recarregue, confira `txt_qty_*`.
   - Linha errada posta nesta sessão: pergunte antes de remover.
5. Recarregue e repita até passar. Sem recarga, não está conferido.

## S5. Relatório (no idioma da mensagem dele)
Tabela: loja | itens | total Liga | subtotal na loja. Depois, só o que houver: itens prévios mantidos (e valor), carrinho de visitante, variantes ausentes, quantidades > 1 vindas da Liga, divergência de cabeçalho explicada. Diga que parou antes do checkout. `!!`: só a tabela e as ressalvas. `***`: inclua a conciliação por chave de cada loja.

## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.

Os seletores históricos são pistas, não prova de que o site atual os usa. Confirme a estrutura observável. Só use extração de DOM quando a documentação da ferramenta permitir; caso contrário leia a interface e reporte os campos não acessíveis.
````
