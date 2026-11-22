---
id: token-thrift
title: token-thrift
aliases: [token-thrift report, token thrift]
kind: project
project: token-thrift
status: active
location: token-thrift:src
fed_by: [claude-code-settings]
feeds: []
sources: [token-thrift:README.md, token-thrift:DESIGN.md, token-thrift:CLAUDE.md, token-thrift:docs/REQUIREMENTS.md, token-thrift:docs/MAINTENANCE.md, token-thrift:docs/adr/0002-single-binary-three-subcommands.md, token-thrift:docs/adr/0003-program-measures-skill-judges.md, token-thrift:src/main.rs, token-thrift:src/report.rs, token-thrift:src/daily.rs, token-thrift:tools/systemd/token-thrift-log.service, token-thrift:tools/systemd/token-thrift-log.timer, token-thrift:src/render.rs, token-thrift:src/statusline.rs, token-thrift:src/hook.rs, token-thrift:src/args.rs, token-thrift:src/timeutil.rs, token-thrift:tools/install.sh, token-thrift:tools/quality_gate.sh, token-thrift:tools/pipeline-check.sh, token-thrift:pipeline-check.toml, token-thrift:pipeline-check.version, token-thrift:Cargo.toml, token-thrift:.github/workflows/quality-gate.yml, home:.claude/settings.json, token-thrift:tests/daily.rs, token-thrift:.gitignore, token-thrift:Cargo.lock, token-thrift:docs/TESTES-AUTOMATIZADOS.md, token-thrift:docs/TRACEABILITY.md, token-thrift:docs/adr/0000-template.md, token-thrift:docs/adr/0001-record-decisions.md, token-thrift:docs/adr/README.md]
reviewed: 2026-11-22T14:38Z
---

