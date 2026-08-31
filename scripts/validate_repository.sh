#!/usr/bin/env sh
# Single deterministic quality gate for the Mercado Pago Codex plugin.

set -eu

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

python3 -m json.tool .agents/plugins/marketplace.json >/dev/null
plugin_dir="plugins/mercadopago/codex"

python3 -m json.tool "$plugin_dir/.codex-plugin/plugin.json" >/dev/null
python3 -m json.tool "$plugin_dir/.mcp.json" >/dev/null
python3 -m json.tool "$plugin_dir/hooks/hooks.json" >/dev/null
python3 -m py_compile "$plugin_dir/hooks/validate_mp_credentials.py"
python3 -m unittest "$plugin_dir/hooks/test_validate_mp_credentials.py"

for script in "$plugin_dir"/scripts/*.mjs; do
  [ -f "$script" ] || continue
  node --check "$script"
done

for test in "$plugin_dir"/scripts/test-*.mjs; do
  [ -f "$test" ] || continue
  node "$test"
done

expected_skills='mp-connect
mp-integrate
mp-review
mp-test-setup
mp-webhooks'
actual_skills="$(find "$plugin_dir/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -type f -exec dirname {} \; | sed 's#.*/##' | sort)"
[ "$actual_skills" = "$expected_skills" ] || {
  echo "ERROR: expected Codex skills:" >&2
  printf '%s\n' "$expected_skills" >&2
  echo "Found:" >&2
  printf '%s\n' "$actual_skills" >&2
  exit 1
}

if grep -rl '^tools:' "$plugin_dir"/skills/*/SKILL.md >/dev/null 2>&1; then
  echo "ERROR: Codex skills must not declare top-level tools" >&2
  exit 1
fi

unexpected_references="$(find "$plugin_dir/skills" -name references -type d 2>/dev/null | grep -v '/mp-integrate/references$' || true)"
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
