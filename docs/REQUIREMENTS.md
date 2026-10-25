# Requirements

Every promise the software makes, with an ID. A test that checks it carries the tag `REQ <ID>` in a comment;
`tools/pipeline-check.sh --traceability` fails when a requirement has no test or a tag names an unknown requirement.
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
| CO-6 | Every page has a reviewed date or date-and-time in UTC that is not in the future; a page without sources is shown as "may be stale" 30 days after it | D |
| CO-7 | Sources are written repo:path; local mode checks that they and the memory refs exist | D |
| CO-8 | A page of kind skill has a non-empty Steps section: the skill's own definition (rules or steps), so the page is enough to understand the skill | G |
| CO-9 | The first use of every acronym listed in content/_acronyms.tsv is next to its full name (the name appears before it or within 100 characters after it), outside code quotes | G |
| ST-1 | `wiki stale` lists a page when any of its sources changed after the page's reviewed time; commits that touch only the page file never clear it | G |
| ST-2 | A source outside git (home:) counts as changed at the newest modification time of its file or folder | G |
| ST-3 | `wiki stale` prints for each page the source and both times, and exits 1 when it lists a page and 0 when it lists none | D |
| LG-1 | Every English page has German and Brazilian Portuguese versions made from its current English text | G |
| LG-2 | The interface is in English by default and switchable to German and Brazilian Portuguese | G |
| BU-1 | The build writes graph.json (nodes, feeds and mentions edges) and one article per page per language | D |
| BU-2 | A page's since date is its header value, else the first commit of its sources | D |
| BU-3 | A page of kind reference (the glossary) can link to any page without drawing edges on the map | G |
| UP-1 | The Stop hook blocks only for code changes the wiki covers (or new files) since the last publish, at most once per session per change set, never when a stop hook is already active | G |
| UP-2 | wiki publish refuses when the local check fails, and commits only content/ | G |
| UP-3 | The Stop hook message tells Claude to record a page it checked and found right by setting its reviewed time, and keeps "review: no page change" for changes no page describes | G |
| MP-1 | Search suggests matching pages (title and aliases) while typing, best match first | G |
| MP-2 | Hovering a node fills the four info boxes; clicking a node opens its article | G |
| MP-3 | Links written [[id]] in an article lead to that article | G |
| MP-4 | The map can be filtered by project and by date (timeline) | D |
| MP-5 | On windows wider than 1100 px the map is as tall as the window allows and leaves only the height of the four info boxes below it, so hovering a node never makes the page scroll; a text longer than its box scrolls inside the box | G |
| MP-6 | The map layout takes the shape of the map area: on a wide window the nodes spread over the full width, on a tall one over the full height; distances only grow, none shrinks, and every node keeps its place relative to the others | G |
| MP-7 | Hovering a node lights it, its neighbours and its edges within 80 ms: every transition on the map is at most 0.08 s | G |
| MP-8 | A link to another site in an article opens in a new tab; a link to a wiki page stays in the tab | G |
| MP-9 | The top bar of every screen links to the glossary page, labelled in the chosen language | G |
| MB-1 | On a phone-width window (760 px or less) the map fills the whole screen and the search bar floats over its top with the menu button inside it | G |
| MB-2 | On a phone, tapping a node opens a balloon over the lower part of the map with what it is, what it does, what feeds it, who receives its output and a link to its page; tapping a node never leaves the map by itself | G |
| MB-3 | On a phone the balloon's neighbours are buttons that select that node, and the search selects the node it finds | D |
| MB-4 | On a phone an article shows its title, lead and infobox first, and every other section starts closed and opens when its heading is tapped | G |
| MB-5 | The lit step of a process page is drawn whole: its circle, glow and growth are not cut off by the box around the steps | G |
| LN-1 | On a desktop window the map is seen through a lens: dots in the middle of the area are bigger and further apart, dots near the border smaller and closer, and no dot leaves the window because of it; on a phone the lens is off | G |
| LN-2 | Detail follows the lens: dots in the middle get their labels, dots near the border have none, and the dashed "mentions" lines are left out there unless lit | G |
| LN-3 | A pointer position maps back through the lens to the dot under it, so dragging and clicking work where the dots are drawn | D |
| DY-1 | The dots have an elastic layer on top of the layout: at rest every displacement is zero (the layout, MP-6, is unchanged) and when everything has settled no animation frames are requested | G |
| DY-2 | Pressing a dot and moving the mouse drags it, its neighbours stretch along and contract back when it is let go; a press without movement still opens the page and a drag never does | G |
| DY-3 | Hovering a dot draws its neighbours a fifth of the way towards it, and they return when the pointer leaves | G |
| DY-4 | On first load the dots spring open from the middle, and after a window resize they spring from where they were to their new places instead of jumping | G |
| MB-6 | On a phone the map has no CSS transitions and no dashed lines, so a tap, a pan and a pinch keep frames short (measured on the phone before the lens: 118 ms a frame after a tap with them, 19 ms without) | G |
| MB-7 | The page declares itself not translatable, so the browser's own translation offer neither covers the search bar nor rewrites the app's text | D |
| MB-8 | On a phone, choosing a search result closes the keyboard, and a change of the window's height alone (keyboard, address bar) keeps the map's zoom and place | D |
| DY-5 | A dot answers the pointer at its resting place, not where the elastic movement has drawn it, so motion never slides a dot under or out from under a still pointer: the highlighted dot does not change while the pointer is still | G |
| LN-4 | On a phone the lens has a rectangular focus: each axis is bent on its own, so the middle band is magnified while every side and corner of the area stays in place; while a dot is selected the focus moves to the part of the screen the balloon leaves free and the selected dot lands in its middle | G |
| DY-6 | The phone's elastic movement is slightly less elastic than the desktop's (stiffer spring, less following of neighbours, more friction), and tapping a dot draws its neighbours in a little, as hovering does on a desktop | G |
| LY-1 | The force layout is computed a few steps per animation frame instead of in one block, so the page keeps answering while it settles (on the phone the single block froze the page for about 3 seconds); run in slices it gives exactly the layout of a single run | G |
| TC-1 | On the map one finger pans (the map point under the finger stays under it, through the lens) and two fingers pinch around their midpoint | G |
| TC-2 | Nothing but a pinch zooms the map by touch: a double tap, quick repeated taps or circles of one finger never zoom it | G |
| TC-3 | Every touch event restates the fingers that are down, so a missed lift cannot leave a phantom finger that turns the next touch into a pinch | D |

