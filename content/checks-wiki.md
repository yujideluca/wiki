---
id: checks-wiki
title: Wiki: checkers and rules
aliases: [wiki checks, wiki gate]
kind: decision
project: wiki
status: active
fed_by: []
feeds: []
sources: [wiki:tools/quality_gate.sh, wiki:pipeline-check.toml, wiki:CLAUDE.md, wiki:docs/REQUIREMENTS.md, wiki:.github/workflows/quality-gate.yml]
reviewed: 2026-11-06T21:25Z
---

## What it is
These are the checkers of the [[wiki]], the site you are reading. It is written in Elixir (back end) and Elm (front end), and it is the project with the most content rules.

## What it does
The gate has five steps: (1) Elixir tests (checker, build, staleness, hook, publish, login gate, decoy); (2) Elm tests and an optimized Elm build; (3) requirement traceability with the committed matrix; (4) `wiki check` on the real content, after comparing the privacy-pattern file with the one in workflow-memory; (5) fitness limits: no Elixir or Elm file over 800 lines, the compressed Elm bundle (`app.js`) at most 200,000 bytes, the gate at most 1200 seconds.

`wiki check` ([[wiki-check]]) enforces: required header fields and five sections on every page; links and the symmetry of `fed_by` and `feeds`; orphan pages; the privacy scan ([[security-layers]]); promotion of a function mentioned by two pages to its own page; a `reviewed` time that is not in the future; sources that exist; acronym spelled out at first use; `Steps` on skill pages; the complete `SKILL.md` copy with its SHA-256 (Secure Hash Algorithm 256) fingerprint on skill pages; a Flow chart on actor, project, process and skill pages; Architecture and Engineering practices on project pages; and English only (a translation file such as `<id>.de.md` is refused). The access rules AU-1 to AU-6 and DC-1 are tests in `server/test/router_test.exs` and `decoy_test.exs`.

## How it does it
CI (continuous integration) runs the gate in `ci` mode, which skips the checks that need other private repositories ([[wiki-quality-gate]]). The job `gate` is a required check on `main`. Publishing uses `wiki publish`, which refuses on any `wiki check` problem ([[wiki-cli]]).

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
