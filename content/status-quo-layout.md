---
id: status-quo-layout
title: Status Quo — terminal-style layout mockup
aliases: [Status Quo mockup]
kind: reference
project: none
status: beta
since: 2026-11-01
location: wiki:content/status-quo-layout.md
fed_by: []
feeds: []
sources: [wiki:content/status-quo-design.md, status-quo:crates/tray/src/ui.rs, status-quo:crates/core/src/config.rs]
reviewed: 2026-11-08T19:32Z
---

## What it is
This is the proposed layout for [[status-quo-design]], a desktop panel showing assistant usage and current work. All names, numbers, task labels, and events below are invented demonstration data. They are not a live account reading. The diagrams are terminal-style wireframes: pictures made of text to show placement and behavior before code is written.

## What it does
The overview keeps five-hour and weekly usage at the top, then sessions, repository activity, and memory. A narrow panel stacks the two usage widgets vertically; a wider one puts them side by side. Widgets can be hidden, resized, detached, and reordered. Keyboard move-up/move-down actions accompany drag handles. The illustration shows the expanded form; compact mode retains quotas and source health while collapsing details.

## How it does it
### Independent widgets inside the tray
The approved visual arrangement remains a mockup, not a fixed grouping of functionality. Each account meter, token graph, sessions list, GitHub feed, and memory feed is an independently removable and replaceable widget. A graph and a meter drawn close together do not become one component. The tray's add-widget catalog can restore a removed widget or replace it with another compatible type. Each instance keeps independent settings. The running layout will make these separate boundaries visible in edit mode; further visual refinement happens after it runs.

### Overview tab — wide panel
```text
┌─ STATUS QUO ────────────────────────────────────────────────────────┐
│ [Overview]  [Customize]  [Sources]          Edit layout: off    ─  × │
├────────────────────────────────┬───────────────────────────────────┤
│ :: CLAUDE             ↗ detach │ :: CODEX                  ↗ detach│
│ 5h used   ███████░░░  68%      │ 5h used    ███░░░░░░░  32%       │
│ weekly    ████░░░░░░  41%      │ weekly     █████░░░░░  54%       │
│ resets in 02h 14m / Fri 18:00  │ resets in 03h 02m / Sun 12:00     │
│ [24h] [7d] [30d]  [Buckets ▾]  │ [24h] [7d] [30d]  [Buckets ▾]     │
│ tokens/hour                   │ tokens/hour                       │
│ 12k ┤       ╭╮                │ 12k ┤  ╭╮                         │
│  6k ┤ ╭╮ ╭──╯╰─╮              │  6k ┤╭─╯╰╮  ╭──╮                  │
│   0 └────────────────── time  │   0 └─────────────────── time      │
│ input / output / cache   14:32 │ input / output / cache      14:32 │
├────────────────────────────────┴───────────────────────────────────┤
│ :: SESSIONS                               3 main / 2 child agents │
│ ▾ sample-project                                                  │
│   ▾ Claude · Implement graph buckets      RUNNING   3/6 · 4s ago   │
│     ├ child · Check time boundaries       RUNNING         2s ago  │
│     └ child · Review fixtures             COMPLETED      32s ago  │
│   ▸ Codex  · Verify history import        WAITING FOR INPUT       │
│ ▸ another-project · Codex                 IDLE                    │
├───────────────────────────────────────────────────────────────────┤
│ :: RECENT ACTIVITY              [Repositories ▾] [All events ▾]    │
│ sample-project · commit · Correct bucket boundaries       6m ago  │
│ sample-project · checks passed · revision abc123           7m ago  │
│ another-project · issue opened · Improve loading state   25m ago  │
├───────────────────────────────────────────────────────────────────┤
│ :: WORKFLOW MEMORY             [Both assistants ▾] [All types ▾]   │
│ ▸ Decision · Keep source timestamps visible               9m ago  │
│ ▸ Resolved · Verify restart recovery                     18m ago  │
│ ▸ Preference · Prefer compact display                    45m ago  │
├───────────────────────────────────────────────────────────────────┤
│ KDE · behind windows · navigation on · sources 5/5 fresh           │
└───────────────────────────────────────────────────────────────────┘
```

