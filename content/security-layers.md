---
id: security-layers
title: Security layers of the code pipeline
aliases: [security pipeline, secret scanning, privacy scan, default deny]
kind: process
project: none
status: active
fed_by: []
feeds: []
sources: [workflow-memory:mem/privacy-patterns.tsv, workflow-memory:mem/validate.py, wiki:server/lib/wiki/content/privacy.ex, wiki:docs/adr/0003-login-gate-and-decoy.md, wiki:docs/REQUIREMENTS.md, machine-bootstrap:mb/scan.py, machine-bootstrap:docs/adr/0004-allow-list-and-scanner.md, machine-bootstrap:docs/adr/0005-secrets-passphrase-two-places.md, workflow-memory:.github/workflows/mem.yml, radiology-crawler:tools/check_dependencies.py]
reviewed: 2026-11-02T10:44Z
---

## What it is
Giovanni's systems hold keys, tokens and private notes, and some repositories are public. There is no single security product; instead, several small layers each stop one kind of leak or mistake. This page lists the layers that exist in the files, so nobody has to assume a protection that is not there.

## Flow
trigger t1: Text, a file or a login attempt arrives | [[code-security-pipeline]]
step s1: A visitor asks the wiki for a page; with no verified Google session the answer is a decoy | [[wiki-sign-in]], [[decoy-page]]
step s2: Content is checked against the shared privacy patterns before it is published or stored | [[wiki-check]], [[mem-validator]]
step s3: The machine-bootstrap scanner refuses files that look like secrets | [[machine-bootstrap]]
step s4: Secrets that must be kept travel only inside an encrypted archive | [[machine-bootstrap]]
step s5: Code changes pass the gate, shell lint and the declared-dependency check | [[quality-gate-explained]]
step s6: Branch protection or the pre-push hook stops a failing change from reaching main | [[branch-protection-explained]]
decide d1: Did a layer find a problem?
product p1: A refusal that names the kind of problem, never the secret value
product p2: Content that is safe to store, publish or serve

t1 -> s1
t1 -> s2
t1 -> s3
s3 -> s4
t1 -> s5
s5 -> s6
s1 -> d1
s2 -> d1
s4 -> d1
s6 -> d1
d1 -yes-> p1
d1 -no-> p2

## What it does
The layers, from the most to the least specific:
1. **Default deny on the web** ([[wiki-router]]). Without a session of Giovanni's verified Google account, every page path answers a decoy page and the data paths answer 404 (requirements AU-1 to AU-6, DC-1). Every response is marked not to be cached and carries security headers; the decoy's content security policy forbids network requests. OAuth (Open Authorization, the standard behind "sign in with Google") state and nonce are checked, and the Google client allows only one test user.
2. **One list of privacy patterns**. `mem/privacy-patterns.tsv` in [[workflow-memory]] lists 12 secret shapes (private-key block, GitHub, GitLab, Slack, Telegram, Google and AWS keys, bearer tokens, password assignments), 2 phone shapes and 1 Brazilian CPF (Cadastro de Pessoas Físicas, the taxpayer number) shape. The memory moves an event that matches one into `quarantine/` with a reason ([[mem-validator]]); the wiki runs the same list in `wiki check` and refuses to publish a page that matches (CO-4), and also refuses any e-mail address except Giovanni's and Anthropic's no-reply address. The wiki keeps a copy and its gate fails if the two files differ on the laptop.
3. **Allow-list capture and a scanner in machine-bootstrap**. Only the files named in `mb.toml` are ever read; each is scanned for seven secret shapes and a flagged file is refused by name, never by content; the gate scans `state/` again (`python3 -m mb scan`). Real secrets travel only in a passphrase-encrypted archive made with `gpg` and kept in two places ([[checks-machine-bootstrap]]).
4. **Secret files stay outside git**. The wiki reads its keys from `~/.config/wiki/oauth.env` and `secret.env` (mode 600, readable by the owner only) and the rule is never to print or commit them.
5. **Append-only memory**. The CI (continuous integration) job `append-only` in [[workflow-memory]] fails when an event file is edited in place, so the history of what Giovanni decided cannot be rewritten silently.
6. **Declared dependencies**. [[checks-radiology-crawler]] fails the gate when a third-party import is not declared or when CI installs anything but `requirements.txt`.
7. **Shell lint and the gate**: ShellCheck on every shell script ([[checker-catalog]]), then branch protection or the pre-push hook ([[branch-protection-explained]]). "Never force-push" is a standing preference in the memory.

Not found in any repository file: automatic dependency-vulnerability scanning, GitHub secret scanning configuration and code-scanning workflows. Whether GitHub has any of these switched on in its settings was not checked.

## How it does it
Each layer reports the kind of problem and the place (a line number or a file name), never the value, so the log itself cannot leak a secret. The scanners are safety nets, not guarantees: the working rules still say that Claude must not write such data in the first place ([[wiki-check]]).

## Where it sits in the pipeline
It runs inside step 4 and 5 of [[code-security-pipeline]].

## Who receives its output
The author of the change (a refusal or a warning) and [[giovanni]], who decides about any exception.

## Steps
1. A text or file is about to be stored or published. Actor: the tool for that project ([[mem-validator]], [[wiki-check]] or the machine-bootstrap scanner). Output: pass, or a refusal naming the secret kind.
2. A visitor reaches the wiki. Actor: [[wiki-router]]. Output: the real page for Giovanni, the decoy for everyone else.
3. Code is changed. Actor: the project gate. Output: pass or the first failing check, including ShellCheck and dependency checks where the project has them.
4. A push reaches `main`. Actor: branch protection or the pre-push hook. Output: accepted, or stopped with the failing check.
