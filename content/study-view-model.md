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
---

## What it is
The one ViewModel of [[quizapp]]: it exposes a sealed `UiState` (`ModeSelect`, `Studying`, `Finished`, `Settings`, `Failed`) to the Compose screens.

## What it does
Turns [[study-controller]] results into what the screens show: the home screen (calendar, daily goal, mode cards), the question with feedback (green/red, explanation, auto-advance after 0.5 s except Fehler finden), settings and the update popup.

## How it does it
Survives the activity recreation on a language change; text it produces itself goes through its `t()` helper. Screens scale with height (`ScreenScale`); the screen-fit test checks nothing hides below the fold on tall phones.

## Where it sits in the pipeline
The top of the app: `ui → StudyController`.

## Who receives its output
Giovanni on the [[phone]].
