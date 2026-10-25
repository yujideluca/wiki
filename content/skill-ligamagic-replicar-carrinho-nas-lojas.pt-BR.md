---
id: skill-ligamagic-replicar-carrinho-nas-lojas
lang: pt-BR
source_hash: e4df24589328
title: Skill: ligamagic-replicar-carrinho-nas-lojas
---

## What it is
A skill "ligamagic-replicar-carrinho-nas-lojas" refaz o carrinho por loja da LigaMagic no site próprio de cada loja e concilia os dois antes do checkout. É escrita em português. Sua descrição diz: refaz o carrinho por loja da LigaMagic no site próprio de cada loja (mesma carta, edição, idioma, qualidade, extras e quantidade) e concilia os dois antes do checkout; usar quando o Giovanni pedir para conferir os carrinhos da LigaMagic e montá-los ou conferi-los nos sites das lojas, sem usar os links da Liga. Vem de uma tarefa de 12 de outubro de 2026 (5 lojas, 90 itens) e previne os erros encontrados então: item Foil/Promo pulado na leitura, estoque lido como quantidade, cópia duplicada por clique repetido, edição parecida escolhida no lugar da certa e conferência só pelo número de itens.

## What it does
Copia a mesma carta, edição, idioma, qualidade, extras e quantidade para o carrinho de cada loja, sem usar os links da LigaMagic; as compras em si precisam da aprovação do Giovanni. Seu papel é "domínio": é dona do fluxo Liga→loja, dos scripts de leitura do carrinho por loja e da página de produto, da conciliação e do relatório final; remete à [[skill-ligamagic-listas]], à [[skill-browser-automacao-segura]] (alertas, laços, ações destrutivas: esta prevalece), à [[skill-click-protocol]] (mecânica de clique) e à [[skill-minimize-site-approvals]] (domínios).

## How it does it
Um `SKILL.md` em `~/.claude/skills/ligamagic-replicar-carrinho-nas-lojas`; o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
O hobby de Magic: The Gathering do Giovanni.

## Who receives its output
O Giovanni, antes de pagar.

## Steps
Regras fixas:
1. A LigaMagic é só leitura. Nunca clicar em `.btn-circle.remove` (remove o item ou a loja inteira).
2. Na loja: buscar, COMPRAR (o botão "COMPRAR" do produto) e corrigir a quantidade. Nada de login, conta, pagamento, formulário ou o botão COMPRAR do carrinho (checkout).
3. Itens que já estavam no carrinho da loja ficam (padrão dele: manter e acrescentar). Perguntar só se ele não tiver dito.
4. Não chegar às lojas pelos links da Liga.
5. Antes de adicionar, instalar o registro de alertas (regra 3 da [[skill-browser-automacao-segura]]). Um item por vez; nunca dois cliques sem verificação entre eles.
6. Mensagem curta de progresso a cada 5 itens e a cada troca de loja.
7. `navigate` sozinho, fora de lotes. Lotes de no máximo 4 ações inofensivas, terminando em verificação ([[skill-click-protocol]]).

Checklist (copiar e marcar): S1 ler a Liga (script A) → a lista esperada E por loja, listar os domínios e pedir acesso de uma vez; S2 para cada loja ler R0 (o carrinho antes de mexer); S3 adicionar cada item de E (script B + regra de escolha); S4 conciliar a loja até passar; S5 relatório.

S1. **O carrinho da Liga** (`?view=mp/carrinho&open=1`). O script A (testado em 12/10/2026; 90 linhas, 5 lojas) lê, para cada bloco de loja: o nome da loja, o número de itens no cabeçalho, o total e, por linha, o nome da carta (o nome em inglês depois do último " / "), a edição (do título do ícone de edição), idioma, qualidade, extras (Foil, Promo, Pre-release, Textless, Etched, assinada, alterada, oversize), quantidade (o campo de quantidade), estoque e subtotal. Validar antes de usar: a contagem do cabeçalho é igual ao número de linhas de cada loja e nenhum campo de edição, idioma ou qualidade está vazio; se falhar (o site mudou), ler linha a linha pela página. Ler os itens em fatias; a ferramenta corta saídas longas e bloqueia URLs. "N unids." é ESTOQUE, nunca quantidade; a quantidade é o valor do campo. Se uma quantidade for maior que 1, perguntar se é intencional antes de replicar (já houve cópia extra por engano). A Lista de Compras (tabela com seletores) é da [[skill-ligamagic-listas]]; não confundir com o carrinho por loja. Para achar o site da loja, clicar no nome da loja; domínios confirmados: primemtg.com.br e tavernagamehouse.com.br.

