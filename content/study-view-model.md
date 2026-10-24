---
id: study-view-model
title: StudyViewModel (UI state)
aliases: [UiState, screens]
kind: function
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz/ui/StudyViewModel.kt
fed_by: [activity-calendar, daily-goal, question-pool-updater, settings-store, study-controller]
feeds: [phone]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/ui/StudyViewModel.kt, QuizApp:app/src/main/java/dev/yuji/quiz/ui/Screens.kt]
reviewed: 2026-10-22T16:33Z
---

## What it is
A [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel) is the part of an Android app that prepares data for the screens and survives screen rotations. The StudyViewModel is the one ViewModel of [[quizapp]]; it exposes a "sealed" `UiState` (UI means user interface; sealed means it can only be one of a fixed list of cases: `ModeSelect`, `Studying`, `Finished`, `Settings`, `Failed`) to the Compose screens.

## What it does
It turns the results of the [[study-controller]] into what the screens show: the home screen (calendar, daily goal, mode cards), the question with feedback (green or red, the explanation, automatic advance after 0.5 s except in Fehler finden), the settings and the update popup.

## How it does it
It survives the recreation of the screen that happens when the language is changed. Text that it produces itself goes through its `t()` helper, which picks the right language. The screens scale with the screen height (`ScreenScale`), and a "screen-fit" test checks that nothing is hidden below the fold on tall phones.

## Where it sits in the pipeline
The top of the app: `ui → StudyController`.

## Who receives its output
Giovanni on the [[phone]].