## What it is
token-thrift is a small program, written in [Rust](https://www.rust-lang.org/), that shows where the tokens of Giovanni's Claude Code sessions go and warns him before they are wasted. A token is the unit of text a language model counts and charges for; one token is roughly three to four characters. The reason the project exists is on the page [[task-delegation]]: two earlier savings only shortened the text printed at the start of a session, because nothing measured the total. This program measures it.

It is one file with four commands. `token-thrift log` keeps a history with one row per day of the tokens used, in a CSV file (comma-separated values, a plain text table that spreadsheet programs open), updated every night. `token-thrift report` prints where the tokens went over the last days. `token-thrift statusline` prints one warning line for the status line, the strip of text at the bottom of the Claude Code screen. `token-thrift hook-session-start` is run as a hook, a command that Claude Code starts by itself at a fixed moment (here, when a session starts); it prints one sentence when a resumed session has lost its stored copy of the context. Giovanni uses it; the source is in `~/dev/token-thrift` (GitHub repository `yujideluca/token-thrift`, private).

Words used on this page:
- **Context**: everything the model reads for one request, that is, the conversation so far plus instructions and tool results. Claude Code sends the whole context again with every step.
- **Cache** (prompt cache): a stored copy of the context that Claude Code keeps so the next request can read it cheaply. It expires after about one hour without use. When it has expired, the next request stores the context again (a cache rebuild), which costs much more for a large context.
- **Model call**: one request to the model.
- **Subagent**: a helper session that the main session starts for one job; its calls are counted apart.
- **Transcript**: the log file Claude Code writes for each session, one JSON record per line (JSON, JavaScript Object Notation, is a plain-text format for structured data).
- **Cost units**: a score per call, input tokens x 1 + cache-write tokens x 1.25 + cache-read tokens x 0.1 + output tokens x 5. The same weights apply to every model, so the units compare calls with each other and are not dollars.

## Flow
trigger t1: Giovanni runs token-thrift report
trigger t2: Claude Code redraws the status line (every second) | [[claude-code-settings]]
trigger t3: A Claude Code session starts or is resumed | [[claude-code-settings]]
trigger t4: The systemd timer fires at 03:30, or Giovanni runs token-thrift log
step s1: Read the transcripts of the last days and add up every model call
step s2: Print totals, groups and a short What to do list
step s3: Read the session description that Claude Code sends in
step s4: Read the session start description that Claude Code sends in
decide d1: Is the context large, or is its cache cold or about to expire?
decide d2: Is the session resumed and its cache likely expired?
product p1: A report Giovanni reads, to judge a saving by the numbers | [[task-delegation]]
product p2: One warning line under the prompt, or nothing
product p3: One sentence shown at session start, or nothing
step s5: Read all transcripts and add up each UTC day
step s6: Merge the days into the history file and write it
product p4: The file daily.csv, one row per day, kept forever

t1 -> s1
s1 -> s2
s2 -> p1
t2 -> s3
s3 -> d1
d1 -yes-> p2
d1 -no-> p2
t3 -> s4
s4 -> d2
d2 -yes-> p3
d2 -no-> p3
t4 -> s5
s5 -> s6
s6 -> p4

## Architecture
### Context
person g: Giovanni — runs the report and reads the warnings | [[giovanni]]
system t: token-thrift — counts token use and warns about it
external c: Claude Code — pipes JSON into the two small commands and shows their output | [[claude-code]]
external s: Claude Code settings — call the program from the status line and the start hook | [[claude-code-settings]]
external l: Session transcripts — the log files under ~/.claude/projects

g -runs the report of-> t
s -starts-> t
c -sends session data to-> t
t -reads token counts from-> l

### Containers
person g: Giovanni
container m: main.rs — reads arguments and standard input, sets the exit code
container r: report.rs — reads transcripts and adds up model calls
container d: render.rs — writes the text report, the JSON report and the What to do lines
container w: statusline.rs — decides which warning line to print
container h: hook.rs — decides whether to print the session start sentence
container q: daily.rs — adds up each day and merges it into the history file
container u: args.rs and timeutil.rs — hand-written argument and timestamp parsing
store l: Transcripts — read only, never changed
store f: daily.csv — the daily history, rewritten by the log command

g -runs-> m
m -calls-> r
m -calls-> d
m -calls-> w
m -calls-> h
m -calls-> q
q -reads counting rules from-> r
q -reads and rewrites-> f
m -parses with-> u
r -parses time with-> u
r -reads-> l
d -formats the numbers of-> r

## What it does
**report.** `token-thrift report [--days N] [--root DIR] [--json] [--top N]` compares the last N days (14 by default) with the N days before. It prints the totals (calls, average context per call, and the share of cost units from cache reads, cache writes and output, each with its change against the previous period), then groups by model, by main session versus subagent, by project, by day and by session, context-size buckets of 50,000 tokens, cache rebuilds, the median size of the first context of a session, and the text that tool results returned, by tool. It ends with at most five "What to do" lines, each produced by a rule on the numbers (the thresholds are named constants at the top of `src/render.rs`). A cache rebuild here means a call that stores more than 30,000 tokens while reading less than it stores. With `--json` it prints the same numbers as one JSON object and nothing else. It never writes a file and never changes `~/.claude`.

A real run on 2026-11-22 (`token-thrift report --days 14`, 1,290 files read) printed these total lines; no other part of the output is quoted here:

    calls                  20,315   +62.7%
    avg context/call         148k   -0.5%
    cost units             508.3M   +51.5%

**log.** `token-thrift log [--file PATH] [--root DIR] [--show [N]]` keeps `~/.local/share/token-thrift/daily.csv` (the folder is created). Claude Code deletes old transcripts after some weeks, so the report cannot look far back; this file can. Each run reads all transcripts under the root (default `~/.claude/projects`), with no time window and with the same counting rules as the report, and sums per UTC day (by the timestamp of each record; records without one are left out). The 15 columns, header included, are `date,calls,input_tokens,cache_write_tokens,cache_read_tokens,output_tokens,cost_units,avg_context,subagent_cost_pct,cache_rebuild_cost_pct,fable_units,opus_units,sonnet_units,haiku_units,other_units`; the two percentages have one decimal, the rest are whole numbers, and the model columns are matched by a substring of the model id. The run merges into the existing file: a day only in the file stays unchanged; a day in both takes the fresh row, unless the file's row has more calls (then transcripts were partly deleted and the file's row is kept). An unreadable line in the file stops the run with exit code 1, names the line and leaves the file untouched. The file is written as `daily.csv.tmp` and renamed. The run prints one line, for example `log updated: 29 days (first 2026-10-10, last 2026-11-22), 29 new or changed, file /home/yuji/.local/share/token-thrift/daily.csv`. `--show` (14 rows, or `--show N`) recomputes nothing: it prints the last N rows as an aligned table (calls like `1,513`, tokens and units like `12.3M` or `456k`) and a last line with the sum of calls and cost units; a missing file gives an error and exit code 1. A real `--show 30` run on 2026-11-22 listed 29 days, 2026-10-10 to 2026-11-22, ending with `29 days: 34,751 calls, 907.1M cost units`.

