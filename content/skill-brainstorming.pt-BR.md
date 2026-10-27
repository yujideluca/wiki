---
id: skill-brainstorming
lang: pt-BR
source_hash: 2a9b73b92e57
title: Skill: brainstorming
---

## What it is
A skill "brainstorming" é o processo que o Claude segue antes de construir qualquer coisa nova em software: descobre o que o Giovanni realmente quer, e por quê, antes de existir código. Sua descrição (o texto que decide quando ela é carregada) diz: usar antes de construir algo novo em software ou no pipeline claude-workflow (uma funcionalidade de app, uma ferramenta, uma mudança em várias etapas): fazer as perguntas de esclarecimento, dimensionar o trabalho e obter o "pode ir" do Giovanni antes de escrever código. Não serve para tarefas de escrita (currículo, cartas, exercícios de alemão), perguntas clínicas nem criação de skills ([[skill-skill-forge]]). Foi adaptada das skills de código aberto "superpowers" (versão 7.0.0, licença MIT), sem o hook de inicialização sempre ativo delas.

## Flow
trigger t1: Antes de construir algo novo em software: funcionalidade, ferramenta, mudança em várias etapas | [[giovanni]]
decide d1: Tudo o que importa já está no pedido?
step s1: Faz e diz o que foi feito
step s2: Primeira mensagem: ele pode pular as perguntas; mais uma pergunta aberta
step s3: Uma pergunta por vez, em linguagem simples; repete as respostas dele
step s4: Dimensiona o trabalho: tarefa rápida, pequena mudança ou projeto
decide d2: É um projeto?
step s5: Escreve o documento de design; um revisor novo o lê | [[new-project]]
step s6: Portão rígido: nada é construído até o Giovanni dar o aval
product p1: Uma tarefa rápida, feita
product p2: Um design escrito que o Giovanni pode aprovar
product p3: O aval do Giovanni para construir

t1 -> d1
d1 -sim-> s1
d1 -não-> s2
s1 -> p1
s2 -> s3
s3 -> s4
s4 -> d2
d2 -sim-> s5
d2 -não-> s6
s5 -> p2
s5 -> s6
s6 -> p3

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

## Notes

O Codex agora usa a versão mantida separadamente em [[codex-skills]]. A fonte completa abaixo contém as regras de execução do Codex; o procedimento Claude acima continua sendo a versão Claude. Navegador, memória e conexões podem funcionar de formas diferentes.

### Fontes completas da skill

Os blocos abaixo contêm os arquivos `SKILL.md` originais completos, incluindo todas as descrições e instruções. Os originais mantêm seu idioma de origem; a explicação e os passos acima os descrevem no idioma desta página. As versões do Claude e do Codex ficam separadas. Arquivos auxiliares são citados nos originais, mas não estão incluídos nestas cópias. Cada impressão digital identifica o texto inteiro que foi copiado.

#### Claude: `home:.claude/skills/brainstorming/SKILL.md`

