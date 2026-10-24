# Wiki: design and development decisions

What the system is, how it is built and why. Living document: updated in the same commit as the change.
The approved design and build plan of 2026-10-22 are in `docs/2026-10-22-wiki-design.md`.

Last updated: 2026-10-24

## 1. What it is

A private wiki of everything in Giovanni's systems (projects, programs, modules, functions, skills, hooks,
services, data, actors, processes), so Giovanni can answer an architecture question from Claude after one search
and at most two clicks. Home is a Dark-style map; hovering a dot fills four boxes (what it is, what it does, fed by,
who receives its output); clicking opens a Wikipedia-style article with an infobox, a pipeline strip and a small
graph of connected pages. Interface and pages in English, German and Brazilian Portuguese. Claude keeps it current
at the end of every task (`wiki publish`, then `mem use`).

## 2. Architecture

### System context (C4 level 1)

```mermaid
flowchart LR
    giovanni([Giovanni<br/>browser, laptop or phone])
    claude([Claude Code / assistant])
    wiki[Wiki<br/>Elixir server + Elm app]
    google[(Google sign-in)]
    funnel[(Tailscale Funnel<br/>public HTTPS address)]
    gh[(GitHub<br/>private repo yujideluca/wiki)]
    repos[(~/dev repos and<br/>workflow-memory)]
    giovanni -- HTTPS --> funnel --> wiki
    wiki -- verifies identity --> google
    claude -- writes pages, wiki publish --> wiki
    wiki -- push content --> gh
    wiki -- reads git dates, checks sources --> repos
```

### Containers and modules (C4 level 2)

```mermaid
flowchart TB
    subgraph server["server/ (Elixir)"]
        router[Web.Router<br/>default deny, Google OIDC via Assent]
        decoy[priv/decoy.html<br/>self-contained]
        content[Content.Page / Store<br/>parse pages]
        check[Content.Check + Privacy]
        build[Content.Build + Git]
        stale[Content.Stale<br/>Stop hook]
        cli[CLI escript `wiki`]
    end
    subgraph frontend["frontend/ (Elm)"]
        main[Main: routes, search bar, language]
        mapv[MapView + Layout + MapSize + Filter]
        art[ArticleView + WikiText]
        search[Search]
    end
    pages[(content/*.md)]
    site[(site/: index, assets, data JSON)]
    cli --> check --> content --> pages
    cli --> build --> content
    build --> site
    cli --> stale
    router --> decoy
    router --> site
    main --> mapv & art & search
    site -. served after login .-> main
```

Dependency direction: the content modules know nothing about the web; the router only serves files. The front end
only reads `data/*.json`. What enforces it: the router tests serve fixtures, the content tests run on temporary
folders, and the Elm app makes no request outside `/data`.

## 3. Testing

`docs/REQUIREMENTS.md` (AU, DC, CO, LG, BU, UP, MP) with tagged tests in `server/test` (ExUnit) and
`frontend/tests` (elm-test); `tools/quality_gate.sh` also runs `wiki check` on the real content and the fitness
functions (gzipped bundle size, gate time).

## 4. Decision log

Newest first. **Type** is the ISO/IEC/IEEE 14764 maintenance category: *corrective*, *adaptive*, *perfective*,
*preventive* or *initial*.

