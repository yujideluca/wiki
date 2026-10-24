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
sources: [home:.claude/skills/brainstorming/SKILL.md]
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
