# Wiki of Giovanni's projects and workflow: design

Date: 2026-10-22 · Status: draft for Giovanni's approval · Author: Claude Code (brainstorming session)

Marks used below: **[G]** = decided by Giovanni in the conversation; **[C]** = Claude's call, open to change.

## 1. Intent: why this exists

Claude often asks Giovanni to decide something about a system they are building ("should X run before Y?",
"change the architecture of Z?"). To answer well, Giovanni has to remember what X is, what it does and what
depends on it, and today that context is spread across chats, repos and memory. The wiki is the place they open
in that moment: type two or three letters, land on the thing, understand it and its neighbours, answer. **[G]**

Success: Giovanni can answer any architecture question from Claude after one search and at most two clicks,
and the wiki is never behind what was actually built.

## 2. Goals, non-goals, anti-goals

Goals
- Cover **absolutely everything** in Giovanni's systems: projects, programs, scripts, functions/modules,
  skills, hooks, services, data stores, actors, processes. **[G]**
- One page per concept, with the same questions answered every time: what it is, what it does, how it does it,
  where it sits in its pipeline, who receives what it produces. **[G]**
- Pages linked like Wikipedia and Obsidian, forming a concept graph. **[G]**
- Visual schematics that make the workflow understandable (inspiration: Dark/Netflix explorer above all,
  Seeing Theory, Our World in Data, JetBrains survey, Pangram Pangram). **[G]**
- Kept current automatically as a chain reaction to every change, without weakening the safety and quality
  rules of the general architecture. **[G]**
- Built so it can grow: new projects, new kinds of concepts and new views plug in without redesign. **[G]**

Non-goals
- Not a second memory. Rules and preferences stay in workflow-memory (`mem`); a page that mentions a rule
  links to the memory entry (`#ref`) instead of copying it, so the two never disagree. **[C]**
- Not an editor for Giovanni. Claude writes; Giovanni reads (they can still edit Markdown in the repo). **[C]**
- Not for the Claude app (claude.ai); it cannot reach the laptop. **[C]**

Anti-goals (a failure even if it "works")
- Anything real is visible without login (the decoy must contain zero real content).
- Pages that silently go stale or contradict the code/memory.
- Secrets, keys, or clinical, secret or contact data about other people in any page (same rule as memory).
- An update path that can break the site or push unchecked content.

## 3. How Giovanni uses it (the approved interaction) **[G]**

Approved through clickable mockups (visual companion, `layout-v3`).

1. **Home = system map**, in the style of Dark: dark background, clean force-directed graph, dots coloured by
   kind, lines for "feeds / is fed by" and "mentions". A **search bar with autocomplete** list below it sits on
   top; choosing a result centres and selects that node.
2. **Hover a node** → the node and its direct connections light up (gold), others dim, and **four large info
   boxes** below the map fill in: *What it is*, *What it does*, *Fed by*, *Who receives its output*.
3. **Click a node** → opens the **article page**, Wikipedia-style (option A): title, one-line definition,
   infobox on the right (kind, project, location on disk, status, small local graph, **pipeline strip**:
   inputs → this → outputs), then sections *What it does*, *How it does it*, *Where it sits in the pipeline*,
   *Who receives its output*, *History*. Links in the text go to other articles. A "back to map" link returns.

Accepted guesses (Giovanni: "everything agreed") **[C→G]**
- Map filter by project, so the graph does not become one tangle as it grows.
- **Process pages** (e.g. "what happens when a chat starts") get a step-by-step animated diagram
  (Seeing-Theory style: next/previous step highlights the active part).
- **Timeline slider** (from Dark): shows the map as it was at a date, from page creation dates.

## 4. Decided constraints

