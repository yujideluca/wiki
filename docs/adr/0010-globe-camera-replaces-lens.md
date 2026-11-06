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
