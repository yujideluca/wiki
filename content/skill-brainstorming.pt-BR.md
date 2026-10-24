---
id: skill-brainstorming
lang: pt-BR
source_hash: ed56aad52fa4
title: Skill: brainstorming
---

## What it is
A skill "brainstorming" é o processo que o Claude segue antes de construir qualquer coisa nova em software: descobre o que o Giovanni realmente quer, e por quê, antes de existir código. Sua descrição (o texto que decide quando ela é carregada) diz: usar antes de construir algo novo em software ou no pipeline claude-workflow (uma funcionalidade de app, uma ferramenta, uma mudança em várias etapas): fazer as perguntas de esclarecimento, dimensionar o trabalho e obter o "pode ir" do Giovanni antes de escrever código. Não serve para tarefas de escrita (currículo, cartas, exercícios de alemão), perguntas clínicas nem criação de skills ([[skill-skill-forge]]). Foi adaptada das skills de código aberto "superpowers" (versão 7.0.0, licença MIT), sem o hook de inicialização sempre ativo delas.

## What it does
O Claude faz uma pergunta aberta por vez, devolve o que entendeu, oferece um acompanhante visual (uma aba do navegador com esboços) quando ver ajuda mais do que ler, dimensiona o trabalho (tarefa rápida, pequena mudança ou projeto com design escrito), pede a um revisor novo que leia o design e bloqueia a construção até o Giovanni aprovar. Desde 2026-10-22 também pergunta qual linguagem de programação usar ([[work-ask-language]]).

## How it does it
Um `SKILL.md` em `~/.claude/skills/brainstorming`; o Claude o carrega quando um pedido combina com a descrição. O papel da skill é "processo"; ela remete à [[skill-skill-forge]] (skills novas), à [[skill-revisao-manutencao]] (revisões de manutenção não são brainstorms) e ao CLAUDE.md do projeto, e respeita a regra do idioma de resposta e a de definir cada termo no primeiro uso.

## Where it sits in the pipeline
Parte do processo de desenvolvimento no Claude Code, usada em todo projeto; alimenta o [[new-project]].

## Who receives its output
O Giovanni (as perguntas e o documento de design) e a construção que se segue.

## Steps
1. **Perguntar o que se sabe.** Antes de responder, o Claude se pergunta o que sabe sobre o que o Giovanni quer e por quê. Se tudo o que importa está no pedido ("deixe o ícone azul-centáurea"), é uma tarefa rápida e clara: fazer e dizer o que foi feito. Se falta algo não trivial, começar a conversa.
2. **Primeira mensagem, duas partes.** Uma linha dizendo que o Giovanni pode pular as perguntas e pedir que o Claude simplesmente comece (então a skill termina, depois de dizer em uma linha simples qualquer escolha significativa, como plataforma ou linguagem); e uma pergunta aberta que faz o Giovanni descrever um momento real ou uma imagem concreta.
3. **Conversa.** Cada mensagem termina com uma pergunta (uma frase, sem lista de exemplos de resposta), em linguagem simples, um pouco acima do nível do Giovanni. Perguntas abertas primeiro; menus curtos só quando o Giovanni estiver travado. Quando pedirem "chute", propor algo concreto.
4. **Como será feito.** Descobrir cedo quais escolhas de meio, ferramentas e materiais o Giovanni quer fazer e quais delega. Toda escolha que o Claude faz entra no design como decisão do Claude. A linguagem de programação nunca é decisão do Claude: perguntar para cada parte (front end, back end, ferramentas) antes de o design ser escrito (chave de memória `work.ask-language`).
5. **Cobrir o terreno** (nunca lido como questionário): que tipo de coisa é e o que a torna especial; por que agora e como é o sucesso; metas, não metas e antimetas; referências anteriores; o estado atual; os detalhes que importam ao Giovanni. Boas perguntas se ancoram no concreto ("Me conte da última vez que…"). Oferecer reconhecimento (olhar o código, arquivos ou a web) e deixar o Giovanni decidir.
6. **Pensar amplo em privado; mostrar em vez de contar.** Pensar em várias ideias e descartar as fracas. Oferecer o acompanhante visual na primeira vez que ver ajudaria (uma tela, um layout, um fluxo, um diagrama), como mensagem própria e só uma vez; se recusado, ficar no texto. Oferecer um "spike" descartável (um experimento rápido) quando for o jeito mais barato de aprender.
7. **Devolver o entendimento.** Assim que uma parte for entendida, descrevê-la de volta em cerca de 200–300 palavras, marcar palpites como palpites e perguntar o que está errado ou faltando. Devolução e perguntas se alternam.
8. **Dimensionar o trabalho.** Dizer o tamanho em palavras simples: uma tarefa rápida e clara (fazer), uma pequena mudança (descrever no chat e depois construir) ou um projeto com design escrito (um documento de design com plano numerado). Se crescer, subir um tamanho; se na verdade são vários projetos, ordená-los e fazer um de cada vez.
9. **Escrever o design (só projetos).** Um documento simples a partir do qual um construtor competente poderia planejar: intenção e motivo, metas/não metas/antimetas, restrições, as partes já decididas e o que fica a cargo do construtor. Num repositório de software, é `docs/AAAA-MM-DD-<assunto>-design.md`, commitado.
10. **Checagem do construtor.** Um assistente auxiliar novo lê o documento como o construtor leria. Suas perguntas são separadas em três pilhas: já respondidas, menores (o Claude resolve e marca como decisão do Claude) e do Giovanni (perguntadas em uma mensagem, a mais importante primeiro). Só então o documento é entregue.
11. **Portão rígido.** Nada é construído (código do produto, esqueleto, instalar dependências, criar projetos) até o Giovanni aprovar a descrição completa: no chat para uma pequena mudança, o documento para um projeto. Exceções: o Giovanni dispensou as perguntas ou concordou com um spike descartável rotulado. Depois da aprovação vem o plano, escrito como lista numerada no mesmo documento.
12. **Sinais de alerta.** Oferecer opções "para poupar esforço" conduz em vez de ouvir; padrões não ditos não podem ser rejeitados, então diga-os em voz alta; "parece bom" aprova só o que foi mostrado; manter um spike é um novo pedido.
