---
id: skill-ligamagic-replicar-carrinho-nas-lojas
title: Skill: ligamagic-replicar-carrinho-nas-lojas
aliases: [ligamagic-replicar-carrinho-nas-lojas]
kind: skill
project: skills
status: active
location: home:.claude/skills/ligamagic-replicar-carrinho-nas-lojas
fed_by: [skill-ligamagic-listas]
feeds: []
sources: [home:.claude/skills/ligamagic-replicar-carrinho-nas-lojas/SKILL.md]
---

## What it is
Rebuilds LigaMagic's per-store cart on each store's own website and reconciles the two before checkout. Written in Portuguese.

## What it does
Same card, edition, language, condition, extras and quantity, without using LigaMagic's links; purchases themselves need Giovanni's approval.

## How it does it
A `SKILL.md` in `~/.claude/skills/ligamagic-replicar-carrinho-nas-lojas`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Giovanni's Magic: The Gathering hobby.

## Who receives its output
Giovanni, before paying.
