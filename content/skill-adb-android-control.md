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
reviewed: 2026-10-22T16:33Z
---

## What it is
The skill "adb-android-control" is the command reference for working with Giovanni's phone (a Motorola edge 50 fusion) over adb during app development, such as QuizApp. adb is the Android Debug Bridge ([documentation](https://developer.android.com/tools/adb)): a tool that lets a computer control a phone over a cable. Its description says: use it for Android work over adb during app development: install an APK (Android Package, the installable app file), launch the app, tap, swipe and type to exercise a flow, take a screenshot, read logcat (Android's system log, [documentation](https://developer.android.com/tools/logcat)) for crashes, dumpsys (a status dump of system services) and permissions. It is the command reference for the debug pass after coding. It is not for general phone questions, USB or Kubuntu problems ([[skill-reparo-kubuntu]]), or anything without adb. It is adapted from the open-source skill hah23255/adb-android-control 2.0.1 (MIT licence): the command reference and workflows only; the Termux scripts, the network port scanner, the radio scanner and the Python package were left out, and a network scan must never be run from this skill.

## What it does
It lets Claude exercise an app on the phone and read what happened: the first-line debug pass after coding [[quizapp]]. Its role is "domain"; it defers to the project's CLAUDE.md (for QuizApp, `source ~/dev/env.sh` puts adb on the path and describes build and install steps), to [[skill-verification-before-completion]] (what counts as proof) and to [[skill-reparo-kubuntu]] (USB and host problems).

## How it does it
A `SKILL.md` in `~/.claude/skills/adb-android-control`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Part of the development process in Claude Code, used in every project that has an Android app.

## Who receives its output
The [[phone]]; the logcat output ([[study-debug-log]]) comes back to Claude.

## Steps
The skill is a reference of commands, grouped by task. The groups are:
1. **Connection.** `adb devices` lists connected devices; `adb connect <ip>:<port>` and `adb disconnect` handle wireless debugging; `adb kill-server && adb start-server` restarts the adb background process when something is stuck.
2. **App management.** `adb install -r app.apk` installs (replace), `-d` allows a downgrade, `-g` grants all permissions; `adb uninstall`, `adb shell pm clear <package>` (erase the app's data), `adb shell am force-stop <package>`, `pm list packages` (optionally filtered), `pm path` and `adb pull` to extract the APK.
3. **Files.** `adb push` and `adb pull` copy files; `adb shell ls`, `mkdir`, `rm` and `df -h` inspect the phone's storage.
4. **Screen.** `adb exec-out screencap -p > shot.png` takes a screenshot straight to the laptop; `adb shell screenrecord` records video (up to 180 seconds).
5. **Input.** `adb shell input tap X Y`, `input swipe X1 Y1 X2 Y2 ms`, `input text "..."` (spaces written as `%s`) and `input keyevent KEYCODE_...` (Home 3, Back 4, Power 26, Enter 66, and so on).
6. **Activities and intents.** `adb shell am start -n <package>/.Activity` launches a screen; `am start -a android.intent.action.VIEW -d <url>` opens a link; `am broadcast` sends a system message.
7. **Information.** `getprop` (model, Android version), `dumpsys battery|meminfo|cpuinfo|wifi`, `wm size`, `ps -A`, `top -n 1`.
8. **Logcat.** `adb logcat -c` clears the log, `adb logcat -d` dumps and exits, `-s TAG:*` filters by tag, `"*:E"` shows errors only, `--pid=$(adb shell pidof -s <package>)` shows one app, `-b crash` shows crashes, `-v time` adds timestamps.
9. **Settings and network.** `adb shell settings get|put`, `svc wifi enable|disable`, `adb forward` and `adb reverse` (port forwarding between laptop and phone).
10. **Power.** `adb reboot` (also `recovery` and `bootloader`), `svc power stayon usb` keeps the screen awake while connected.
11. **Advanced.** `uiautomator dump` writes the screen's structure as XML, `monkey -p <package> -v 500` sends random events, `pm grant|revoke` changes a permission, `dumpsys package <package>` shows permissions.
12. **Ready-made workflows.** App test automation (install, launch, screenshot, tap, scroll, final screenshot, logs of the app's process), device health check (model, Android version, battery, storage, memory, process count), bulk screenshots at an interval, and extraction of an app's APK and permissions.
13. **Troubleshooting.** Device not found: restart the adb server and list devices. Device offline: disconnect and connect again. Permission denied: some operations need root. Connection refused: pair the device again with `adb pair <ip>:PORT CODE`.
