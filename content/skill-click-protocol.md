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
sources: [home:.claude/skills/click-protocol/SKILL.md]
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
