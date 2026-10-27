---
id: codex-pbar
title: Codex terminal task progress
aliases: [Codex status bar, codex-task-progress]
kind: project
project: codex-pbar
status: active
location: codex-pbar:src/codex_pbar/terminal.py
fed_by: [global-codex-agents]
feeds: []
sources: [home:fixes/codex-touchpad-scroll.sh, home:fixes/LEIAME.md, codex-pbar:docs, codex-pbar:src/codex_pbar, codex-pbar:tests, codex-pbar:tools, codex-pbar:upstream, codex-pbar:pipeline-check.toml, codex-pbar:pipeline-check.version, codex-pbar:pyproject.toml, codex-pbar:.github/workflows/quality-gate.yml, codex-pbar:.gitignore, codex-pbar:AGENTS.md, codex-pbar:CLAUDE.md, codex-pbar:DESIGN.md, codex-pbar:docs/2026-10-25-codex-pbar-design.md, codex-pbar:docs/MAINTENANCE.md, codex-pbar:docs/REQUIREMENTS.md, codex-pbar:src/codex_pbar/terminal.py, codex-pbar:tests/test_terminal.py, codex-pbar:tests/test_terminal_mouse.py, codex-pbar:tools/terminal_smoke.py, codex-pbar:docs/adr/0004-persistent-terminal-footer.md, codex-pbar:README.md, home:AGENTS.md, home:.codex/AGENTS.md, home:.config/systemd/user/codex-pbar.service]
reviewed: 2026-10-27T01:34Z
---

## What it is
A fixed line at the bottom of Giovanni's Codex terminal shows task progress and estimated time remaining. The Python source lives in `~/dev/codex-pbar`. Start with its `README.md`. This is separate from the Claude terminal display [[pbar]].

## Flow
trigger t1: Giovanni starts codex in a terminal | [[global-codex-agents]]
step s1: The codex launcher wraps the session in tmux
step s2: A dedicated codex-status server reserves the bottom row of the terminal | [[codex-status-line]]
step s3: Each terminal gets its own identifier, linking its footer to its task state
trigger t2: Codex starts a task with several steps
step s4: The agent runs codex-task-progress set with steps done, total, seconds left and label
decide d1: Is there an active task plan?
decide d2: Has the time estimate run out?
product p1: Footer shows percentage, tasks done and time left
product p2: Footer shows over by, and the excess time
product p3: Footer says No active task

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
t2 -> s4
s4 -> d1
d1 -yes-> d2
d1 -no-> p3
d2 -no-> p1
d2 -yes-> p2

## Architecture
### Context
person g: Giovanni — works with Codex in a terminal | [[giovanni]]
system p: codex-pbar — shows task progress under the terminal
external a: Global Codex instructions — tell Codex to report milestones | [[global-codex-agents]]
external x: Codex — the assistant doing the work | [[codex]]
external t: tmux terminal — has the row where the footer is drawn

a -instructs-> x
x -reports milestones to-> p
p -draws the footer in-> t
g -reads the footer in-> t

### Containers
person g: Giovanni | [[giovanni]]
external x: Codex session files | [[codex]]
container rd: Incremental reader — the only code that opens session files
container co: Pure session state — keeps no prompt or tool text
container ap: Desktop window — kept, not switched on
container ft: Terminal footer — completed/total tasks and time left
store ts: Private task state — written by milestone updates
store hs: Private timing history — hashed

rd -reads-> x
rd -updates-> co
rd -appends to-> hs
co -feeds-> ap
ft -reads-> ts
g -sees-> ft

## What it does
The line remains visible while Codex works or waits. It matches Claude’s compact style: a green Progress label on the normal terminal background, middle-dot separators, percentage, completed tasks and estimated time remaining. It draws no block bar. For example, two completed steps out of five show `Progress: [ 40%] 2/5 tasks`. Time alone never advances the percentage. If an estimate runs out, the line says `over by` and the elapsed excess. When there is no task plan, the line says `No active task`. Explicit completion remains visible until the next task starts.

## How it does it
The installed `codex` launcher wraps interactive sessions in tmux, a program that keeps terminal programs running after disconnection (see [[glossary]]). A dedicated `codex-status` server reserves its bottom row outside Codex's drawing area. The native `task-progress` setting remains configured, but the fixed row does not depend on the model's planning tool. Each new terminal receives a unique identifier linking its footer to its task state. Different tasks do not share a counter.

