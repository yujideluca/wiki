---
id: machine-bootstrap
title: machine-bootstrap (rebuild the laptop setup)
aliases: [mb, bootstrap, reinstall, restore tool]
kind: project
project: none
status: active
location: machine-bootstrap:
fed_by: [acer-nitro]
feeds: []
sources: [machine-bootstrap:README.md, machine-bootstrap:DESIGN.md, machine-bootstrap:docs/RESTORE.md, machine-bootstrap:docs/MANUAL.md, machine-bootstrap:docs/REQUIREMENTS.md, machine-bootstrap:mb.toml, machine-bootstrap:mb/cli.py, machine-bootstrap:mb/plan.py, machine-bootstrap:mb/capture.py, machine-bootstrap:mb/secrets_backup.py, machine-bootstrap:mb/databackup.py, machine-bootstrap:bootstrap.sh, machine-bootstrap:tools/vm-test.sh]
reviewed: 2026-10-26T12:06Z
---

## What it is
`machine-bootstrap` records the setup of Giovanni's laptop ([[acer-nitro]]) so it can be rebuilt after reinstalling the operating system or moving to another computer. It uses Python's standard library and a Bash starter script. Its local repository is `~/dev/machine-bootstrap`; the public source repository is [yujideluca/machine-bootstrap](https://github.com/yujideluca/machine-bootstrap). Captured settings and package lists are public; encrypted archives and credentials are excluded. Start with `docs/RESTORE.md`; `docs/MANUAL.md` contains the longer instructions and failure cases.

## What it does
The command `python3 -m mb` has eight subcommands. `capture` records packages, repositories and allowed settings in `state/`. `status` reports changes since that record. `install-timer` enables a weekly background check. `restore` prints a plan and applies it only with `--apply`. `secrets-backup` encrypts keys and logins; `secrets-restore` restores an archive. `data-backup` copies personal folders. `scan` checks the recorded settings for secrets.

## How it does it
The configuration file `mb.toml` lists the files allowed into the record and the recipes used to install tools. A recipe has a check command and an install command. Capture refuses files detected by the secret scanner. Restore installs package sources first, then packages, early recipes, apps, repositories and tool recipes, and writes settings last. Different existing settings receive a dated `.mb-bak` copy. Boot-loader packages, which determine how the computer starts, are excluded. `--profile new` also excludes hardware-specific drivers and settings. `bootstrap.sh` installs missing prerequisites before starting restore.

Secret archives use GnuPG, the encryption program invoked as `gpg`. Giovanni types a passphrase, which is never saved or placed in a command argument. Backup writes an encrypted archive, decrypts it for comparison with the originals, then uploads and checks the Google Drive copy through rclone, a file-copy tool. The external drive is found by its filesystem identifier. Personal-file backup refuses an unmounted target or insufficient space, keeps older overwritten files and never deletes destination files. `--verify` compares checksums; `--bulk` includes large replaceable folders.

## Where it sits in the pipeline
It records [[laptop-setup]] and rebuilds it after a reinstall. Requirements `MB-1` to `MB-16` are the testable promises in `docs/REQUIREMENTS.md`. The quality gate, the checks that decide whether the project passes, is `tools/quality_gate.sh`: unit tests, shell checks, secret scanning, requirement-to-test links and size limits. [[pipeline-check]] runs it. The source decision log records a clean Ubuntu 26.04 virtual-machine run with 27 successful checks on 2026-10-25; this review read that record and the test script, but did not repeat the whole restore. Private repository cloning and the real passphrase archive were excluded from that recorded proof.

## Who receives its output
Giovanni and the assistant helping restore the computer. The documented order is: obtain the tool, restore keys, restore programs and settings, then copy personal files back.

## Notes
Browser profiles, game installations and the phone's own settings are outside the restore. The current capture configuration includes `.codex/skills` but omits `.agents/skills`; restoration of Codex's managed skill links is therefore not established. That gap is documented in the workflow audit of [[codex-skills]]. Download recipes depend on external addresses, so a previous successful restore does not establish that a future one will succeed. A secrets archive dated 2026-10-26 exists on the drive; no restore of it on a new machine has been tested. `DESIGN.md` records that the public repository's main branch requires the GitHub Actions check `gate`, applies this to administrators, and disallows force pushes and branch deletion.

Run `python3 -m mb` from `~/dev/machine-bootstrap`. Allowed settings include `.bashrc` and the desktop's configuration files. Early recipes prepare app stores before apps are installed; later recipes install tools after repositories are cloned. The drive identifier is `[data].ssd_uuid` and the cloud destination is `[secrets].gdrive_path` in `mb.toml`. Archives go under `machine-bootstrap/secrets/` on the drive and personal files under `machine-bootstrap/home/`. A failed restore step is reported as `[FAIL]`; restore continues unless `--stop-on-error` is set. Correct the cause and rerun: completed steps are skipped. Skill links are filesystem references that let Codex find the instruction folders managed by [[codex-skillsctl]].
