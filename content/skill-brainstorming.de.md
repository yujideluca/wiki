---
id: skill-brainstorming
lang: de
source_hash: 656049e9ed47
title: Skill: brainstorming
---

## What it is
Die Skill „brainstorming“ ist der Prozess, dem Claude folgt, bevor es etwas Neues in Software baut: Sie findet heraus, was Giovanni wirklich will und warum, bevor Code existiert. Ihre Beschreibung (der Text, der entscheidet, wann sie geladen wird) sagt: vor dem Bauen von etwas Neuem in Software oder in der claude-workflow-Pipeline verwenden (eine App-Funktion, ein Werkzeug, eine mehrstufige Änderung): klärende Fragen stellen, den Umfang einschätzen und Giovannis Freigabe einholen, bevor Code geschrieben wird. Nicht für Schreibaufgaben (Lebenslauf, Briefe, Deutschübungen), klinische Fragen oder das Erstellen von Skills ([[skill-skill-forge]]). Sie wurde aus den Open-Source-Skills „superpowers“ (Version 7.0.0, MIT-Lizenz) angepasst, ohne deren dauerhaften Start-Hook.

## What it does
Claude stellt jeweils eine offene Frage, spiegelt sein Verständnis zurück, bietet einen visuellen Begleiter an (einen Browser-Tab mit Entwürfen), wenn Sehen mehr hilft als Lesen, schätzt den Umfang ein (schnelle Aufgabe, kleine Änderung oder Projekt mit schriftlichem Entwurf), lässt einen frischen Prüfer den Entwurf lesen und blockiert das Bauen, bis Giovanni zustimmt. Seit 2026-10-22 fragt sie auch, welche Programmiersprache benutzt werden soll ([[work-ask-language]]).

## How it does it
Eine `SKILL.md` in `~/.claude/skills/brainstorming`; Claude lädt sie, wenn eine Anfrage zu ihrer Beschreibung passt. Die Rolle der Skill ist „Prozess“; sie verweist auf [[skill-skill-forge]] (neue Skills), [[skill-revisao-manutencao]] (Wartungs-Reviews sind keine Brainstormings) und die CLAUDE.md des Projekts und beachtet die Regel zur Antwortsprache sowie die Regel, jeden Begriff bei erster Verwendung zu definieren.

## Where it sits in the pipeline
Teil des Entwicklungsprozesses in Claude Code, in jedem Projekt benutzt; sie speist [[new-project]].

## Who receives its output
Giovanni (die Fragen und das Entwurfsdokument) und der anschließende Bau.

