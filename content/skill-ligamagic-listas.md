---
id: skill-ligamagic-listas
title: Skill: ligamagic-listas
aliases: [ligamagic-listas]
kind: skill
project: skills
status: active
location: home:.claude/skills/ligamagic-listas
fed_by: []
feeds: [skill-ligamagic-replicar-carrinho-nas-lojas]
sources: [home:.claude/skills/ligamagic-listas/SKILL.md]
---

## What it is
Working with LigaMagic's shopping list (Lista de Compras / Compra por Lista), the Brazilian Magic card marketplace. Written in Portuguese.

## What it does
Extracts cards, generates lists with edition, removes or edits items in batch.

## How it does it
A `SKILL.md` in `~/.claude/skills/ligamagic-listas`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Giovanni's Magic: The Gathering hobby.

## Who receives its output
Giovanni's LigaMagic lists, and [[skill-ligamagic-replicar-carrinho-nas-lojas]] for the per-store carts.
