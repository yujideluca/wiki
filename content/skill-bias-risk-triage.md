---
id: skill-bias-risk-triage
title: Skill: bias-risk-triage
aliases: [bias-risk-triage]
kind: skill
project: skills
status: active
location: home:.claude/skills/bias-risk-triage
fed_by: []
feeds: []
sources: [home:.claude/skills/bias-risk-triage/SKILL.md]
---

## What it is
A silent pre-answer check for short factual questions.

## What it does
Looks for bias, myths, conspiracy, staleness or high stakes and sets how deeply to verify (tiers T0–T3). It sets only the minimum verification depth, never the format; domain skills such as [[skill-consulta-clinica]] keep their own format.

## How it does it
A `SKILL.md` in `~/.claude/skills/bias-risk-triage`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Before short factual answers, in any chat.

## Who receives its output
The answer that follows (its depth).
