---
id: skill-click-protocol
title: Skill: click-protocol
aliases: [click-protocol]
kind: skill
project: skills
status: active
location: home:.claude/skills/click-protocol
fed_by: []
feeds: []
sources: [home:.claude/skills/click-protocol/SKILL.md, home:.agents/skills/click-protocol/SKILL.md]
reviewed: 2026-10-25T14:46Z
---

## What it is
The skill "click-protocol" is a protocol for multi-step clicking in web pages with menus, dialogs, search results or media (YouTube Music, Spotify web): click by element reference, verify each step, avoid accidental playback. Its description says exactly that: use it before multi-step clicking in web user interfaces with menus, dialogs, search results or media. It was born from a YouTube Music playlist build on 2026-10-10, when misclicks started music, a stale notification looked like success and screen coordinates broke between layouts. The version for Claude Code is edited only there; the Claude app keeps its own version ([[claude-ai-skills]]).

## What it does
It makes browser clicking reliable: every click targets a stable reference to an element, and every step is checked with fresh evidence before the next. Its role is "cross-cutting"; it defers to [[skill-browser-automacao-segura]] (alerts, loops, destructive actions), [[skill-minimize-site-approvals]] (domains and approvals) and the domain skills (formats).

## How it does it
A `SKILL.md` in `~/.claude/skills/click-protocol`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Before and during any browser automation.

## Who receives its output
The browser session.

