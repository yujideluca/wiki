---
id: status-quo
title: Status Quo desktop widget tray
aliases: [Status Quo app, widget tray]
kind: project
project: status-quo
status: beta
since: 2026-11-01
location: status-quo:README.md
fed_by: [claude-code, codex, github, workflow-memory]
feeds: []
sources: [status-quo:README.md, status-quo:DESIGN.md, status-quo:CLAUDE.md, status-quo:Cargo.toml, status-quo:Cargo.lock, status-quo:.cargo/config.toml, status-quo:.gitignore, status-quo:pipeline-check.toml, status-quo:pipeline-check.version, status-quo:.github/workflows/quality-gate.yml, status-quo:docs/REQUIREMENTS.md, status-quo:docs/adr/0002-portable-rust-widgets.md, status-quo:tools/quality_gate.sh, status-quo:tools/rust_architecture.rs, status-quo:tools/resource_check.rs, status-quo:crates/core/Cargo.toml, status-quo:crates/core/src/config.rs, status-quo:crates/core/src/data.rs, status-quo:crates/core/src/lib.rs, status-quo:crates/core/src/tokens.rs, status-quo:crates/core/tests/behavior.rs, status-quo:crates/core/tests/cumulative.rs, status-quo:crates/desktop/Cargo.toml, status-quo:crates/desktop/src/main.rs, status-quo:crates/tray/Cargo.toml, status-quo:crates/tray/src/lib.rs, status-quo:crates/tray/src/ui.rs, status-quo:crates/tray/tests/layout.rs, status-quo:crates/web/Cargo.toml, status-quo:crates/web/site/index.html, status-quo:crates/web/src/lib.rs, status-quo:crates/widgets/Cargo.toml, status-quo:crates/widgets/src/lib.rs, status-quo:crates/widgets/tests/models.rs, status-quo:docs/adr/0000-template.md, status-quo:docs/adr/README.md, status-quo:docs/2026-11-01-status-quo-design.md, status-quo:docs/MAINTENANCE.md, status-quo:docs/TESTES-AUTOMATIZADOS.md, status-quo:docs/TRACEABILITY.md, status-quo:docs/adr/0003-program-measures-skill-judges.md, status-quo:crates/tray/src/layout.rs, status-quo:crates/desktop/src/host/mod.rs, status-quo:crates/desktop/src/host/layer.rs, status-quo:crates/desktop/src/host/x11.rs, status-quo:crates/sources/src/lifecycle.rs, status-quo:crates/sources/src/local.rs, status-quo:crates/sources/src/logs.rs, status-quo:crates/sources/src/parse.rs, status-quo:crates/sources/tests/adapters.rs, status-quo:crates/store/Cargo.toml, status-quo:crates/store/src/lib.rs, status-quo:crates/store/tests/durable.rs, status-quo:docs/adr/0004-host-compatibility-layer.md, status-quo:docs/adr/0005-free-canvas-layout.md, status-quo:crates/desktop/src/native.rs, status-quo:crates/sources/Cargo.toml, status-quo:crates/sources/examples/account_status.rs, status-quo:crates/sources/examples/log_diagnostics.rs, status-quo:crates/sources/src/accounts.rs, status-quo:crates/sources/src/github.rs, status-quo:crates/sources/src/lib.rs, status-quo:crates/desktop/src/install.rs, status-quo:crates/contract/Cargo.toml, status-quo:crates/contract/src/lib.rs, status-quo:crates/contract/tests/registry.rs, status-quo:crates/collector/Cargo.toml, status-quo:crates/collector/src/lib.rs, status-quo:crates/collector/src/workers.rs, status-quo:crates/collector/src/events.rs, status-quo:crates/collector/tests/lifecycle.rs, status-quo:crates/collector/tests/transport.rs, status-quo:tools/ui_e2e.sh, status-quo:crates/desktop/tests/desktop_e2e.rs, status-quo:crates/desktop/tests/e2e/manual-baseline.json]
reviewed: 2026-11-02T16:22Z
---

## What it is
Status Quo is a desktop widget environment written in Rust: small always-visible panels on the desktop itself, without a window frame, that show how much of Giovanni's Claude and Codex usage limits is spent, token graphs, the sessions each assistant is running, recent GitHub activity and recent workflow-memory entries. The code lives in `~/dev/status-quo` and in the private GitHub repository `yujideluca/status-quo`. Start with its `README.md`. The approved scope is on [[status-quo-design]] and the layout mockup on [[status-quo-layout]]; this page describes the code as built.

