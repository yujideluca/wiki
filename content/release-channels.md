---
id: release-channels
title: Release channels: stable and beta
aliases: [beta, bleeding-edge, flavors]
kind: decision
project: quizapp
status: active
location: QuizApp:docs/adr/0005-release-channels.md
fed_by: []
feeds: [update-client]
sources: [QuizApp:docs/adr/0005-release-channels.md, QuizApp:docs/adr/0011-promote-after-updated-tests.md]
---

## What it is
A "release channel" is a separate stream of versions that people can follow. This page describes the rule that nothing reaches the player without going through the beta app first (decision ADR-0005), and when a beta may be promoted (decision ADR-0011). An ADR is an architecture decision record, a short note that keeps the reasons for a decision.

## What it does
There are two build flavors. `stable` (package `dev.yuji.quiz`, shown as "Deutsch B2") follows the `main` branch of the [[release-feed]]; `beta` (package `dev.yuji.quiz.beta`, shown as "Deutsch B2 beta") follows the `bleeding-edge` branch. Because the packages differ, both can be installed on the phone at the same time. A beta becomes eligible for promotion once it has survived the automated tests that were updated for what it changes; after that, Giovanni decides.

## How it does it
It is enforced by [[publish-apk]]: its `promote` runs the gate with the [[mutation-check]] and [[check-tests-updated]]. Web ports wait on a branch `web-<version>` of [[quizweb]] until the promotion.

## Where it sits in the pipeline
It governs the [[quizapp-release]].

## Who receives its output
The [[update-client]], which learns which branch to follow.
