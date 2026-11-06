# Measuring what the map costs

How the speed of the map (`frontend/src/MapView.elm` and the modules around it) was measured on 2026-11-05, what the
numbers were, and the traps that made earlier numbers wrong. Requirement: DY-8 (`docs/REQUIREMENTS.md`).

## What is measured

One **animation-frame task** is the browser task that runs the page's animation-frame callbacks (for this page: the Elm
`update` for a `Frame` message, then the view, the comparison with the previous view and the changes to the page). Per
frame task the harness reports the time in:

| Part | What it is |
|---|---|
| script | the callbacks themselves: update, view, comparison, changes to the page |
| style | working out which style rules apply to which elements again |
| layout | working out sizes and places again |
| prepaint, paint, layerize | recording what to draw and splitting it into layers |
| commit | handing the layers to the compositor |

Raster time (drawing the layers into pixels, on other threads) is reported separately as the total of `RasterTask`. "Busy"
is the sum of all main-thread tasks in the scenario. All times come from a Chrome trace (the `devtools.timeline` events).

Scenarios (each runs three times round, on a 1920 x 943 window, 202 dots and 977 lines):
`hover` (a dot is lit and released, on three different dots, two seconds each way), `zoom` (eight mouse-wheel steps in, eight
out, at the middle), `drag` (a dot is pressed and moved in a loop, then released).

## The tool

Two scripts in `~/dev/wiki-bench/` (Python; kept outside this repository until Giovanni decides whether a tool in that
language belongs here, memory key `work.ask-language`):

- `map_bench.py OUT.json name=url ...` records the traces and writes the numbers. Environment: `SCENARIOS`, `ABLATIONS`,
  `REPEATS`, `CYCLES`, `SCRATCH`, `CHROME_FLAGS`.
- `map_verify.py REFERENCE_URL CANDIDATE_URL` checks that a build looks and behaves like a reference build (resting dots,
  radii, labels, all lines, what a hover does in computed styles, a real click, a real drag, and the animation frames
  requested at rest, after a hover, after an unhover and after a sweep of the pointer).
- `ab_run.sh`, `ab_ablate.sh`: the alternating loops described below.

To compare two versions: build each with `elm make src/Main.elm --optimize`, copy `frontend/static/*` and `site/data/graph.json`
next to the build (`assets/` and `data/`), serve each folder with `python3 -m http.server PORT`, then run the scripts with
`CHROME_FLAGS="--enable-gpu --ignore-gpu-blocklist --enable-gpu-rasterization --use-angle=gl"`. The scripts start their own
headless Chrome (`google-chrome`, remote-debugging port 9333) and need the Python package `websockets`.

### Ablations

An ablation injects a style sheet that removes one kind of element, so that the cost of that kind is the difference to the
plain run: `no-labels`, `no-label-outline` (the outline of the label text), `no-edges` (the 977 lines), `no-dashes` (the
"mentions" lines drawn solid), `no-dots`, `no-globe` (the shading and the curved lines), `no-fades` (the opacity
transitions), `nothing-drawn` (everything inside the map hidden: what is left is script and the browser's own overhead).

## Traps found (each one produced a wrong conclusion once)

1. **The browser that Claude controls throttles animation frames** (about one frame a second for a page that is not in
   front), so numbers from it measure the throttle. Use the harness's own headless Chrome.
2. **Headless Chrome draws in software by default**: the main thread was busy 95 % of the time and raster looked like the
   biggest cost (labels seemed to cost 6 to 8 ms a frame). With the GPU flags above (`SystemInfo.getInfo` reports
   `rasterization: enabled_force`, `gpu_compositing: enabled`) the same labels cost about 1 ms on the main thread.
3. **The same build ran 3.5 times slower in one batch than in another** (39.6 against 11.1 ms a frame, same code, an hour
   apart). Only runs that alternate between the versions inside one batch can be compared; a plain run before every ablation
   keeps the drift out of the difference. The spread of 17 plain runs of one build was 11.0 to 12.2 ms: a difference under
   about 5 % is noise.
4. **"Busy" is not comparable when the number of frames differs**: a faster version fits more frames into the same two
   seconds, so its total goes up. Compare time per frame.
5. A timer that stands in for the animation frame (to get around the throttle) measures the script only, not style, layout and
   paint, and counts each callback, not each frame.

## Results of 2026-11-05 (GPU compositing, alternating runs, mean of two)

Milliseconds per animation-frame task, hover:

| Version | total | 95th percentile | script | style | layout | paint | layerize |
|---|---|---|---|---|---|---|---|
| before this work (`HEAD`) | 26.5 | 33.2 | 9.9 | 4.8 | 2.3 | 3.2 | 2.2 |
| geometry cache, lazy hit layer and globe, rounded numbers | 13.3 | 20.0 | 6.0 | 0.8 | 0.7 | 2.6 | 2.2 |
| plus class-based dimming, lazy map chrome, sparse springs, indexed lookup, no `r` transition | 11.6 | 17.4 | 5.6 | 0.6 | 0.7 | 2.6 | 2.3 |

Zoom went from 21.1 to 9.3 ms and drag from 29.5 to 14.8 ms the same way. Main-thread busy time over the hover scenario
fell from 6.4 s to 3.1 s.

Script only (everything inside the map hidden, so no painting; one batch, so only the ratios mean something): 44 ms a frame
before, 9 ms after the cache, 8.5 ms after the second round.

What a hover frame of the final version (11.5 ms) is made of, from the ablations (difference to a plain run made just before):

| Without | Frame | Where it goes |
|---|---|---|
| the 977 lines | -28.5 % (-3.2 ms) | paint -1.9, layerize -1.3, layout -0.5, style -0.3 |
| the dashes (lines solid) | -10.9 % (-1.2 ms) | about 40 % of what the lines cost |
| the labels | -8.9 % (-1.0 ms) | script -0.4, paint -0.2, layout -0.2; raster time -50 % |
| the label outline only | within noise | raster time -27 % |
| the dots | within noise | |
| the globe | within noise | |
| the fades | -4.7 % (-0.5 ms) | |
| all drawing | -35.6 % (-4.1 ms) | what is left (7.7 ms) is script and overhead |

## Tried and not kept

A line list in which only the lines that end at a displaced or lit dot are rebuilt each frame (the others kept ready as
finished nodes, found through an index of the lines of each dot) cost 1.4 ms more per frame than rebuilding every line lazily
(13.0 against 11.6 ms, alternating runs). Building the nodes was not the cost; the browser changing the touched lines is.

## Not measured, and ideas the numbers support

- Portrait phone frame times and the browser's paint time on the phone (the phone check was landscape, a visual tap test).
- The 977 lines are the largest single cost. One path for all unlit lines of a kind (instead of one element each) would remove
  most of it, at a visible price: the arrowheads of the "feeds" lines would have to be drawn by hand (a marker on a path
  marks only its end), line widths would be grouped into a few steps, and the dimming would apply to the whole path
  (crossings no longer darken). Not done; Giovanni decides.
- Drawing the "mentions" lines solid and faint instead of dashed would save about 1.2 ms a frame.
