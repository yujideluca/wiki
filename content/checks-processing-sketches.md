---
id: checks-processing-sketches
title: processing-sketches: checkers and rules
aliases: [processing-sketches checks, sketches gate]
kind: decision
project: processing-sketches
status: active
fed_by: []
feeds: []
sources: [processing-sketches:tools/quality_gate.sh, processing-sketches:pipeline-check.toml, processing-sketches:.github/workflows/quality-gate.yml]
reviewed: 2026-11-02T10:44Z
---

## What it is
These are the checkers of [[processing-sketches]], a folder of drawings written for the Processing environment ([[drachenkurve]] and [[drachenfraktal]]). It is the smallest project.

## What it does
The gate does two things: every sketch folder `name/` must contain `name/name.pde` (the file Processing expects), and no file under a `build/` folder may be tracked by git. Limits: the gate at most 300 seconds. There is no test suite, no requirement list and no mutation check.

## How it does it
CI (continuous integration) runs `pipeline-check --mode ci` (20 minutes at most); `pipeline-check.toml` names the repository and the required job `gate`, and the wiki records the protection as active ([[maintenance-pipeline]]).

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