Graphs use separate series with labels and a legend; the wireframe uses one line only to avoid implying measured values. Pointer or keyboard inspection shows the exact bucket, time zone, and counter categories. Source timestamp and coverage remain accessible even in compact mode. The close control hides the panel; quitting the collector is a separate explicit action in settings.

### Customize tab
```text
┌─ STATUS QUO / CUSTOMIZE ───────────────────────────────────────────┐
│ [Overview]  [Customize]  [Sources]                                 │
│ Style          [Terminal ▾]     Mode       [Dark ▾]               │
│ Accent         [#7DDE8A]        Text size  [14 px]                 │
│ Background     [#111816]        Text       [#E0E8E2]               │
│ Background opacity  ─────────●── 85%     Text remains readable    │
│ Apply to       [All widgets ▾]  Density    [Expanded ▾]           │
│ Window layer   [Behind windows ▾]                                │
│ [✓] Open source links and local navigation                        │
│ [✓] Start at login            [ ] Lock layout                    │
│                                                                  │
│ Layout        [Edit arrangement] [Saved layouts ▾]               │
│ Presets       [Save as…] [Import…] [Export…]                      │
│                                                                  │
│ Live preview  ┌─ CLAUDE ───────────────────────────────────────┐  │
│               │ 5h used ███████░░░ 68%   weekly ████░░░░░░ 41%│  │
│               └───────────────────────────────────────────────┘  │
│                        [Restore defaults] [Cancel] [Save]        │
└──────────────────────────────────────────────────────────────────┘
```

Changing colors or opacity previews the result. Cancel restores the last saved values. The style selector lists installed Rust styles; it does not download executable plugins. Turning navigation off disables launches and source links, while retaining configuration and local display controls. Font size and keyboard focus remain usable in both light and dark styles.

### Sources tab and failure example
```text
┌─ SOURCES ─────────────────────────────────────────────────────────┐
│ Claude     STALE · last success 14:27 · retry scheduled 14:37      │
│            Showing last-known limits, not a new measurement       │
│ Codex      FRESH · last success 14:32                             │
│ GitHub     OFFLINE · 3 selected repositories · last success 14:20 │
│ Memory     FRESH · read-only · both assistants                    │
│ Sessions   FRESH · 1 session has unknown state                    │
│ Token log  PARTIAL · 1 incomplete trailing record · retry pending │
│ Desktop    KDE / Wayland · selected layer: behind windows         │
│            Placement capability checked by host wrapper          │
└──────────────────────────────────────────────────────────────────┘
```

Each widget retains its title and reports its own loading, empty, unavailable, stale, or error state. Failure never becomes a misleading zero. The health bar counts five source groups: Claude, Codex, GitHub, memory, and sessions. It does not count individual session rows; details identify the failing adapter. KDE Plasma is the desktop shell managing panels and windows; Wayland is the display protocol through which applications show their surfaces. Secrets and full conversation contents never appear in diagnostics.

### Narrow panel and future hosts
At narrow widths, keep each usage widget complete on its own row, followed by sessions, recent activity, and memory. Overflow lists scroll within a configurable height; text wraps or opens a local detail view. Do not shrink fonts automatically to fit. A detached widget uses the same component and theme values. A browser host uses the same components with sample data and advertises unsupported desktop placement.

## Where it sits in the pipeline
This mockup accompanies the [[status-quo-design]] review. It establishes information order and interaction behavior, not final pixel measurements. Visual implementation checks compare actual desktop screenshots with these layouts, including narrow widths, light mode, low opacity, keyboard focus, and unavailable sources. [[project-template]] supplies the development checks used after approval.