Every display is a separate widget that can be removed, replaced or moved to another program, and the tray that arranges them is reusable too. KDE, the desktop shell on the laptop, is the first host; nothing portable depends on it.

## Flow
trigger t1: Giovanni opens the panel, or it starts at login
trigger t2: A Claude or Codex session starts, waits or stops | [[claude-code]], [[codex]]
step s1: The panel starts the collector, one background process per user, if none runs
step s2: The collector reads account status, session transcripts, GitHub and memory | [[workflow-memory]], [[github]]
step s3: An assistant hook records the event for the collector
step s4: Results are stored in a private folder, keeping the last good value of each source
step s5: The panel asks the collector for a snapshot over a local socket
decide d1: Is a source unavailable or out of date?
step s6: The tray draws each registered widget in the chosen terminal style
product p1: Widgets show usage, graphs, sessions, activity and memory
product p2: The affected widget says what is missing and how old its data is

t1 -> s1
t2 -> s3
s1 -> s2
s2 -> s4
s3 -> s4
s4 -> s5
s5 -> d1
d1 -no-> s6
d1 -yes-> p2
s6 -> p1

## Architecture
### Context
person g: Giovanni — reads usage, sessions and activity on the desktop | [[giovanni]]
system sq: Status Quo — the widget panel and its collector
external cc: Claude Code — its transcripts and hooks | [[claude-code]]
external cx: Codex — its transcripts and hooks | [[codex]]
external gh: GitHub — repository activity, read through the gh program | [[github]]
external wm: workflow-memory — shared notes, read only | [[workflow-memory]]

cc -sends session events and transcripts to-> sq
cx -sends session events and transcripts to-> sq
gh -supplies repository activity to-> sq
wm -supplies recent entries to-> sq
g -reads the panel of-> sq

### Containers
container co: Core — validated configuration, token ledger and normalized records, with no input or output
container ct: Contract — widget registry and the versioned messages between host and collector
container wd: Widgets — display models that cannot read files or start programs
container sc: Sources — read-only adapters for accounts, transcripts, GitHub and memory
container cl: Collector — background workers and the per-user socket
container tr: Tray — egui layout and customization, with terminal style
container dk: Desktop wrapper — compatibility layer that picks layer-shell, X11 hints or a plain window; installer and hooks
store st: Private state folder — configuration, snapshot and lifecycle events

wd -uses-> co
tr -draws models from-> wd
tr -registers widgets through-> ct
cl -fills records from-> sc
cl -serves snapshots through-> ct
cl -saves data in-> st
dk -hosts-> tr
dk -starts-> cl

## What it does
The panel has five initial widgets, instantiated for each assistant where that applies, giving seven by default: Claude and Codex account usage, Claude and Codex token history, sessions grouped by project, recent GitHub activity and workflow-memory entries. Usage shows the percentage used for the five-hour and weekly limits with reset times; it never derives a percentage from local token counts. Token graphs switch between 24 hours, 7 days and 30 days, and between per-bucket and cumulative views. Missing values are shown as unavailable, never zero.

The customization tab changes light, dark or system mode, accent colors, background opacity, text size and widget order and size. Changes preview first and can be cancelled. Widgets can be added, removed, hidden or detached. The default stacking is behind normal windows, anchored to the top-right corner; on the laptop it was seen hidden behind a maximized browser and visible on an empty workspace.

## How it does it
The code is a Rust workspace of nine packages. `sq-core`, `sq-contract` and `sq-widgets` hold the portable logic and may not use graphics, files, processes or the network; `tools/rust_architecture.rs` checks this on every gate run, because the shared checker only understands Java and Kotlin. `sq-sources` reads outside data, `sq-store` writes it atomically, `sq-collector` runs the workers and serves a versioned, size-limited socket, `sq-tray` is the reusable egui interface (egui is a Rust library for drawing interfaces), `status-quo` is the Linux wrapper and `sq-web` is a browser demonstration with invented data.

