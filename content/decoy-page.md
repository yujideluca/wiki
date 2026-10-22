---
id: decoy-page
title: Decoy page
aliases: [decoy, psychedelic graph]
kind: function
project: wiki
status: active
location: wiki:server/priv/decoy.html
fed_by: [wiki-router]
feeds: []
sources: [wiki:server/priv/decoy.html]
---

## What it is
What anyone who is not logged in sees: a psychedelic, animated graph of made-up words and a "Sign in with Google" button (Giovanni's design).

## What it does
Shows glowing, colour-cycling nodes drifting and linking, which react to the mouse, with gibberish labels generated at random in the visitor's browser. Nothing real is on the page.

## How it does it
One self-contained HTML file with inline canvas JavaScript: no external file, no fetch. Tests check it loads nothing from outside, makes no requests and contains no page title from the content (DC-1). Respects "reduce motion".

## Where it sits in the pipeline
Returned by [[wiki-router]] for every page without a session.

## Who receives its output
Visitors without a session (and Giovanni before logging in).
