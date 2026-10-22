# Architecture decision records

One short file per structural decision (format: [MADR](https://adr.github.io/madr/), trimmed). Copy
`0000-template.md`, take the next number, link it from the decision log in `DESIGN.md`. An accepted ADR is never
rewritten: a new decision supersedes it.

| ADR | Decision | Status |
|---|---|---|
| [0001](0001-record-decisions.md) | Record architecture decisions as ADRs | accepted |
| [0002](0002-elm-and-elixir.md) | Front end in Elm, back end in Elixir | accepted |
| [0003](0003-login-gate-and-decoy.md) | One Elixir login gate, Google sign-in for one account, decoy, Tailscale Funnel | accepted |
| [0004](0004-content-format.md) | Content as Markdown pages with a header, checked before publishing | accepted |