| # | Decision | By |
|---|---|---|
| D1 | Front end written in **Elm** | G |
| D1b | Back end (server, login, content checker/builder, CLI, hook) written in **Elixir** | G |
| D2 | Own **private GitHub repo** (`yujideluca/wiki`); every checked update is committed and pushed; never force-push | G |
| D3 | Update is tied to the end-of-task `mem use` step | G |
| D4 | Reachable on the **web** via **Tailscale Funnel** | G |
| D5 | **Google login**, only `yujideluca@gmail.com` gets in | G |
| D6 | Not logged in → **psychedelic node graph of gibberish** + login button, nothing else | G |
| D7 | Starts from `~/dev/project-template` (golden path, ADR-0003 of workflow-memory) | C |
| D8 | Content = Markdown files with a header block, separate from the Elm code | C |
| D9 | Wiki is a project repo, not a change to workflow-memory; no new inter-instance protocol (respects workflow-memory ADR-0003) | C |
| D10 | Page language: English (the language of the code, repos and ADRs) | C |
| D11 | Granularity **option A**: own page for every project, program, module, skill, hook, service, data store, actor, process, and for a function that (a) is an entry point (called directly by Giovanni, Claude or another program), (b) passes data between modules, or (c) appears in a decision or conversation. Every other function is listed by name with one line on its module's page (searchable) | G |
| D12 | **Promotion:** anything listed below that level that grows (meets a rule of D11, is split into its own helpers, or is mentioned by name from 2 or more pages) gets its own page automatically in the next update | G |
| D13 | Languages: **English by default**, switchable to **German** and **Brazilian Portuguese** (interface and page content) | G |
| D14 | English pages are the source of truth; Claude writes the DE and PT-BR versions in the same update (`content/<id>.de.md`, `content/<id>.pt-BR.md`, each storing a hash of the English text it was made from). `wiki check` fails when a translation is missing or outdated, so they cannot drift; the chosen language is remembered in the browser | C |

## 5. Architecture

```
 Claude Code / remote assistant ── writes ──▶ content/*.md (pages)
                                                 │
                                    wiki check   ▼   wiki build
                                     (gate)  ─▶ site/ (Elm app + graph.json + pages/*.json)
                                                 │
 internet ─▶ Tailscale Funnel :443 ─▶ Elixir app 127.0.0.1:4180 ─┬─ logged in as Giovanni ─▶ Elm app + site/ data
                                                                  │
                                                                  └─ anyone else ─▶ decoy page (self-contained,
                                                                                    no real data) + Google login
```

### 5.1 Content (the source of truth)
- `content/<id>.md`, one file per concept. `id` = lowercase slug, stable forever (renames keep the id and add
  an `aliases` entry).
- Header block (YAML-like front matter):
  `id, title, aliases[], kind, project, status (active|beta|retired|planned), location (path or URL),
  fed_by[ids], feeds[ids], tags[], sources[repo:path whose change makes this page stale], memory[#refs],
  since (date the thing came to exist), until (retired only), reviewed (date, for pages without sources)`.
  `sources` use `repo:path` (repo = folder name under `~/dev`), never absolute laptop paths. **[C]**
- Body sections, fixed order and required: `## What it is`, `## What it does`, `## How it does it`,
  `## Where it sits in the pipeline`, `## Who receives its output`; optional `## Steps` (process pages, one
  numbered step per line, each step naming the node ids it involves), `## Notes`.
- Links in text: `[[id]]` or `[[id|label]]` (Obsidian syntax). Every link becomes a graph edge of type
  "mentions"; `fed_by/feeds` become typed pipeline edges.
- `kind` is an open vocabulary registered in `content/_kinds.yaml` (name, colour, description), so a new kind
  is one line, not code. Initial kinds: project, program, module, function, script, skill, hook, service,
  data, actor, process, decision, external.
- `since` is filled by the builder from the first commit of the page's `sources` when not written by hand, so
  the timeline shows how the system really grew, not the day the wiki was filled. **[C]**
- Things that live off the laptop (Claude app projects and instructions, claude.ai skills, Google Doc states,
  browser routines) are in scope ("absolutely everything"). They have no `sources`; instead `reviewed` is
  required, and the page shows a "may be stale" badge 30 days after it. **[C]**
- History is derived from git (`git log --follow` per file) at build time, plus links to ADRs/decision-log rows.

