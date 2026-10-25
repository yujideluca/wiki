---
id: skill-ligamagic-replicar-carrinho-nas-lojas
lang: de
source_hash: e4df24589328
title: Skill: ligamagic-replicar-carrinho-nas-lojas
---

## What it is
Die Skill „ligamagic-replicar-carrinho-nas-lojas“ baut den Warenkorb pro Shop von LigaMagic auf der eigenen Website jedes Shops nach und gleicht beide vor dem Bezahlen ab. Sie ist auf Portugiesisch geschrieben. Ihre Beschreibung sagt: Sie baut den Warenkorb pro Shop von LigaMagic auf der eigenen Seite jedes Shops nach (dieselbe Karte, Edition, Sprache, Zustand, Extras und Menge) und gleicht beide vor dem Checkout ab; verwenden, wenn Giovanni bittet, die LigaMagic-Warenkörbe zu prüfen und auf den Seiten der Shops aufzubauen oder zu prüfen, ohne die Links von LigaMagic zu benutzen. Sie stammt aus einer Aufgabe vom 12. Oktober 2026 (5 Shops, 90 Positionen) und verhindert die damals gefundenen Fehler: eine beim Lesen übersprungene Foil- oder Promo-Position, Lagerbestand als Menge gelesen, eine doppelte Kopie durch wiederholten Klick, eine ähnliche statt der richtigen Edition und eine Prüfung nur nach der Positionszahl.

## What it does
Sie kopiert dieselbe Karte, Edition, Sprache, Zustand, Extras und Menge in den Warenkorb jedes Shops, ohne die Links von LigaMagic zu benutzen; die Käufe selbst brauchen Giovannis Freigabe. Ihre Rolle ist „Domäne“: Sie besitzt den Ablauf von LigaMagic zum Shop, die Skripte zum Lesen des Warenkorbs pro Shop und der Produktseite, den Abgleich und den Abschlussbericht; sie verweist auf [[skill-ligamagic-listas]], auf [[skill-browser-automacao-segura]] (Warnungen, Schleifen, zerstörerische Aktionen: diese gilt vorrangig), auf [[skill-click-protocol]] (Klickmechanik) und auf [[skill-minimize-site-approvals]] (Domains).

## How it does it
Eine `SKILL.md` in `~/.claude/skills/ligamagic-replicar-carrinho-nas-lojas`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt.

## Where it sits in the pipeline
Giovannis Hobby Magic: The Gathering.

## Who receives its output
Giovanni, vor dem Bezahlen.

## Steps
Feste Regeln:
1. LigaMagic ist nur lesbar. Nie `.btn-circle.remove` klicken (es entfernt die Position oder einen ganzen Shop).
2. Im Shop: suchen, KAUFEN (der Knopf „COMPRAR“ des Produkts) und die Menge korrigieren. Nie anmelden, ein Konto erstellen, bezahlen, Formulare ausfüllen oder den Knopf „COMPRAR“ des Warenkorbs (Checkout) drücken.
3. Positionen, die schon im Warenkorb des Shops lagen, bleiben (sein Standard: behalten und ergänzen). Nur fragen, wenn er es nicht gesagt hat.
4. Die Shops nicht über die Links von LigaMagic erreichen.
5. Vor dem Hinzufügen das Warnungsprotokoll einrichten (Regel 3 von [[skill-browser-automacao-segura]]). Eine Position nach der anderen; nie zwei Klicks ohne Prüfung dazwischen.
6. Eine kurze Fortschrittsmeldung alle 5 Positionen und bei jedem Shopwechsel.
7. `navigate` allein, außerhalb von Stapeln. Stapel aus höchstens 4 harmlosen Aktionen, mit einer Prüfung am Ende ([[skill-click-protocol]]).

Checkliste (kopieren und abhaken): S1 LigaMagic lesen (Skript A) → die erwartete Liste E pro Shop, die Domains auflisten und auf einmal um Zugriff bitten; S2 für jeden Shop R0 lesen (den Warenkorb vor dem Eingriff); S3 jede Position aus E hinzufügen (Skript B + Auswahlregel); S4 den Shop abgleichen, bis es besteht; S5 Bericht.

S1. **Der LigaMagic-Warenkorb** (`?view=mp/carrinho&open=1`). Skript A (am 12. Okt. 2026 getestet; 90 Zeilen, 5 Shops) liest für jeden Shop-Block: den Shopnamen, die Zahl der Positionen im Kopf, die Summe, und je Zeile den Kartennamen (der englische Name nach dem letzten „ / “), die Edition (aus dem Titel des Editionssymbols), Sprache, Zustand, Extras (Foil, Promo, Pre-release, Textless, Etched, signiert, verändert, Oversize), Menge (das Mengenfeld), Lagerbestand und Zwischensumme. Vor der Nutzung validieren: Die Zahl im Kopf entspricht der Zeilenzahl jedes Shops, und kein Feld für Edition, Sprache oder Zustand ist leer; scheitert das (die Seite hat sich geändert), Zeile für Zeile von der Seite lesen. Die Positionen in Scheiben lesen; das Werkzeug kappt lange Ausgaben und blockiert URLs. „N unids.“ ist LAGERBESTAND, nie Menge; die Menge ist der Wert des Eingabefelds. Ist eine Menge über 1, fragen, ob das Absicht ist, bevor man sie kopiert (einmal entstand irrtümlich eine zusätzliche Kopie). Die Einkaufsliste (eine Tabelle mit Auswahllisten) gehört zu [[skill-ligamagic-listas]]; nicht mit dem Warenkorb pro Shop verwechseln. Um die Website des Shops zu finden, auf den Shopnamen klicken; bestätigte Domains: primemtg.com.br und tavernagamehouse.com.br.

