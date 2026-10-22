# ADR-0002: Front end in Elm, back end in Elixir

- **Status:** accepted
- **Date:** 2026-10-22
- **Type (ISO/IEC/IEEE 14764):** initial
- **Decided by:** Giovanni (owner)

## Context

The wiki needs a browser front end (an interactive map, search, articles) and a back end (login gate, content
checker and builder, the `wiki` command and the Claude Code Stop hook). Giovanni chose the languages during the
design, after it had been drafted; since then Claude asks for the language first (memory key `work.ask-language`).

## Decision

The front end is written in Elm 0.19.1 (`frontend/`): elm-visualization for the force-directed map and zoom,
elm-markdown for articles. Everything else is Elixir 1.18 on Erlang/OTP 27 (`server/`): one Mix project that is both
the web server (Plug + Bandit) and the escript `wiki`.

## Alternatives considered

- **Python for the tools, as in workflow-memory** — rejected by Giovanni's choice of Elixir for the back end.
- **A JavaScript framework for the front end** — rejected by Giovanni's choice of Elm.

## Consequences

Elixir and Erlang come from Ubuntu packages (installed with sudo by Giovanni); Elm, elm-test and elm-format are
user-space npm installs. CI installs both with `erlef/setup-beam` and npm. Content stays plain Markdown, so neither
language is needed to write a page.