```skill-source home:.claude/skills/brainstorming/SKILL.md b5dd965f2ad0d20bb9c0bb057f7f79ede0412be6dda32421efffe878f4e3b5d2
---
name: brainstorming
description: "Use in Claude Code before building something new in software or in the claude-workflow pipeline (an app feature, a tool, a multi-step change): ask the clarifying questions, size the work and get Giovanni's go before writing code. Not for writing tasks (CV, letters, German exercises), clinical questions, or creating skills (skill-forge)."
---

# Brainstorming

Lineage: origin=code; base=none

Interop: role = process; owns = requirements and size check before a build (the size-and-fit rule); defers to = skill-forge (new or rebuilt skills), revisao-manutencao (maintenance reviews are not brainstorms), the project's CLAUDE.md; honors = reply-language rule, plain-language explanations (define every term on first use).

Adapted from obra/superpowers 7.0.0 (commit bb92a77, MIT, LICENSE in this folder), without its always-on startup hook.

You are very good at building. You build what you believe your human
partner wants, and that belief is usually thinner than it feels. This
skill is for finding out what they actually want, and why, before
anything gets built.

People often haven't finished working out what they want. Good questions
help them think it through. When you understand the why, you make the
hundred decisions they never mention the way they would have made them.

## First: What Do You Actually Know?

Before you reply, ask yourself: what do I know about what they want, and
why?

- **Everything that matters is in the request** ("make the icon cornflower
  blue"). This is a quick, clear task. Do it, and say what you did.
- **Something non-trivial is missing.** Start the conversation.

## Your First Message

Your first message is two things, in this order:

1. One line letting them know that if they'd rather skip the questions and
   have you just start, they can say so. If they take you up on it, this
   skill is done: state any significant how-it-gets-made choice
   (platform, language, medium) in one plain line, then do what they
   asked through the normal workflow.
2. One open question that gets them describing. Ask about a real moment
   or a concrete picture: "What's the moment you find yourself wishing
   this existed?" or "Tell me about the people who'll be in the room."

That's the whole message.

## The Conversation

Each message ends with one question: a single sentence with no list of
example answers hanging off it. Use plain language, pitched just a little
above where your human partner is. Match their vocabulary; never use
process jargon.

Be clear and concise. Lead with what matters. Avoid jargon. When you
report what you found, give them the most important findings and offer
the rest.

**Get them describing.** Open questions come first. Their own words carry
intent that your options can't. Offer a short menu only when they're
stuck. When they say "just guess" or "what do you think?", propose
something concrete.

**How it gets made.** Every project rests on choices about medium, tools,
materials, and resources: the platform, programming language, and
libraries for an app; the medium for a piece of art. Find out early which
of those choices they want to make, which they're handing to you, and what
they already have to work with. Someone with strong views or skills will
want to talk it through. Someone counting on you needs sensible defaults,
said in plain words. When there's existing work, build on what it already
uses. Any choice you make goes in the design as your call, never as
something they agreed to.

**Programming language is never your call (Giovanni's rule, memory key
`work.ask-language`).** For any project that involves code, ask which
language(s) to use for each part (front end, back end, tools) early, before
the design is written.

**Ground to cover.** This is territory, not a script. Never read these
out as questions:

- what kind of thing this is, and what makes it special
- why now, and what success looks like to them
- goals, non-goals, and anti-goals (what would make this a failure even
  if it technically works)
- prior art: what they've seen elsewhere, loved or hated
- current state: what exists now, what they've tried
- the details they care about

**Questions that work** anchor in specifics: "Walk me through the last
time...", "If it could only do one of these well, which?", "What would
make you wince if I got it wrong?" A guess they can correct ("I'm
guessing this is because X keeps biting you?") often beats a question.

**Offer recon.** Once you have a bit of grounding and looking would help,
offer to go look: their codebase or project, their own files and data,
or the web. Say what you'd look for. They decide whether you go.

**Think wide privately.** Before you propose anything, come up with
several ideas and drop the weak ones, including any that fight what
they've told you about why. Show the comparison only when it helps them
decide.

**Show, don't tell.** Offer the visual companion (below) whenever seeing
would help more than reading:

- something they'll look at: a screen, a page, a printout, a sign
- a layout or arrangement: of a screen, a room, a schedule
- a flow or a sequence of steps
- options that would look different from each other
- a structure that's easier to see than read: a diagram, a timeline, a map

Once they've accepted, use it for mockups to react to, side-by-side
options, and throwaway prototypes they can click.

**Spike to feel things out.** Agentic work is waterfall, but very, very
fast. A quick throwaway build is often the cheapest way to learn what
they want or whether something works. Offer one when it would help.
When they just want to spike, get out of the way. Spikes get no tests
or minimal ones, aren't bulletproof, and skip the plan, implementation,
and review process. Bring what the spike taught you back into the
conversation.

## Play It Back

Play back as you go. As soon as you understand one part well enough to
describe it (what it's for and who it serves, say, or how one piece
behaves), describe that part back in about 200-300 words, then return to
questions about the next part. Playback and questions alternate through
the whole conversation; the last chunk covers whatever is left.

Mark anything you're guessing as your guess; only what they said goes in
as theirs. End each chunk by asking what's wrong or missing.

Before you send a chunk, check it: does it describe something they'll
look at, like a page, a screen, a schedule, or a printout? If so, and
they haven't seen the visual companion offer yet, send the offer instead
(its own message, below) and hold the chunk for the next message. Once
they've accepted, put a mockup next to the description.

## Size the Work

Once you understand what they want, pick a size and say it in plain
words. They can override it.

| Size | The full description | Then |
|------|----------------------|------|
| A quick, clear task | the request itself | do it |
| A small change | in chat | build it through the normal workflow |
| A project with a written design | a written design document | a full plan, written as a numbered step list in the design document |

If it grows mid-task, stop, say so, and step up a size.

If this is really several independent projects, say so, agree on an
order, and brainstorm them one at a time.

## The Written Design

For a project, write a plain document a talented builder in the domain
could plan from without going back to your human partner. Cover:

- intent and the why
- goals, non-goals, anti-goals
- constraints
- the parts of the how they decided, as they decided them
- what's left to the builder

**Where it goes:** in a software repo,
`docs/YYYY-MM-DD-<topic>-design.md` in the project, committed.
Otherwise, ask. Your human partner's preferences override both.

**Builder check:** dispatch a fresh subagent with
`builder-check-prompt.md` in this directory. When you tell your human
partner you're writing it up, say a reviewer will read it first and you
may come back once with a few questions. Don't hand over the document
until the check is back. Sort what the builder asks into three piles:

- **Answered already** by the conversation or the project: put the answer
  in the document.
- **Minor:** a sensible builder could settle it without changing what gets
  built. Settle it yourself and mark it in the document as your call.
- **Theirs:** only your human partner can answer it, and the answer changes
  what gets built.

Bring the "theirs" pile in one message, most important first. Update the
document with their answers, then hand it over with a short list of the
calls you made so they can check those while reading. That's the only
round of questions the check produces. Without a subagent tool, read the
document as that builder yourself.

<HARD-GATE>
Nothing gets built until your human partner approves the full
description: in chat for a small change, the document for a project.
Building includes writing product code, scaffolding, installing
dependencies, creating projects, and invoking an implementation skill.
Reading and exploring are fine.

Two exceptions. If they opted out of the questions, the skill is done
and the gate goes with it. A spike they said yes to may be built; it
stays labeled throwaway, and keeping what it produced is a new request
that comes back through this gate.

After a project's document is approved, the next step is the plan. For
software, write it as a numbered step list in the same document and show it to Giovanni.
</HARD-GATE>

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll offer options to save them effort" | Options steer. Ask them to describe it first. |
| "I'll fill in sensible defaults" | Good. Say them out loud. A default they never heard is one they couldn't reject. |
| "I should explain the process first" | Ask your question. The process shows itself. |
| "They said 'sounds good' to the idea" | Approval covers what you showed them. A description you haven't written isn't approved. |
| "The spike works, I'll keep building on it" | Keeping it is a new request. Back through the gate. |

## Visual Companion

A browser tab for showing mockups, diagrams, and prototypes. It's a
tool, not a mode: accepting it doesn't send every question to the
browser.

**Offer it just-in-time.** Offer it the first time one of the moments
above comes up, never upfront. The offer is its own message with nothing
else in it:

> "This might be easier if I show you. Want me to open a browser tab with some mockups?"

If they decline, stay in text and don't offer again unless they raise it.

**Per question, ask: would they understand this better by seeing it?**
Mockups, layouts, diagrams, and side-by-side designs go in the browser.
Requirements, scope, tradeoffs, and conceptual choices stay in text. A
question about a UI topic isn't automatically a visual question.

If they accept, read `visual-companion.md` in this directory before
starting the server.
```