## Who receives its output
Giovanni reviews the layout together with the written design. The builder translates the approved behavior into requirements and real interface tests. Future styles preserve the same meanings and capabilities while replacing presentation.

## Notes
The mockup contains no real private repository activity or workflow-memory content. The layout was approved on 2026-11-01 and the desktop panel is now built (see [[status-quo-design]] for its current state); this page stays the design mockup. One deliberate difference: on the desktop-layer hosts the tray is bare, without the framed "STATUS QUO" title bar or any background of its own, so only the widgets and the three small buttons Add widget, Edit tray and Customize are visible, and the widget rows fill the tray space exactly. Since 2026-11-02 the Edit tray feature can replace that flow with explicit widget rectangles on a free canvas (see [[status-quo]], requirement SQ-29); a tray without explicit rectangles still fills its space as described. Since 2026-11-04 the editor lets a widget be placed anywhere on the desktop, also left of or above the docked tray, and shows a "Remove" button in the centre of each widget that removes it from the draft (Done saves, Cancel restores; details on [[status-quo]]). The built tray's Customize page has a slider "Space between widgets" that runs from 0 to 40 pixels (`crates/tray/src/ui.rs`), while the configuration check (`Config::validate` in `crates/core/src/config.rs`) accepts 0 to 64 and the default is 10; the wireframe above predates this control. Whether the built tray matches the wireframe's information order, as stated at approval time, was not verified in this review. Since 2026-11-06 the real Customize page (one scrolling page, not the tab mockup below) also offers the option Follow the wallpaper colours and a Browse button beside each source path (see [[status-quo]], requirements SQ-37 and SQ-39).