S2. **R0 da loja.** Abrir `https://<loja>/?view=ecom/carrinho` e ler o texto da página: guardar as linhas, o subtotal e os campos `txt_qty_*` (campos cujo nome começa assim). Sem "Olá, <nome>" no topo, o carrinho é de visitante: avisar no fim.

S3. **Adicionar um item.** (a) Busca direta: `https://<loja>/?view=ecom/itens&busca=<nome em inglês>`; um resultado abre o produto; com vários, Art Card, "com assinatura" e tokens são outros produtos, então abrir candidatos até achar a edição. (b) O script B (página do produto; testado na Prime MTG, a mesma plataforma das outras lojas) lista as linhas compráveis com edição, idioma, qualidade, extras, estoque e preço; se não achar linhas, passar o mouse no ícone de edição de cada linha e dar zoom. (c) Regra de escolha (parar no primeiro filtro que der 1 linha): linhas com a mesma edição, idioma, qualidade e extras da Liga → comprar essa; mais estoque igual e preço final igual ao unitário da Liga desempata; 0 linhas → variante ausente: não substituir, registrar. As lojas usam o sistema da Liga, então edição, idioma, estoque e preço vêm com o mesmo texto; edições parecidas são linhas diferentes (por exemplo "FINAL FANTASY Commander (Extended Art)" é a certa e "FINAL FANTASY Commander" é outra na mesma página). (d) COMPRAR na linha i, um clique só; no primeiro item da sessão, testar o clique por script, e se o contador do carrinho não subir, usar `find` (a ref do COMPRAR daquela linha) ou, se o `find` falhar, rolar a linha para o centro, tirar uma captura e clicar no COMPRAR da linha central; usar o caminho que funcionou no resto da loja. (e) Mudança esperada: o contador do carrinho (o número ao lado do ícone do carrinho, no topo à direita) sobe exatamente 1; qualquer outro valor → parar e ler o carrinho antes de clicar de novo. Duas falhas no mesmo passo → captura de tela, relatar, perguntar.

S4. **Conciliar a loja** (do mais barato ao mais caro; parar na primeira que falhar). (1) Contador (conta unidades) = unidades de R0 + soma das quantidades de E. (2) Subtotal do carrinho = subtotal de R0 + total da Liga. (3) Os `txt_qty_*` dos itens novos = as quantidades de E; um subtotal de linha diferente do unitário revela quantidade 2. (4) Se tudo estiver certo, a loja está pronta; senão comparar pela chave `nome | edição | idioma | qualidade | extras` (esperado = R0 + E) e corrigir: falta → S3; quantidade a mais desta sessão → triplo clique no campo, digitar o valor, Tab, clicar "Alterar", recarregar e conferir; linha errada posta nesta sessão → perguntar antes de remover. (5) Recarregar e repetir até passar; sem recarga, não está conferido.

S5. **Relatório** (no idioma da mensagem do Giovanni): uma tabela loja | itens | total da Liga | subtotal na loja; depois só o que houver: itens prévios mantidos (e seu valor), carrinho de visitante, variantes ausentes, quantidades acima de 1 vindas da Liga, divergência de cabeçalho explicada. Dizer que parou antes do checkout. Com `!!`: só a tabela e as ressalvas. Com `***`: incluir a conciliação por chave de cada loja.

## Notes

O Codex agora usa a versão mantida separadamente em [[codex-skills]]. A fonte completa abaixo contém as regras de execução do Codex; o procedimento Claude acima continua sendo a versão Claude. Navegador, memória e conexões podem funcionar de formas diferentes.

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

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
