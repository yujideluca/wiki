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
reviewed: 2026-10-24T21:59Z
---

## What it is
The validator is the privacy and format guard of the memory, whoever the writer is. Its patterns for secrets, phone numbers and CPF numbers (Cadastro de Pessoas Físicas, the Brazilian personal tax number) are kept in `mem/privacy-patterns.tsv`, the one list that the wiki's own privacy scan ([[wiki-check]]) also uses.

## What it does
It rejects tokens and keys, e-mail addresses, phone numbers, CPF numbers and malformed events. A rejected file is moved to the `quarantine/` folder with a `.reason` note and appears in the review file. There is deliberately no filter for health vocabulary (Giovanni's decision of 2026-10-19); not storing clinical data about other people is a standing rule that Claude follows, not an automatic check.

## How it does it
The function `check_event` examines one event, `load_checked` separates valid from invalid events, and `quarantine` moves the bad ones. It is tested by `test_privacy_boundary` and by the bug-finding tests in `tests/test_bughunt.py`; the token patterns include GitHub fine-grained tokens, GitLab tokens and Google API (application programming interface) keys, and phone numbers are caught in the international form too.

## Where it sits in the pipeline
Before every write by [[mem]], and on GitHub in [[mem-action]].

## Who receives its output
[[memory-fold]] (only valid events) and [[memory-views]] (the review file lists what was quarantined).
