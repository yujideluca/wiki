---
id: status-quo-install
title: Status Quo installer, doctor and release
aliases: [status-quo install, status-quo doctor, status-quo-setup.exe]
kind: script
project: status-quo
status: beta
since: 2026-11-06
location: status-quo:tools/install.sh
fed_by: []
feeds: [status-quo]
sources: [status-quo:tools/install.sh, status-quo:crates/setup/Cargo.toml, status-quo:crates/desktop/src/doctor.rs, status-quo:crates/desktop/src/install.rs, status-quo:crates/desktop/tests/installer.rs, status-quo:crates/setup/src/main.rs, status-quo:crates/setup/build.rs, status-quo:.github/workflows/release.yml, status-quo:LICENSE, status-quo:docs/guide/install.md]
reviewed: 2026-11-06T20:32Z
---

## What it is
The way to put [[status-quo]] on a computer in one step, and to check that a computer can run it. It has four parts that all live in the `status-quo` repository: `tools/install.sh` (Linux installer), `status-quo doctor` (a compatibility check), `status-quo install --adopt` (taking over a program that was copied by hand) and `status-quo-setup.exe` (a one-file Windows installer built by the continuous integration (CI) service, the automatic checks that run on every push). They are requirements SQ-41, SQ-42 and SQ-43 of the project, and the repository has been public under the MIT licence since 2026-11-06.

## What it does
`tools/install.sh` installs on a Debian/Ubuntu, Fedora, Arch or openSUSE family system: it checks the distribution, installs the build libraries with the right package manager (`apt`, `dnf`, `pacman` or `zypper`), checks that Rust is present, builds the program, runs `status-quo install` and starts the two user services `status-quo-collector.service` and `status-quo-panel.service`. Options: `--check-only` (only report), `--dry-run` (print every command without running it), `--uninstall`, `--adopt`, `--yes` (no questions), `--no-deps` (skip the library step), `--repo` and `--src`.

`status-quo doctor` prints, in plain language, what is fine, what is a warning and what blocks the program (operating system, desktop and display method, libraries, graphics, services, writable folders). It exits with an error status only for a blocking problem.

`status-quo install` copies the program, writes the service and hook files and records every file it wrote with a content fingerprint in a manifest (`install.json`). It never overwrites a managed file whose content it did not install: it stops with "unmanaged or changed ownership; original retained". `--adopt` is the deliberate way past that stop: the existing file is first saved next to it as `<file>.before-status-quo` (then `.1`, `.2` if that name exists), and the installer takes ownership of the new one. Hook files that belong to the user's assistants (Claude Code, Codex) are never adopted, only added to.

`status-quo-setup.exe` does the same on Windows 10 and 11 with the program embedded in it, so there is nothing else to download; it supports `--dry-run` and runs the doctor first.

## How it does it
The Linux script is plain Bash and the program does the rest in Rust (`crates/desktop/src/install.rs`, `doctor.rs`). The Windows installer is the crate `status-quo-setup` (`crates/setup`); its `build.rs` embeds the file named by the variable `STATUS_QUO_PAYLOAD`. The workflow `quality-gate.yml` builds it on every push and smoke-tests `--dry-run` and `doctor`; `release.yml` runs when a tag starting with `v` is pushed, rebuilds the program and the installer on a Windows runner and attaches `status-quo-setup.exe` to a GitHub release. Every action in both workflows is pinned to a full commit hash instead of a movable tag, and the release build only reads the build cache, so a poisoned cache entry cannot be written from a release. Tests: `crates/desktop/tests/installer.rs` runs the script with fake systems (help, bad options, uninstall, missing Rust, unknown distribution, the package command of each family); `install.rs` has the adopt test; `crates/desktop/tests/docs.rs` checks that the guide lists every option, that `LICENSE` is MIT and that no workflow action is unpinned.

## Where it sits in the pipeline
It is the delivery end of [[status-quo]]; the rules that keep it correct are in [[checks-status-quo]], the Windows test machines come from [[vm-lab]], and the scope is in [[status-quo-design]].

## Who receives its output
Giovanni, and anyone who wants to try Status Quo on their own computer.

## Notes
Verified: the Linux path end to end on this laptop (Kubuntu, with `--adopt` and a service restart), the other families only as printed `--dry-run` commands (no container runtime was available), and the Windows installer only through CI (build, `--dry-run`, `doctor`), not on a real Windows computer. Branch protection on `main` requires the `gate` check and forbids force-push and deletion; administrators are not forced to follow it.
