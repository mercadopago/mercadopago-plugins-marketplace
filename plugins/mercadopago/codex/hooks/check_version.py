#!/usr/bin/env python3
"""
SPDX-FileCopyrightText: (c) 2026 Mercado Pago (MercadoLibre S.R.L.)
SPDX-License-Identifier: Apache-2.0

Mercado Pago Codex Plugin - Version Change Notice Hook (UserPromptSubmit)

Ported from the Claude Code plugin (mercadopago-claude-marketplace) and adapted
to the Codex hooks runtime.

Behavior:
  Runs on every UserPromptSubmit. Silent unless the installed plugin version
  changed since the last time it ran. When it changes, it prints a one-line
  notice, which Codex adds to the conversation as extra developer context.

  On a brand-new install (no previously seen version) it stays silent: it just
  records the current version, so the user is not nagged on first use.

Codex I/O contract (UserPromptSubmit):
  - Input: one JSON object on stdin (session_id, cwd, prompt, ...). Not needed
    here, but read and ignored so the pipe drains cleanly.
  - Output: plain text on stdout is added as extra developer context. Exit 0
    with no output means "nothing to say".

Notes:
  - No value on v1.0.0 (the baseline version — there is no older version to
    compare against yet). This hook is included so the plugin is ready for later
    versions without further work.
  - Hooks are disabled on Windows by Codex; this is a no-op there.
"""

import json
import os
import sys


def plugin_root() -> str:
    """Resolve the plugin root from this file's location.

    This script lives at <plugin_root>/hooks/check_version.py, so the plugin
    root is two levels up. Falls back to the PLUGIN_ROOT / CODEX_PLUGIN_ROOT
    environment variables if, for any reason, __file__ is unavailable.
    """
    env = os.environ.get("PLUGIN_ROOT") or os.environ.get("CODEX_PLUGIN_ROOT")
    if env:
        return env
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def read_version(root: str):
    version_file = os.path.join(root, ".codex-plugin", "plugin.json")
    try:
        with open(version_file, "r") as f:
            data = json.load(f)
    except (OSError, json.JSONDecodeError):
        return None
    version = data.get("version")
    return version if version else None


def main():
    # Drain stdin so the pipe closes cleanly; contents are not needed here.
    try:
        sys.stdin.read()
    except Exception:
        pass

    current = read_version(plugin_root())
    if not current:
        sys.exit(0)  # can't read version -> stay silent

    seen_dir = os.path.expanduser("~/.codex")
    seen_file = os.path.join(seen_dir, "mp-plugin-seen-version")

    try:
        os.makedirs(seen_dir, exist_ok=True)
    except OSError:
        sys.exit(0)

    try:
        with open(seen_file, "r") as f:
            seen = f.read().strip()
    except OSError:
        seen = ""

    if current != seen:
        try:
            with open(seen_file, "w") as f:
                f.write(current)
        except OSError:
            sys.exit(0)
        # Only notify on a real change, not on the first install.
        if seen:
            print(
                f"[Mercado Pago plugin updated: v{seen} -> v{current}. "
                "Reconnect the MCP if needed: codex mcp login mercadopago.]"
            )

    sys.exit(0)


if __name__ == "__main__":
    main()
