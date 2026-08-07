# codalio-blueprint — contributor guide

This repo ships a set of planning skills, flagship being **prd-builder**, as a
plugin for IDE coding agents (Claude Code, Cursor, Codex, Antigravity,
Gemini). Full details in [CONTRIBUTING.md](CONTRIBUTING.md); rules below
apply to any edit made here.

## Rules

- **Keep lens/skill content generic and original.** Don't lift field names,
  terminology, or prompt text from any proprietary product — write it
  yourself, from first principles. Applies to every contributor, not just
  Codalio staff.
- **One skill per PR.** Don't bundle unrelated skill changes together.
- **Design-discuss before adding a lens or a new skill.** Open an issue first
  — see the Roadmap section in [README.md](README.md).
- **Re-read the whole flow before editing part of it.** Before changing any
  part of a skill's `SKILL.md` or its `references/` files, read all of them
  end to end.
- **Run `bash scripts/validate-manifests.sh`** before opening a PR.
- **Use conventional-commit PR titles** (`feat: ...`, `fix: ...`, `docs: ...`)
  — this repo uses [release-please](https://github.com/googleapis/release-please)
  to cut releases from commit history.
