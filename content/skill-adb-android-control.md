---
id: skill-adb-android-control
title: Skill: adb-android-control
aliases: [adb-android-control]
kind: skill
project: skills
status: active
location: home:.claude/skills/adb-android-control
fed_by: [android-toolchain, study-debug-log]
feeds: []
sources: [home:.claude/skills/adb-android-control/SKILL.md]
---

## What it is
The command reference for working with Giovanni's phone (Motorola edge 50 fusion) over adb during app development.

## What it does
Install an APK, launch the app, tap, swipe and type to exercise a flow, take screenshots, read logcat for crashes, dumpsys, permissions: the first-line debug pass after coding [[quizapp]].

## How it does it
A `SKILL.md` in `~/.claude/skills/adb-android-control`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Part of the development process in Claude Code, used in every project.

## Who receives its output
The [[phone]]; its logcat output ([[study-debug-log]]) comes back to Claude.
