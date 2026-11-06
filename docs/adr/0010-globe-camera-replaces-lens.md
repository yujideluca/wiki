# ADR-0010: The map is one camera on a sphere (`Globe`) instead of a lens bent over a flat layout

- **Status:** accepted
- **Date:** 2026-11-06
- **Type (ISO/IEC/IEEE 14764):** perfective
- **Decided by:** Giovanni (owner: "v2 shall be the new processing", then "1 the spring could be calculated on the matrix, would that help? 2 do it 3 do it, 4 test it 5 ok", then "merge it all in a way no data becomes lost") / proposed, built and measured by Claude Code

## Context

Until now the dots lived on a flat layout in pixels. `Lens` bent that plane into a globe shape for every dot, on every
rebuild, with trigonometry (about six sine, cosine and arctangent calls and three powers per dot), the zoom came from a
zoom library, and the pointer found a dot through an invisible disc drawn for each of them (`MapView.hit`). Turning the
globe rewrote every disc, and every mouse move over a drag lit and put out the dots passing under it.

Three experiments in `~/dev/wiki-globe-sandbox` (v1 code, v2 written for cost per frame, v3 in WebAssembly) and four
more rounds of measuring with a fixed input timeline (`~/dev/wiki-bench`, `docs/MEASURING-THE-MAP.md`) showed that the
maths was never the bottleneck: the cost was the browser changing elements (about 1,200 attribute writes per mouse event
while turning the globe) and the spring layer on `Dict`s.

## Decision

- Every dot is a unit vector on a sphere, made once per layout (`Globe.embed`); the camera is three numbers (longitude,
  latitude, zoom; north stays up) and a frame builds one camera and multiplies each dot by its matrix (`Globe`,
  `MapGeometry`). `Lens` is removed; the zoom library is no longer used for the camera, and `Touch` turns the globe.
- The dot under the pointer is found by the camera maths (`MapGeometry.hitAt`: the nearest dot within its drawn radius plus
  6 pixels). There are no invisible discs in the page. A click opens a page only if the mouse was pressed on the same dot
  (`MapCamera.clickOpens`).
- While the globe is turned, a dot is dragged or fingers are down, the pointer does not light dots (`MapCamera.pointerMoved`,
  DY-9). This is a change in behaviour that was chosen for its cost: the lit dots started springs and created labels on every move.
- The spring layer is one dense pass over one array (`Motion.step`; the neighbour average is the row-normalised neighbour
  matrix times the displacement vector), equal to the dictionary version to 1e-9 over 400 steps (`MotionTests`).
- `svg.map` has `will-change: transform`, a layer of its own (DY-10).
- The Python that regenerates `tests/GlobeVectors.elm` from the maths spec stays outside this repository, with the spec
  and the benchmark, in `~/dev/wiki-bench/globe/spec` (memory key `work.ask-language`).

## Alternatives considered

- **The same maths in Rust compiled to WebAssembly (v3)** — no faster than Elm in the frame, and a second language.
- **A static picture moved by a CSS transform between exact redraws (v4)** — no frame-time gain once the input was held
  fixed, and the picture drifts from the exact one by up to 45 px mid-gesture. Withdrawn.
- **Lines drawn as a few paths (v5-edges), keyed children (v5-keyed)** — no frame-time gain; keyed children created about
  four times more nodes in zoom and sweep. Not adopted.
- **Keeping the old unit tests of the lens and the discs** — they test code that no longer exists. They were ported where
  the behaviour still exists (see Consequences) and retired where it does not.

## Consequences

- Measured on one machine, headless Chrome with GPU raster flags, three rounds, input sent at fixed times, against the old
  map with only the `will-change` rule added: turning the globe 11.8 to 6.8 ms mean per frame (95th percentile 24.2 to
  12.5 ms), main-thread busy time -41 %, attribute writes -72 %; moving the cursor over the globe without a button -14 %;
  zooming is the same on the main thread. The figures are only claims above about 15 %.