**Collector.** `crates/collector/src/lib.rs` holds the socket server and process lock, so only one collector runs per user. `workers.rs` runs one worker per source: account status, session transcripts, GitHub and memory. Each worker keeps its last valid data with a freshness and error state, so one broken source never freezes the rest. Workers watch folders for changes and fall back to 2-second polling only when a watch fails. The collector creates its own private `events` folder before watching it; before that fix, a missing folder forced polling and tripled idle CPU use. `events.rs` writes one small file per session lifecycle event, under a lock, and keeps no prompt or tool text. A Stop event means the session is waiting, not that its task is complete.

**Widgets.** `crates/widgets/src/lib.rs` (package `sq-widgets`) registers the five built-in widget types, `quota`, `tokens`, `sessions`, `activity` and `memory`, through `registry()`. Each type turns a snapshot from the collector into a view, a list of plain nodes (text, rows, notices) that the tray draws; the package cannot read files or start programs. A row keeps at most 100 entries for GitHub activity and for memory. A widget also adds a notice when its source is not fresh, or has malformed or deferred records, and "Waiting for source status" before any status exists. The sessions widget shows running, waiting and blocked sessions always, completed ones for one hour, others for 24 hours, unless its `history` option is `true`. `format_utc` prints times as `YYYY-MM-DD HH:MM UTC` without reading a clock. The tests in `crates/widgets/tests/models.rs` (requirements SQ-5, SQ-6, SQ-8, SQ-10, SQ-11) check, among others, that a missing quota is not shown as zero, that projects with the same folder name stay separate, that nested agents stay under their real parent and that dates at the extremes do not overflow.

**Contract.** `crates/contract` defines how a host registers widget types and how requests and snapshots are framed. Incompatible versions and oversized frames are rejected, and an unrelated sample widget proves that registration works without changing the tray (`tests/registry.rs`, `tests/transport.rs`).

**Hooks.** The installer adds Status Quo entries to `~/.claude/settings.json` and `~/.codex/hooks.json` and keeps every existing hook. It was run on 2026-11-02.

**Compatibility layer.** `crates/desktop/src/host/` is the only code that knows how the tray is placed on a given Linux desktop, and it chooses at run time, so one program works across distributions (decision in `docs/adr/0004-host-compatibility-layer.md`). Layer-shell, a Wayland protocol that lets a program draw on the desktop layer, is used when the compositor offers it (KDE Plasma, Hyprland, sway); the tray then has no frame, is anchored to an edge or corner (`STATUS_QUO_ANCHOR`, default top-right) and draws only when something changed. On an X11 session it uses a frameless window with window-manager hints for below, off the taskbar and off the pager; asking for all workspaces is best effort because KDE's X11 compatibility ignores it. Everywhere else, for example GNOME on Wayland, it falls back to an ordinary window and says so. `STATUS_QUO_HOST=layer-shell|x11|window` forces a choice when it can work. In these two hosts the tray is bare: it has no background or title of its own, only the widgets and the three small buttons Add widget, Edit tray and Customize are visible (the connection status appears only while disconnected), and the rows of widgets are scaled so they fill the tray space exactly, with equal gaps. Customization and screenshots use the ordinary window because the layer host has no keyboard input yet.

