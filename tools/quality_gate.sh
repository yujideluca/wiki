#!/usr/bin/env bash
# Quality gate: the one definition of "passing". CI runs exactly this script on every push.
#   tools/quality_gate.sh           on the laptop: also checks sources and memory refs (wiki check --local)
#   WIKI_GATE_MODE=ci tools/...     on GitHub, where the other private repos are not visible
set -euo pipefail
cd "$(dirname "$0")/.."
MAX_GATE_SECONDS=1200   # fitness function: a slow gate gets skipped; speed up or split tests instead
MAX_APP_JS_GZIP=200000  # fitness function: the optimized Elm bundle stays small (gzipped bytes)
SECONDS=0
step() { printf '\n== %s\n' "$1"; }
mode="${WIKI_GATE_MODE:-local}"

step "1/5 Elixir tests (checker, build, hook, publish, login gate, decoy)"
(cd server && mix test)

step "2/5 Elm tests and optimized build"
(cd frontend && elm-test && elm make src/Main.elm --optimize --output=/tmp/wiki-gate-app.js >/dev/null)

step "3/5 requirement traceability"
python3 tools/check_traceability.py
git diff --quiet -- docs/TRACEABILITY.md || { echo "docs/TRACEABILITY.md changed: commit the regenerated matrix"; exit 1; }

step "4/5 content rules (wiki check, $mode mode)"
(cd server && mix escript.build >/dev/null)
if [ "$mode" = ci ]; then WIKI_ROOT="$PWD" server/wiki check; else WIKI_ROOT="$PWD" server/wiki check --local; fi

step "5/5 fitness functions"
size=$(gzip -c /tmp/wiki-gate-app.js | wc -c)
[ "$size" -le "$MAX_APP_JS_GZIP" ] || { echo "FAIL app.js is $size bytes gzipped (> $MAX_APP_JS_GZIP)"; exit 1; }
echo "app.js $size bytes gzipped (limit $MAX_APP_JS_GZIP)"
[ "$SECONDS" -le "$MAX_GATE_SECONDS" ] || { echo "FAIL gate took ${SECONDS}s (> ${MAX_GATE_SECONDS}s)"; exit 1; }
printf '\nquality gate passed (%ss, %s mode)\n' "$SECONDS" "$mode"
