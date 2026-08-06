# codalio-blueprint — contributor guide

This repo ships one skill, **prd-builder**, as a plugin for IDE coding agents
(Claude Code, Cursor, Codex, Antigravity, Gemini). Full details in
[CONTRIBUTING.md](CONTRIBUTING.md); rules below apply to any edit made here.

## Rules

- **Keep lens content generic.** No field names, terminology, or prompt text
  lifted from any proprietary product — only the general "multiple lenses →
  synthesis" idea is reused here.
- **One skill per PR.** Don't bundle unrelated skill changes together.
- **Design-discuss before adding a lens or a new skill.** Open an issue first
  — see the Roadmap section in [README.md](README.md).
- **Re-read the whole flow before editing part of it.** Before changing any
  part of `skills/prd-builder/SKILL.md` or its `references/lens-prompts.md`,
  read both files end to end.
- **Run `bash scripts/validate-manifests.sh`** before opening a PR.
- **Use conventional-commit PR titles** (`feat: ...`, `fix: ...`, `docs: ...`)
  — this repo uses [release-please](https://github.com/googleapis/release-please)
  to cut releases from commit history.
