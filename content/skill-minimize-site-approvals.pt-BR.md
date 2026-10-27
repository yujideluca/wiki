---
id: skill-minimize-site-approvals
lang: pt-BR
source_hash: 9d9759257243
title: Skill: minimize-site-approvals
---

## What it is
A skill "minimize-site-approvals" é uma etapa de planejamento antes de navegar, para que o Giovanni precise clicar em "aprovar" o menor número possível de vezes. Sua descrição diz: usar antes de qualquer tarefa de navegação para reduzir cliques de aprovação de sites: planejar os domínios com antecedência, pedir acesso ao site inteiro uma vez e preferir ferramentas que não exigem aprovação. A versão do Claude Code só é editada lá; o app Claude mantém a sua ([[claude-ai-skills]]).

## Flow
trigger t1: Antes de qualquer tarefa de navegação
step s1: Prefere o caminho mais barato: ferramentas que não pedem aprovação
decide d1: Existe uma ferramenta que não pede aprovação?
step s2: Lista todos os domínios de que a tarefa vai precisar
step s3: Diz ao Giovanni a lista completa numa linha | [[giovanni]]
step s4: Pede acesso a todo o site uma vez só
product p1: A tarefa feita sem cliques de aprovação
product p2: Uma rodada de aprovação em vez de várias

t1 -> s1
s1 -> d1
d1 -sim-> p1
d1 -não-> s2
s2 -> s3
s3 -> s4
s4 -> p2

## What it does
Planeja os domínios com antecedência, pede acesso ao site inteiro uma vez e prefere ferramentas que não exigem aprovação. Nunca contorna, desativa nem burla aprovações ou a verificação de segurança do site; apenas reduz quantos avisos são disparados. Funciona junto com a [[skill-browser-automacao-segura]] e a [[skill-click-protocol]].

## How it does it
Um `SKILL.md` em `~/.claude/skills/minimize-site-approvals`; o Claude o carrega quando um pedido combina com a descrição.

## Where it sits in the pipeline
Antes e durante qualquer automação de navegador.

## Who receives its output
A sessão do navegador e o Giovanni (menos avisos).

## Steps
Antes de tocar em um navegador:
1. **Preferir o caminho mais barato.** Para páginas públicas, ferramentas de busca na web e de leitura de página evitam o navegador, mas no Claude Code ainda podem disparar um aviso de permissão, então não são livres de aprovação. Abrir o Chrome só quando a tarefa exigir uma sessão autenticada, interação, formulários ou uma página que essas ferramentas não leem.
2. **Listar todo domínio** de que a tarefa provavelmente precisará (site principal, host de login, qualquer subdomínio citado pelo usuário), uma vez, com antecedência.
3. **Dizer ao usuário a lista completa em uma linha**, para as aprovações virem de uma vez em vez de uma a uma.

Aprovações no Claude Code:
4. Não existe ferramenta "pedir acesso". O acesso a sites vem do aviso da extensão Claude in Chrome: pedir ao usuário que escolha "Sempre permitir ações neste site" para sites confiáveis; os sites aprovados podem ser revistos e revogados na página de Permissões da extensão.
5. Avisos de ferramentas (comandos de shell, leitura de páginas, ferramentas de conectores) vêm do sistema de permissões do Claude Code. Para chamadas seguras repetidas, oferecer acrescentar uma regra de permissão nas configurações (a skill update-config ou o comando `/permissions`); nunca acrescentar uma sem o sim do usuário.
6. Se uma aprovação for recusada ou estiver pendente, esperar. Não repetir em laço nem tentar outra rota para o mesmo conteúdo. O shell pode executar curl, Python, wget ou git aqui, então isso importa: nunca usá-los para chegar a uma página que um aviso de aprovação, a extensão ou uma ferramenta de leitura recusou.

Durante o trabalho:
7. Preferir ferramentas de texto da página e de leitura a capturas de tela e navegação repetida; cada salto extra de site pode disparar um novo aviso.
8. Ficar nos domínios aprovados. Se a tarefa precisar de um novo domínio, juntar os novos pedidos e perguntar uma vez.
9. Agir em sequência, uma ação por vez, e neutralizar ou tratar diálogos de alerta e confirmação da página antes de ações em lote ([[skill-browser-automacao-segura]]).
10. Não reutilizar ids de abas de sessões anteriores; ler primeiro o contexto atual das abas.

Coisas a dizer com honestidade:
11. Algumas aprovações não podem ser removidas: sites bloqueados ou sinalizados pela verificação de segurança da extensão, downloads, digitação de informações sensíveis, concessão de autorizações. Compras, criação de contas e exclusões permanentes ficam com o usuário.
12. Os modos de permissão do Claude Code (por exemplo modo automático ou regras amplas de permissão) reduzem avisos mas também reduzem a revisão. Só o usuário os altera; mencionar a troca uma vez se perguntado e nunca insistir para poupar cliques em sites não confiáveis.

