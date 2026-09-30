---
name: productivity-metrics
description: Use when the user wants delivery measured from the repo's real git/GitHub history — full reports or one casual question — "how productive is our team", PR cycle time, review wait, how often we release, "feels slower lately", DORA metrics, whether the codalio-blueprint skills changed delivery, or a breakdown of my own work. Writes one report across team, blueprint-impact and individual lenses. Not for OKRs without data, product analytics, single-PR review, line counts, or architecture reviews.
---

# Productivity Metrics

## Overview

Measure how a team actually delivers, whether the codalio-blueprint skills
changed that, and what one developer's own work looks like — from the
repository's real history, not from recollection or a survey. Three lenses run
over the same collected data, then get synthesized into one report.

The hard part is not computing numbers. It is keeping them honest: small
samples, bot activity, and metrics that reward the wrong behavior make a
confident-looking report wrong. Every number in the report must trace back to
the collected data, state its sample size, and state its time window.

**Announce at start:** "I'm using the productivity-metrics skill to measure delivery from your repository's history."

## Process Flow

1. **Scope.** Confirm the repository (the current one unless the user names
   another), the time window (default: last 90 days), and which lenses the
   user cares most about. Run all three regardless — a single lens without
   the others' context misleads — but weight the report toward what was asked.
2. **Collect.** Run the bundled collector from the repository root:

   ```bash
   python3 <this-skill-dir>/scripts/collect.py --since YYYY-MM-DD [--until YYYY-MM-DD] [--author LOGIN]
   ```

   It prints JSON: merged PRs (cycle time, time to first review, size, files,
   reviews, conventional-commit type, bot flag, in-window flag), releases,
   reverts, skill artifacts, the invoking user, and a precomputed `summary`.
   It uses the GitHub CLI when authenticated and falls back to git history
   otherwise — check `source` in the output, because the git-only fallback
   has no PR open time, so cycle time and review latency are unavailable
   there. Say so in the report instead of estimating them.
   Use the `summary` numbers as the source of truth for headline figures;
   compute anything extra from the `prs` array with the same rules
   (in-window, bots excluded).

   The collector merges accounts that look like one person — logins or
   emails whose commits share a git author name or email, after `.mailmap`
   — and lists each merge in `identity_groups` with the evidence
   (`linked_by`). Every PR and review carries a `person` field; group by
   `person`, not `author`. A merge linked only by a short or common name is
   a guess: state it in the report, show the figures it changes, and quote
   the group's `suggested_mailmap` lines verbatim so the user can confirm it. Rerun with `--no-merge-identities` if the
   user says the merge is wrong.
3. **Run the three lenses** (see below).
4. **Synthesize.** Merge the lens outputs into the report template in
   `references/lenses.md`. Cross-reference where lenses touch: the impact
   lens's before/after comparison must use the team lens's metric
   definitions; the individual lens is read against the team baseline, not
   in isolation. Don't concatenate raw lens output.
5. **Write the report** to
   `docs/productivity/YYYY-MM-DD-<repo-slug>-productivity-report.md` in the
   user's project (create the folder if missing).
6. **Self-review.** Check every figure against the collector JSON. Check
   every metric names its window and sample size. Remove any sentence that
   ranks people or presents commit or line counts as productivity.
7. **User review gate.** Point the user to the file and ask them to review
   before treating it as final. Wait for their response.

## Running the Three Lenses

Each lens is independent — all three read the same collector JSON. Check once,
silently, before starting:

**Do you have a tool that dispatches an isolated agent/sub-task — with its own
context window, that you hand a prompt to and that returns a result — whatever
it is called in your environment?**

- **Yes → dispatch the three lenses as separate calls, issued together so
  they run concurrently.** Give each the collector JSON (or its file path),
  the user's question, and that lens's prompt from `references/lenses.md`,
  with an instruction to return only that lens's findings.
- **No → run all three yourself, one after another, in this conversation.**
  Finish one lens before starting the next. Don't skip a lens.
- **Either path produces the same three write-ups** before synthesis.

## Guardrails

- **No leaderboards.** The individual lens covers the invoking user by
  default. Cover someone else only when the user explicitly asks, and never
  rank or compare named people against each other — that turns a reflection
  tool into surveillance and makes the numbers get gamed. This covers
  reviewers too: describe review wait as a property of the process ("reviewed
  PRs waited 5.8 days for a first review"), not as a named person being the
  bottleneck.
- **Stay inside the repository's history.** Don't read local agent session
  history, editor data, or other private files to infer skill use — only
  committed evidence counts.
- **Activity is not productivity.** Commits, lines changed, and PR counts are
  context, never a verdict. Pair any volume figure with a flow or quality
  figure (cycle time, review latency, change-failure proxy).
- **Correlation is not causation.** The impact lens compares periods; it
  cannot prove a skill caused a change. Say so, and say how small the sample is.
- **Exclude bots and release automation** from delivery figures (the
  collector flags them). Mention how many were excluded.
- **"Not enough data" is a valid finding.** Under ~10 PRs in a window, report
  the raw values and skip percentiles and trend claims.

## Lenses and Report Template

See `references/lenses.md`: Team Delivery, Blueprint Impact, Individual
Developer, and the final report template.
