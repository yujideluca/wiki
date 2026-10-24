# Requirements

Every promise the software makes, with an ID. A test that checks it carries the tag `REQ <ID>` in a comment;
`tools/check_traceability.py` fails when a requirement has no test or a tag names an unknown requirement.
Source: G = stated by Giovanni, D = derived by Claude Code and accepted (design of 2026-10-22).

| ID | Requirement | Source |
|---|---|---|
| AU-1 | Without a session, every page path answers the decoy page and no real content | G |
| AU-2 | Without a session, /data and /assets paths answer 404 | D |
| AU-3 | Only yujideluca@gmail.com with an e-mail verified by Google gets a session; any other account is refused | G |
| AU-4 | A sign-in callback without the state saved by the same browser's sign-in start is refused | D |
| AU-5 | Logout ends the session | D |
| AU-6 | Every response is no-store and carries security headers; the decoy's CSP forbids network requests | D |
| DC-1 | The decoy page is self-contained (no external URL, no fetch) and contains nothing from content/ | G |
| CO-1 | Every page has the required header fields and the five required sections, non-empty | G |
| CO-2 | Every link, fed_by and feeds points to an existing page, and fed_by/feeds are symmetric | G |
| CO-3 | No orphan pages, except actors and external things | D |
| CO-4 | The privacy scan blocks keys, tokens, passwords, phone numbers and e-mails other than Giovanni's | G |
| CO-5 | A function listed on a page and mentioned by two or more other pages must get its own page | G |
| CO-6 | A page without sources needs a reviewed date and is shown as "may be stale" 30 days after it | D |
| CO-7 | Sources are written repo:path; local mode checks that they and the memory refs exist | D |
| LG-1 | Every English page has German and Brazilian Portuguese versions made from its current English text | G |
| LG-2 | The interface is in English by default and switchable to German and Brazilian Portuguese | G |
| BU-1 | The build writes graph.json (nodes, feeds and mentions edges) and one article per page per language | D |
| BU-2 | A page's since date is its header value, else the first commit of its sources | D |
| UP-1 | The Stop hook blocks only for code changes the wiki covers (or new files) since the last publish, at most once per session per change set, never when a stop hook is already active | G |
| UP-2 | wiki publish refuses when the local check fails, and commits only content/ | G |
| MP-1 | Search suggests matching pages (title and aliases) while typing, best match first | G |
| MP-2 | Hovering a node fills the four info boxes; clicking a node opens its article | G |
| MP-3 | Links written [[id]] in an article lead to that article | G |
| MP-4 | The map can be filtered by project and by date (timeline) | D |
| MP-5 | On windows wider than 1100 px the map is as tall as the window allows and leaves only the height of the four info boxes below it, so hovering a node never makes the page scroll; a text longer than its box scrolls inside the box | G |
| MP-6 | The map layout takes the shape of the map area: on a wide window the nodes spread over the full width, on a tall one over the full height; distances only grow, none shrinks, and every node keeps its place relative to the others | G |
| MP-7 | Hovering a node lights it, its neighbours and its edges within 80 ms: every transition on the map is at most 0.08 s | G |
| PC-1 | `pipeline-check` writes `report.json` with `schema_version`, project, date, mode (`local` or `ci`), the list of checks (id, status `ok`/`aviso`/`falha`/`pulado`, value, limit) and the `dora` block. The exit code is non-zero if and only if some check is `falha`; an `aviso` never fails. | G |
| PC-2 | A fitness function is `ok` below the warning share of its limit (default 80 %, set per project), `aviso` from there up to the limit, and `falha` at 100 % of the limit or more. | G |
| PC-3 | The architecture check fails when any Kotlin or Java source in the pure module imports `android.*` or `androidx.*`, or its build file names Android, even if the compiler would not notice. | G |
| PC-4 | A check that cannot run in the current mode or environment is reported `pulado`, never `ok`; a `pulado` check that the config marks required is `falha`. The report states the mode that ran. | D |
| PC-5 | The project gate runs once; a non-zero exit is `falha`, and its duration feeds the gate-time fitness function. | D |
| PC-6 | DORA figures come from git, the release feed and the decision log, are `null` when there is no data, and never fail the run. | D |
| PC-7 | The GitHub checks (last CI run green, branch protection requires the CI job) only read, never change anything; an unavailable `gh` or no network is `pulado`, a missing protection is `falha`. | G |
| PC-8 | A missing or invalid limits file stops the program with exit code 2 and a clear message; it never falls back to silent defaults. | D |
| PC-9 | The architecture check also catches `import static android...` (Java), fully qualified uses such as `android.util.Log.d(...)` without an import, and ignores `android` inside comments and inside a longer name (`myandroid.Foo`, `dev.x.android.Foo`). | D |
| PC-10 | Walking a source directory terminates and finishes even when it contains a symbolic link that points back up (no infinite recursion). | D |
| PC-11 | A cancelled or skipped CI run is neither green nor red: "last CI run is green" looks at the most recent run that succeeded or failed. | D |