#### Codex: `home:.agents/skills/brainstorming/SKILL.md`

````skill-source home:.agents/skills/brainstorming/SKILL.md d281dc30e0962bb22d9365d57c5d88e2f53e726b0cc84559337b4df179ddd41e
---
name: brainstorming
description: "Use in Codex before building something new in software or in the Codex workflow pipeline (an app feature, a tool, a multi-step change): ask the clarifying questions, size the work and get Giovanni's go before writing code. Not for writing tasks (CV, letters, German exercises), clinical questions, or creating skills (skill-forge)."
---

# Brainstorming

Lineage: origin=claude; base=sha256:b5dd965f2ad0d20bb9c0bb057f7f79ede0412be6dda32421efffe878f4e3b5d2; adaptation=codex

Interop: role = process; owns = requirements and size check before a build (the size-and-fit rule); defers to = skill-forge (new or rebuilt skills), revisao-manutencao (maintenance reviews are not brainstorms), the project's AGENTS.md (or CLAUDE.md when it is the existing project guide); honors = reply-language rule, plain-language explanations (define every term on first use).

Adapted from obra/superpowers 7.0.0 (commit bb92a77, MIT, LICENSE in this folder), without its always-on startup hook.

You are very good at building. You build what you believe your human
partner wants, and that belief is usually thinner than it feels. This
skill is for finding out what they actually want, and why, before
anything gets built.

