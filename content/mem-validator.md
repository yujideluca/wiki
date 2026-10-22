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
---

## What it is
The privacy and format guard of the memory, whoever the writer is.

## What it does
Rejects tokens and keys, e-mail addresses, phone numbers and CPF numbers, and malformed events. Rejected files move to `quarantine/` with a `.reason` note and appear in REVIEW. There is deliberately no health-vocabulary filter (Giovanni's decision, 2026-10-19); not storing clinical data about other people is a standing rule, not an automatic check.

## How it does it
`check_event` per event; `load_checked` splits valid from invalid; `quarantine` moves the bad ones. Tested by `test_privacy_boundary`.

## Where it sits in the pipeline
Before every write by [[mem]], and on GitHub in [[mem-action]].

## Who receives its output
[[memory-fold]] (only valid events) and [[memory-views]] (REVIEW lists the quarantined).
