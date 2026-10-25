---
id: skill-brainstorming
title: Skill: brainstorming
aliases: [brainstorming]
kind: skill
project: skills
status: active
location: home:.claude/skills/brainstorming
fed_by: []
feeds: [new-project]
sources: [home:.claude/skills/brainstorming/SKILL.md, home:.agents/skills/brainstorming/SKILL.md]
reviewed: 2026-10-25T20:41Z
---

## What it is
The skill "brainstorming" is the process Claude follows before it builds anything new in software: it finds out what Giovanni actually wants, and why, before any code exists. Its description (the text that decides when it is loaded) says: use it before building something new in software or in the claude-workflow pipeline (an app feature, a tool, a multi-step change): ask the clarifying questions, size the work and get Giovanni's go before writing code. It is not for writing tasks (a CV, letters, German exercises), clinical questions, or creating skills ([[skill-skill-forge]]). It was adapted from the open-source "superpowers" skills (version 7.0.0, MIT licence), without their always-on startup hook.

## What it does
Claude asks one open question at a time, plays its understanding back, offers a visual companion (a browser tab with mockups) when seeing helps more than reading, sizes the work (quick task, small change, or project with a written design), has a fresh reviewer read the design, and blocks building until Giovanni approves. Since 2026-10-22 it also asks which programming language to use ([[work-ask-language]]).

## How it does it
A `SKILL.md` in `~/.claude/skills/brainstorming`; Claude loads it when a request matches its description. The skill's role is "process", it defers to [[skill-skill-forge]] (new skills), [[skill-revisao-manutencao]] (maintenance reviews are not brainstorms) and the project's CLAUDE.md, and it honours the reply-language rule and the rule to define every term on first use.

## Where it sits in the pipeline
Part of the development process in Claude Code, used in every project; it feeds [[new-project]].

## Who receives its output
Giovanni (the questions and the design document) and the build that follows.

## Steps
1. **Ask what is known.** Before replying, Claude asks itself what it knows about what Giovanni wants and why. If everything that matters is in the request ("make the icon cornflower blue"), it is a quick, clear task: do it and say what was done. If something non-trivial is missing, start the conversation.
2. **First message, two parts.** One line saying that Giovanni may skip the questions and have Claude just start (then the skill is done, after stating any significant choice such as platform or language in one plain line); and one open question that gets Giovanni describing a real moment or a concrete picture.
3. **Conversation.** Each message ends with one question (one sentence, no list of example answers), in plain language slightly above Giovanni's level. Open questions come first; short menus only when Giovanni is stuck. When asked to "just guess", propose something concrete.
4. **How it gets made.** Find out early which choices of medium, tools and materials Giovanni wants to make and which are handed over. Any choice Claude makes goes into the design as Claude's call. The programming language is never Claude's call: ask for each part (front end, back end, tools) before the design is written (memory key `work.ask-language`).
5. **Cover the ground** (never read out as a questionnaire): what kind of thing this is and what makes it special; why now and what success looks like; goals, non-goals and anti-goals; prior art; the current state; the details Giovanni cares about. Good questions anchor in specifics ("Walk me through the last time…"). Offer reconnaissance (looking at the codebase, files or the web) and let Giovanni decide.
6. **Think wide privately; show, don't tell.** Come up with several ideas and drop the weak ones. Offer the visual companion the first time seeing would help (a screen, a layout, a flow, a diagram), as its own message, and only once; if declined, stay in text. Offer a throwaway "spike" (a quick experiment) when it is the cheapest way to learn.
7. **Play it back.** As soon as one part is understood, describe it back in about 200–300 words, mark guesses as guesses, and ask what is wrong or missing. Playback and questions alternate.
8. **Size the work.** Say the size in plain words: a quick clear task (do it), a small change (describe it in chat, then build), or a project with a written design (a design document with a numbered plan). If it grows, step up a size; if it is really several projects, order them and do one at a time.
9. **Write the design (projects only).** A plain document a skilled builder could plan from: intent and why, goals/non-goals/anti-goals, constraints, the parts already decided, and what is left to the builder. In a software repository it is `docs/YYYY-MM-DD-<topic>-design.md`, committed.
10. **Builder check.** A fresh sub-assistant reads the document as the builder would. Its questions are sorted into three piles: answered already, minor (Claude settles it and marks it as Claude's call) and Giovanni's (asked in one message, most important first). Only then is the document handed over.
11. **Hard gate.** Nothing is built (product code, scaffolding, installing dependencies, creating projects) until Giovanni approves the full description: in chat for a small change, the document for a project. Exceptions: Giovanni opted out of the questions, or agreed to a labelled throwaway spike. After approval comes the plan, written as a numbered list in the same document.
12. **Red flags.** Offering options to "save effort" steers instead of listening; unspoken defaults cannot be rejected, so say them out loud; "sounds good" approves only what was shown; keeping a spike is a new request.

## Notes

Codex now uses the independently maintained version in [[codex-skills]]. Its complete source below includes the Codex-specific execution rules; the Claude procedure above remains the Claude version. Browser, memory and connector behavior can differ between versions.

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

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