The agent updates the local command `codex-task-progress set --done 2 --total 5 --eta 300 --label 'Testing'`. `--eta` is seconds remaining; `--new` starts a new task. Instructions in both local `AGENTS.md` files make the agent maintain the count. State is saved by replacing a complete private file under `~/.local/share/codex-pbar/tasks/`; incomplete writes cannot replace valid state. Labels are short task descriptions. No model request or network listener is added.

The installer saves the original Codex executable path and replaces the `~/.local/bin/codex` link with a launcher. It preserves arguments and exit status for noninteractive commands, including `codex exec` and `codex --version`. The original binary, hooks and approval configuration are unchanged. Re-run the installer after a Codex installer replaces the launcher. `CODEX_PBAR_DISABLE=1 codex` bypasses the footer. A terminal process already running before installation is not retroactively wrapped; a terminal interface launched through this wrapper can resume the same conversation without starting a new task.

## Where it sits in the pipeline
It runs in the laptop terminal. The quality gate, the automated checks required before completion, runs tests and controlled fault injections through [[pipeline-check]]. The live terminal check attaches an existing conversation without sending a prompt, rejects a working-directory selection dialog as a false pass, verifies two terminal widths and a quiet period, and saves a terminal capture under `build/`.

## Who receives its output
Giovanni reads the footer. The agent can inspect `codex-task-progress show`. The older desktop window implementation is not enabled by this terminal installation.

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
1. **Requirements precede changes**: tests carry `REQ PB-N`, and the traceability step of the gate fails when one has none.
2. **Pure modules stay free of GUI and network code**: the state and the reader are tested by plain unit tests, with branch coverage required.
3. **Nothing private is kept**: no model or network calls, no authentication reads, and no raw tool arguments or output in the saved status or history.
4. **The gate decides**: `tools/quality_gate.sh` is the only definition of passing, and continuous integration runs it.

### Decisions
Four architecture decision records (ADRs, short notes that keep the reasons for a decision) in `docs/adr/`: 0002 a Python desktop companion that reads session files; 0003 a program measures and a skill judges; 0004 the persistent terminal footer in a dedicated tmux row, bound to its session. `DESIGN.md` holds the diagram and the decision log.

### Requirements
10 requirements (prefix PB) in `docs/REQUIREMENTS.md`. Each has a test tagged `REQ PB-N`, and the traceability check ([[check-traceability]]) fails when one has none.

### Quality gate
The gate runs the unit tests with branch coverage of at least 85 % on the state and reader modules; a mutation check (faults planted on purpose must be caught); a window smoke test without a screen; requirement traceability; and the fitness functions.

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` runs the gate on GitHub for every push, through `pipeline-check` pinned in `pipeline-check.version`.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` (P1 to P3) under the [[maintenance-policy]]. The [[monthly-architecture-review]] checks the project every month; the next is due 2026-11-22.

## Notes
Install from `~/dev/codex-pbar` with `PYTHONPATH=src .venv/bin/python -m codex_pbar.terminal install`. Detach with `Ctrl-b d` and reattach with `tmux -L codex-status attach`. Estimated time is the agent's forecast, not a measured guarantee. This change adds no token, context or quota fields.


Failure limits: the fixed row requires the installed launcher and tmux. A missing or corrupt state file shows unknown values. A missing tmux executable reports an error. Marking all planned steps done explicitly sets 100%. New terminals have separate identifiers; two views of the same resumed conversation intentionally share its task counter. Existing desktop-window code remains in the repository but this installer does not start it.


Project files: `AGENTS.md` points contributors to `CLAUDE.md`, which describes the Python architecture, privacy limits and required checks. `DESIGN.md` records the current terminal design and decisions. `docs/2026-10-25-codex-pbar-design.md` preserves the original desktop design; the newer terminal decision is in `docs/adr/0004-persistent-terminal-footer.md`. `docs/REQUIREMENTS.md` lists PB-1 through PB-10, including the retained desktop behavior and the terminal promises. `docs/MAINTENANCE.md` describes monthly reviews and debt handling. `.github/workflows/quality-gate.yml` runs the shared checker on pushes and pull requests and retains its report for fourteen days. `.gitignore` excludes virtual environments, Python caches, coverage files and build output, including private terminal captures, from version control.


