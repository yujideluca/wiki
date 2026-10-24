---
id: skill-minimize-site-approvals
lang: pt-BR
source_hash: a2b0a008490a
title: Skill: minimize-site-approvals
---

## What it is
A skill "minimize-site-approvals" é uma etapa de planejamento antes de navegar, para que o Giovanni precise clicar em "aprovar" o menor número possível de vezes. Sua descrição diz: usar antes de qualquer tarefa de navegação para reduzir cliques de aprovação de sites: planejar os domínios com antecedência, pedir acesso ao site inteiro uma vez e preferir ferramentas que não exigem aprovação. A versão do Claude Code só é editada lá; o app Claude mantém a sua ([[claude-ai-skills]]).

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