| Date | Type | Decision | Why |
|---|---|---|---|
| 2026-10-24 | Corrective | **First maintenance review: bug-finding tests for the privacy scan and three fixes** (`docs/TESTES-AUTOMATIZADOS.md`, `server/test/privacy_test.exs`): GitHub fine-grained, GitLab and Google API tokens, Brazilian and other phone shapes, and CPF numbers are now blocked before publishing | CO-4 promises that keys, tokens, passwords and phone numbers are blocked; the patterns had never been checked against that rule, and the same boundary in workflow-memory had the same gaps (two copies of one rule: debt) |
| 2026-10-24 | Preventive | **One list of privacy patterns** instead of two: `mem/privacy-patterns.tsv` in workflow-memory is the source, `server/priv/privacy-patterns.tsv` its copy, compared by the gate on the laptop (debt issue workflow-memory#3) | The two lists had already drifted (the wiki lacked bearer tokens; memory lacked Telegram, Google client secrets and `password: value`). The union is stricter in both. A copy remains because the private repositories cannot see each other in CI; the comparison makes drift fail instead of go unnoticed |
| 2026-10-24 | Preventive | **`pipeline-check` moved to its own repository** (`yujideluca/pipeline-check`, ADR-0003 there) and consumed by pinned version: this project keeps `pipeline-check.toml`, `pipeline-check.version`, the small runner `tools/pipeline-check.sh` and a local pre-push check (`tools/hooks/pre-push`, enable with `git config core.hooksPath tools/hooks`; it stands in for branch protection on a private free-plan repository). The program's requirements PC-* and tests live there | One fix there, one tag, instead of N copies. Rule: a tool used by more than one project lives once and is consumed by version |
| 2026-10-24 | Preventive | **`tools/pipeline-check` adopted** ([ADR-0005](docs/adr/0005-program-measures-skill-judges.md)): the Rust program that measures and blocks (copied from the project template) runs the gate once in CI and writes `report.json`; limits in `pipeline-check.toml` (largest Elixir/Elm file, gate time); the existing gzip size limit of `app.js` stays in the gate | The gate held only because Claude ran it; now a `falha` fails the CI job. The monthly review (skill `revisao-manutencao`) reads the report |
| 2026-10-22 | Perfective | **Bigger map, quicker highlight, roomier layout** (MP-5..MP-7). On a wide, tall enough window (above 1100 px) the map takes all the height the four info boxes do not need: `MapSize` gives the boxes a fixed height from their text width (about 226 px at 1920 px, a longer text scrolls inside its box) and the map the rest, so the page fits the window and never scrolls on hover; on a shorter or narrower window nothing changes (58 % share, boxes size themselves), so the map is never smaller than before (1920x943: 623 px instead of 547). The layout is reshaped to the map area (`Layout.matchAspect`, stretch only, capped at 3) after a force simulation that settles wide and flat (a pull to a horizontal line, stronger repulsion, a collision radius), and the graph is centred below the floating controls (`MapSize.insets`). Every fade on the map lasts 0.07 s (was 0.25 s) and each dot has an invisible larger hit area. Measured on the 149 pages at 1920x943: median gap between dots 48 px (was 23), closest pair 31 px (was 10), pairs closer than 20 px none (was 37) | Giovanni: the map window should use the free screen, leaving only room for the boxes; dots lit up too slowly; dots were too close together. Elm's own work per hover is about 12 ms, so the delay was the CSS fades. Scaling a layout to fit changes nothing on screen, so spacing had to come from the layout's shape and the collision radius, not from bigger distances |
| 2026-10-22 | Corrective | Map zoom and pan: the SVG declares a `viewBox` equal to its size, and on the map the top bar floats over it so the map starts at the window's top-left | Without a viewBox Chrome reports an empty one and elm-visualization turned every pointer position into (0,0): wheel zoom anchored at the corner and drag did not pan (Giovanni's report). Touch positions are measured from the window, wheel positions from the map; with the map at (0,0) they agree |
| 2026-10-22 | Corrective | Google's certificate is checked with OTP's system trust store (`:public_key.cacerts_get()`) plus `ssl_verify_fun` for the host name | Assent refused an unverified HTTPS call to Google; certifi would add a second, separately updated CA list |
| 2026-10-22 | Perfective | Map labels: only projects, the hovered dot and its neighbours until zoomed in; label size compensates zoom. Timeline stops are days, not months | With 145 pages the full-map labels piled up; all pages so far appeared in the same month |
| 2026-10-22 | Perfective | Articles follow the system colour scheme (light Wikipedia paper, warm dark paper when the system is dark); pages declare `color-scheme` | Chrome's forced dark mode was inverting the light article into unreadable colours |
| 2026-10-22 | Initial | Content as Markdown + header, `[[id]]` links, `fed_by`/`feeds` edges, `repo:path` sources, translations with a source hash (ADR-0004) | Claude can write and check plain files; the format is independent of the site's code |
| 2026-10-22 | Initial | One Elixir app for login, decoy and files; Google OIDC via Assent; Tailscale Funnel for the address (ADR-0003) | Giovanni chose Elixir, Google login for one account, and Funnel over buying a domain |
| 2026-10-22 | Initial | Elm front end, Elixir back end (ADR-0002) | Giovanni's choice of languages |
| 2026-10-22 | Initial | Project started from `~/dev/project-template` | Golden path: ADRs, requirements, gate and CI from day one |

## 5. Known limitations

Tracked as GitHub Issues labelled `debt` (see `docs/MAINTENANCE.md`). At the start:
- The site is online only while the laptop is on and awake.
- The Stop hook sees committed changes only; uncommitted work is caught at the next commit.
- Off-laptop pages (Claude app, Google Doc) cannot be checked against their source; they carry a review date.