Validation files: `docs/TESTES-AUTOMATIZADOS.md` describes the test strategy, known gaps and terminal checks. `docs/TRACEABILITY.md` is generated and links PB-1 through PB-10 to their tests. `pipeline-check.toml` selects the required gate, forbids network-library imports in the source directory, sets a 1200-second gate limit and names the GitHub gate. `pipeline-check.version` pins the shared checker to `v0.5.0`; `tools/pipeline-check.sh` consumes that version rather than copying its implementation. `pyproject.toml` declares Python and the pinned display and test dependencies.

Decision files: `docs/adr/README.md` explains architecture decision records, short files recording the reason for structural choices, and `0000-template.md` supplies their format. `0001-record-decisions.md` requires recording those choices; `0002-python-transcript-companion.md` records the original desktop architecture; `0003-program-measures-skill-judges.md` separates automated measurement from maintenance judgement. The terminal decision is `0004-persistent-terminal-footer.md`. The `src/codex_pbar/` modules retain the desktop reader, state and display alongside the terminal entry point; `tests/` and `tools/` contain their checks and installers. `upstream/` holds the archival Claude source, which is not executed.


Blocked user tasks pause the countdown and show `Blocked`; they do not keep accumulating overdue time. `codex-task-progress clear` removes a stale counter for the bound session. An idle greeting needs no task plan. Automatic documentation hooks retain the primary task counter rather than replacing it with documentation work.

`task-progress` is an entry in `tui.status_line` in `~/.codex/config.toml`; [[codex-status-line]] describes the other native fields. New conversations get distinct identifiers. An explicit `codex resume <conversation UUID>` uses that conversation identifier, so two views resumed by the same identifier share the counter. To pause the estimate, update the unfinished counter with a label beginning `Blocked:`, for example `codex-task-progress set --done 2 --total 5 --eta 300 --label 'Blocked: waiting for access'`.

The global instruction file [[global-codex-agents]] describes how the assistant maintains task progress. At this review, `codex-pbar.service`, the older desktop-window service, is masked and inactive: its service file is linked to `/dev/null`, which prevents it from starting. The active terminal footer uses the launcher instead.

The terminal can be checked without opening a second Codex frontend: attach a read-only client to its existing tmux session with `tmux -L codex-status attach-session -r -f ignore-size -t SESSION`. Replace `SESSION` with the session whose footer command contains the current `CODEX_PBAR_SESSION`. The read-only client cannot send input, and `ignore-size` keeps its resize from changing the working terminal. On 2026-10-26 this method verified the fixed footer at 116×53 and 70×35, through idle and redraw; the wide view also showed the native five-hour and weekly budget percentages, context used and context capacity. The older `tools/terminal_smoke.py` starts another Codex frontend and currently stops at the conversation ownership lock; that failure does not show that the existing terminal footer is absent.

Each new interactive terminal enables tmux mouse forwarding and installs wheel bindings before attachment. In fullscreen Codex without mouse capture, each tick sends native one-row wheel events for one quarter of the current pane height, rounded down with a minimum of one row. tmux recalculates the count on every tick, so resizing changes the step automatically. This uses Codex's default one-row mouse-scroll speed. Applications requesting mouse capture and tmux copy mode keep their native events. The earlier full-page fallback restored scrolling but made each tick jump too far. Real-terminal fixtures now check movement in both directions at pane heights 24, 18 and 3; controlled faults change the divisor or reverse either direction. Hold Shift while dragging to use Konsole's own text selection. The launcher reapplies the bindings on every new session; the current server is repaired without restarting Codex.

The repair helper `~/fixes/codex-touchpad-scroll.sh` reapplies the maintained wheel bindings to the running dedicated server. Its `--undo` option restores the previous wheel bindings for that server; future launcher starts still install the correction. `~/fixes/LEIAME.md` records the cause, checks and rollback limits.

Giovanni confirmed the quarter-screen movement feels right. A live capture measured 13 rows from one tick in a 52-row pane. A fresh session through the installed launcher moved seven rows in its 29-row pane, in both directions, without a model request. The continuous integration workflow installs tmux, and the regression fails rather than skips when tmux is missing. A physical reboot was not tested.