![Status Quo — static English interface mockup; sample data](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDgwIiBoZWlnaHQ9IjExNjAiIHZpZXdCb3g9IjAgMCAxMDgwIDExNjAiPgo8cmVjdCB3aWR0aD0iMTA4MCIgaGVpZ2h0PSIxMTYwIiBmaWxsPSIjMGIxMDBmIi8+CjxnIGZvbnQtZmFtaWx5PSJEZWphVnUgU2FucyBNb25vLG1vbm9zcGFjZSIgZm9udC1zaXplPSIxNCIgZmlsbD0iI2RjZThkZiI+Cjx0ZXh0IHg9IjQwIiB5PSIzNiIgZmlsbD0iIzdkZGU4YSIgZm9udC1zaXplPSIyMiI+U1RBVFVTIFFVTyAvIERFU0lHTiBQUkVWSUVXPC90ZXh0Pgo8dGV4dCB4PSI0MCIgeT0iNjEiIGZpbGw9IiM5MmE3OWIiPkludmVudGVkIHNhbXBsZSBkYXRhIMK3IHRlcm1pbmFsIHN0eWxlIMK3IEtERSBkZXNrdG9wIHdyYXBwZXI8L3RleHQ+CjxyZWN0IHg9IjMyIiB5PSI4MiIgd2lkdGg9IjEwMTYiIGhlaWdodD0iNjcwIiByeD0iOCIgZmlsbD0iIzExMTgxNiIgc3Ryb2tlPSIjNDk2MjUzIi8+Cjx0ZXh0IHg9IjUyIiB5PSIxMTMiIGZpbGw9IiM3ZGRlOGEiIGZvbnQtc2l6ZT0iMTgiPiZndDtfIFNUQVRVUyBRVU88L3RleHQ+Cjx0ZXh0IHg9IjY3MCIgeT0iMTExIiBmaWxsPSIjOTJhNzliIj5iZWhpbmQgd2luZG93cyDCtyBsYXlvdXQgbG9ja2VkPC90ZXh0Pgo8cGF0aCBkPSJNMzIgMTMxIEgxMDQ4IiBzdHJva2U9IiM0OTYyNTMiLz4KPHJlY3QgeD0iNDkiIHk9IjE0NCIgd2lkdGg9IjExOCIgaGVpZ2h0PSIzMCIgZmlsbD0iIzI2M2QyZSIgcng9IjMiLz4KPHRleHQgeD0iNjMiIHk9IjE2NCIgZmlsbD0iIzdkZGU4YSI+T3ZlcnZpZXc8L3RleHQ+PHRleHQgeD0iMTkwIiB5PSIxNjQiPkN1c3RvbWl6ZTwvdGV4dD48dGV4dCB4PSIzMjUiIHk9IjE2NCI+U291cmNlczwvdGV4dD4KPHJlY3QgeD0iNTAiIHk9IjE5MCIgd2lkdGg9IjQ4MCIgaGVpZ2h0PSIyMjYiIGZpbGw9IiMxNjIxMWMiIHN0cm9rZT0iIzM1NGIzZSIvPgo8cmVjdCB4PSI1NDkiIHk9IjE5MCIgd2lkdGg9IjQ4MCIgaGVpZ2h0PSIyMjYiIGZpbGw9IiMxNjIxMWMiIHN0cm9rZT0iIzM1NGIzZSIvPgo8dGV4dCB4PSI2OCIgeT0iMjE4IiBmaWxsPSIjN2RkZThhIj46OiBDTEFVREU8L3RleHQ+PHRleHQgeD0iNTY3IiB5PSIyMTgiIGZpbGw9IiM3ZGRlOGEiPjo6IENPREVYPC90ZXh0Pgo8dGV4dCB4PSI2OCIgeT0iMjUwIj41aCB1c2VkPC90ZXh0Pjx0ZXh0IHg9IjQ1OSIgeT0iMjUwIiBmaWxsPSIjN2RkZThhIj42OCU8L3RleHQ+CjxyZWN0IHg9IjE2OCIgeT0iMjM3IiB3aWR0aD0iMjcwIiBoZWlnaHQ9IjE0IiBmaWxsPSIjMmMzYzMxIi8+PHJlY3QgeD0iMTY4IiB5PSIyMzciIHdpZHRoPSIxODQiIGhlaWdodD0iMTQiIGZpbGw9IiM3ZGRlOGEiLz4KPHRleHQgeD0iNjgiIHk9IjI3OCI+V2Vla2x5PC90ZXh0Pjx0ZXh0IHg9IjQ1OSIgeT0iMjc4IiBmaWxsPSIjN2RkZThhIj40MSU8L3RleHQ+CjxyZWN0IHg9IjE2OCIgeT0iMjY1IiB3aWR0aD0iMjcwIiBoZWlnaHQ9IjE0IiBmaWxsPSIjMmMzYzMxIi8+PHJlY3QgeD0iMTY4IiB5PSIyNjUiIHdpZHRoPSIxMTEiIGhlaWdodD0iMTQiIGZpbGw9IiM3ZGRlOGEiLz4KPHRleHQgeD0iNTY3IiB5PSIyNTAiPjVoIHVzZWQ8L3RleHQ+PHRleHQgeD0iOTU4IiB5PSIyNTAiIGZpbGw9IiM4MGM4ZDUiPjMyJTwvdGV4dD4KPHJlY3QgeD0iNjY3IiB5PSIyMzciIHdpZHRoPSIyNzAiIGhlaWdodD0iMTQiIGZpbGw9IiMyYzNjMzEiLz48cmVjdCB4PSI2NjciIHk9IjIzNyIgd2lkdGg9Ijg2IiBoZWlnaHQ9IjE0IiBmaWxsPSIjODBjOGQ1Ii8+Cjx0ZXh0IHg9IjU2NyIgeT0iMjc4Ij5XZWVrbHk8L3RleHQ+PHRleHQgeD0iOTU4IiB5PSIyNzgiIGZpbGw9IiM4MGM4ZDUiPjU0JTwvdGV4dD4KPHJlY3QgeD0iNjY3IiB5PSIyNjUiIHdpZHRoPSIyNzAiIGhlaWdodD0iMTQiIGZpbGw9IiMyYzNjMzEiLz48cmVjdCB4PSI2NjciIHk9IjI2NSIgd2lkdGg9IjE0NiIgaGVpZ2h0PSIxNCIgZmlsbD0iIzgwYzhkNSIvPgo8ZyBmaWxsPSIjOTJhNzliIiBmb250LXNpemU9IjEyIj48dGV4dCB4PSI2OCIgeT0iMzAxIj41aCByZXNldCBpbiAwMmggMTRtIMK3IHdlZWtseSBGcmkgMTg6MDA8L3RleHQ+PHRleHQgeD0iNTY3IiB5PSIzMDEiPjVoIHJlc2V0IGluIDAzaCAwMm0gwrcgd2Vla2x5IFN1biAxMjowMDwvdGV4dD48L2c+CjxwYXRoIGQ9Ik04MSAzMjAgVjM3NiBINTA1IE01ODAgMzIwIFYzNzYgSDEwMDQiIHN0cm9rZT0iIzQ5NjI1MyIgZmlsbD0ibm9uZSIvPgo8cGF0aCBkPSJNODIgMzY4IEwxMTAgMzY4IEwxMjUgMzUyIEwxNTAgMzU4IEwxNzMgMzQ1IEwyMDUgMzQ5IEwyMjggMzMwIEwyNTEgMzUxIEwyODMgMzU1IEwzMDYgMzQxIEwzMzAgMzQ4IEwzNTUgMzM1IEwzODAgMzUwIEw0MTUgMzUyIEw0NDAgMzYzIEw0NzggMzU4IEw1MDMgMzY5IiBzdHJva2U9IiM3ZGRlOGEiIGZpbGw9Im5vbmUiIHN0cm9rZS13aWR0aD0iMiIvPgo8cGF0aCBkPSJNNTgxIDM2NiBMNjExIDM1NSBMNjM3IDM2MCBMNjYwIDMyOSBMNjg1IDM0NCBMNzE0IDM1MCBMNzQwIDM2NyBMNzYyIDM2NCBMNzg4IDM0OSBMODE2IDM1MiBMODQzIDM0NSBMODcwIDM1NyBMODk5IDM1OSBMOTI0IDM2MyBMOTYwIDM1MyBMMTAwMyAzNjUiIHN0cm9rZT0iIzgwYzhkNSIgZmlsbD0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIyIi8+Cjx0ZXh0IHg9IjY4IiB5PSI0MDAiIGZpbGw9IiM5MmE3OWIiIGZvbnQtc2l6ZT0iMTIiPnRva2Vucy9ob3VyIMK3IFsyNGhdIDdkIDMwZCDCtyBpbnB1dC9vdXRwdXQvY2FjaGU8L3RleHQ+PHRleHQgeD0iNTY3IiB5PSI0MDAiIGZpbGw9IiM5MmE3OWIiIGZvbnQtc2l6ZT0iMTIiPnRva2Vucy9ob3VyIMK3IFsyNGhdIDdkIDMwZCDCtyBpbnB1dC9vdXRwdXQvY2FjaGU8L3RleHQ+CjxwYXRoIGQ9Ik01MCA0MzYgSDEwMjgiIHN0cm9rZT0iIzM1NGIzZSIvPjx0ZXh0IHg9IjY4IiB5PSI0NjMiIGZpbGw9IiM3ZGRlOGEiPjo6IFNFU1NJT05TIC8gc2FtcGxlLXByb2plY3Q8L3RleHQ+PHRleHQgeD0iNzYxIiB5PSI0NjMiIGZpbGw9IiM5MmE3OWIiPjMgbWFpbiDCtyAyIGNoaWxkcmVuPC90ZXh0Pgo8dGV4dCB4PSI4MiIgeT0iNDkwIj52IENsYXVkZSDCtyBJbXBsZW1lbnQgZ3JhcGggYnVja2V0czwvdGV4dD48dGV4dCB4PSI3MzQiIHk9IjQ5MCIgZmlsbD0iIzdkZGU4YSI+UlVOTklORyAgIDMvNjwvdGV4dD4KPHRleHQgeD0iMTEwIiB5PSI1MTQiIGZpbGw9IiM5MmE3OWIiPuKUnCBjaGlsZCDCtyBDaGVjayB0aW1lIGJvdW5kYXJpZXM8L3RleHQ+PHRleHQgeD0iNzM0IiB5PSI1MTQiIGZpbGw9IiM3ZGRlOGEiPlJVTk5JTkc8L3RleHQ+Cjx0ZXh0IHg9IjExMCIgeT0iNTM4IiBmaWxsPSIjOTJhNzliIj7ilJQgY2hpbGQgwrcgUmV2aWV3IGZpeHR1cmVzPC90ZXh0Pjx0ZXh0IHg9IjczNCIgeT0iNTM4IiBmaWxsPSIjOTJhNzliIj5DT01QTEVURUQ8L3RleHQ+Cjx0ZXh0IHg9IjgyIiB5PSI1NjIiPiZndDsgQ29kZXggwrcgVmVyaWZ5IGhpc3RvcnkgaW1wb3J0PC90ZXh0Pjx0ZXh0IHg9IjczNCIgeT0iNTYyIiBmaWxsPSIjZTZjNTc1Ij5XQUlUSU5HIEZPUiBJTlBVVDwvdGV4dD4KPHBhdGggZD0iTTUwIDU4MCBIMTAyOCIgc3Ryb2tlPSIjMzU0YjNlIi8+PHRleHQgeD0iNjgiIHk9IjYwNiIgZmlsbD0iIzdkZGU4YSI+OjogUkVDRU5UIEFDVElWSVRZPC90ZXh0Pjx0ZXh0IHg9IjY4IiB5PSI2MzAiPnNhbXBsZS1wcm9qZWN0IMK3IGNvbW1pdCDCtyBDb3JyZWN0IGJ1Y2tldCBib3VuZGFyaWVzPC90ZXh0Pjx0ZXh0IHg9Ijk0MCIgeT0iNjMwIiBmaWxsPSIjOTJhNzliIj42bTwvdGV4dD4KPHRleHQgeD0iNjgiIHk9IjY1NiIgZmlsbD0iIzdkZGU4YSI+OjogV09SS0ZMT1cgTUVNT1JZPC90ZXh0Pjx0ZXh0IHg9IjY4IiB5PSI2ODAiPiZndDsgRGVjaXNpb24gwrcgS2VlcCBzb3VyY2UgdGltZXN0YW1wcyB2aXNpYmxlPC90ZXh0Pjx0ZXh0IHg9Ijk0MCIgeT0iNjgwIiBmaWxsPSIjOTJhNzliIj45bTwvdGV4dD4KPHBhdGggZD0iTTMyIDcwNyBIMTA0OCIgc3Ryb2tlPSIjNDk2MjUzIi8+PHRleHQgeD0iNTIiIHk9IjczMyIgZmlsbD0iIzkyYTc5YiI+S0RFIC8gV2F5bGFuZCDCtyBuYXZpZ2F0aW9uIG9uIMK3IHNvdXJjZXMgNS81IGZyZXNoIMK3IHVwZGF0ZWQgMTQ6MzI8L3RleHQ+CjxyZWN0IHg9IjMyIiB5PSI3ODAiIHdpZHRoPSIxMDE2IiBoZWlnaHQ9IjMzNSIgcng9IjgiIGZpbGw9IiMxMTE4MTYiIHN0cm9rZT0iIzQ5NjI1MyIvPgo8dGV4dCB4PSI1MiIgeT0iODEzIiBmaWxsPSIjN2RkZThhIiBmb250LXNpemU9IjE4Ij5DVVNUT01JWkUgLyBsaXZlIHByZXZpZXcgYmVmb3JlIHNhdmluZzwvdGV4dD4KPHRleHQgeD0iNTIiIHk9Ijg1MCI+U3R5bGUgIFtUZXJtaW5hbCB2XTwvdGV4dD48dGV4dCB4PSI1NTAiIHk9Ijg1MCI+TW9kZSAgW0Rhcmsgdl08L3RleHQ+Cjx0ZXh0IHg9IjUyIiB5PSI4ODQiPkFjY2VudCBbIzdEREU4QV08L3RleHQ+PHJlY3QgeD0iMjIzIiB5PSI4NjYiIHdpZHRoPSIyOCIgaGVpZ2h0PSIyMiIgZmlsbD0iIzdkZGU4YSIvPgo8dGV4dCB4PSI1NTAiIHk9Ijg4NCI+VGV4dCBzaXplICBbMTQgcHhdPC90ZXh0Pgo8dGV4dCB4PSI1MiIgeT0iOTE4Ij5CYWNrZ3JvdW5kIG9wYWNpdHk8L3RleHQ+PHBhdGggZD0iTTI1NSA5MTMgSDQ3MiIgc3Ryb2tlPSIjNDk2MjUzIiBzdHJva2Utd2lkdGg9IjQiLz48Y2lyY2xlIGN4PSI0NDAiIGN5PSI5MTMiIHI9IjciIGZpbGw9IiM3ZGRlOGEiLz48dGV4dCB4PSI0ODciIHk9IjkxOCI+ODUlPC90ZXh0Pgo8dGV4dCB4PSI1NTAiIHk9IjkxOCI+TGF5ZXIgW0JlaGluZCB3aW5kb3dzIHZdPC90ZXh0Pgo8dGV4dCB4PSI1MiIgeT0iOTUyIj5beF0gTmF2aWdhdGlvbiAgIFt4XSBTdGFydCBhdCBsb2dpbjwvdGV4dD48dGV4dCB4PSI1NTAiIHk9Ijk1MiI+QXBwbHkgdG8gW0FsbCB3aWRnZXRzIHZdPC90ZXh0Pgo8dGV4dCB4PSI1MiIgeT0iOTg2IiBmaWxsPSIjOTJhNzliIj5bRWRpdCBhcnJhbmdlbWVudF0gW1ByZXNldHNdIFtJbXBvcnRdIFtFeHBvcnRdPC90ZXh0Pgo8cGF0aCBkPSJNNTIgMTAwNSBIMTAyOCIgc3Ryb2tlPSIjMzU0YjNlIi8+PHRleHQgeD0iNTIiIHk9IjEwMzMiIGZpbGw9IiM5MmE3OWIiPlBlci13aWRnZXQgY29sb3JzIMK3IGZvbnQgc2l6ZXMgwrcgY29tcGFjdCBtb2RlIMK3IHNhdmVkIGxheW91dHM8L3RleHQ+Cjx0ZXh0IHg9IjUyIiB5PSIxMDgwIj5bUmVzdG9yZSBkZWZhdWx0c108L3RleHQ+PHRleHQgeD0iNzYwIiB5PSIxMDgwIj5bQ2FuY2VsXTwvdGV4dD48cmVjdCB4PSI5MDAiIHk9IjEwNTciIHdpZHRoPSIxMTUiIGhlaWdodD0iMzUiIHJ4PSIzIiBmaWxsPSIjMjYzZDJlIi8+PHRleHQgeD0iOTI5IiB5PSIxMDgwIiBmaWxsPSIjN2RkZThhIj5TYXZlPC90ZXh0Pgo8dGV4dCB4PSI0MCIgeT0iMTE0NCIgZmlsbD0iIzkyYTc5YiIgZm9udC1zaXplPSIxMiI+U3RhdGljIG1vY2t1cCBvbmx5LiBHcmFwaHMgYW5kIGV2ZW50cyBhcmUgc2FtcGxlIGRhdGE7IGNvbnRyb2xzIGFyZSBpbGx1c3RyYXRpdmUuPC90ZXh0Pgo8L2c+PC9zdmc+Cg==)
