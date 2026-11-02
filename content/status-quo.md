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
sources: [status-quo:README.md, status-quo:DESIGN.md, status-quo:CLAUDE.md, status-quo:Cargo.toml, status-quo:Cargo.lock, status-quo:.cargo/config.toml, status-quo:.gitignore, status-quo:pipeline-check.toml, status-quo:pipeline-check.version, status-quo:.github/workflows/quality-gate.yml, status-quo:docs/REQUIREMENTS.md, status-quo:docs/adr/0002-portable-rust-widgets.md, status-quo:tools/quality_gate.sh, status-quo:tools/rust_architecture.rs, status-quo:tools/resource_check.rs, status-quo:crates/core/Cargo.toml, status-quo:crates/core/src/config.rs, status-quo:crates/core/src/data.rs, status-quo:crates/core/src/lib.rs, status-quo:crates/core/src/tokens.rs, status-quo:crates/core/tests/behavior.rs, status-quo:crates/core/tests/cumulative.rs, status-quo:crates/desktop/Cargo.toml, status-quo:crates/desktop/src/main.rs, status-quo:crates/tray/Cargo.toml, status-quo:crates/tray/src/lib.rs, status-quo:crates/tray/src/ui.rs, status-quo:crates/tray/tests/layout.rs, status-quo:crates/web/Cargo.toml, status-quo:crates/web/site/index.html, status-quo:crates/web/src/lib.rs, status-quo:crates/widgets/Cargo.toml, status-quo:crates/tray/src/layout.rs, status-quo:crates/desktop/src/host/mod.rs, status-quo:crates/desktop/src/host/layer.rs, status-quo:crates/desktop/src/host/x11.rs, status-quo:crates/sources/src/lifecycle.rs, status-quo:crates/sources/src/local.rs, status-quo:crates/sources/src/logs.rs, status-quo:crates/sources/src/parse.rs, status-quo:crates/sources/tests/adapters.rs, status-quo:crates/store/Cargo.toml, status-quo:crates/store/src/lib.rs, status-quo:crates/store/tests/durable.rs, status-quo:docs/adr/0004-host-compatibility-layer.md, status-quo:crates/desktop/src/native.rs, status-quo:crates/sources/Cargo.toml, status-quo:crates/sources/examples/account_status.rs, status-quo:crates/sources/examples/log_diagnostics.rs, status-quo:crates/sources/src/accounts.rs, status-quo:crates/sources/src/github.rs, status-quo:crates/sources/src/lib.rs, status-quo:crates/desktop/src/install.rs, status-quo:crates/contract/Cargo.toml, status-quo:crates/contract/src/lib.rs, status-quo:crates/contract/tests/registry.rs, status-quo:crates/collector/Cargo.toml, status-quo:crates/collector/src/lib.rs, status-quo:crates/collector/src/workers.rs, status-quo:crates/collector/src/events.rs, status-quo:crates/collector/tests/lifecycle.rs, status-quo:crates/collector/tests/transport.rs]
reviewed: 2026-11-02T14:01Z
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

**Contract.** `crates/contract` defines how a host registers widget types and how requests and snapshots are framed. Incompatible versions and oversized frames are rejected, and an unrelated sample widget proves that registration works without changing the tray (`tests/registry.rs`, `tests/transport.rs`).

**Hooks.** The installer adds Status Quo entries to `~/.claude/settings.json` and `~/.codex/hooks.json` and keeps every existing hook. It was run on 2026-11-02.

**Compatibility layer.** `crates/desktop/src/host/` is the only code that knows how the tray is placed on a given Linux desktop, and it chooses at run time, so one program works across distributions (decision in `docs/adr/0004-host-compatibility-layer.md`). Layer-shell, a Wayland protocol that lets a program draw on the desktop layer, is used when the compositor offers it (KDE Plasma, Hyprland, sway); the tray then has no frame, is anchored to an edge or corner (`STATUS_QUO_ANCHOR`, default top-right) and draws only when something changed. On an X11 session it uses a frameless window with window-manager hints for below, off the taskbar and off the pager; asking for all workspaces is best effort because KDE's X11 compatibility ignores it. Everywhere else, for example GNOME on Wayland, it falls back to an ordinary window and says so. `STATUS_QUO_HOST=layer-shell|x11|window` forces a choice when it can work. In these two hosts the tray is bare: it has no background or title of its own, only the widgets and the three small buttons Add widget, Edit tray and Customize are visible (the connection status appears only while disconnected), and the rows of widgets are scaled so they fill the tray space exactly, with equal gaps. Customization and screenshots use the ordinary window because the layer host has no keyboard input yet.

**Edit tray (requirement SQ-29).** The Edit tray button turns the tray into a direct editor that works with the pointer alone. Dragging the bottom border of a widget sets its height (100 to 1400 pixels); dragging a side border sets its width, one column or two (a border dragged past three quarters of the tray width means two columns); dragging the body of a widget and dropping it on another widget moves it to that position. All changes happen on a draft copy: Done saves it through the same validated configuration path as Customize, and Cancel discards it. Tests drive real pointer events through the tray; a drag on the live desktop compositor is not yet observed.

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
`DESIGN.md` holds the architecture diagram and a dated decision log with the type of each decision. Three architecture decision records (ADRs, short notes that keep the reasons for a decision) are in `docs/adr/`: 0001 record decisions, 0002 portable Rust widgets, 0003 the program measures and the skill judges.

### Requirements
29 requirements (prefix SQ) in `docs/REQUIREMENTS.md`, all covered by tagged tests on 2026-11-02. A tag proves a test exists, not that the real desktop behaves correctly.

### Quality gate
Five steps: formatting, compiler diagnostics with warnings denied plus all tests, the Rust boundary check, requirement traceability and the 1200-second gate-duration limit. `tools/resource_check.rs` measures the real processes over five minutes. The first observation met the memory target (115 MiB of 200 MiB) and missed idle CPU (2.05% of one core against 1%).

### Continuous integration
Continuous integration (CI) means automatic checks on every push. `quality-gate.yml` installs Rust 1.87, runs `pipeline-check --mode ci` pinned in `pipeline-check.version`, and builds the browser version. It passed on the first commit.

### Maintenance
Technical debt belongs in GitHub issues labelled `debt` (P1 to P3) under the [[maintenance-policy]], and the [[monthly-architecture-review]] checks the project. Branch protection cannot be enabled on a private repository on the free GitHub plan.

## Notes
Build with `cargo build --release --locked -p status-quo`; the installer is `status-quo install` and `status-quo uninstall` reverses it. State lives in `~/.local/state/status-quo`; `STATUS_QUO_STATE_DIR` redirects it for tests. On the laptop, test runs on 2026-11-02 showed the layer-shell host with live data, the collector seeing real assistant sessions through the hooks, a mouse click changing a widget, and a 60-second idle measurement of 1.08% of one core and 195 MB combined (the graphics driver libraries account for most of the panel's 156 MB). Not yet observed: login startup, the 100 ms interaction limit, the full five-minute run, keyboard input in the layer host, GNOME or any other desktop than KDE Plasma, and a real X11 session. The cause of the remaining idle CPU use is open.