**Edit tray (requirement SQ-29, redesigned 2026-11-02, decision in `docs/adr/0005-free-canvas-layout.md`).** The Edit tray button turns the tray into a free canvas editor that works with the pointer alone. Each widget can carry an explicit rectangle in pixels (`x`, `y`, `width`, `height`, in `crates/core/src/config.rs`); a width of 0 keeps the old flow of rows, so old configurations load unchanged, and the validator accepts widths of 120 to 8000 and heights of 60 to 8000. Pressing Edit tray first freezes what is on screen into rectangles, so nothing jumps (`freeze` in `crates/tray/src/layout.rs`). Then every border and corner of a widget resizes it on both axes to any size, and dragging the body moves it anywhere (`drag_rect`, which keeps a minimum size and never crosses the canvas corner). Widget content is switched off while editing so it cannot take the pointer from the handles. All changes happen on a draft copy: Done normalizes the canvas to its corner, records the corner's desktop position in the saved `tray` geometry and saves through the same validated configuration path as Customize; Cancel discards the draft. Widgets learn how much room they have: charts take about 55 percent of the widget height, and token controls and meter text wrap (`crates/tray/src/ui.rs`). Outside editing, the tray reports the size it wants (`desired_size`: the canvas from `free_rects` and `canvas_size`, plus the header), and the layer-shell host sizes its surface to match (`Surface` in `crates/desktop/src/host/layer.rs`, chosen by `LayerApp` in `crates/desktop/src/main.rs`): `Legacy` is the first-run corner layout, `Free` docks the surface at the saved desktop position, and `Editing` covers the whole output, transparent and above windows, so a widget can be dragged anywhere. Window hosts follow with an inner-size request instead. The docked surface is kept on the screen: `clamp_to_screen` in `layer.rs` slides a tray that a widget move made too wide or too low back inside the output, and `docked_origin` reports the clamped corner, so the header buttons stay reachable. Overlapping widgets are allowed; the tray draws each free widget in its own egui layer (an `Area`), stacked in configuration order, so the widget on top also receives the pointer where widgets overlap (test `a_button_on_the_top_widget_still_works_where_widgets_overlap` in `crates/tray/tests/layout.rs`). Only the first output is used (per-monitor placement is not handled). Checked so far: tests drive real pointer events through the tray, and an isolated run in a real compositor rendered a docked free layout correctly (both as recorded in ADR-0005, the architecture decision record (ADR) of this change; the run itself was not repeated here). Not yet observed: a real-pointer drag in the full-screen editor on the live desktop. The effect of the redesign on the idle CPU use is not measured. The change is in the working tree and not yet committed.

## Where it sits in the pipeline
It runs on the laptop next to [[claude-code]] and [[codex]]. Its checks are on [[checks-status-quo]], and it follows [[project-template]] and [[pipeline-check]].

## Who receives its output
Giovanni reads the panel. Other programs can reuse the tray or single widgets through the contract.

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
1. **Requirements precede changes**: tests carry a standalone `// REQ SQ-n` comment, and the traceability step ([[check-traceability]]) fails when a requirement has none.
2. **Portable packages stay free of input and output**: core, contract and widgets, checked by a project-specific detector with planted-defect self-tests.
3. **Everything is a removable widget**: no permanent provider slots in the tray.
4. **The gate decides**: `tools/quality_gate.sh` is the only definition of passing, and no limit is lowered to make it pass.
5. **Nothing private is stored**: no credentials, conversations or memory contents in fixtures, diagnostics or the browser demo.

### Decisions
`DESIGN.md` holds the architecture diagram and a dated decision log with the type of each decision. Five architecture decision records (ADRs, short notes that keep the reasons for a decision) are in `docs/adr/`: 0001 record decisions, 0002 portable Rust widgets, 0003 the program measures and the skill judges, 0004 the host compatibility layer, 0005 the free canvas layout (2026-11-02, a corrective decision by Giovanni: any widget size and position, and a tray surface that follows its widgets; it amends the tray rows of ADR-0002 and the fixed surface of ADR-0004). ADR-0005 is in the working tree and not yet committed; `DESIGN.md` has a matching decision-log row. `docs/adr/0000-template.md` is the blank form for the next one (status, date, type, who decided, context, decision, alternatives, consequences) and `docs/adr/README.md` is the index; a decided ADR is never rewritten, a new one replaces it. The approved scope is kept in `docs/2026-11-01-status-quo-design.md`.

### Requirements
29 requirements (prefix SQ) in `docs/REQUIREMENTS.md`, all covered by tagged tests on 2026-11-02 (SQ-29, whose wording was replaced on 2026-11-02 for the free canvas, is in the working tree, not yet committed, at the time of this review). `docs/TRACEABILITY.md` is the table the traceability step generates: each requirement with the test files that carry its tag; it is not edited by hand. A tag proves a test exists, not that the real desktop behaves correctly.

### Quality gate
Five steps: formatting, compiler diagnostics with warnings denied plus all tests, the Rust boundary check, requirement traceability and the 1200-second gate-duration limit. An optional sixth step, the desktop end-to-end test, runs only when `STATUS_QUO_E2E=1` is set ([[checks-status-quo]]). `tools/resource_check.rs` measures the real processes over five minutes. The first observation met the memory target (115 MiB of 200 MiB) and missed idle CPU (2.05% of one core against 1%).

### Continuous integration
Continuous integration (CI) means automatic checks on every push. `quality-gate.yml` installs Rust 1.87, runs `pipeline-check --mode ci` pinned in `pipeline-check.version`, and builds the browser version. It passed on the first commit.

