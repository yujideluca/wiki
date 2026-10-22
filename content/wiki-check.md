---
id: wiki-check
title: wiki check (content rules)
aliases: [Check, check.ex]
kind: function
project: wiki
status: active
location: wiki:server/lib/wiki/content/check.ex
fed_by: [wiki-content]
feeds: [wiki-cli]
sources: [wiki:server/lib/wiki/content/check.ex, wiki:server/lib/wiki/content/privacy.ex]
---

## What it is
Every rule a page must follow before it can be published (Elixir module `Wiki.Content.Check`).

## What it does
Header fields and kinds valid; the five sections present and non-empty; every `[[link]]`, `fed_by` and `feeds` resolves; `fed_by`/`feeds` symmetric; no orphan pages (except actors and external things); privacy scan (keys, tokens, passwords, phone numbers, e-mails other than Giovanni's); promotion (a function listed on a page and mentioned by two other pages must get its own page); a page without sources needs a review date; German and Portuguese translations exist and match the current English. `--local` also checks that sources and memory refs exist.

## How it does it
Pure functions over the loaded content; returns a sorted list of `file: problem` lines. CI runs it without `--local` because GitHub cannot see the other private repos.

## Where it sits in the pipeline
First step of `wiki publish` and part of [[wiki-quality-gate]].

## Who receives its output
[[wiki-cli]] (publish refuses on any problem).
