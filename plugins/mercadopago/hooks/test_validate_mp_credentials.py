#!/usr/bin/env python3
"""Regression tests for the Codex Bash credential-safety hook."""

import json
import subprocess
import tempfile
import unittest
from pathlib import Path


HOOK = Path(__file__).with_name("validate_mp_credentials.py")

def fake_access_token():
    """Build a pattern-valid synthetic value without storing one in source."""
    return "-".join((
        "APP_USR", "123456789012", "123456",
        "abc1234567890123456789012345678a", "987654321",
    ))


class CredentialHookTests(unittest.TestCase):
    def run_hook(self, command, *, project=True, enabled=True, raw=None):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            if project:
                (root / "package.json").write_text(
                    json.dumps({"dependencies": {"mercadopago": "^2.0.0"}}),
                    encoding="utf-8",
                )
            if not enabled:
                settings = root / ".codex"
                settings.mkdir()
                (settings / "mercadopago.local.md").write_text(
                    "---\nenabled: false\n---\n", encoding="utf-8"
                )
            payload = raw if raw is not None else json.dumps({
                "tool_name": "Bash", "tool_input": {"command": command}
            })
            return subprocess.run(
                ["python3", str(HOOK)], input=payload, text=True, cwd=root,
                capture_output=True, check=False,
            )

    def assert_blocked(self, result):
        self.assertEqual(result.returncode, 2)
        payload = json.loads(result.stdout)
        self.assertEqual(
            payload["hookSpecificOutput"]["permissionDecision"], "deny"
        )

    def test_blocks_hardcoded_access_token(self):
        self.assert_blocked(self.run_hook(f"echo '{fake_access_token()}'"))

    def test_blocks_secret_environment_reads_in_mp_projects(self):
        self.assert_blocked(self.run_hook("cat .env.production"))
        self.assert_blocked(self.run_hook("printenv MP_ACCESS_TOKEN"))

    def test_allows_environment_variable_reference_and_example(self):
        self.assertEqual(self.run_hook("node app.js $MP_ACCESS_TOKEN").returncode, 0)
        self.assertEqual(self.run_hook("cat .env.example").returncode, 0)

    def test_does_not_change_unrelated_projects(self):
        self.assertEqual(self.run_hook("cat .env", project=False).returncode, 0)

    def test_can_be_explicitly_disabled_per_project(self):
        self.assertEqual(
            self.run_hook(f"echo '{fake_access_token()}'", enabled=False).returncode,
            0,
        )

    def test_fails_closed_for_invalid_hook_payload(self):
        self.assert_blocked(self.run_hook("", raw="not-json"))


if __name__ == "__main__":
    unittest.main()
