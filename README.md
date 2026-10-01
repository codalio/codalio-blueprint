# codalio-blueprint

A set of planning and review skills for IDE coding agents, starting from a rough product idea and going all the way through launch — flagship skill turns an idea into a written PRD, and later skills review what gets built.

- **Idea in, PRD out.** Describe what you're building; get a structured PRD file written to your project.
- **Multi-lens, not single-shot.** Product & Scope, Architecture & Data (lite), and GTM (lite) each run as a distinct pass, then get synthesized into one document — not three documents stapled together.
- **Works across hosts.** Ships for Claude Code, Cursor, Codex, Antigravity, and Gemini.

## Before / after

**Before:** "I want to build an app for neighbors to lend and borrow tools instead of everyone buying their own."

**After:** a full PRD — summary, target user, user stories, MVP scope (Now/Next/Later), a lite architecture overview, a lite GTM plan, and open questions — written to `docs/prd/`. See a complete sample run: [`examples/2026-08-06-toolshare-prd.md`](examples/2026-08-06-toolshare-prd.md).

## Quickstart

**Claude Code:**

```
/plugin marketplace add codalio/codalio-blueprint
/plugin install codalio-blueprint@codalio-blueprint
```

**Cursor, Codex, Antigravity, Gemini:** each vendor's local-plugin/extension mechanism changes over time — see that vendor's current docs for installing a local/extension skill, then point it at this repo.

## Updating

New skills and skill updates land on `main` via normal PRs — nothing auto-pulls them into an install.

**Claude Code:**

```
/plugin marketplace update codalio-blueprint
```

Then run `/reload-plugins` to load the changes into your current session, or just start a new session — either picks up the latest `main`. Auto-update is off by default for custom marketplaces like this one; toggle it on per-plugin via `/plugin` → Marketplaces → select this marketplace → Enable auto-update, if you'd rather not run the update command yourself.

**Cursor, Codex, Antigravity, Gemini:** these don't yet have one documented update command the way Claude Code does — check that vendor's current local-plugin/extension docs, or remove and re-add the local plugin/extension pointing at this repo to pick up the latest `main`.

## How it works

The **prd-builder** skill gathers your idea, asks a few clarifying questions, then runs three lenses over the idea — Product & Scope, Architecture & Data (lite), GTM (lite). If your environment can dispatch isolated sub-tasks, the three lenses run concurrently; otherwise the agent runs them one after another in the same conversation. Either way, the three write-ups get synthesized into a single, consistent PRD — see [`skills/prd-builder/SKILL.md`](skills/prd-builder/SKILL.md) for the full process.

## Skills

- **[prd-builder](skills/prd-builder/SKILL.md)** — turn a product idea into a written PRD (see above)
- **[mvp-checklist](skills/mvp-checklist/SKILL.md)** — standalone, deeper MVP scoping than the lite version bundled into prd-builder
- **[gtm-plan](skills/gtm-plan/SKILL.md)** — full go-to-market plan (channels, pricing, launch sequence)
- **[arch-evaluation](skills/arch-evaluation/SKILL.md)** — evaluate an existing codebase's architecture/tech debt against stated requirements
- **[doc-generation](skills/doc-generation/SKILL.md)** — turn an approved PRD into supporting docs (backlog, API contract sketch, onboarding doc)
- **[code-to-prd](skills/code-to-prd/SKILL.md)** — reverse direction: reconstruct a PRD-style doc from an existing codebase
- **[secure-coding](skills/secure-coding/SKILL.md)** — review a change or data-access layer for authorization and data-exposure defects before it ships
- **[efficient-coding](skills/efficient-coding/SKILL.md)** — review a change for performance cost, worked in order of impact from data access down to code volume
- **[regression-analysis](skills/regression-analysis/SKILL.md)** — trace what a change could break through its consumers, ranked by how silently each failure would happen
- **[test-planning](skills/test-planning/SKILL.md)** — decide which tests must exist before a change ships, at which tier, and which are not worth writing
- **[productivity-metrics](skills/productivity-metrics/SKILL.md)** — measure delivery from the repo's real git/GitHub history across team, blueprint-impact, and individual lenses

## Measuring delivery with productivity-metrics

The **productivity-metrics** skill answers "how are we actually shipping?" from your repository's real history — merged pull requests, reviews, releases, and reverts — instead of from recollection or a survey. It computes the numbers with a bundled script, reads them through three lenses, and writes one report you can review and share.

### How to use it

Open a coding agent in the repository you want measured and ask in plain language. For example:

- "How productive has our team been on this repo over the last 60 days?"
- "What's our PR cycle time and review turnaround? Are we getting slower?"
- "Give me DORA-style numbers for this repo."
- "Have the codalio-blueprint skills actually made us ship faster?"
- "Break down my own work this quarter: what I shipped and how fast my PRs merged."

The agent confirms the repository and time window (the default is the last 90 days), collects the data, runs the lenses, and writes the report. It then asks you to review the report before you treat it as final.

**Requirements:**
- `git` and Python 3.8+. The collector uses the standard library only.
- The GitHub CLI (`gh`), authenticated, is optional but recommended. Without it, the collector falls back to local git history. PR open times and reviews are not available in that mode, so cycle time and review latency are reported as unavailable rather than estimated.

### What it looks at

A collector script, [`scripts/collect.py`](skills/productivity-metrics/scripts/collect.py), gathers the data as JSON. Every figure in the report traces back to it.

| Lens | What it measures |
|---|---|
| **Team delivery** | Merged PRs per week. Cycle time (PR opened to merged): median, plus p90 when there are enough data points. Time to first review by someone other than the author, and how many PRs got no review. PR size. Release frequency. A change-failure proxy: reverts, and `fix` PRs that touch files a recent `feat` PR changed. Work mix by conventional-commit type. |
| **Blueprint impact** | Which codalio-blueprint skills left committed output in the repo, found through the `Generated by the <skill> skill on <date>` header every skill writes. When each first appeared, before-and-after delivery figures around that date, and which PRs trace back to that output. |
| **Individual** | The person asking, by default: PRs shipped by type, their own cycle time and PR size against the team, other people's PRs they reviewed, PRs merged without a second reviewer, and active days. It covers someone else only on explicit request. |

**Data handling:**
- **Bots and release automation** (for example release-please or Dependabot PRs) are excluded from every figure, and automated reviewers such as Copilot don't count toward review speed. The report says how many were excluded.
- **One person with several accounts.** The collector merges accounts whose commits share a git author name or email, after applying `.mailmap`. The report states every merge and the evidence behind it, shows how the figures change, and prints the exact `.mailmap` lines to confirm the merge. Run the collector with `--no-merge-identities` to turn merging off.
- **Committed evidence only.** The skill reads git and GitHub history. It never reads local agent session history, editor data, or other private files.

To run the collector yourself, run this from the repository root:

```bash
python3 skills/productivity-metrics/scripts/collect.py --since 2026-07-01 [--until YYYY-MM-DD] [--author LOGIN] [--no-gh] [--no-merge-identities]
```

### Guardrails

The hard part of measuring productivity is keeping the numbers honest, so the skill follows these rules:

- **No leaderboards.** It never ranks or compares named people, and it describes a review wait as a property of the process, not as one person being the bottleneck.
- **Activity is not productivity.** PR counts and lines changed always appear next to a flow or quality figure, never as a verdict on their own.
- **Correlation is not causation.** The impact lens compares two periods and says plainly that it cannot prove a skill caused a change.
- **Small samples are called out.** With fewer than about 10 PRs, the report gives raw values and skips percentiles and trend claims. "Not enough data" is a valid finding.

### What the report looks like

The report is written to `docs/productivity/YYYY-MM-DD-<repo>-productivity-report.md` in your project:

```markdown
# <Repo> — Productivity Report

> Generated by the productivity-metrics skill on <date>. Review and edit before treating this as final.

## 1. Scope & Data Window        — repo, window, data source, PRs counted, bots excluded
## 2. Team Delivery              — throughput, cycle time, review latency, size, releases, change-failure proxy, work mix
## 3. Blueprint Impact           — adoption, before/after comparison, traceability, and an honest read
## 4. Individual — <login>       — shipped, flow, collaboration, rhythm, and one suggestion worth acting on
## 5. Caveats & Data Gaps        — every small-sample warning, missing metric, and assumption in one place
## 6. Suggested Next Measurements — what would make the next report more reliable
```

An excerpt from a real run on this repository, from the team delivery section:

> **Cycle time (PR opened → merged).** Median 15.7 h, p90 140.4 h (≈ 5.8 days), n=21. The distribution is three separate groups, not a spread: 9 PRs self-merged within minutes, 7 merged overnight, and 5 waited about 5.8 days for review.
>
> **Biggest constraint:** review. Every PR that merged without review did so within 16 hours, and most within minutes. The only PRs that waited were the ones that went to review.

See [`skills/productivity-metrics/SKILL.md`](skills/productivity-metrics/SKILL.md) for the full process and [`references/lenses.md`](skills/productivity-metrics/references/lenses.md) for the lens definitions.

## Roadmap

Nothing queued right now — see [CONTRIBUTING.md](CONTRIBUTING.md) for how to propose a new skill.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
