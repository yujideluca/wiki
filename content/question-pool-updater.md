---
id: question-pool-updater
title: Question pool updater (ContentStore, ContentUpdater)
aliases: [ContentUpdater, ContentStore, QuestionPool]
kind: function
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz/data/ContentUpdater.kt
fed_by: [question-pack, release-feed, update-client]
feeds: [study-view-model]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/data/ContentUpdater.kt, QuizApp:app/src/main/java/dev/yuji/quiz/data/ContentStore.kt, QuizApp:app/src/main/java/dev/yuji/quiz/ui/QuestionPool.kt]
reviewed: 2026-10-22T17:29Z
---

## What it is
This is the part of the [[quizapp-app]] module that downloads newer question packs and decides which pack the app uses. In code it consists of `ContentUpdater`, `ContentStore` and `QuestionPool`.

## What it does
At every update check (when the app comes to the foreground, at most every 30 seconds) it reads `content/content.json` from its own branch of the feed (beta: `bleeding-edge`, stable: `main`). It downloads a pack only if the pack's schema is the one the app understands and its version is higher than the pack in use, and installs it only if the validation of the [[question-pack]] passes. At start it uses the downloaded pack only while it is newer than the built-in one; an outdated or unreadable one is deleted. The deck is swapped at once on the home screen or in Settings, and during a study session only when the player returns home. A popup says how many questions were added, and Settings shows the pool version and where it came from.

## How it does it
`ContentUpdater` fetches through the [[update-client]] (the GitHub contents API, application programming interface: a web interface for reading repository files). `ContentStore` writes into `files/content/staging` and then renames that folder to `files/content/current`, so an interrupted install never leaves half a pack. `ui/QuestionPool.kt` applies the swap and shows the popup. Progress is untouched, because card ids come from the content. A download that fails, is refused or happens offline is silent and changes nothing. It is tested by `ContentUpdaterTest`. Debug builds can read a local feed over `adb reverse` (port forwarding from the phone to the laptop; a debug-only network setting allows plain HTTP to 127.0.0.1).

## Where it sits in the pipeline
Between the [[release-feed]] and the screens ([[study-view-model]]).

## Who receives its output
The [[study-view-model]] (the new deck and the popup).
