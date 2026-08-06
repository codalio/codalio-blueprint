#!/usr/bin/env bash
set -euo pipefail

MANIFESTS=(
  ".claude-plugin/plugin.json"
  ".claude-plugin/marketplace.json"
  ".codex-plugin/plugin.json"
  ".cursor-plugin/plugin.json"
  ".antigravity-plugin/plugin.json"
  "gemini-extension.json"
)

fail=0

for f in "${MANIFESTS[@]}"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f"
    fail=1
    continue
  fi
  if node -e "
    const m = JSON.parse(require('fs').readFileSync('$f', 'utf8'));
    const required = ['name', 'version', 'description'];
    const target = Array.isArray(m.plugins) ? m.plugins[0] : m;
    for (const key of required) {
      if (!target[key]) { console.error('$f missing required field: ' + key); process.exit(1); }
    }
  "; then
    echo "OK: $f"
  else
    fail=1
  fi
done

for skill in skills/*/SKILL.md; do
  [ -f "$skill" ] || continue
  if node -e "
    const fs = require('fs');
    const content = fs.readFileSync('$skill', 'utf8');
    const match = content.match(/^---\n([\s\S]*?)\n---/);
    if (!match) { console.error('$skill: no frontmatter found'); process.exit(1); }
    const fm = match[1];
    const nameMatch = fm.match(/^name:\s*(.+)$/m);
    const descMatch = fm.match(/^description:\s*(.+)$/m);
    if (!nameMatch || !nameMatch[1].trim()) { console.error('$skill: empty or missing name'); process.exit(1); }
    if (!descMatch || !descMatch[1].trim()) { console.error('$skill: empty or missing description'); process.exit(1); }
  "; then
    echo "OK: $skill"
  else
    fail=1
  fi
done

exit $fail