S2. **R0 des Shops.** `https://<Shop>/?view=ecom/carrinho` öffnen und den Seitentext lesen: die Zeilen, die Zwischensumme und die Felder `txt_qty_*` (Eingabefelder, deren Name so beginnt) festhalten. Ohne „Olá, <Name>“ oben ist der Warenkorb ein Gastkorb: am Ende darauf hinweisen.

S3. **Eine Position hinzufügen.** (a) Direkte Suche: `https://<Shop>/?view=ecom/itens&busca=<englischer Name>`; ein Ergebnis öffnet das Produkt; bei mehreren sind Art Cards, „mit Signatur“ und Token andere Produkte, also Kandidaten öffnen, bis die Edition gefunden ist. (b) Skript B (Produktseite; im Prime MTG getestet, derselben Plattform wie die anderen Shops) listet die kaufbaren Zeilen mit Edition, Sprache, Zustand, Extras, Bestand und Preis; werden keine Zeilen gefunden, mit der Maus über das Editionssymbol jeder Zeile fahren und zoomen. (c) Auswahlregel (beim ersten Filter anhalten, der 1 Zeile ergibt): Zeilen mit derselben Edition, Sprache, Zustand und Extras wie bei LigaMagic → diese kaufen; dazu gleicher Bestand und ein Endpreis gleich dem Stückpreis von LigaMagic entscheidet bei Gleichstand; 0 Zeilen → die Variante fehlt: nicht ersetzen, festhalten. Die Shops nutzen das System von LigaMagic, also kommen Edition, Sprache, Bestand und Preis mit demselben Text; ähnliche Editionen sind verschiedene Zeilen (zum Beispiel ist „FINAL FANTASY Commander (Extended Art)“ die richtige und „FINAL FANTASY Commander“ eine andere auf derselben Seite). (d) KAUFEN in Zeile i, nur ein Klick; bei der ersten Position der Sitzung den Klick per Skript testen, und steigt der Warenkorbzähler nicht, `find` nutzen (die Referenz des KAUFEN dieser Zeile) oder, wenn `find` scheitert, die Zeile in die Mitte scrollen, einen Screenshot machen und das KAUFEN der mittleren Zeile klicken; den Weg, der funktionierte, für den Rest des Shops nutzen. (e) Erwartete Änderung: Der Warenkorbzähler (die Zahl neben dem Warenkorbsymbol oben rechts) steigt um genau 1; jeder andere Wert → anhalten und den Warenkorb lesen, bevor wieder geklickt wird. Zwei Fehlschläge am selben Schritt → Screenshot, berichten, fragen.

S4. **Den Shop abgleichen** (vom billigsten zum teuersten; beim ersten Fehlschlag anhalten). (1) Zähler (zählt Stück) = Stück von R0 + Summe der Mengen von E. (2) Zwischensumme des Warenkorbs = Zwischensumme von R0 + Summe von LigaMagic. (3) Die `txt_qty_*` der neuen Positionen = die Mengen von E; eine Zeilenzwischensumme, die vom Stückpreis abweicht, verrät Menge 2. (4) Stimmt alles, ist der Shop fertig; sonst nach dem Schlüssel `Name | Edition | Sprache | Zustand | Extras` vergleichen (erwartet = R0 + E) und korrigieren: fehlt → S3; zusätzliche Menge aus dieser Sitzung → Dreifachklick ins Feld, den Wert eintippen, Tab, „Alterar“ klicken, neu laden und prüfen; eine in dieser Sitzung hinzugefügte falsche Zeile → vor dem Entfernen fragen. (5) Neu laden und wiederholen, bis es besteht; ohne Neuladen ist nicht geprüft.

S5. **Bericht** (in der Sprache von Giovannis Nachricht): eine Tabelle Shop | Positionen | LigaMagic-Summe | Zwischensumme im Shop; dann nur, was zutrifft: behaltene frühere Positionen (und ihr Wert), ein Gastkorb, fehlende Varianten, Mengen über 1 aus LigaMagic, eine erklärte Abweichung des Kopfes. Sagen, dass vor dem Checkout angehalten wurde. Mit `!!`: nur die Tabelle und die Vorbehalte. Mit `***`: den Abgleich nach Schlüssel für jeden Shop einschließen.

## Notes

Codex verwendet jetzt die getrennt gepflegte Version in [[codex-skills]]. Der vollständige Quelltext unten enthält die Ausführungsregeln für Codex; das oben beschriebene Claude-Verfahren bleibt die Claude-Version. Browser-, Speicher- und Verbindungsfunktionen können sich unterscheiden.

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

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
