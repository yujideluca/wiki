---
id: map-benchmark
title: Map benchmark tools (wiki-bench)
aliases: [wiki-bench, map_bench, callprof, compare.py]
kind: script
project: wiki
status: active
location: home:dev/wiki-bench
fed_by: []
feeds: [wiki-map-view]
sources: [home:dev/wiki-bench/map_bench.py, home:dev/wiki-bench/globe/compare.py, home:dev/wiki-bench/globe/callprof.py, home:dev/wiki-bench/globe/callcmp.py, home:dev/wiki-bench/globe/elmmap.py, home:dev/wiki-bench/globe/framelog.py, home:dev/wiki-bench/globe/README.md, home:dev/wiki-bench/globe/RESULTS.md]
reviewed: 2026-11-06T03:42Z
---

## What it is
A set of Python scripts in `~/dev/wiki-bench` that measure how much work a browser does to draw the wiki's map while someone moves the mouse, and that name the lines of the map's code that cause that work. They exist so that a speed claim about the map comes with a number, a spread between repeated runs and the code it concerns, instead of an impression.

## What it does
`map_bench.py` loads one build of the wiki in a headless Chrome (Chrome without a window), plays a gesture and records a browser trace: for each animation frame the time spent in JavaScript, style, layout, paint and commit on the main thread, plus the raster work (turning shapes into pixels) on the other threads. The gestures are `pan` (drag the globe), `pan-fast` (a quick flick), `sweep` (the cursor moves over the globe with no button down), `zoom` (mouse wheel), `idle` (nothing happens), `hover` and `drag` (drags a dot, not the globe).

`compare.py` runs several builds under several gestures for several rounds. It rotates the order of the builds from round to round and measures the first build once more at the end of every round; the gap between its two runs (a drift of the machine between -17 % and +18 % was seen) tells how large a difference must be before it counts as a result. It prints the median and the minimum-maximum for frames drawn, mean and 95th-percentile frame time, main-thread busy time and raster time.

`callprof.py` finds the code. For one build and one gesture it runs the page three times: under Chrome's CPU sampler, under exact call counting, and with a `MutationObserver` (a browser feature that reports every change to the DOM, the Document Object Model, the page's tree of elements) that counts the attributes written per mouse event. `elmmap.py` turns a compiled name such as `$author$project$Motion$step` into `src/Motion.elm:89`. `callcmp.py` puts the profiles of several builds side by side, per mouse event and per frame, with the page writes, the hottest compiled lines and a ranked list of what to optimise first. `framelog.py` shows when a build asks for animation frames and which events the page received.

## How it does it
It drives Chrome through the DevTools Protocol (the remote-control interface of Chrome) with the `websockets` library. Mouse input is open loop: `play()` in `map_bench.py` sends every event at its scheduled time and does not wait for the page to answer. This was added after `framelog.py` showed the same flick lasting 179 ms in one build and 826 ms in another when each event waited for the page's answer: a slower build then received a longer gesture, and the comparison favoured the wrong build. The Elm compiler keeps function names in `--optimize` builds but writes no source map, so a line below function level is reported as the compiled line under its Elm function. Builds come from `~/dev/wiki-globe-sandbox` (a worktree of the wiki repository holding variants of the map's coordinate code); `build.sh` deletes and recreates a build folder, so any `http.server` serving it must be restarted.

What the tools found so far is in `globe/RESULTS.md` (rounds 3 to 5). In the last round, with open-loop input: variant v2 (a lighter map view) drew 273 frames at 12.2 ms where the current map drew 82 at 27.2 ms in a pan; a variant that moves a picture with one CSS transform between exact redraws made no measurable difference over v2; adding `will-change: transform` to the map's SVG (Scalable Vector Graphics, the drawing format of the map) cut raster time by about 30 %; and the spring layer `Motion.step` (about 1.3 ms a frame, only while a dot is hovered) and the writes to the page (55-60 % of a frame is the browser's native work) are the parts left to optimise. Not checked: a second machine, a phone, and a visual look at the picture during a gesture.

## Where it sits in the pipeline
Run by hand by [[claude-code]] or Giovanni after a change to the map; its results are the evidence behind the speed notes of [[wiki-map-view]].

## Who receives its output
Files in `~/dev/wiki-bench/globe/results` (raw json and Markdown tables) and `globe/RESULTS.md`; [[wiki-map-view]] describes the map it measures.