### Maintenance
`docs/MAINTENANCE.md` states the method: debt is a GitHub issue labelled `debt` (P1 to P3) and `idea` for features, about one session in five goes to debt or prevention, and a monthly review of every project records a Preventive decision-log row. It follows the template's file and adds that the required CI check `gate` must pass on the exact commit before promotion to `main`. Technical debt belongs in GitHub issues labelled `debt` under the [[maintenance-policy]], and the [[monthly-architecture-review]] checks the project. Branch protection cannot be enabled on a private repository on the free GitHub plan.

## Notes
Build with `cargo build --release --locked -p status-quo`; the installer is `status-quo install` and `status-quo uninstall` reverses it. State lives in `~/.local/state/status-quo`; `STATUS_QUO_STATE_DIR` redirects it for tests. On the laptop, test runs on 2026-11-02 showed the layer-shell host with live data, the collector seeing real assistant sessions through the hooks, a mouse click changing a widget, and a 60-second idle measurement of 1.08% of one core and 195 MB combined (the graphics driver libraries account for most of the panel's 156 MB). `docs/TESTES-AUTOMATIZADOS.md` (in Portuguese, as its name says) is the record of the bug-finding tests; see [[checks-status-quo]]. Not yet observed: login startup, the 100 ms interaction limit, the full five-minute run, keyboard input in the layer host, GNOME or any other desktop than KDE Plasma, and a real X11 session. The cause of the remaining idle CPU use is open.

**Desktop end-to-end test.** This test exercises the real tray on the real desktop, which the ordinary tests cannot do. `tools/ui_e2e.sh` builds the production program and runs `crates/desktop/tests/desktop_e2e.rs`, a Rust test marked ignored so that a plain `cargo test` skips it. The test pauses the live tray, starts a private copy with its own state folder and collector, and drives it with a virtual mouse created through `/dev/uinput` (the Linux interface for fake input devices). It then reads what the tray saved in its configuration and checks it. It covers: start, idle CPU and memory, Edit tray and Cancel, moving a widget, resizing by a corner and by an edge, Done and docking, the token controls, Add widget, Customize and Cancel, and a restart. Afterwards it restarts the live tray.

**Run it:** `tools/ui_e2e.sh` from the repository root, or `STATUS_QUO_E2E=1 tools/quality_gate.sh` to run it as optional gate step 6. **Needs:** a Wayland session, a writable `/dev/uinput` and the screenshot program `spectacle`; without one of them the script prints "skipped" with the reason and exits successfully, so a skip is not a pass. **Output:** `build/e2e/report.json` (each check with `ok` and a detail, a `data` block, and the open findings) and screenshots `build/e2e/*.png`. The expected positions and numbers come from a manual test of 2026-11-02, saved in `crates/desktop/tests/e2e/manual-baseline.json`; `docs/MAINTENANCE.md` section 7 says to repeat the manual pass, update that file and extend the test whenever a major tray update lands.

**Result of the real run on 2026-11-02:** 22 checks passed (read from `build/e2e/report.json`, a generated file that is not in git). Idle CPU for panel plus collector was 1.30% of one core over 20 seconds, and memory 182 MiB (limit 200 MiB). The 1% target of requirement SQ-23 is still missed: the test gates only on a 2% ceiling and records the target result (`meets_sq23_cpu_target_over_20s: false`) as data. The test drove three fixes: the docked tray falling off the screen after a move, the unclamped editing origin, and clicks lost where widgets overlap (decision-log row of 2026-11-02 in `DESIGN.md`).

**Known open findings** (listed in the baseline file under `open_findings` and copied into every report):
- Edit tray ignores the Lock widget layout setting.
- A widget added to a docked free tray stacks below the canvas and can fall outside the screen.
- SIGTERM (the stop signal) is noticed by the layer host only at its next wake-up, about 2 seconds later, so an immediate restart can find the panel lock still held.
- Widgets are frozen at their drawn size when editing starts, so a first-run tray taller than the screen keeps widgets below the screen edge.

**Limits:** one screen size (1920x1080) and the first monitor; button positions are recorded values, not found on screen; the idle check lasts 20 seconds, not the 5 minutes of SQ-23. The test files are in the working tree and not yet committed at the time of writing.

