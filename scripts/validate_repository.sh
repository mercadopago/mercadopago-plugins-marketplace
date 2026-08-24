#!/usr/bin/env sh
# Single deterministic quality gate for this public Codex plugin.

set -eu

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

python3 -m json.tool .agents/plugins/marketplace.json >/dev/null
python3 -m json.tool plugins/mercadopago/.codex-plugin/plugin.json >/dev/null
python3 -m json.tool plugins/mercadopago/.mcp.json >/dev/null
python3 -m json.tool plugins/mercadopago/hooks/hooks.json >/dev/null
python3 -m py_compile plugins/mercadopago/hooks/validate_mp_credentials.py
python3 -m unittest plugins/mercadopago/hooks/test_validate_mp_credentials.py

for script in plugins/mercadopago/scripts/*.mjs; do
  [ -f "$script" ] || continue
  node --check "$script"
done

for test in plugins/mercadopago/scripts/test-*.mjs; do
  [ -f "$test" ] || continue
  node "$test"
done

skill_count="$(find plugins/mercadopago/skills -name SKILL.md -type f | wc -l | tr -d ' ')"
[ "$skill_count" = "4" ] || {
  echo "ERROR: expected exactly 4 skills, found $skill_count" >&2
  exit 1
}

if grep -rl '^tools:' plugins/mercadopago/skills/*/SKILL.md >/dev/null 2>&1; then
  echo "ERROR: Codex skills must not declare top-level tools" >&2
  exit 1
fi

unexpected_references="$(find plugins/mercadopago/skills -name references -type d 2>/dev/null | grep -v '/mp-integrate/references$' || true)"
[ -z "$unexpected_references" ] || {
  echo "ERROR: unexpected references directories:" >&2
  echo "$unexpected_references" >&2
  exit 1
}

if git grep -nE 'npm\.artifacts\.furycloud\.io|/Users/|\\Users\\|\.claude-plugin|CLAUDE_PLUGIN_ROOT|CLAUDE_PROJECT_DIR' -- . ':!CHANGELOG.md' ':!scripts/validate_repository.sh' >/dev/null 2>&1; then
  echo "ERROR: tracked files contain a private path, internal registry, or Claude-only construct" >&2
  git grep -nE 'npm\.artifacts\.furycloud\.io|/Users/|\\Users\\|\.claude-plugin|CLAUDE_PLUGIN_ROOT|CLAUDE_PROJECT_DIR' -- . ':!CHANGELOG.md' ':!scripts/validate_repository.sh' >&2
  exit 1
fi

if find . -path '*/tests/smoke' -type d -print -quit | grep -q .; then
  echo "ERROR: external tests/smoke must not be part of this repository" >&2
  exit 1
fi

python3 scripts/generate_catalog.py --check

echo "Repository validation passed."