### 5.2 Builder and checker (Elixir, Mix tasks + an escript `wiki` CLI) **[G: Elixir]**
Lives in the same Elixir project as the server, tested with ExUnit.
- `wiki check`: header fields valid; required sections present and non-empty; every `[[id]]`, `fed_by`,
  `feeds` resolves; `fed_by`/`feeds` symmetric (A feeds B ⇔ B fed_by A); no orphan page (except kind
  actor/external); `memory` refs exist in workflow-memory; privacy scan (key/token patterns, e-mail addresses
  other than Giovanni's, phone numbers) — fail on hit; `sources` paths exist.
- `wiki build`: writes `site/graph.json` (nodes, edges, kinds, created dates) and `site/pages/<id>.json`
  (header + section Markdown + history), then `elm make --optimize`.
- `wiki stale`: lists pages whose `sources` changed in git after the page's last commit.
- Promotion (D12): `wiki check` fails when a listed (page-less) item is mentioned by name from 2 or more pages;
  the other promotion triggers are applied by Claude during the update, as written in the CLAUDE.md rule.
- `wiki publish -m "msg"`: check → build → commit content + rebuilt site → push. Refuses on any failure.

### 5.3 Front end (Elm 0.19.1) **[G: Elm]**
- Routes: `/` map, `/p/<id>` article, `/process/<id>` (article with step-through diagram).
- Graph: `gampleman/elm-visualization` force layout, SVG; hover/selection state in the model; project filter;
  timeline slider; search with fuzzy autocomplete over titles + aliases (keyboard: ↑↓ Enter Esc).
- Markdown: `dillonkearns/elm-markdown`, custom renderer turning `[[id]]` into internal links.
- Visual direction: dark, cinematic (Dark), gold accent for selection, colour per kind from `_kinds.yaml`;
  article view light, serif body (Wikipedia). Must work on a phone screen (map pans/zooms by touch; boxes stack).
- Fetches only `graph.json` and `pages/*.json`; no third-party requests at runtime.

### 5.4 Access, login and decoy (Elixir app) **[G: Elixir; C: shape]**
- **Tailscale** (already installed and logged in on `yuji-nitro`, no serve/funnel config yet) + `tailscale funnel --bg 4180` → public
  `https://<machine>.<tailnet>.ts.net`.
- **One Elixir app** (Plug + Bandit, or Phoenix if the builder prefers; listens on 127.0.0.1 only) does
  Google sign-in with a maintained OAuth/OpenID library (e.g. Assent), checks the verified e-mail equals exactly
  `yujideluca@gmail.com` (allowlist in config), keeps a signed + encrypted HttpOnly Secure session cookie
  (30 days), and only then serves the Elm bundle and `site/` JSON. Every non-auth route requires the session;
  the default is deny. Auth is never hand-rolled beyond calling that library.
- **Decoy**: the page served at `/` to anyone without a session. Fully self-contained (inline JS/CSS, no fetches):
  animated psychedelic force graph of randomly generated pseudo-words and the "Sign in with Google" button.
  Nothing from `content/` or `site/` is ever embedded; a gate test asserts it.
- Google OAuth client: Giovanni creates it in Google Cloud Console (guided by Claude); client id/secret and the
  cookie secret live in `~/.config/wiki/oauth.env` (mode 600), never in git.
- Elixir/Erlang: Ubuntu packages `elixir` 1.18 + Erlang/OTP 27 (one `sudo apt install` by Giovanni); Elm 0.19.1
  installed in user space through npm.
- Services: one systemd **user** unit `wiki.service` running the Elixir release (linger is already on, so they
  run without a login session). Online only while the laptop is on.

### 5.5 Update chain (D3) **[G trigger, C mechanism]**
- Global `~/.claude/CLAUDE.md` gets one rule next to the `mem use` rule: *at the end of a task, update the wiki
  pages for what changed (new/changed/retired concepts), run `wiki publish`, then `mem use`.* Applies to
  Claude Code and the remote assistant alike.
- Safety net: a **Stop hook** `wiki hook-stop` (fast, read-only). It **blocks the stop (exit 2) only** when a
  repo under `~/dev` has commits made after the wiki's last publish that touch some page's `sources` or add
  files no page covers; the message tells Claude which pages to update. It blocks at most once per session
  (Claude Code's `stop_hook_active` flag), so it cannot loop, and tasks that changed no code (German, clinical,
  chores) never trigger it. **[C]**
- Publishing needs no per-task approval: Giovanni asked for automatic sync to the private repo and the site
  is behind the login (D2, D3, D5). **[C→G]**
- Each project's `CLAUDE.md` working rules get one line pointing to this (via project-template, so new
  projects inherit it).
- A `mem task` open item is created if publish fails and cannot be fixed in the session.

### 5.6 Quality gate (`tools/quality_gate.sh`, from project-template)
1. `elm make` + `elm-test`; `mix test` (checker, builder, auth: unauthenticated requests get only the decoy,
   wrong e-mail is refused, real data never served without a session).
2. Requirement traceability (`docs/REQUIREMENTS.md`, tests tagged `REQ <ID>`).
3. `wiki check` on the real content.
4. Fitness: decoy has no real data; `site/` bundle under 1 MB gzip; no external URLs in built JS.
CI (GitHub Actions) runs the same gate on push, except the checks that need the laptop (memory `#ref`s,
`sources` existence, `wiki stale`): those run under `--local` in `wiki publish` only, and the gate prints
which mode it ran in. No cross-repo tokens are stored in CI. **[C]**

## 6. Initial content (from the read-only survey of 2026-10-22)

Projects and their main parts, down to module / main-function level **[C]**:
- **QuizApp** (Android, `yujideluca/german-quiz`): `:core` scheduler, grader, queue, session, content;
  app UI; flavours stable/beta; `publish_apk.sh` and the release feed (`german-quiz-releases`); quality gate and
  its tools; backups (`quiz-backups`); ADRs.
