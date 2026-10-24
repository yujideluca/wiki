---
id: skill-browser-automacao-segura
title: Skill: browser-automacao-segura (safe browser automation)
aliases: [browser-automacao-segura]
kind: skill
project: skills
status: active
location: home:.claude/skills/browser-automacao-segura
fed_by: []
feeds: []
sources: [home:.claude/skills/browser-automacao-segura/SKILL.md]
---

## What it is
The skill "browser-automacao-segura" ("safe browser automation") holds the safety rules for any action in a web browser (the app's built-in browser or Claude in Chrome), especially batch actions, removals, mass edits and scripts on pages. It is written in Portuguese. Its description says: use it always when executing actions in any browser, especially batch actions, removals, mass edits and JavaScript scripts on pages.

## What it does
It prevents dialogs that freeze the session, overlapping loops and destructive mistakes, and it asks before anything irreversible. For the mechanics of clicking it defers to [[skill-click-protocol]], and for reducing approval clicks to [[skill-minimize-site-approvals]]; where they disagree, the safety rules of this skill win.

## How it does it
A `SKILL.md` in `~/.claude/skills/browser-automacao-segura`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Before and during any browser automation.

## Who receives its output
The browser session; [[skill-click-protocol]] and [[skill-minimize-site-approvals]] defer to it for alerts and destructive actions.

## Steps
Why it matters: a native `alert()` dialog that is open blocks all browser tools (screenshot, JavaScript, clicks) until someone clicks OK. It often appears when two concurrent actions hit the same item (for example two loops clicking "remove" on the same row and the server refusing the second). A known trap: when the `javascript_tool` fails by timeout, the script keeps running on the page, and starting another loop creates a parallel run.
1. **Never run overlapping loops** on the same page. Before starting a new loop, stop the previous one (a flag such as `window.stopRem = true`) and confirm it finished.
2. **Sequential, with real waiting.** After each action, wait for the effect to happen (for example the row disappearing from the page) instead of a fixed interval. Skip items that are being processed (no action button, or a spinner).
3. **Neutralise alerts before batch actions** and log them for later reading: `window.alertLog = []; window.alert = m => window.alertLog.push(String(m));`. Do not override `confirm` to return `true` automatically, since that could approve destructive actions nobody asked for; if a `confirm` is expected for the action the user asked, handle it individually.
4. **Long loops in the background.** Start them with an asynchronous immediately-invoked function without `await` at the top, which returns at once, and check progress in separate calls; the loop checks the stop flag each round, clicks the next item that has an active button, and waits (up to about 10 seconds) until its row is gone before the next.
5. **If an alert is already open**, the tools fail. Try pressing Return once; if still blocked, ask the user to click OK and explain why. Then stop loops (`window.stopRem = true`) and install the alert override.
6. **Verify at the end by reloading the page** and counting again; the local page may not reflect the server. Read `window.alertLog` to see the errors that occurred.
7. **Destructive actions** (remove, send, buy) only on the user's explicit request. Test on one item first, check the result and only then run the batch.
