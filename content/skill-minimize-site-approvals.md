---
id: skill-minimize-site-approvals
title: Skill: minimize-site-approvals
aliases: [minimize-site-approvals]
kind: skill
project: skills
status: active
location: home:.claude/skills/minimize-site-approvals
fed_by: []
feeds: []
sources: [home:.claude/skills/minimize-site-approvals/SKILL.md]
reviewed: 2026-10-22T16:33Z
---

## What it is
The skill "minimize-site-approvals" is a planning step before browsing, so that Giovanni has to click "approve" as few times as possible. Its description says: use it before any browsing task to cut down site-approval clicks: plan the domains up front, request site-wide access once, and prefer tools that need no approval. The Claude Code version is edited only there; the Claude app keeps its own version ([[claude-ai-skills]]).

## What it does
It plans the domains up front, asks for site-wide access once, and prefers tools that need no approval. It never bypasses, disables or works around approvals or the site safety check; it only reduces how many prompts are triggered. It runs together with [[skill-browser-automacao-segura]] and [[skill-click-protocol]].

## How it does it
A `SKILL.md` in `~/.claude/skills/minimize-site-approvals`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Before and during any browser automation.

## Who receives its output
The browser session and Giovanni (fewer prompts).

## Steps
Before touching a browser:
1. **Prefer the cheapest path.** For public pages, web search and page fetch tools avoid the browser, but in Claude Code they can still trigger a permission prompt, so they are not approval-free. Open Chrome only when the task needs a signed-in session, interaction, forms, or a page those tools cannot read.
2. **List every domain** the task will likely need (main site, login host, any subdomain the user mentioned), once, up front.
3. **Tell the user the full list in one line**, so the approvals come in one go instead of one by one.

Approvals in Claude Code:
4. There is no "request access" tool. Site access comes from the prompt of the Claude in Chrome extension: ask the user to choose "Always allow actions on this site" for trusted sites; approved sites can be reviewed and revoked on the extension's Permissions page.
5. Tool prompts (shell commands, page fetching, connector tools) come from Claude Code's permission system. For repeated safe calls, offer to add an allow rule in the settings (the update-config skill, or the `/permissions` command); never add one without the user's yes.
6. If an approval is declined or pending, wait. Do not retry in a loop and do not try another route to the same content. The shell can run curl, Python, wget or git here, so this matters: never use them to reach a page that an approval prompt, the extension or a fetch tool refused.

While working:
7. Prefer page-text and read tools over screenshots and repeated navigation; every extra site hop can trigger a new prompt.
8. Stay on the approved domains. If the task needs a new domain, batch the new requests together and ask once.
9. Act sequentially, one action at a time, and neutralise or handle page alert and confirm dialogs before batch actions ([[skill-browser-automacao-segura]]).
10. Do not reuse tab ids from earlier sessions; read the current tab context first.

Things to say honestly:
11. Some approvals cannot be removed: sites blocked or flagged by the extension's safety check, downloads, entering sensitive information, granting authorisations. Purchases, account creation and permanent deletions stay with the user.
12. Claude Code permission modes (for example auto mode or broad allow rules) reduce prompts but also reduce review. Only the user changes them; mention the trade-off once if asked, and never push for it to save clicks on untrusted sites.

Closing the task:
13. Say which sites and tools were approved and how (once, always, or a settings rule), so the user knows what is now saved and can revoke it.
