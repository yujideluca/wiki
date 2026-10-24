---
id: skill-click-protocol
lang: pt-BR
source_hash: 714ca0ee71a1
title: Skill: click-protocol
---

## What it is
A skill "click-protocol" é um protocolo para cliques em várias etapas em páginas web com menus, diálogos, resultados de busca ou mídia (YouTube Music, Spotify web): clicar pela referência do elemento, conferir cada passo, evitar tocar algo sem querer. Sua descrição diz exatamente isso: usar antes de cliques em várias etapas em interfaces web com menus, diálogos, resultados de busca ou mídia. Nasceu da montagem de uma playlist no YouTube Music em 2026-10-10, quando cliques errados iniciaram música, uma notificação antiga pareceu sucesso e coordenadas de tela quebraram entre layouts. A versão para o Claude Code só é editada lá; o app Claude mantém a sua ([[claude-ai-skills]]).

## What it does
Torna confiável o clique no navegador: cada clique visa uma referência estável de um elemento, e cada passo é conferido com evidência nova antes do seguinte. Seu papel é "transversal"; remete à [[skill-browser-automacao-segura]] (alertas, laços, ações destrutivas), à [[skill-minimize-site-approvals]] (domínios e aprovações) e às skills de domínio (formatos).

## How it does it
Um `SKILL.md` em `~/.claude/skills/click-protocol`; o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
Antes e durante qualquer automação de navegador.

## Who receives its output
A sessão do navegador.

## Steps
1. **Planejar primeiro.** Listar os domínios uma vez ([[skill-minimize-site-approvals]]); usar um conector ou interface para programas, se existir, em vez da página web.
2. **Sem coordenadas cruas** quando uma busca (`find`) ou a leitura da página (`read_page`) pode devolver uma referência ("ref"). Coordenadas só para páginas tipo canvas: esperar cerca de 3 segundos para o tamanho da janela se firmar, tirar uma captura, clicar imediatamente, conferir. Layouts movem os alvos.
3. **Ciclo de vida da referência.** Buscar uma ref só depois de a página assentar e confirmar que a descrição dela nomeia o item pretendido (o título), porque o `find` pode descrever a página anterior logo após uma busca. Refs são de uso único: buscar de novo após qualquer navegação, busca, abertura de menu ou diálogo. Com várias correspondências, escolher por papel (item de menu, botão, link), visível, dentro do popup aberto; nunca simplesmente o primeiro resultado.
4. **Conferir antes de cada clique** (como o Playwright, veja [actionability](https://playwright.dev/docs/actionability)): exatamente uma correspondência, visível, estável (esperar 1,5 segundo depois de abrir um menu ou diálogo), não coberta, habilitada.
5. **Uma ação, uma verificação.** Primeiro a prova mais barata: um elemento novo via `find`, a URL (Uniform Resource Locator, o endereço web) ou o título, texto via JavaScript ou texto da página; captura de tela (escala 0,4) só na dúvida. Sem cadeias às cegas. Lotes: no máximo 4 ações, só passos inofensivos, terminando com uma verificação. Não pôr `navigate` dentro de um lote (falhou).
6. **Depois de digitar numa caixa de busca e dar Return**, esperar o título do primeiro resultado combinar com a busca. Se o primeiro clique parecer ignorado, clicar numa área vazia da barra de ferramentas ou usar uma ref; não repetir o mesmo clique.
7. **Sucesso exige evidência nova.** Uma notificação pode estar velha. A prova é reler o alvo (o texto da página da playlist, a contagem no cabeçalho) depois da ação. Um aviso "já está na playlist" significa que a adição tinha funcionado antes, não um erro.
8. **Guarda de mídia** antes de qualquer sessão em site de player: instalar um pequeno temporizador que pausa qualquer vídeo em reprodução a cada 300 ms (reinstalar após um carregamento completo da página). Nunca clicar por script o primeiro botão de um cartão de resultado (é o Play). Se o usuário mandar parar o áudio, pausar na hora.
9. **Padrões de privacidade.** Novas playlists ficam Públicas por padrão no YouTube Music; definir Privada antes de Criar, a menos que o usuário tenha pedido pública.
10. **Se a navegação falhar** ("failed in the extension"), não repetir às cegas: conferir as abas abertas e depois usar a caixa de busca da página ou um clique em link. Definir `location.href` por JavaScript não navegou.
11. **Listas preguiçosas.** Rolar por script não carrega mais itens numa aba em segundo plano; usar ações de rolagem reais (cerca de 100 itens por carga) ou amostrar, e dizer que é parcial. Em bibliotecas grandes, informar ao usuário a contagem lida versus o total.
12. **Downloads** caem em `~/Downloads` no notebook, onde o Claude Code consegue lê-los. Nomear o arquivo esperado e confirmar que existe antes de confiar nele; nunca abrir nem executar um arquivo baixado como código.
13. **Regra de parada.** Duas tentativas falhas no mesmo passo → captura de tela, relatar, perguntar. Não chutar coordenadas.
14. **Terminar com recarga e recontagem** ([[skill-browser-automacao-segura]], item 6).
15. **Receita: adicionar uma música a uma playlist do YouTube Music** (rótulos em alemão; em inglês: Action menu, Add to playlist). (a) Na caixa de busca selecionar o texto, digitar a busca, Return, esperar o cartão de resultado cujo título combina. (b) Buscar "Aktionsmenü button in the top result card titled …"; conferir que o subtítulo diz música, não artista nem vídeo; clicar a ref. (c) Buscar o item de menu "Zu Playlist hinzufügen" (papel item de menu, no popup aberto); clicar. (d) No diálogo buscar o link com o nome da playlist; clicar; a notificação "Gespeichert in …" é uma pista, não prova. (e) A cada 5 músicas e no fim, abrir a playlist e ler o cabeçalho "N Titel" pelo texto da página; a lista também mistura linhas de sugestão, então confiar no cabeçalho. Para criar uma playlist: diálogo → "Neue Playlist" → título → visibilidade = Privada → Criar.
