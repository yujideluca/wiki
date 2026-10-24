---
id: skill-ligamagic-replicar-carrinho-nas-lojas
lang: pt-BR
source_hash: fa2516bd4da8
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