Encerrando a tarefa:
13. Dizer quais sites e ferramentas foram aprovados e como (uma vez, sempre ou por regra nas configurações), para o usuário saber o que ficou salvo e poder revogar.

## Notes

O Codex agora usa a versão mantida separadamente em [[codex-skills]]. A fonte completa abaixo contém as regras de execução do Codex; o procedimento Claude acima continua sendo a versão Claude. Navegador, memória e conexões podem funcionar de formas diferentes.

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/minimize-site-approvals/SKILL.md`

```skill-source home:.claude/skills/minimize-site-approvals/SKILL.md 0457c58dd26434a2fd12c54a615d53a3be66e279154eb478e7b7023e31beba8c
---
name: "minimize-site-approvals"
description: "Use before any browsing task to cut down site-approval clicks: plan the domains up front, request site-wide access once, and prefer tools that need no approval."
---

# Minimize site-approval clicks

Lineage: origin=gui; base=52547cd8127647409f6397067c9e7af5e903aa4c

Code version: adapted for Claude Code on the laptop from `gui/skills/minimize-site-approvals`. Edited only by Claude Code; the app keeps its own version.

Goal: the user should click "approve" as few times as possible. This skill never bypasses, disables, or works around approvals or the site safety check. It only reduces how many prompts get triggered.

## Before touching a browser

1. Prefer the cheapest path. For public pages, WebSearch and WebFetch avoid the browser, but in Claude Code they can still trigger a permission prompt, so they are not approval-free. Open Chrome only when the task needs a signed-in session, interaction, forms, or a page those tools cannot read.
2. List every domain the task will likely need (main site, login host, any subdomain the user mentioned). Do this once, up front.
3. Tell the user the full list in one line, so the approvals come in one go instead of one by one as pages come up.

## Approvals in Claude Code

- There is no `request_access` tool. Site access comes from the Claude in Chrome extension prompt: ask the user to choose "Always allow actions on this site" for trusted sites. Approved sites can be reviewed and revoked on the extension's Permissions page.
- Tool prompts (Bash, WebFetch, MCP tools) come from Claude Code's permission system. For repeated safe calls, offer to add an allow rule in settings (the `update-config` skill, or `/permissions`); never add one without the user's yes.
- If an approval is declined or pending, wait for it. Do not retry in a loop, and do not try another route to the same content. Bash can run curl, Python, wget or git here, so this rule matters more than in the app: never use them to reach a page that an approval prompt, the extension or a fetch tool refused.

## While working

- Prefer page-text and read tools over screenshots and repeated navigation; every extra site hop can trigger a new prompt.
- Stay on the approved domains. If the task needs a new domain, batch the new requests together and ask once.
- Act sequentially, one action at a time, and neutralize or handle page alert/confirm dialogs before batch actions so they never block the task (browser-automacao-segura).
- Do not reuse tab IDs from earlier sessions; call tabs_context_mcp first.

## Things to say honestly

- Some approvals cannot be removed: sites blocked or flagged by the extension's safety check, downloads, entering sensitive information, granting authorizations. Purchases, account creation, and permanent deletions stay with the user.
- Claude Code permission modes (for example auto mode, or broad allow rules) reduce prompts but also reduce review. Only the user changes them; mention the trade-off once if asked, and never push for it to save clicks on untrusted sites.

## Closing the task

Say which sites and tools were approved and how (once, always, or a settings rule) so the user knows what is now saved and can revoke it.
```


#### Codex: `home:.agents/skills/minimize-site-approvals/SKILL.md`

````skill-source home:.agents/skills/minimize-site-approvals/SKILL.md e7193b47923f6cfad90c9aa7be27c628aab10776af66073fe4654a7d9c9c459a
---
name: minimize-site-approvals
description: "Use before browsing to minimize repeated site-access requests while respecting the active host permission system."
---

# Minimize site approvals

Lineage: origin=claude; base=sha256:0457c58dd26434a2fd12c54a615d53a3be66e279154eb478e7b7023e31beba8c; adaptation=codex

Interop: role = cross-cutting; owns = choosing the least costly authorized web access; defers to = host permission rules, browser-automacao-segura, connected-service skills; honors = user language and persistent task authorization.

1. Prefer available connected-service tools for account data, public search/fetch tools for public information, and browser control for signed-in interaction or pages those tools cannot read.
2. Identify likely domains once. If the host requires site approval, batch necessary access requests and explain their scope. If access is already allowed, proceed without asking the user to approve it again.
3. Discover actual tools and read their schemas. Do not invent an access-request tool, a browser extension setting or a permission mode. Do not modify settings to reduce prompts unless explicitly requested.
4. If access is denied, do not retry in a loop or bypass the decision through shell downloads, another browser or another tool. A pending approval stays pending.
5. Read compact relevant page text and reuse verified results; avoid unnecessary screenshots and navigation. Obtain current tabs from the host rather than reusing old session identifiers.
6. Report only permissions actually requested or changed. Never claim site-wide access was saved merely because a page opened. A purchase or message send needs authorization for that action, even when site access is allowed.
````