**Daily timer.** `tools/systemd/token-thrift-log.service` (Type=oneshot, runs `%h/.local/bin/token-thrift log`) and `token-thrift-log.timer` (`OnCalendar=*-*-* 03:30:00`, `Persistent=true`, so a missed run happens at the next start, `WantedBy=timers.target`) are systemd user units (systemd is the Linux service manager; user units need no administrator rights). `tools/install.sh` copies them to `~/.config/systemd/user/`, runs `systemctl --user daemon-reload` and `systemctl --user enable --now token-thrift-log.timer`, then runs `token-thrift log` once. On 2026-11-22 `systemctl --user list-timers token-thrift-log.timer` showed the next run at 03:30 the next day, and a manual `systemctl --user start token-thrift-log.service` ended with status=0/SUCCESS.

**statusline.** Claude Code pipes a JSON description of the session into `token-thrift statusline` (options `--warn-context`, default 100,000, and `--warn-cold`, default 50,000). The program prints at most one line of under 100 characters, or nothing:
- the cache is cold and the context is at least `--warn-cold`: `cache cold: next message re-stores 180k tokens. Topic finished? /clear is cheaper`;
- the cache expires within 5 minutes and the context is at least `--warn-cold`: `cache expires in 4 min (180k tokens): send now or /clear`;
- otherwise, the context is at least `--warn-context`: `context 132k: every step re-reads it all. Topic finished? /clear`.

With missing or garbage input it prints nothing and exits with code 0. `/clear` is the Claude Code command that starts a fresh context. A real run on 2026-11-22 with the real status line input of a session holding 185,000 tokens of context printed `context 185k: every step re-reads it all. Topic finished? /clear`. The two cache lines (`cache cold` and `cache expires`) were checked only by tests on made-up input, not yet seen in a real session.

**hook-session-start.** When the field `source` of the JSON payload is `resume` or `fork` and `prompt_cache_likely_expired` is true, it prints one JSON object `{"systemMessage": "..."}`. The message says that the stored context of the resumed session has expired, so continuing stores all of it again, and that a new session with a short handoff is cheaper. It adds the token count (read from `context_tokens` or four other field names) and the dollar estimate (`estimated_cache_write_usd`) when the payload has them. In every other case it prints nothing, and it always exits with code 0. A real resume payload on 2026-11-22 carried the fields `source`, `context_tokens`, `prompt_cache_likely_expired` and `estimated_cache_write_usd`. The message for an expired cache has not yet been observed in a real expired resume.

## How it does it
The counting rules (one call once, `<synthetic>` skipped, subagent test, cache rebuild test) live in one function in `report.rs` that both the report and `daily.rs` use. The report reads each transcript line into a small typed record that ignores unknown fields, and measures embedded image data by its length without copying it, because some lines are several megabytes. A call counts once (the key is the message identifier plus the request identifier), calls of the model `<synthetic>` and lines that do not parse are skipped, and a call belongs to the current or the previous window by its timestamp. A call is a subagent call when its file path contains `/subagents/` or its record says `isSidechain`. Log files not modified in the last 2N days are skipped. Timestamps ending in `Z` and the command-line arguments are parsed by hand (`timeutil.rs`, `args.rs`), so the only dependencies are `serde` and `serde_json` (decision ADR-0002; an ADR, architecture decision record, is a short note that keeps the reasons for a decision). Only `main.rs` touches standard input, standard output and the clock; everything else is a plain function that tests call directly.

Giovanni's `~/.claude/settings.json` calls the installed copy `~/.local/bin/token-thrift`. The status line command passes its input to `token-thrift statusline` after the line of [[pbar]], and one SessionStart entry runs `token-thrift hook-session-start` with a timeout of 5 seconds; both run only when the file `~/.local/bin/token-thrift` is executable. `tools/install.sh` builds the release binary (`cargo build --release --locked`), copies it there and installs the daily timer. The project itself does not edit `~/.claude`.

