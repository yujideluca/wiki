# Maintenance and evolution

The method: maintenance types of **ISO/IEC/IEEE 14764** (corrective, adaptive, perfective, preventive), **Lehman's
laws** (software in use must keep changing, and its complexity grows unless work is spent to reduce it),
**evolutionary architecture** (architecture rules as automatic checks, "fitness functions") and the **DORA**
delivery metrics (how often and how fast changes reach users, how often they need repair).

## 1. Technical debt

**Debt** = anything that works today but makes the next change slower or riskier: a missing test, a known
limitation, a file doing too many jobs, a manual step that should be a script.

- Each item is a GitHub Issue labelled `debt` with one priority: `P1` (risk of data loss or wrong results),
  `P2` (slows every change or misleads the user), `P3` (nice to have). New features use the label `idea`.
- **Fixed share:** about one work session in five (≈ 20 %) goes to debt or prevention, highest priority first.
- A limitation found while working becomes an issue in the same session.

## 2. Monthly architecture review (all projects)

One session a month; it is an open item in workflow-memory, so every chat shows it until done. For each active
project in `~/dev`:

1. The gate passes locally and the latest CI runs on GitHub are green.
2. Metrics (where the project has `tools/metrics.py`): deployment frequency, lead time, rework rate (share of
   Corrective changes), preventive share (target ≈ 20 %).
3. Fitness functions: what is closest to its limit? Act before it crosses.
4. `DESIGN.md` diagrams and the ADRs still match the code; every structural change since the last review has an ADR.
5. Adaptive maintenance: toolchain, SDK and dependency updates due? Upgrade on a branch, run the gate.
6. Debt list: still true, right priority; a `P1` older than a month is scheduled now.
7. Across projects: the same problem solved twice in different ways? Move the better solution into this template.
8. Memory: are workflow-memory entries still true (`mem search <project>`)? Outdated → `mem feedback REF stale`.

Record the outcome as a decision-log row of Type *Preventive* in each project reviewed, then close the open item
with `mem use REF --note "..."` (it stays open as the monthly reminder).