People often haven't finished working out what they want. Good questions
help them think it through. When you understand the why, you make the
hundred decisions they never mention the way they would have made them.

## First: What Do You Actually Know?

Before you reply, ask yourself: what do I know about what they want, and
why?

- **Everything that matters is in the request** ("make the icon cornflower
  blue"). This is a quick, clear task. Do it, and say what you did.
- **Something non-trivial is missing.** Start the conversation.

## Your First Message

Your first message is two things, in this order:

1. One line letting them know that if they'd rather skip the questions and
   have you just start, they can say so. If they take you up on it, this
   skill is done: state any significant how-it-gets-made choice
   (platform, language, medium) in one plain line, then do what they
   asked through the normal workflow.
2. One open question that gets them describing. Ask about a real moment
   or a concrete picture: "What's the moment you find yourself wishing
   this existed?" or "Tell me about the people who'll be in the room."

That's the whole message.

## The Conversation

Each message ends with one question: a single sentence with no list of
example answers hanging off it. Use plain language, pitched just a little
above where your human partner is. Match their vocabulary; never use
process jargon.

Be clear and concise. Lead with what matters. Avoid jargon. When you
report what you found, give them the most important findings and offer
the rest.

**Get them describing.** Open questions come first. Their own words carry
intent that your options can't. Offer a short menu only when they're
stuck. When they say "just guess" or "what do you think?", propose
something concrete.

**How it gets made.** Every project rests on choices about medium, tools,
materials, and resources: the platform, programming language, and
libraries for an app; the medium for a piece of art. Find out early which
of those choices they want to make, which they're handing to you, and what
they already have to work with. Someone with strong views or skills will
want to talk it through. Someone counting on you needs sensible defaults,
said in plain words. When there's existing work, build on what it already
uses. Any choice you make goes in the design as your call, never as
something they agreed to.

**Programming language is never your call (Giovanni's rule, memory key
`work.ask-language`).** For any project that involves code, ask which
language(s) to use for each part (front end, back end, tools) early, before
the design is written.

**Ground to cover.** This is territory, not a script. Never read these
out as questions:

- what kind of thing this is, and what makes it special
- why now, and what success looks like to them
- goals, non-goals, and anti-goals (what would make this a failure even
  if it technically works)
- prior art: what they've seen elsewhere, loved or hated
- current state: what exists now, what they've tried
- the details they care about

**Questions that work** anchor in specifics: "Walk me through the last
time...", "If it could only do one of these well, which?", "What would
make you wince if I got it wrong?" A guess they can correct ("I'm
guessing this is because X keeps biting you?") often beats a question.

**Offer recon.** Once you have a bit of grounding and looking would help,
offer to go look: their codebase or project, their own files and data,
or the web. Say what you'd look for. They decide whether you go.

**Think wide privately.** Before you propose anything, come up with
several ideas and drop the weak ones, including any that fight what
they've told you about why. Show the comparison only when it helps them
decide.

**Show, don't tell.** Offer the visual companion (below) whenever seeing
would help more than reading:

- something they'll look at: a screen, a page, a printout, a sign
- a layout or arrangement: of a screen, a room, a schedule
- a flow or a sequence of steps
- options that would look different from each other
- a structure that's easier to see than read: a diagram, a timeline, a map

Once they've accepted, use it for mockups to react to, side-by-side
options, and throwaway prototypes they can click.

**Spike to feel things out.** Agentic work is waterfall, but very, very
fast. A quick throwaway build is often the cheapest way to learn what
they want or whether something works. Offer one when it would help.
When they just want to spike, get out of the way. Spikes get no tests
or minimal ones, aren't bulletproof, and skip the plan, implementation,
and review process. Bring what the spike taught you back into the
conversation.

## Play It Back

Play back as you go. As soon as you understand one part well enough to
describe it (what it's for and who it serves, say, or how one piece
behaves), describe that part back in about 200-300 words, then return to
questions about the next part. Playback and questions alternate through
the whole conversation; the last chunk covers whatever is left.

Mark anything you're guessing as your guess; only what they said goes in
as theirs. End each chunk by asking what's wrong or missing.

Before you send a chunk, check it: does it describe something they'll
look at, like a page, a screen, a schedule, or a printout? If so, and
they haven't seen the visual companion offer yet, send the offer instead
(its own message, below) and hold the chunk for the next message. Once
they've accepted, put a mockup next to the description.

## Size the Work

Once you understand what they want, pick a size and say it in plain
words. They can override it.

| Size | The full description | Then |
|------|----------------------|------|
| A quick, clear task | the request itself | do it |
| A small change | in chat | build it through the normal workflow |
| A project with a written design | a written design document | a full plan, written as a numbered step list in the design document |

If it grows mid-task, stop, say so, and step up a size.

If this is really several independent projects, say so, agree on an
order, and brainstorm them one at a time.

## The Written Design

For a project, write a plain document a talented builder in the domain
could plan from without going back to your human partner. Cover:

- intent and the why
- goals, non-goals, anti-goals
- constraints
- the parts of the how they decided, as they decided them
- what's left to the builder

**Where it goes:** in a software repo,
`docs/YYYY-MM-DD-<topic>-design.md` in the project, committed.
Otherwise, ask. Your human partner's preferences override both.

**Builder check:** dispatch a fresh subagent with
`builder-check-prompt.md` in this directory. When you tell your human
partner you're writing it up, say a reviewer will read it first and you
may come back once with a few questions. Don't hand over the document
until the check is back. Sort what the builder asks into three piles:

- **Answered already** by the conversation or the project: put the answer
  in the document.
- **Minor:** a sensible builder could settle it without changing what gets
  built. Settle it yourself and mark it in the document as your call.
- **Theirs:** only your human partner can answer it, and the answer changes
  what gets built.

Bring the "theirs" pile in one message, most important first. Update the
document with their answers, then hand it over with a short list of the
calls you made so they can check those while reading. That's the only
round of questions the check produces. Without a subagent tool, read the
document as that builder yourself.

<HARD-GATE>
Nothing gets built until your human partner approves the full
description: in chat for a small change, the document for a project.
Building includes writing product code, scaffolding, installing
dependencies, creating projects, and invoking an implementation skill.
Reading and exploring are fine.

Two exceptions. If they opted out of the questions, the skill is done
and the gate goes with it. A spike they said yes to may be built; it
stays labeled throwaway, and keeping what it produced is a new request
that comes back through this gate.

After a project's document is approved, the next step is the plan. For
software, write it as a numbered step list in the same document and show it to Giovanni.
</HARD-GATE>

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll offer options to save them effort" | Options steer. Ask them to describe it first. |
| "I'll fill in sensible defaults" | Good. Say them out loud. A default they never heard is one they couldn't reject. |
| "I should explain the process first" | Ask your question. The process shows itself. |
| "They said 'sounds good' to the idea" | Approval covers what you showed them. A description you haven't written isn't approved. |
| "The spike works, I'll keep building on it" | Keeping it is a new request. Back through the gate. |

## Visual Companion

A browser tab for showing mockups, diagrams, and prototypes. It's a
tool, not a mode: accepting it doesn't send every question to the
browser.

**Offer it just-in-time.** Offer it the first time one of the moments
above comes up, never upfront. The offer is its own message with nothing
else in it:

> "This might be easier if I show you. Want me to open a browser tab with some mockups?"

If they decline, stay in text and don't offer again unless they raise it.

**Per question, ask: would they understand this better by seeing it?**
Mockups, layouts, diagrams, and side-by-side designs go in the browser.
Requirements, scope, tradeoffs, and conceptual choices stay in text. A
question about a UI topic isn't automatically a visual question.

If they accept, read `visual-companion.md` in this directory before
starting the server.


## Codex execution

Use the actual tools exposed in this session and read their schemas before calling them. Discover deferred capabilities through the tool catalog; missing tools are a reported limitation, never an invented call. Current user instructions and host tool documentation take precedence. Domain skills own the answer format; cross-cutting skills set minimum verification and interaction requirements. Claude permissions, subscriptions and scheduled jobs do not transfer.
````
