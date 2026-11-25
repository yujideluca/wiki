---
id: task-delegation
title: Task delegation by cost (who does which step)
aliases: [delegation, cheap instances, token saving, work.token-thrift]
kind: process
project: laptop-setup
status: active
location: home:.claude/CLAUDE.md
fed_by: []
feeds: []
sources: [home:.claude/CLAUDE.md, home:.claude/settings.json, workflow-memory:docs/adr/0010-briefings-before-full-text.md]
memory: [b62cf5]
reviewed: 2026-11-25T17:36Z
---

## What it is
Task delegation by cost is the rule by which [[claude-code]] decides who does each step of a task, so that simple work is not done by the most expensive worker. The workers are language models of three sizes (Haiku is the smallest and cheapest, Sonnet the middle one, Opus and Fable the largest) and, cheapest of all, a plain script that needs no model. Cost is counted in tokens: a token is the unit in which a model reads and writes text, about four characters.

## Flow
trigger t1: A step of a task has to be done | [[claude-code]]
decide d1: Is the step fixed, the same every time it is done?
step s1: A script or command does it; no model reads anything
decide d2: Is it finding or shortening: a search, logs, web pages, a summary?
step s2: A helper session on the smallest model does it, from a short brief
decide d3: Is there a clear written description of the work and of what done means?
step s3: A helper session on the middle model does it, from a short brief | [[claude-code-settings]]
step s4: The main session does it itself: design, causes, medical facts, judgement
step s5: The main session checks the result itself before reporting it
product p1: The step is done by the cheapest worker able to do it | [[token-thrift]]

t1 -> d1
d1 -yes-> s1
d1 -no-> d2
d2 -yes-> s2
d2 -no-> d3
d3 -yes-> s3
d3 -no-> s4
s1 -> s5
s2 -> s5
s3 -> s5
s5 -> p1
s4 -> p1

## What it does
It sorts every step into one of four levels and gives it to the cheapest level that can do it. Level 1 is a fixed, repeatable step, done by a script or command. Level 2 is finding or shortening information (a search, reading logs or web pages, a summary), done by a subagent on Haiku; a subagent is a helper session that the main session starts for one job. Level 3 is work that follows a clear written description (routine code, tests, wiki pages, reviews by checklist), done by a subagent on Sonnet. Level 4 is work that needs judgement (design, finding the cause of a problem, medical facts), done by the main session, or by a subagent on a large model when the reason is stated.

It also limits what every worker has to read. The context is all the text a session carries: instructions, rules, the conversation so far and every file it opened. The model reads the whole context again at each step, so a long session pays for its history many times. The rule therefore says: read a briefing before any full text ([[mem-rules]]), read only the part of a file the task needs, and end the session when its topic is finished.

## How it does it
The rule is written in `~/.claude/CLAUDE.md`, the instruction file Claude Code loads in every session, and in the memory rule `work.token-thrift` ([[workflow-memory]]). Two parts do not depend on the model remembering them, because they are settings ([[claude-code-settings]]): a subagent started without a named model runs on Sonnet, and a session whose context reaches 150,000 tokens has its older part replaced by a summary. A subagent receives a brief (the goal, the files, what done means) and never the whole conversation.

The rule comes from a measurement of 2026-11-22 over 14 days of session records (21,788 calls to a model). The average call carried 149,000 tokens of context, and 86 % of the cost was in calls that carried more than 100,000. Subagents spent 39 % of the cost, most of it on the two largest models. Storing a large context again after a pause of more than about one hour, when the stored copy has expired, cost 14.5 %. Two earlier savings (2026-10-26 and 2026-11-07) had shortened only the text printed at the start of a session, which is under 2 % of an average call, because nothing measured the total. The program [[token-thrift]] now reports the total, so a saving is judged by it.

## Where it sits in the pipeline
Inside every Claude Code session, each time the main session is about to do a step or start a helper.

## Who receives its output
Giovanni, as lower token use for the same work, visible in the report of [[token-thrift]].

## Steps
1. The main session of [[claude-code]] reads the request and loads the briefing of the rules for its kind of task ([[mem-rules]]).
2. For each step it asks the three questions of the flow above, in that order, and picks the first level that fits.
3. For level 2 or 3 it writes a brief (goal, files, what done means) and starts the subagent; for level 2 it names the model `haiku`, for level 3 it names none and the setting gives Sonnet.
4. It checks the returned result itself before using or reporting it.
5. When the topic is finished, it records what is still open in [[workflow-memory]] and tells Giovanni that clearing the session (`/clear`) is now cheaper than continuing.
