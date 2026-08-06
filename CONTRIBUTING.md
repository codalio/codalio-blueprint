# Contributing

Thanks for considering a contribution to codalio-blueprint.

## Ground rules

- **Keep lens content generic.** No field names, terminology, or prompt text lifted from any proprietary product — this repo only reuses the general "multiple lenses → synthesis" idea, nothing specific to how Codalio's own tools work internally.
- **One skill per PR.** Don't bundle unrelated skill changes together.
- **Design-discuss before adding a lens or a new skill.** Open an issue describing the proposed lens/skill and why it earns a place here before writing the PR — see the Roadmap section in [README.md](README.md) for skills already agreed as future work.
- **Re-read the whole flow before editing part of it.** Before changing any part of `skills/prd-builder/SKILL.md` or its `references/lens-prompts.md`, read both files end to end — a change to one lens or process step can quietly break an assumption made elsewhere in the flow.

## Making a change

1. Fork or branch, make your change.
2. Run `bash scripts/validate-manifests.sh` locally — it checks every plugin manifest and `SKILL.md` frontmatter.
3. Open a PR with a conventional-commit-style title (`feat: ...`, `fix: ...`, `docs: ...`) — this repo uses [release-please](https://github.com/googleapis/release-please) to cut releases from commit history.

## Reporting issues

Open a GitHub issue with what you expected vs. what happened. For skill-behavior issues, include which host (Claude Code, Cursor, Codex, Antigravity, Gemini) you ran it in.
