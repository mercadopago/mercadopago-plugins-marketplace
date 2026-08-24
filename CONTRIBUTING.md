# Contributing

Thanks for your interest in improving the Mercado Pago Codex plugin.

## How to contribute

The best way to contribute is to **open an issue** — a bug report, a feature
request, or a question. See the issue as the entry point for any change.

## Development notes

- This plugin targets the [OpenAI Codex CLI](https://developers.openai.com/codex).
- Use the source order documented in `AGENTS.md`: official country `llms.txt`,
  bundled references, then MCP documentation only for a gap. Keep scaffolding
  and deterministic validators usable offline.
- Skill format follows the [Agent Skills standard](https://agentskills.io):
  each skill is a folder with a `SKILL.md` (frontmatter `name` + `description`,
  no `model` field) and an optional `agents/openai.yaml` declaring UI metadata
  and MCP tool dependencies.
- The credential hook runs on `PreToolUse` and only intercepts `Bash` commands
  in Codex today — keep that scope in mind.

## Before opening a pull request

Run the same public gate used by CI and the local pre-commit hook:

```sh
sh scripts/validate_repository.sh
```

Do not add credentials, local `.env` files, user profiles, smoke-test artifacts,
absolute personal paths, private registry URLs, or cached plugin copies. Do not
install or update an SDK in an example without the developer's explicit approval.

## Code of Conduct

By participating, you agree to uphold our [Code of Conduct](./CODE_OF_CONDUCT.md).
