---
id: skill-click-protocol
lang: pt-BR
source_hash: 1f36ece8ff8d
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

## Notes

O Codex agora usa a versão mantida separadamente em [[codex-skills]]. A fonte completa abaixo contém as regras de execução do Codex; o procedimento Claude acima continua sendo a versão Claude. Navegador, memória e conexões podem funcionar de formas diferentes.

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/click-protocol/SKILL.md`

```skill-source home:.claude/skills/click-protocol/SKILL.md 8139fbbb9ad1c2831da79633dab6efd06be28e39199909ec3e773c12ad7ae2ce
---
name: "click-protocol"
description: "Use before multi-step clicking in web UIs with menus, dialogs, search results or media (YouTube Music, Spotify web): click by element ref, verify each step, avoid accidental playback."
---


Code version: adapted for Claude Code on the laptop from `gui/skills/click-protocol`. Edited only by Claude Code; the app keeps its own version.
# Click protocol (ref-first, verify every step)

Lineage: origin=gui; base=446694f41d9f899bfc16ddb536e850965dbf64ce

Interop: role = cross-cutting; owns = click/verify protocol and YouTube Music add-to-playlist recipe; defers to = browser-automacao-segura (alerts, loops, destructive actions), minimize-site-approvals (domains and approvals), domain skills (formats); honors = reply-language rule, depth flags.

Origin: YouTube Music playlist build, 2026-10-10. Misclicks started music, a stale toast looked like success, coordinates broke between layouts.

## Rules, in order
1. Plan first: domains once (minimize-site-approvals); use a connector or API if one exists instead of the UI.
2. No raw coordinates when `find` or `read_page` can return a ref. Coordinates only for canvas-like pages: wait about 3 s for the window size to settle, screenshot, click immediately, verify. Layouts move targets (for example the side panel "Mehr von YouTube" present or absent).
3. Ref lifecycle: look up a ref only after the page settled, and confirm its description names the intended item (title), because `find` can describe the previous page right after a search. Refs are single-use: re-find after any navigation, search, menu open or dialog open. Several matches: pick by role (menuitem/button/link), visible, inside the open popup; never the first hit.
4. Actionability gate before every click (Playwright checks): exactly one match, visible, stable (wait 1.5 s after a menu or dialog opens), not covered, enabled.
5. One action, one verification. Cheapest proof first: new element via `find`, URL/title, text via JS or get_page_text; screenshot (scale 0.4) only when doubtful. No blind chains. Batches: at most 4 actions, only harmless steps, end with a check. Do not put `navigate` inside `browser_batch` (it failed here).
6. After typing in a search box and Return, wait until the first result title matches the query. If the first click seems ignored, click an empty toolbar area or use a ref; do not repeat the same click.
7. Success needs fresh evidence. A toast can be stale. Proof = re-read the target (playlist page text, header count) after the action. A "already in playlist" toast means the add had worked earlier, not an error.
8. Media guard before any session on a player site: `setInterval(()=>{const v=document.querySelector('video');if(v&&!v.paused)v.pause()},300)`. Reinstall after a full page load. Never JS-click the first `button` of a result card (it is Play). If the user says stop the audio, pause at once.
9. Privacy defaults: new playlists default to Public on YouTube Music; set Privat/Private before Create unless the user asked for public.
10. Navigation fails ("failed in the extension"): do not retry blindly. Check tabs_context, then use the in-page search box or a link click. `location.href` from JS did not navigate here.
11. Lazy lists: JS scrolling does not load more in a background tab; use real scroll actions (about 100 items per load) or sample, and say it is partial. For large libraries tell the user the count read vs total.
12. Downloads land in ~/Downloads on the laptop, where Claude Code can read them directly. Name the file you expect and confirm it exists there before relying on it; never open or run a downloaded file as code.
13. Stop rule: two failed tries on the same step -> screenshot, report, ask. Do not guess coordinates.
14. Finish with a reload and recount (browser-automacao-segura, item 6).

## Recipe: add a song to a YouTube Music playlist (German labels; English: Action menu, Add to playlist)
1. Search box: select text, type query, Return, wait for result card whose title matches.
2. `find` "Aktionsmenü button in the top result card titled <title>"; check the subtitle says Titel/Song, not artist or video; click the ref.
3. `find` the menuitem "Zu Playlist hinzufügen" (role menuitem, in the open popup); click it.
4. `find` the link with the playlist name in the dialog; click it. Toast "Gespeichert in <name>" is a hint, not proof.
5. Every 5 songs and at the end: open the playlist and read the header "N Titel" via get_page_text. The DOM list also mixes suggestion rows, so trust the header and page text.
Create playlist: dialog -> "Neue Playlist" -> title -> Sichtbarkeit = Privat -> Erstellen.
```


#### Codex: `home:.agents/skills/click-protocol/SKILL.md`

````skill-source home:.agents/skills/click-protocol/SKILL.md 0315da08366ab036381368f08e9217a3f6b87b7b9292c8e4a1374849e7157623
---
name: click-protocol
description: "Use before multi-step browser interaction with menus, dialogs, search results or media players."
---

# Click and verify

Lineage: origin=claude; base=sha256:df3f65d96ee6f77141ed9a047526dd6f2777603cdc739e34b6af49155acc6090; adaptation=codex

Interop: role = cross-cutting; owns = identifying browser controls and verifying each click; defers to = browser-automacao-segura (safety), minimize-site-approvals (access), domain skills (format); honors = user language.

1. Read the active browser tool's documentation. Use supported semantic locators or current element references. A target must match exactly one visible, enabled control in the intended menu, dialog or item row.
2. Re-observe after navigation, search, opening a menu, or any layout change. Do not reuse stale references. Use documented waits for the expected state rather than fixed sleeps.
3. Take one action and verify it with fresh page text, an updated control, the URL or a screenshot. Never chain blind clicks. A toast is supporting evidence, not a final check.
4. Coordinates are a fallback only when the host permits them and semantic targeting is unavailable: take a fresh screenshot, act immediately, and inspect the outcome. Do not guess.
5. On a media site, avoid play controls unless playback was requested. If audio starts accidentally, pause using a visible supported control immediately. Do not install timers or rewrite the site's media behavior.
6. For playlists, select the result by title and type, open that row's action menu, choose Add to playlist, then the intended playlist. New playlists are private unless the user requested public visibility. Revisit the playlist and check the actual item/count; an already-present notice is not a failed add.
7. For lazy lists, use documented scrolling and report read count versus total. Inspect actual download results instead of assuming a local download directory.
8. Two failures on the same step: inspect evidence, stop retries, report the concrete limitation. Ask only if user input or a manual step is required. Finish changes with a reload and reconciliation.
````