## Steps
1. **Fragen, was bekannt ist.** Vor der Antwort fragt sich Claude, was es darüber weiß, was Giovanni will und warum. Steht alles Wichtige in der Anfrage („mach das Symbol kornblumenblau“), ist es eine schnelle, klare Aufgabe: erledigen und sagen, was getan wurde. Fehlt etwas Nicht-Triviales, beginnt das Gespräch.
2. **Erste Nachricht, zwei Teile.** Eine Zeile, dass Giovanni die Fragen überspringen und Claude einfach starten lassen kann (dann ist die Skill fertig, nachdem jede wesentliche Wahl wie Plattform oder Sprache in einer schlichten Zeile genannt wurde); und eine offene Frage, die Giovanni einen echten Moment oder ein konkretes Bild beschreiben lässt.
3. **Gespräch.** Jede Nachricht endet mit einer Frage (ein Satz, keine Liste von Beispielantworten), in einfacher Sprache knapp über Giovannis Niveau. Offene Fragen kommen zuerst; kurze Auswahllisten nur, wenn Giovanni nicht weiterkommt. Bei „rate einfach“ etwas Konkretes vorschlagen.
4. **Wie es gemacht wird.** Früh herausfinden, welche Entscheidungen über Medium, Werkzeuge und Material Giovanni selbst treffen will und welche er abgibt. Jede Wahl, die Claude trifft, kommt als Claudes Entscheidung in den Entwurf. Die Programmiersprache ist nie Claudes Entscheidung: für jeden Teil (Front End, Back End, Werkzeuge) fragen, bevor der Entwurf geschrieben wird (Gedächtnis-Key `work.ask-language`).
5. **Gelände abdecken** (nie als Fragebogen vorlesen): was für eine Sache das ist und was sie besonders macht; warum jetzt und woran sich Erfolg misst; Ziele, Nicht-Ziele und Anti-Ziele; Vorbilder; der Ist-Zustand; die Details, die Giovanni wichtig sind. Gute Fragen verankern sich im Konkreten („Erzähl mir vom letzten Mal…“). Erkundung anbieten (Codebasis, Dateien oder Web ansehen) und Giovanni entscheiden lassen.
6. **Privat weit denken; zeigen statt erzählen.** Mehrere Ideen entwickeln und schwache verwerfen. Den visuellen Begleiter beim ersten Mal anbieten, wenn Sehen helfen würde (ein Bildschirm, ein Layout, ein Ablauf, ein Diagramm), als eigene Nachricht und nur einmal; bei Ablehnung im Text bleiben. Einen Wegwerf-„Spike“ (ein schnelles Experiment) anbieten, wenn er der billigste Weg zum Lernen ist.
7. **Zurückspielen.** Sobald ein Teil verstanden ist, ihn in etwa 200–300 Wörtern zurückbeschreiben, Vermutungen als Vermutungen kennzeichnen und fragen, was falsch ist oder fehlt. Zurückspielen und Fragen wechseln sich ab.
8. **Umfang einschätzen.** Die Größe in einfachen Worten sagen: eine schnelle klare Aufgabe (erledigen), eine kleine Änderung (im Chat beschreiben, dann bauen) oder ein Projekt mit schriftlichem Entwurf (ein Entwurfsdokument mit nummeriertem Plan). Wächst es, eine Stufe höher gehen; sind es eigentlich mehrere Projekte, sie ordnen und eins nach dem anderen angehen.
9. **Entwurf schreiben (nur Projekte).** Ein schlichtes Dokument, aus dem ein fähiger Bauer planen kann: Absicht und Grund, Ziele/Nicht-Ziele/Anti-Ziele, Randbedingungen, die bereits entschiedenen Teile und was dem Bauer überlassen bleibt. In einem Software-Repository ist es `docs/YYYY-MM-DD-<Thema>-design.md`, committet.
10. **Bauer-Prüfung.** Ein frischer Hilfsassistent liest das Dokument wie der Bauer. Seine Fragen werden in drei Stapel sortiert: schon beantwortet, geringfügig (Claude entscheidet und kennzeichnet es als Claudes Entscheidung) und Giovannis (in einer Nachricht gefragt, das Wichtigste zuerst). Erst dann wird das Dokument übergeben.
11. **Harte Sperre.** Nichts wird gebaut (Produktcode, Gerüst, Abhängigkeiten installieren, Projekte anlegen), bis Giovanni die vollständige Beschreibung genehmigt: im Chat bei einer kleinen Änderung, das Dokument bei einem Projekt. Ausnahmen: Giovanni hat auf die Fragen verzichtet oder einem gekennzeichneten Wegwerf-Spike zugestimmt. Nach der Genehmigung kommt der Plan, als nummerierte Liste im selben Dokument.
12. **Warnzeichen.** Optionen „zur Entlastung“ anzubieten lenkt, statt zuzuhören; unausgesprochene Standardwerte lassen sich nicht ablehnen, also laut sagen; „klingt gut“ genehmigt nur, was gezeigt wurde; einen Spike zu behalten ist eine neue Anfrage.

## Notes

### Vollständige Skill-Quellen

Die folgenden Blöcke enthalten die vollständigen ursprünglichen `SKILL.md`-Dateien einschließlich ihrer Beschreibungen und Anweisungen. Die Originale bleiben in ihrer Ausgangssprache; die Erklärung und die Schritte oben beschreiben sie in der Sprache dieser Seite. Die Fassungen für Claude und Codex sind getrennt. Zusätzliche Referenzdateien werden in den Originalen genannt, sind aber nicht Teil dieser Kopien. Jeder Fingerabdruck kennzeichnet den gesamten kopierten Text.

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

```skill-source home:.agents/skills/brainstorming/SKILL.md ffd72e9b301559d8eb0efd112e09a17ab76917de228ed4e8dc1c7f65ed339452
---
name: brainstorming
description: "Use in Codex before building something new in software or in the Codex-workflow pipeline (an app feature, a tool, a multi-step change): ask the clarifying questions, size the work and get Giovanni's go before writing code. Not for writing tasks (CV, letters, German exercises), clinical questions, or creating skills (skill-forge)."
---

# Brainstorming

Lineage: origin=code; base=none

Interop: role = process; owns = requirements and size check before a build (the size-and-fit rule); defers to = skill-forge (new or rebuilt skills), revisao-manutencao (maintenance reviews are not brainstorms), the project's AGENTS.md; honors = reply-language rule, plain-language explanations (define every term on first use).

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
