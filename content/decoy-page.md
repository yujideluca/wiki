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
A decoy is something that looks real but hides the real thing. The decoy page is what anyone who is not signed in sees when they open the wiki's address: an animated, psychedelic graph of made-up words and a "Sign in with Google" button (Giovanni's design). Its purpose is that a stranger who finds the address learns nothing about what the wiki contains.

## What it does
It shows glowing, colour-cycling nodes that drift and link up and react to the mouse, labelled with gibberish generated at random in the visitor's own browser. Nothing real is on the page.

## How it does it
It is one self-contained [HTML](https://en.wikipedia.org/wiki/HTML) file (HyperText Markup Language, the language of web pages) with inline JavaScript that draws on a canvas: no external file and no network request. Tests check that it loads nothing from outside, makes no requests and contains no page title from the content (requirement DC-1). It respects the browser setting "reduce motion".

## Where it sits in the pipeline
Returned by the [[wiki-router]] for every page request without a valid session.

## Who receives its output
Visitors without a session (and Giovanni, before logging in).
