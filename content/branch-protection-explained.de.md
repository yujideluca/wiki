---
id: branch-protection-explained
lang: de
source_hash: 0a0bff868819
title: Branch-Schutz und Pre-Push-Hook erklärt
---

## What it is
Ein Branch ist eine Arbeitslinie in Git; `main` ist die Linie, die als offizielle Version gilt. Branch-Schutz ist eine GitHub-Einstellung, die Änderungen an `main` ablehnt, bis genannte Prüfungen grün sind (hier: der CI-Job `gate`, CI = Continuous Integration). Ein Hook ist ein kleines Programm, das bei einem Ereignis automatisch läuft; der Pre-Push-Hook läuft direkt vor dem Senden der Commits mit `git push`.

## What it does
Zwei Wächter schützen `main`. Auf GitHub ist der Job `gate` eine Pflichtprüfung ([[ci-explained]]). Auf dem Laptop führt `tools/hooks/pre-push` den Befehl `pipeline-check --pre-push` aus, der das Gate laufen lässt und den Push von `main` stoppt, wenn eine Prüfung fehlschlägt; `[pre_push] guard` in `pipeline-check.toml` listet Pfadpräfixe, damit ein Push, der nur andere Dateien berührt, nicht geprüft wird. Er wird einmal pro Klon mit `git config core.hooksPath tools/hooks` eingeschaltet und absichtlich mit `git push --no-verify` umgangen. Die weitere Regel „niemals Force-Push“ ist eine feste Präferenz im Gedächtnis.

## How it does it
Branch-Schutz ist nur bei öffentlichen Repositories kostenlos (GitHub Free lehnt ihn bei privaten mit Fehler 403 ab), daher verlassen sich die privaten auf den Hook. Die Berichtsprüfung `protecao-de-branch` liest die echte Einstellung mit dem Befehl `gh`. Ein Projekt, das den Schutz nicht haben kann, hält den Grund in `protection_exception` in seiner `pipeline-check.toml` fest, und die Prüfung meldet dann `aviso`, nie `ok`. Heute erklären zwei Projekte eine Ausnahme: [[checks-workflow-memory]] (sein `mem`-Job pusht mit GitHubs eingebautem Token nach `main`, was eine Pflichtprüfung ablehnen würde) und [[checks-codex-pbar]] (privates Repository im kostenlosen Tarif).

## Where it sits in the pipeline
Schritt 1 von [[code-security-pipeline]], mit der weiteren Politik in [[maintenance-pipeline]].

## Who receives its output
Die Person oder Sitzung, die pusht: Ein abgelehnter Push nennt die fehlgeschlagene Prüfung.