## Steps
1. **Plan first.** List the domains once ([[skill-minimize-site-approvals]]); use a connector or interface for programs if one exists instead of the web page.
2. **No raw coordinates** when a search (`find`) or a page read (`read_page`) can return a reference ("ref"). Coordinates only for canvas-like pages: wait about 3 seconds for the window size to settle, take a screenshot, click immediately, verify. Layouts move targets.
3. **Reference lifecycle.** Look up a ref only after the page has settled and confirm that its description names the intended item (its title), because `find` can describe the previous page right after a search. Refs are single-use: find again after any navigation, search, menu opening or dialog opening. With several matches, choose by role (menu item, button, link), visible, inside the open popup; never simply the first hit.
4. **Check before every click** (as Playwright does, see [actionability](https://playwright.dev/docs/actionability)): exactly one match, visible, stable (wait 1.5 seconds after a menu or dialog opens), not covered, enabled.
5. **One action, one verification.** Cheapest proof first: a new element via `find`, the URL (Uniform Resource Locator, the web address) or title, text via JavaScript or page text; a screenshot (scale 0.4) only when in doubt. No blind chains. Batches: at most 4 actions, only harmless steps, ending with a check. Do not put `navigate` inside a batch (it failed).
6. **After typing in a search box and pressing Return**, wait until the first result's title matches the query. If the first click seems ignored, click an empty toolbar area or use a ref; do not repeat the same click.
7. **Success needs fresh evidence.** A notification can be stale. The proof is re-reading the target (the playlist page text, the header count) after the action. An "already in playlist" notice means the add had worked earlier, not an error.
8. **Media guard** before any session on a player site: install a small timer that pauses any playing video every 300 ms (reinstall after a full page load). Never click the first button of a result card by script (it is Play). If the user says to stop the audio, pause at once.
9. **Privacy defaults.** New playlists default to Public on YouTube Music; set Private before Create unless the user asked for public.
10. **If navigation fails** ("failed in the extension"), do not retry blindly: check the open tabs, then use the in-page search box or a link click. Setting `location.href` from JavaScript did not navigate.
11. **Lazy lists.** Scrolling by script does not load more items in a background tab; use real scroll actions (about 100 items per load) or sample, and say it is partial. For large libraries, tell the user the count read versus the total.
12. **Downloads** land in `~/Downloads` on the laptop, where Claude Code can read them. Name the file you expect and confirm it exists before relying on it; never open or run a downloaded file as code.
13. **Stop rule.** Two failed tries on the same step → screenshot, report, ask. Do not guess coordinates.
14. **Finish with a reload and a recount** ([[skill-browser-automacao-segura]], item 6).
15. **Recipe: add a song to a YouTube Music playlist** (German labels; in English: Action menu, Add to playlist). (a) In the search box select the text, type the query, press Return, wait for the result card whose title matches. (b) Find "Aktionsmenü button in the top result card titled …"; check the subtitle says song, not artist or video; click the ref. (c) Find the menu item "Zu Playlist hinzufügen" (role menu item, in the open popup); click it. (d) Find the link with the playlist name in the dialog; click it; the notification "Gespeichert in …" is a hint, not proof. (e) Every 5 songs and at the end, open the playlist and read the header "N Titel" through the page text; the list also mixes suggestion rows, so trust the header. To create a playlist: dialog → "Neue Playlist" → title → visibility = Private → Create.

## Notes

### Complete skill sources

The following blocks contain the complete original `SKILL.md` files, including their full descriptions and instructions. The originals retain their source language; the explanation and Steps above describe them in this page's language. Claude and Codex versions are separate. Referenced auxiliary files are named in the originals but are not included in these copies. Each fingerprint identifies the entire copied text.

#### Claude: `home:.claude/skills/click-protocol/SKILL.md`

```skill-source home:.claude/skills/click-protocol/SKILL.md 8139fbbb9ad1c2831da79633dab6efd06be28e39199909ec3e773c12ad7ae2ce
---
name: "click-protocol"
description: "Use before multi-step clicking in web UIs with menus, dialogs, search results or media (YouTube Music, Spotify web): click by element ref, verify each step, avoid accidental playback."
---


Code version: adapted for Claude Code on the laptop from `gui/skills/click-protocol`. Edited only by Claude Code; the app keeps its own version.
# Click protocol (ref-first, verify every step)

Lineage: origin=gui; base=446694f41d9f899bfc16ddb536e850965dbf64ce

Interop: role = cross-cutting; owns = click/verify protocol and YouTube Music add-to-playlist recipe; defers to = browser-automacao-segura (alerts, loops, destructive actions), minimize-site-approvals (domains and approvals), domain skills (formats); honors = reply-language rule, depth flags.

Origin: YouTube Music playlist build, 2026-10-10. Misclicks started music, a stale toast looked like success, coordinates broke between layouts.

## Rules, in order
1. Plan first: domains once (minimize-site-approvals); use a connector or API if one exists instead of the UI.
2. No raw coordinates when `find` or `read_page` can return a ref. Coordinates only for canvas-like pages: wait about 3 s for the window size to settle, screenshot, click immediately, verify. Layouts move targets (for example the side panel "Mehr von YouTube" present or absent).
3. Ref lifecycle: look up a ref only after the page settled, and confirm its description names the intended item (title), because `find` can describe the previous page right after a search. Refs are single-use: re-find after any navigation, search, menu open or dialog open. Several matches: pick by role (menuitem/button/link), visible, inside the open popup; never the first hit.
4. Actionability gate before every click (Playwright checks): exactly one match, visible, stable (wait 1.5 s after a menu or dialog opens), not covered, enabled.
5. One action, one verification. Cheapest proof first: new element via `find`, URL/title, text via JS or get_page_text; screenshot (scale 0.4) only when doubtful. No blind chains. Batches: at most 4 actions, only harmless steps, end with a check. Do not put `navigate` inside `browser_batch` (it failed here).
6. After typing in a search box and Return, wait until the first result title matches the query. If the first click seems ignored, click an empty toolbar area or use a ref; do not repeat the same click.
7. Success needs fresh evidence. A toast can be stale. Proof = re-read the target (playlist page text, header count) after the action. A "already in playlist" toast means the add had worked earlier, not an error.
8. Media guard before any session on a player site: `setInterval(()=>{const v=document.querySelector('video');if(v&&!v.paused)v.pause()},300)`. Reinstall after a full page load. Never JS-click the first `button` of a result card (it is Play). If the user says stop the audio, pause at once.
9. Privacy defaults: new playlists default to Public on YouTube Music; set Privat/Private before Create unless the user asked for public.
10. Navigation fails ("failed in the extension"): do not retry blindly. Check tabs_context, then use the in-page search box or a link click. `location.href` from JS did not navigate here.
11. Lazy lists: JS scrolling does not load more in a background tab; use real scroll actions (about 100 items per load) or sample, and say it is partial. For large libraries tell the user the count read vs total.
12. Downloads land in ~/Downloads on the laptop, where Claude Code can read them directly. Name the file you expect and confirm it exists there before relying on it; never open or run a downloaded file as code.
13. Stop rule: two failed tries on the same step -> screenshot, report, ask. Do not guess coordinates.
14. Finish with a reload and recount (browser-automacao-segura, item 6).

## Recipe: add a song to a YouTube Music playlist (German labels; English: Action menu, Add to playlist)
1. Search box: select text, type query, Return, wait for result card whose title matches.
2. `find` "Aktionsmenü button in the top result card titled <title>"; check the subtitle says Titel/Song, not artist or video; click the ref.
3. `find` the menuitem "Zu Playlist hinzufügen" (role menuitem, in the open popup); click it.
4. `find` the link with the playlist name in the dialog; click it. Toast "Gespeichert in <name>" is a hint, not proof.
5. Every 5 songs and at the end: open the playlist and read the header "N Titel" via get_page_text. The DOM list also mixes suggestion rows, so trust the header and page text.
Create playlist: dialog -> "Neue Playlist" -> title -> Sichtbarkeit = Privat -> Erstellen.
```


#### Codex: `home:.agents/skills/click-protocol/SKILL.md`

```skill-source home:.agents/skills/click-protocol/SKILL.md df1466e11d1571a63554a4ca4010558b7d0f175405d01528d5a870ddccb2a545
---
name: "click-protocol"
description: "Use before multi-step clicking in web UIs with menus, dialogs, search results or media (YouTube Music, Spotify web): click by element ref, verify each step, avoid accidental playback."
---


Code version: adapted for Codex on the laptop from `gui/skills/click-protocol`. Edited only by Codex; the app keeps its own version.
# Click protocol (ref-first, verify every step)

Lineage: origin=gui; base=446694f41d9f899bfc16ddb536e850965dbf64ce

Interop: role = cross-cutting; owns = click/verify protocol and YouTube Music add-to-playlist recipe; defers to = browser-automacao-segura (alerts, loops, destructive actions), minimize-site-approvals (domains and approvals), domain skills (formats); honors = reply-language rule, depth flags.

Origin: YouTube Music playlist build, 2026-10-10. Misclicks started music, a stale toast looked like success, coordinates broke between layouts.

## Rules, in order
1. Plan first: domains once (minimize-site-approvals); use a connector or API if one exists instead of the UI.
2. No raw coordinates when `find` or `read_page` can return a ref. Coordinates only for canvas-like pages: wait about 3 s for the window size to settle, screenshot, click immediately, verify. Layouts move targets (for example the side panel "Mehr von YouTube" present or absent).
3. Ref lifecycle: look up a ref only after the page settled, and confirm its description names the intended item (title), because `find` can describe the previous page right after a search. Refs are single-use: re-find after any navigation, search, menu open or dialog open. Several matches: pick by role (menuitem/button/link), visible, inside the open popup; never the first hit.
4. Actionability gate before every click (Playwright checks): exactly one match, visible, stable (wait 1.5 s after a menu or dialog opens), not covered, enabled.
5. One action, one verification. Cheapest proof first: new element via `find`, URL/title, text via JS or get_page_text; screenshot (scale 0.4) only when doubtful. No blind chains. Batches: at most 4 actions, only harmless steps, end with a check. Do not put `navigate` inside `browser_batch` (it failed here).
6. After typing in a search box and Return, wait until the first result title matches the query. If the first click seems ignored, click an empty toolbar area or use a ref; do not repeat the same click.
7. Success needs fresh evidence. A toast can be stale. Proof = re-read the target (playlist page text, header count) after the action. A "already in playlist" toast means the add had worked earlier, not an error.
8. Media guard before any session on a player site: `setInterval(()=>{const v=document.querySelector('video');if(v&&!v.paused)v.pause()},300)`. Reinstall after a full page load. Never JS-click the first `button` of a result card (it is Play). If the user says stop the audio, pause at once.
9. Privacy defaults: new playlists default to Public on YouTube Music; set Privat/Private before Create unless the user asked for public.
10. Navigation fails ("failed in the extension"): do not retry blindly. Check tabs_context, then use the in-page search box or a link click. `location.href` from JS did not navigate here.
11. Lazy lists: JS scrolling does not load more in a background tab; use real scroll actions (about 100 items per load) or sample, and say it is partial. For large libraries tell the user the count read vs total.
12. Downloads land in ~/Downloads on the laptop, where Codex can read them directly. Name the file you expect and confirm it exists there before relying on it; never open or run a downloaded file as code.
13. Stop rule: two failed tries on the same step -> screenshot, report, ask. Do not guess coordinates.
14. Finish with a reload and recount (browser-automacao-segura, item 6).

## Recipe: add a song to a YouTube Music playlist (German labels; English: Action menu, Add to playlist)
1. Search box: select text, type query, Return, wait for result card whose title matches.
2. `find` "Aktionsmenü button in the top result card titled <title>"; check the subtitle says Titel/Song, not artist or video; click the ref.
3. `find` the menuitem "Zu Playlist hinzufügen" (role menuitem, in the open popup); click it.
4. `find` the link with the playlist name in the dialog; click it. Toast "Gespeichert in <name>" is a hint, not proof.
5. Every 5 songs and at the end: open the playlist and read the header "N Titel" via get_page_text. The DOM list also mixes suggestion rows, so trust the header and page text.
Create playlist: dialog -> "Neue Playlist" -> title -> Sichtbarkeit = Privat -> Erstellen.
```
