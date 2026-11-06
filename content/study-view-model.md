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
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/ui/StudyViewModel.kt, QuizApp:app/src/main/java/dev/yuji/quiz/ui/Screens.kt, QuizApp:app/src/main/java/dev/yuji/quiz/ui/UiState.kt, QuizApp:app/src/main/java/dev/yuji/quiz/ui/FspCaseScreen.kt]
reviewed: 2026-11-06T23:20Z
---

## What it is
A [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel) is the part of an Android app that prepares data for the screens and survives screen rotations. The StudyViewModel is the one ViewModel of [[quizapp]]; it exposes a "sealed" `UiState` (UI means user interface; sealed means it can only be one of a fixed list of cases: `ModeSelect`, `Studying`, `Finished`, `Settings`, `Failed`) to the Compose screens.

## What it does
It turns the results of the [[study-controller]] into what the screens show: the home screen (calendar, daily goal, mode cards), the question with feedback (green or red, the explanation, automatic advance after 0.5 s except in Fehler finden), the settings and the update popup. For an FSP case (FSP: Fachsprachprüfung, the German medical-language exam; one simulated exam case of the FSP-Fälle mode, [[fsp-case]]) the `Studying` state also carries the case being played; `pickCaseOption` picks an answer of the current step and `nextCaseStep` moves on, and after the last step asks the [[study-controller]] to grade the case and shows the result screen, drawn by the case screen of [[fsp-case]]. It keeps one case run per card: a new card, or a finished run whose result is no longer on screen, starts the case afresh.

## How it does it
It survives the recreation of the screen that happens when the language is changed. Text that it produces itself goes through its `t()` helper, which picks the right language. The `UiState` types live in `UiState.kt` and the update flow (asking the feed, the popup, downloading the APK, Android Package, the installable app file) in `AppUpdater.kt`, so the view model stays under 300 lines; a question pool downloaded by the update flow is handed back to it, and it decides when the deck may be replaced ([[question-pool-updater]]). The screens scale with the screen height (`ScreenScale`), and a "screen-fit" test checks that nothing is hidden below the fold on tall phones. With six mode cards since 2.8.0, short screens use tighter padding on the home screen's cards (text sizes stay) so the whole home screen still fits on phones 800 dp tall (dp: density-independent pixels, Android's screen-size unit; requirement UI-1).

## Where it sits in the pipeline
The top of the app: `ui → StudyController`.

## Who receives its output
Giovanni on the [[phone]].
