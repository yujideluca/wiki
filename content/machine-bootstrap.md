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
sources: [machine-bootstrap:docs/PRIVACY.md, machine-bootstrap:pipeline-check.toml, machine-bootstrap:README.md, machine-bootstrap:DESIGN.md, machine-bootstrap:docs/RESTORE.md, machine-bootstrap:docs/MANUAL.md, machine-bootstrap:docs/REQUIREMENTS.md, machine-bootstrap:mb.toml, machine-bootstrap:mb/cli.py, machine-bootstrap:mb/plan.py, machine-bootstrap:mb/capture.py, machine-bootstrap:mb/secrets_backup.py, machine-bootstrap:mb/databackup.py, machine-bootstrap:bootstrap.sh, machine-bootstrap:tools/vm-test.sh]
reviewed: 2026-10-27T01:34Z
---

## What it is
`machine-bootstrap` records the setup of Giovanni's laptop ([[acer-nitro]]) so it can be rebuilt after reinstalling the operating system or moving to another computer. It uses Python's standard library and a Bash starter script. Its local repository is `~/dev/machine-bootstrap`; the public source repository is [yujideluca/machine-bootstrap](https://github.com/yujideluca/machine-bootstrap). Captured settings and package lists are public; encrypted archives and credentials are excluded. Start with `docs/RESTORE.md`; `docs/MANUAL.md` contains the longer instructions and failure cases.

## Flow
trigger t1: Giovanni wants to record or rebuild the laptop setup | [[acer-nitro]]
decide d1: Record or rebuild?
step s1: capture records packages, repositories and allowed settings; the secret scanner refuses secrets
step s2: status and a weekly timer report what changed since the record
step s3: restore prints a plan
decide d2: Does Giovanni add --apply?
step s4: Installs sources, packages, tools and repositories; settings last, with dated .mb-bak copies
step s5: Secrets come back from the encrypted archive; personal folders are copied back
trigger t2: Giovanni backs up keys, logins and personal folders
step s6: secrets-backup encrypts keys and logins; data-backup copies the folders
product p1: A public record of packages and settings, without secrets
product p2: A plan only: nothing on the laptop changed
product p3: A rebuilt laptop
product p4: Encrypted archives and copied folders, kept outside the public repository

t1 -> d1
d1 -record-> s1
d1 -rebuild-> s3
s1 -> s2
s2 -> p1
s3 -> d2
d2 -no-> p2
d2 -yes-> s4
s4 -> s5
s5 -> p3
t2 -> s6
s6 -> p4

## Architecture
### Context
person g: Giovanni — captures and restores | [[giovanni]]
system m: machine-bootstrap — rebuilds the laptop's setup
external pc: The computer — packages, settings, services | [[acer-nitro]]
external gh: GitHub — keeps the captured state | [[github]]
external ssd: External disk — encrypted keys and personal files
external gd: Google Drive — a second copy of the encrypted keys

g -captures and restores with-> m
m -reads and rebuilds-> pc
m -keeps state in-> gh
m -saves encrypted keys on-> ssd
m -saves encrypted keys on-> gd

### Containers
person g: Giovanni | [[giovanni]]
container cl: Command line — commands and the passphrase prompt
container pl: Plan — building it is pure, only execute changes anything
container cp: Capture — copies only what the allow-list names
container sb: Secrets backup — encrypted archive of keys and logins
container db: Data backup — preflight check, then copy
container fa: Facts — what the machine looks like
container sc: Secret scanner — refuses anything that looks secret
store ss: state/ — what capture writes, kept in git
store cf: mb.toml — the allow-list

g -runs-> cl
cl -plans with-> pl
cl -captures with-> cp
cl -backs up keys with-> sb
cl -backs up files with-> db
cl -reads the list from-> cf
pl -asks-> fa
pl -reads-> ss
cp -asks-> fa
cp -checks with-> sc
cp -writes-> ss

## What it does
The command `python3 -m mb` has eight subcommands. `capture` records packages, repositories and allowed settings in `state/`. `status` reports changes since that record. `install-timer` enables a weekly background check. `restore` prints a plan and applies it only with `--apply`. `secrets-backup` encrypts keys and logins; `secrets-restore` restores an archive. `data-backup` copies personal folders. `scan` checks the recorded settings for secrets.

## How it does it
The configuration file `mb.toml` lists the files allowed into the record and the recipes used to install tools. A recipe has a check command and an install command. Capture refuses files detected by the secret scanner. Restore installs package sources first, then packages, early recipes, apps, repositories and tool recipes, and writes settings last. Different existing settings receive a dated `.mb-bak` copy. Boot-loader packages, which determine how the computer starts, are excluded. `--profile new` also excludes hardware-specific drivers and settings. `bootstrap.sh` installs missing prerequisites before starting restore.

Secret archives use GnuPG, the encryption program invoked as `gpg`. Giovanni types a passphrase, which is never saved or placed in a command argument. Backup writes an encrypted archive, decrypts it for comparison with the originals, then uploads and checks the Google Drive copy through rclone, a file-copy tool. The external drive is found by its filesystem identifier. Personal-file backup refuses an unmounted target or insufficient space, keeps older overwritten files and never deletes destination files. `--verify` compares checksums; `--bulk` includes large replaceable folders.

## Where it sits in the pipeline
It records [[laptop-setup]] and rebuilds it after a reinstall. Requirements `MB-1` to `MB-16` are the testable promises in `docs/REQUIREMENTS.md`. The quality gate, the checks that decide whether the project passes, is `tools/quality_gate.sh`: unit tests, shell checks, secret scanning, requirement-to-test links and size limits. [[pipeline-check]] runs it. The source decision log records a clean Ubuntu 26.04 virtual-machine run with 27 successful checks on 2026-10-25; this review read that record and the test script, but did not repeat the whole restore. Private repository cloning and the real passphrase archive were excluded from that recorded proof.

## Who receives its output
Giovanni and the assistant helping restore the computer. The documented order is: obtain the tool, restore keys, restore programs and settings, then copy personal files back.

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
1. **Requirement, then test, then code**: checked by the traceability step of the gate.
2. **Planning is pure, the system is touched in one place**: `build_plan` only reads; only `execute` changes anything, and the command runner is a required argument. The tests pass a runner that fails the test if it is called.
3. **Nothing secret in git**: capture is an allow-list plus a scanner, and the gate scans `state/`. Secrets go only through the encrypted backup.
4. **The gate decides**: `tools/quality_gate.sh` is the only definition of passing, and continuous integration runs it.
5. **Only the virtual machine proves a restore**: after changing a recipe, the plan or `bootstrap.sh`, `tools/vm-test.sh` runs and its result goes in the decision log.
6. **A tool used by more than one project lives once**, in its own repository, pinned by version.
7. **Decisions are written where the code is**: decision log and an architecture decision record for structural ones.

### Decisions
Five architecture decision records (ADRs, short notes that keep the reasons for a decision) in `docs/adr/`: 0002 Python with only its standard library, plus a small Bash starter; 0003 a program measures and a skill judges; 0004 capture by allow-list, and refuse anything the secret scanner flags; 0005 keys and logins in one passphrase-encrypted archive stored in two places. `DESIGN.md` holds the diagrams, including the restore order, and the decision log.

### Requirements
16 requirements (prefix MB) in `docs/REQUIREMENTS.md`. Each has a test tagged `REQ MB-N`, and the traceability check ([[check-traceability]]) fails when one has none.

### Quality gate
The gate has three steps: the unit tests, a shell-script check of `bootstrap.sh` and the secret scan of `state/`; requirement traceability; and the fitness functions (limits in `pipeline-check.toml`, including gate time).

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` runs the gate on GitHub for every push, through `pipeline-check` pinned in `pipeline-check.version`.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` (P1 to P3) under the [[maintenance-policy]]. The [[monthly-architecture-review]] checks the project every month; the next is due 2026-11-22.

## Notes
Browser profiles, game installations and the phone's own settings are outside the restore. The current capture configuration includes `.codex/skills` but omits `.agents/skills`; restoration of Codex's managed skill links is therefore not established. That gap is documented in the workflow audit of [[codex-skills]]. Download recipes depend on external addresses, so a previous successful restore does not establish that a future one will succeed. A secrets archive dated 2026-10-26 exists on the drive; no restore of it on a new machine has been tested. `DESIGN.md` records that the public repository's main branch requires the GitHub Actions check `gate`, applies this to administrators, and disallows force pushes and branch deletion. The repository also holds `docs/PRIVACY.md`, the privacy notice of a personal Google OAuth (Open Authorization, a standard for granting access without sharing a password) application (the identity [rclone](https://rclone.org/) uses to reach Google Drive) that replaces rclone's shared one; it states that the application can view and manage all files in the authorizing Drive account, that the workflow uploads encrypted archives and does not delete existing Drive backups, and that credentials and tokens stay in the private rclone configuration. An upload with it has not been tested.

Run `python3 -m mb` from `~/dev/machine-bootstrap`. Allowed settings include `.bashrc` and the desktop's configuration files. Early recipes prepare app stores before apps are installed; later recipes install tools after repositories are cloned. The drive identifier is `[data].ssd_uuid` and the cloud destination is `[secrets].gdrive_path` in `mb.toml`. Archives go under `machine-bootstrap/secrets/` on the drive and personal files under `machine-bootstrap/home/`. A failed restore step is reported as `[FAIL]`; restore continues unless `--stop-on-error` is set. Correct the cause and rerun: completed steps are skipped. Skill links are filesystem references that let Codex find the instruction folders managed by [[codex-skillsctl]].

The local `pipeline-check.toml` now names `yujideluca/machine-bootstrap`, its `main` branch and required check `gate`. In local mode, the checker verifies both the latest GitHub test result and the live branch-protection settings; the 2026-10-26 report shows both as `ok` (passed).

A dedicated Google authorization application is registered in project `rclone-personal-backup-512812`. The app is published in production mode. Its desktop client identifies the local rclone installation when it requests Google access. The Google user-data policy was accepted and the full Drive permission was configured with Giovanni’s approval. The public privacy notice is `docs/PRIVACY.md` in the bootstrap repository. The rclone connection now uses this desktop client and a replacement secret downloaded on 2026-10-26. Google accepted the replacement during a fresh sign-in. The private configuration is `~/.config/rclone/rclone.conf`, readable only by its owner. Giovanni authorized full Drive access, and a fresh Google sign-in granted the `drive` permission. The existing encrypted backup is accessible: its complete metadata matches the saved baseline, and downloading its 174220 bytes produces the same SHA-256 (Secure Hash Algorithm 256) checksum, a value used to detect content changes. The comparison found one file before and one after, unchanged. No new backup upload was performed during this check. The original secret has not been verified as revoked.
