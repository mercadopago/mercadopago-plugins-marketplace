# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Codex parity entry flows for the Mercado Pago application, credential choice,
  complete seven-step integration journey, MCP OAuth connection, and standalone
  test-card lookup.
- Generic Checkout Pro and Checkout API CTA detection, resolution, and
  acceptance checks.
- Deterministic Checkout API checks for a separate payment screen, associated
  labels, interactive secure fields, and runtime public-key configuration.
- Deterministic integration contracts and regression tests for Bricks, Point,
  QR, Subscriptions, Marketplace, Wallet Connect, Smart Apps, and Payouts.
- Public security and privacy documentation, issue and pull-request templates,
  credential-hook regression tests, and a repository validation gate shared by
  CI and pre-commit.

### Changed

- Checkout API creates a separate payment screen and wires the resolved entry
  CTA to it; Checkout Pro places a visible Mercado Pago button at the resolved
  CTA location.
- SDK installation and updates require authorization and use the official
  current stable release.
- Bundled files are resolved through `${PLUGIN_ROOT}` without scanning
  installation caches.
- Checkout Pro preference creation uses `/checkout/preferences`, without a
  `/v1` prefix.
- CI validates Node, Python, plugin scripts, the deterministic product suites,
  the generated catalog, and public-repository safety rules.

### Fixed

- Public-key loading no longer relies on cache-prone HTML placeholder
  substitution.
- CardForm lifecycle controls remain present and enabled so secure fields stay
  responsive.
- CTA and label validators reject unrelated destinations and unresolved labels.
- Public documentation and repository validation reject maintainer-specific
  paths, internal registry URLs, private smoke artifacts, and credentials.

## [1.0.0] - 2026-07-02

### Added
- Initial Codex (OpenAI) plugin for Mercado Pago payment integrations — the Codex
  equivalent of `mercadopago/mercadopago-claude-marketplace`.
- Plugin manifest at `.codex-plugin/plugin.json`.
- Marketplace entry at `.agents/plugins/marketplace.json`.
- Global routing in `AGENTS.md` (replaces the Claude router agent).
- MCP server configuration (`.mcp.json`) for `mcp.mercadopago.com/mcp` via streamable HTTP.
- Four initial orchestration skills, each with `SKILL.md` and `agents/openai.yaml`:
  - `mp-integrate` — integration scaffolding wizard.
  - `mp-webhooks` — HMAC-SHA256 webhook validation, configure/simulate/diagnose.
  - `mp-test-setup` — create test users and load funds.
  - `mp-review` — official quality checklist + cross-cutting security checklist.
- Credential-leak prevention hook (`hooks/validate_mp_credentials.py`) on the
  `PreToolUse` event (scans Bash commands).

[Unreleased]: https://github.com/mercadopago/mercadopago-plugins-marketplace/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/mercadopago/mercadopago-plugins-marketplace/releases/tag/v1.0.0