- **QuizWeb** (`german-quiz-web`, GitHub Pages): domain, content, controller, store, app, service worker,
  web-sync with QuizApp.
- **workflow-memory**: `mem` CLI and commands, events/, views/ (BRIEF, PREFERENCES, REVIEW), fold rules,
  hooks (session-start, prompt, stop), open items, validator/quarantine, CI, ADRs 0001–0003.
- **project-template** (golden path).
- **Laptop setup**: Claude Code settings and hooks, status line `pbar.py`, `claude-assistant` (Remote Control
  in tmux + systemd), `tg-send` Telegram bot, `env.sh`/Android SDK/JDK/Gradle, user-space tools (uv, pyright,
  kotlin-lsp, rclone), plugins.
- **Skills**: one page each for the 18 in `~/.claude/skills` and the plugin skills in use.
- **processing-sketches**.
- **Actors**: Giovanni, Claude Code, remote assistant, Claude app (from workflow-memory ADR-0003).
- **Processes**: chat start (hooks → brief), end of task (mem use → wiki publish), QuizApp release
  (beta → promote), the wiki update chain itself.
- **The wiki itself** (it documents its own pipeline).

## 7. Left to the builder
Exact colours and typography inside the approved direction; graph physics tuning; fuzzy-match algorithm;
Plug + Bandit vs Phoenix; which OAuth library; test list beyond the gate items above;
how history is rendered.

## 8. Plan

Approved design: 2026-10-22. Steps run in order; each ends with its tests green.

1. **Toolchain.** Giovanni runs `sudo apt install elixir erlang-dev erlang-xmerl erlang-os-mon` (Elixir 1.18,
   OTP 27). Claude installs Elm 0.19.1, elm-test and elm-format in user space via npm; checks `mix`, `elm`.
2. **Project skeleton.** Copy `~/dev/project-template` to `~/dev/wiki` (keeping this document); fill `CLAUDE.md`,
   `DESIGN.md` §1–2; ADR-0002 (stack: Elm + Elixir, D1/D1b), ADR-0003 (login + decoy, default-deny),
   ADR-0004 (content format, promotion, translations); `docs/REQUIREMENTS.md` from §3–5 and D11–D14.
3. **GitHub.** Create private repo `yujideluca/wiki`, labels `debt idea P1 P2 P3`, CI running the gate (CI mode).
4. **Content core (Elixir, test first).** Parser for header + sections + `[[links]]`; validator (all `wiki check`
   rules incl. symmetry, orphans, privacy scan, promotion count, translation hashes, `--local` checks); graph
   builder (`graph.json`, `pages/<id>.<lang>.json`, `since` from git, history); `wiki stale`.
5. **Server (Elixir).** Plug/Bandit app on 127.0.0.1:4180: decoy at `/` for anyone without a session; Google
   sign-in via Assent; exact-email allowlist; encrypted session cookie; authenticated routes for the Elm bundle and
   JSON; security headers. Tests: no real byte served without a session, wrong account refused, logout.
6. **Decoy page.** Self-contained psychedelic gibberish graph + "Sign in with Google"; gate test that it contains
   nothing from `content/`.
7. **Elm front end.** Map (force layout, kind colours, gold highlight), search with autocomplete, hover boxes,
   click → article (Wikipedia style, infobox, local graph, pipeline strip), process step-through, project filter,
   timeline slider, language switch EN/DE/PT-BR, phone layout. elm-test for search ranking, i18n and routing.
8. **CLI + update chain.** Escript `wiki` (`check`, `build`, `publish`, `stale`, `hook-stop`); install the Stop hook
   in `~/.claude/settings.json`; add the end-of-task rule to `~/.claude/CLAUDE.md` and a line to
   `project-template` `CLAUDE.md`.
9. **Initial content.** Write the English pages from the §6 survey (~150–300, rule D11), then DE and PT-BR versions;
   `wiki check --local` green.
10. **Service + public address.** systemd user unit `wiki.service` (release build, restart always);
    `tailscale funnel --bg 4180`.
11. **Google login key.** Guide Giovanni through creating the OAuth client (redirect URI = the funnel address);
    store it in `~/.config/wiki/oauth.env` (mode 600).
12. **End-to-end check.** Gate green locally and in CI; in Chrome: decoy from a logged-out window, login, map,
    hover, click, search, languages, phone width; a test change in a `~/dev` repo triggers the hook and
    `wiki publish` updates the live site.
13. **Hand-over.** Report with "Verified by", `mem use`, open items for anything unfinished.
