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
---

## What it is
The part of [[quizapp-app]] that downloads newer question packs and decides which pack the app uses.

## What it does
With each update check (app in the foreground, at most every 30 s) it reads `content/content.json` of its own feed branch (beta: `bleeding-edge`, stable: `main`), downloads a pack only if its schema is the app's and its version is higher than the pack in use, and installs it only if [[question-pack]] validation passes. On start it uses the downloaded pack only while it is newer than the built-in one; an outdated or unreadable one is deleted. The deck is swapped at once on the home screen or in Settings, during a study session only when the player returns home; a popup says how many questions were added and Settings shows the pool version and its origin.

## How it does it
`ContentUpdater` fetches through [[update-client]] (GitHub contents API); `ContentStore` writes to `files/content/staging` and renames it to `files/content/current`, so an interrupted install never leaves half a pack. `ui/QuestionPool.kt` applies the swap and the popup. Progress is untouched, because card ids come from the content. A failed, refused or offline download is silent and changes nothing. Tested by `ContentUpdaterTest`. Debug builds can read a local feed over `adb reverse` (a debug-only network config allows plain HTTP to 127.0.0.1).

## Where it sits in the pipeline
Between [[release-feed]] and the screens ([[study-view-model]]).

## Who receives its output
[[study-view-model]] (the new deck and the popup).
