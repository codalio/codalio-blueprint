# codalio-blueprint

Turn a rough product idea into a written PRD, right inside your IDE coding agent.

- **Idea in, PRD out.** Describe what you're building; get a structured PRD file written to your project.
- **Multi-lens, not single-shot.** Product & Scope, Architecture & Data (lite), and GTM (lite) each run as a distinct pass, then get synthesized into one document — not three documents stapled together.
- **Works across hosts.** One skill, ships for Claude Code, Cursor, Codex, Antigravity, and Gemini.

## Before / after

**Before:** "I want to build an app for neighbors to lend and borrow tools instead of everyone buying their own."

**After:** a full PRD — summary, target user, user stories, MVP scope (Now/Next/Later), a lite architecture overview, a lite GTM plan, and open questions — written to `docs/prd/`. See a complete sample run: [`examples/2026-08-06-toolshare-prd.md`](examples/2026-08-06-toolshare-prd.md).

## Quickstart

**Claude Code:**

```
/plugin marketplace add codalio/codalio-blueprint
/plugin install prd-builder@codalio-blueprint
```

**Cursor, Codex, Antigravity, Gemini:** each vendor's local-plugin/extension mechanism changes over time — see that vendor's current docs for installing a local/extension skill, then point it at this repo.

## How it works

The **prd-builder** skill gathers your idea, asks a few clarifying questions, then runs three lenses over the idea — Product & Scope, Architecture & Data (lite), GTM (lite). If your environment can dispatch isolated sub-tasks, the three lenses run concurrently; otherwise the agent runs them one after another in the same conversation. Either way, the three write-ups get synthesized into a single, consistent PRD — see [`skills/prd-builder/SKILL.md`](skills/prd-builder/SKILL.md) for the full process.

## Roadmap

Not built yet — future skills in this same repo:

- **mvp-checklist** — standalone, deeper MVP scoping than the lite version bundled here
- **gtm-plan** — full go-to-market plan (channels, pricing, launch sequence)
- **arch-evaluation** — evaluate an existing codebase's architecture/tech debt against stated requirements
- **doc-generation** — turn an approved PRD into supporting docs (backlog, API contract sketch, onboarding doc)
- **code-to-prd** — reverse direction: reconstruct a PRD-style doc from an existing codebase

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
