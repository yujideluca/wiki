# Wiki

Private wiki of Giovanni's projects and workflow: a Dark-style map of every program, skill and process, hover for a
summary, click for the full page. English, German and Brazilian Portuguese. Online at
https://yuji-nitro.tailed3a22.ts.net (Google sign-in, one account).

- `content/`: the pages (Markdown; English plus `.de` and `.pt-BR` translations) and `_kinds.json`
- `server/`: Elixir app (login gate, decoy, content checker/builder, the `wiki` command, the Stop hook)
- `frontend/`: Elm app (map, search, articles)
- `tools/`: `quality_gate.sh`, `install.sh`, `wiki.service`, `check_traceability.py`
- `docs/`: design document, requirements, ADRs, maintenance policy

Day to day: write or change pages, then `wiki publish -m "what changed"`. Install or update the server:
`tools/install.sh`. Check everything: `tools/quality_gate.sh`.
