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
The rule that nothing reaches the player without the beta app first (ADR-0005), and when a beta may be promoted (ADR-0011).

## What it does
Two build flavors: `stable` (`dev.yuji.quiz`, "Deutsch B2", follows `main` of [[release-feed]]) and `beta` (`dev.yuji.quiz.beta`, "Deutsch B2 beta", follows `bleeding-edge`). A beta becomes eligible once it survives the automated tests updated for what it changes; then Giovanni decides.

## How it does it
Enforced by [[publish-apk]] (`promote` runs the gate with [[mutation-check]] and [[check-tests-updated]]). Web ports wait on a `web-<version>` branch of [[quizweb]] until promotion.

## Where it sits in the pipeline
Governs [[quizapp-release]].

## Who receives its output
[[update-client]] (which branch to follow).