- **Open:** the raster time (drawing, on other threads) of zooming rose 60 to 75 % (2,148 against 1,317 ms). Excluded by
  bisecting: the mouse-move handler and the cursor rule. Not tested alone: the removal of the discs and the spring rewrite.
- Not checked: a phone, a person's look at a long interaction, the effect of the frozen hover separately from the other changes.
- Kept true by: `frontend/tests/GlobeTests.elm` (78 checks of the maths against the spec's vectors, 1e-9), `MotionTests.elm`,
  `WikiTests.elm` (76 tests: of the previous 80, 55 are unchanged and 25 were rewritten for the globe or retired, listed
  below; 21 are new), `MotionTests.elm` (the arrays against the old dictionaries, 1e-9), `server/test/map_css_test.exs`
  (DY-10), and the requirements LN-1..LN-5, DY-1..DY-10, TC-1..TC-3. All of the old file, `Lens.elm` and the old tests are in
  the git tag `backup/dy8-snapshot-before-v6`.
- `Main.update` has no unit test (its model holds a navigation key that tests cannot build); the rules that matter were
  moved into pure functions (`MapCamera.pointerMoved`, `clickOpens`) and are tested there. The whole flow was checked with
  real mouse input in headless Chrome (`~/dev/wiki-bench/globe/functional.py`).

## The 25 previous tests that were rewritten or retired

Rewritten for the globe (same behaviour, new code): hover and click on a dot (now the pointer messages and `hitAt`), one finger
pans, quick taps and circles do not zoom, a dot in the middle is bigger and labelled, a displaced dot is placed where it belongs,
the geometry does not depend on the displacement, a settled map has no displaced dot, the lit dot has no hit area to grow, a dot
beyond the rim is not drawn. Retired with the code they tested (nothing replaces them, because the thing no longer exists): the
lens's order along a line, rim never crammed (about 3 times), no folding back far outside the window, strength 0 on phones,
ellipse touching the sides stays put, a pinch measured through the lens, the lens undone first, the layout made round and fitted
inside the rim, the ball growing until 30 % is cut off (the camera's growth is checked by `GlobeTests` against the spec's vectors
instead), and the step that visited only a set of candidate dots (`MotionTests` compares the array version with the old
dictionary version instead).

Full titles:

- hovering a node asks to preview it
- clicking a node opens its page
- one finger pans: the map point under it stays under it
- a double tap, quick taps and circles of one finger do not change the scale
- a pinch scales by the distance between the fingers on screen, whatever the lens does around them
- the lens is undone first, so the finger holds the dot it is on
- the middle is magnified, the ellipse touching the sides is not, the border is squeezed
- dots near the middle end up further apart, dots near the border closer together
- points on the ellipse that touches the sides stay where they are, everything stays inside the window
- order along a line is kept
- the rim is tighter than the middle but never crammed: about 3 times at most on the sides
- a round dot faces us in the middle and is flattened towards the middle where the surface turns away
- a point far outside the window never folds back over the globe
- strength 0 changes nothing (phones)
- a pointer position maps back to the dot under it
- a dot in the middle is drawn bigger and with its label, one at the border smaller and without
- the layout made round fits inside the rim, wide or tall area alike
- the ball starts fitting exactly, grows with the zoom until the edges cut off 30 % of it, then stays
- a dot beyond the rim is on the far side and is not drawn
- a displaced dot is drawn exactly where the lens puts its displaced place, one that rests at its cached place
- the pointer's discs and the geometry do not depend on the displacement, and change with the zoom
- stepping only the dots that can move gives exactly the displacements of stepping every dot, and leaves no entry for a dot at rest
- the sparse step reports at rest at the same step as the plain step does, while a dot is held lit
- when everything has settled with nothing pulling or holding, no dot has an entry any more
- the hit disc is flattened like the resting dot, and the drawn dot has none, so lighting it cannot grow it

## Update 2026-11-06 (same day): the open raster question

The raster rise is caused by the missing hit discs. A copy of the old map with only `.node-hit { display: none; }` added (the discs
not drawn) raised the zoom raster time from 1,363 to 2,074 ms, the same as the new map (2,028 ms); 4 rounds, same method
(`~/dev/wiki-bench/globe/RESULTS.md`, round 9). It is not the spring rewrite or the handlers. The browser's reason is not known. The
main thread did not pay for it (the new map's busy time in the zoom scenario is lower than both controls, the 95th percentile frame
time is equal or lower), so it is work on other threads. Not measured: a phone GPU, compositor frames, and whether an inert
transparent element would bring the old raster time back; no such element was added because nothing shows a cost to the reader.

## Update 2026-11-06 (later): labels, found on the real phone

Looking at the phone (Motorola edge 50 fusion, over USB) showed what the desktop screenshots had not: the globe labelled 59 of 126
dots at the first view, the earlier lens only the 14 projects, and the names piled up on the small screen. Both versions used the
same rule (zoom times the square of the dot's area scale at least 0.7), but the old zoom number started well below 1 and the new
area scale at the middle grows one for one with the zoom, so the new rule counted the zoom three times. The rule is now the square
of the area scale divided by the zoom, at least 1.4 (`MapGeometry.labelThreshold`): 12 labels at the first view (the projects in
view), more as you zoom in, the middle first. LN-2 says so, and `WikiTests` checks it (no non-project label at the first view; at
zoom 2 the middle dot has one, the dot near the rim has none). The earlier claim that the screenshots "look the same by eye" was
made from desktop-size pictures only.

## Update 2026-11-06 (later still): dots grew too fast when zooming (DY-11)

Giovanni: "the balls are getting disproportionately bigger as the zoom is implemented, it makes the zoom unusable after a certain
point." Measured on the real phone, pinching in on the merged build: the middle dot was 8 px wide at the first view, 75 px after
one pinch, 141 px after three, and 344 px after four, while the distance to the nearest dot went 27, 63, 80, 220 px. Dots
overlapped into blobs (screenshots in the session). Cause: the dot's matrix (`Globe.place`) already grows with the globe's scale,
which is about the zoom at the middle, and `MapGeometry.build` still multiplied by `rz = clamp 0.7 2.2 (z^0.6)`, which the lens had
used when its matrix did not grow with the zoom. The zoom was counted twice. `rz` is now divided by the zoom (`/ max 1 z`), so the
whole growth is the zoom to the power 0.6, at most 2.2 times, and with the area factor (at most 1.6) 3.5 times, the lens's own
limit. The same pinch on the fixed build: 8, 31, 34, 38, 37 px wide against 27, 63, 67, 168, 264 px between dots. The hit area had
the same flaw the other way round: the reach was the base radius times the area factor plus 6 px and ignored the matrix, so a
dot drawn large was only hit near its middle; it is now multiplied by the globe's scale at the dot (not below 1, so the first view
is unchanged). DY-11 states both; `WikiTests` checks the growth limit, the ratio to the distance to the neighbour at zoom 1 to 3,
and that the edge of a zoomed dot is inside its hit area. The earlier tests passed because they looked at the first view and at
zoom 2 to 3 only, not at the size of a dot against its neighbours.

## Update 2026-11-06 (end of day): the lines as paths (DY-12)

Measured on the real phone, what a frame of a swipe is made of: 12.8 ms, script 5.5, layout 3.5, paint 2.6. Hiding the lines (CSS
`display: none`, five builds alternated, a control build measured twice and within 0.1 ms of itself) gave 10.1 ms; hiding only the
arrowhead markers gave 12.0 ms (paint 2.6 to 1.6); removing the dashes changed nothing. So the cost was the number of elements, not
the dashes. `MapEdges` draws the unlit lines as one `path` per kind and per stroke width (quarter-pixel steps, so at most 14 groups)
and the arrowheads as triangles in one more path per feeding group, because an SVG marker belongs to the last point of a path, not to
each segment. The lit lines keep their own elements and the marker (they are few and the stylesheet lights them one by one). Phone,
3 repeats x 2 cycles: swipe 13.1 to 9.6 ms, flick 14.7 to 10.4, pinch 12.1 to 9.5. The desktop had shown no gain from an earlier
variant (lines as paths, round 6) because there the browser's paint is not on the main thread; the phone's is. DY-12 states it;
`MapEdgesTests` checks the group count, that every line is present, the arrowhead geometry and the line of length zero.

## Update 2026-11-06 (night): smaller dots that spread (DY-13)

Giovanni: "make the nodes smaller and they are not spreading as you zoom in." DY-11 had capped the growth but the dots still filled
the picture at moderate zoom. Measured on the live map (desktop, wheel at the middle; real phone, Chrome's pinch): the median dot width
against the median distance to the nearest dot went 0.30, 0.55, 0.49, 0.19 at 0, 3, 6, 9 wheel clicks (the dot 9 to 35 px, the spacing
30 to 180 px), and on the phone 9 px to 30 px after one pinch. Reading `MapGeometry.dotAt`: the dot's matrix already grows with the
local scale `s`, and `radiusScale = clamp 0.4 1.6 (s * sqrt s) * rz` multiplied it by a depth cue built on the absolute `s`. At the
middle `s` equals the zoom exactly, so the cue was 1 at the first view and 1.6 (its cap) from the first wheel clicks on: a 60 %
growth that had nothing to do with depth, and `rz` (zoom to the power 0.6) came on top. The cue now uses `s / z`, so it means "how
much nearer than the middle" at any zoom and is the same as before at the first view; `rz` follows the zoom to the power 0.4, at
most 2; base radii are 4 and 7 (were 6 and 11); the hit padding is 8 px (was 6) so an ordinary dot keeps its 12 px reach. Result:
the ratio falls at every step (desktop 0.20, 0.13, 0.07, 0.03; phone 0.22 to 0.04), the middle dot grows 8 to 13 px over the pinch
range. DY-13 states it and `WikiTests` checks the first-view size, the growth limit and that the ratio falls; the growth test
fails on the previous formulas. Not changed: labels (at moderate zoom they overlap, as before).

## Update 2026-11-06 (night): names that do not overlap (LB-1, LB-2)

Giovanni: "Too many names are appearing after a little zoom, it becomes illegible. Why did this pass the tests?" Counting the names on
the live map (`zoomstats.py`: text boxes from the browser): after three wheel clicks 42 names with 43 overlapping pairs on the desktop;
on a phone-sized window 36 names and 54 pairs after six pinches; 4 and 7 pairs even at the first view (projects over projects).
`labelled` was true for every dot whose scale passed `labelThreshold`, `MapView` added every project and every neighbour of the lit
dot, and nothing looked at the others. The tests that existed (`WikiTests`, LN-2) used the six-dot fixture and checked that `mem`
had a name and `quizapp` had none at zoom 2, so a map with names on top of each other passed them. I had also looked at the pictures
of the DY-13 change, seen the overlap, and written "as before" instead of treating it as the defect it was.
`MapLabels.chosen` now decides in `MapGeometry.build`: candidates (the dots over the threshold and the projects) best first,
projects, then scale, then id (so the choice is stable), and a name is kept only if its estimated box (0.55 of the font size per
character, below the dot, 3 px margin) misses the boxes kept. `MapView` forces only the lit dot's name. Result on the live map: 0
overlapping pairs at every step on the desktop and the phone-size window, 5 to 19 names where there were 36 to 42. The new tests
(`MapLabelsTests`) build a map of the real size (130 dots, 14 projects, titles of 8 to 50 characters, a spiral over the whole ball) and
check every zoom of 1 to 12 in three turns; three of them fail when the overlap test in `chosen` is switched off. What they still do
not check: that the box estimate matches the font (it did on the live map: 0 real overlaps), or that a name does not lie over
another dot.