## Where it sits in the pipeline
[[claude-code-settings]] starts it from the status line and the session start. It supports the rule of [[task-delegation]]: the report is how a saving in tokens is judged. It also follows the golden path of [[project-template]] and is measured by [[pipeline-check]].

## Who receives its output
Giovanni, in the terminal (the report) and under the prompt and at session start (the two warnings). Claude Code shows the warning line and the start sentence.

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
1. **Requirement, then test, then code**: a behaviour becomes a row in `docs/REQUIREMENTS.md`, then a test tagged `REQ <ID>`; the traceability step of the gate checks it.
2. **Logic is framework-free**: counting and formatting live in the library `src/lib.rs` and its modules; `src/main.rs` only reads arguments and input. Only `serde` and `serde_json` are used, checked by the test for TT-17.
3. **The gate decides**: `tools/quality_gate.sh` is the only definition of passing, and continuous integration (CI) runs it.
4. **A tool used by more than one project lives once**, in its own repository, and is used by pinned version (this project consumes [[pipeline-check]]).
5. **Decisions are written where the code is**: a decision-log row in `DESIGN.md`, an ADR for structural ones.

### Decisions
Three files in `docs/adr/` besides the template: 0001 record decisions; 0002 one binary with three subcommands, two dependencies and price-neutral cost units (the stack decision, 2026-11-22); 0003 a program measures and a skill judges. `DESIGN.md` holds the diagrams and the decision log, which has two rows of this project's own: the start and the `log` command, both 2026-11-22.

Other files in the repository: `tests/daily.rs` holds the nine tests of the `log` command; `Cargo.lock` records the exact version of every library used, so each build uses the same ones; `.gitignore` keeps the build folders `build/` and `target/` out of git; `docs/adr/README.md` and `docs/adr/0000-template.md` say how to write a decision record; `docs/TRACEABILITY.md` is the generated table of requirements and their tests. `docs/TESTES-AUTOMATIZADOS.md` came with the project template and still describes the template, not this project (as of 2026-11-22).

### Requirements
26 requirements, TT-1 to TT-26, in `docs/REQUIREMENTS.md`: counting (TT-1 to TT-6), report contents and options (TT-7 to TT-10), the three status line cases and its safety (TT-11 to TT-14), the hook (TT-15, TT-16), the dependency limit (TT-17) timestamp parsing (TT-18), and the daily log, its merge rules, `--show` and the timer (TT-19 to TT-26). Each has a test tagged `REQ TT-N`, and the traceability check ([[check-traceability]]) fails when one has none. The test inputs are small made-up files in `tests/fixtures/`, and no test makes a temporary folder.

### Quality gate
`tools/quality_gate.sh` runs: `cargo fmt --check`; a scan that refuses hand-built temporary folders in tests; `cargo clippy` with warnings as errors; `cargo test`, including a run of the real binary against the fixtures (`tests/cli.rs`); requirement traceability, with a check that the generated `docs/TRACEABILITY.md` is committed; and the fitness limits of [[pipeline-check]]. The only limit set is a gate time of 1200 seconds. The gate passed on 2026-11-22 after the `log` command was added.

### Continuous integration
Continuous integration means automatic checks on every push. The workflow `.github/workflows/quality-gate.yml` runs `tools/pipeline-check.sh --mode ci` on every push and pull request, caches the pinned `pipeline-check` build (version v0.8.0 in `pipeline-check.version`) and keeps its `report.json` for 14 days. The state of the latest run was not verified for this page.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` under the [[maintenance-policy]]; the [[monthly-architecture-review]] checks the project every month. Its `DESIGN.md` has no review row yet.

## Notes
Build and install: `tools/install.sh` in `~/dev/token-thrift` (needs Rust). Known limits: cost units hide the price difference between models; the status line and the hook were written from the Claude Code documentation, so they print nothing when a field is missing; the `README.md` still says the wiring into Claude Code is "not done by this project", which is right in the sense that `tools/install.sh` does not edit `~/.claude`.
