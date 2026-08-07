# codalio-blueprint

A set of planning skills for IDE coding agents, starting from a rough product idea and going all the way through launch — flagship skill turns an idea into a written PRD.

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
/plugin install prd-builder@codalio-blueprint
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

## Roadmap

Nothing queued right now — see [CONTRIBUTING.md](CONTRIBUTING.md) for how to propose a new skill.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
