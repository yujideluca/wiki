---
id: mem-validator
title: Validator and quarantine (validate.py)
aliases: [privacy check, quarantine]
kind: function
project: workflow-memory
status: active
location: workflow-memory:mem/validate.py
fed_by: [events-log]
feeds: []
sources: [workflow-memory:mem/validate.py]
reviewed: 2026-11-05T04:03Z
---

## What it is
The validator is the privacy and format guard of the memory, whoever the writer is. Its patterns for secrets, phone numbers and CPF numbers (Cadastro de Pessoas Físicas, the Brazilian personal tax number) are kept in `mem/privacy-patterns.tsv`, the one list that the wiki's own privacy scan ([[wiki-check]]) also uses.

## What it does
It rejects tokens and keys, e-mail addresses, phone numbers, CPF numbers and malformed events. A rejected file is moved to the `quarantine/` folder with a `.reason` note and appears in the review file. There is deliberately no filter for health vocabulary (Giovanni's decision of 2026-10-19); not storing clinical data about other people is a standing rule that Claude follows, not an automatic check.

## How it does it
The function `check_event` examines one event, `load_checked` separates valid from invalid events, and `quarantine` moves the bad ones. It is tested by `test_privacy_boundary` and by the bug-finding tests in `tests/test_bughunt.py`; the token patterns include GitHub fine-grained tokens, GitLab tokens and Google API (application programming interface) keys, and phone numbers are caught in the international form too. Since 2026-10-30 `clamp_to_now` also limits the time of every valid event to the moment it is read: a writer without a trusted clock, such as the chat app, can stamp an event a few minutes ahead, and that event must not sort after one really written later. The claimed time is kept in `ts_claimed`. It also checks tags: each must be listed in `mem/tags.toml` (the known tags), be made of lowercase letters, digits and hyphens, an event may carry at most six, and only a preference, decision or fact may have them ([[mem-rules]]).

## Where it sits in the pipeline
Before every write by [[mem]], and on GitHub in [[mem-action]].

## Who receives its output
[[memory-fold]] (only valid events) and [[memory-views]] (the review file lists what was quarantined).
