# mercadopago-plugins-marketplace

**Codex (OpenAI) plugin marketplace for Mercado Pago payment integrations.**

The Codex equivalent of the official
[`mercadopago-claude-marketplace`](https://github.com/mercadopago/mercadopago-claude-marketplace).
Same product scope, adapted to the Codex plugin format.

## What it is

An AI-powered Mercado Pago integration assistant for the Codex CLI, IDE
extension, and app. `AGENTS.md` routes requests to four orchestration skills
backed by the live Mercado Pago MCP server. Nothing about products is
hardcoded — it all comes live from the MCP.

- **4 skills:** `mp-integrate`, `mp-webhooks`, `mp-test-setup`, `mp-review`
- **Routing:** `AGENTS.md` (Codex has no bundled router agent like Claude)
- **MCP:** `mcp.mercadopago.com/mcp` (streamable HTTP, OAuth)
- **Two hooks:** credential-leak scan (`PreToolUse`, Bash) + version-change notice (`UserPromptSubmit`)
- **7 countries:** AR, BR, MX, CL, CO, PE, UY

## Structure

```
mercadopago-plugins-marketplace/
├── AGENTS.md                         # global routing (replaces the Claude router agent)
├── README.md
├── .agents/plugins/marketplace.json  # marketplace entry
└── plugins/mercadopago/
    ├── .codex-plugin/plugin.json     # plugin manifest
    ├── .mcp.json                     # MCP server config (mcp_servers, url + http_headers)
    ├── hooks/
    │   ├── hooks.json                 # PreToolUse -> credentials · UserPromptSubmit -> version
    │   ├── validate_mp_credentials.py
    │   └── check_version.py
    └── skills/
        ├── mp-integrate/SKILL.md
        ├── mp-webhooks/SKILL.md
        ├── mp-test-setup/SKILL.md
        └── mp-review/SKILL.md
```

## Codex architecture

| Topic | This plugin |
|-------|-------------|
| Manifest | `.codex-plugin/plugin.json` |
| Routing | `AGENTS.md` plus skill descriptions |
| Entry point | natural-language requests; Codex has no plugin slash commands |
| Skill metadata | `name`, `description`, optional `license`/`metadata`, and `agents/openai.yaml` tool dependencies |
| Hook event | `PreToolUse` for **Bash only** in Codex today |
| MCP config | `.mcp.json` using `mcp_servers`, `url`, and `http_headers` |

## Quickstart

With the plugin installed and the MCP connected (see Install below), just
describe what you want in plain language — Codex routes to the right skill:

- "Add a Checkout Pro integration to this project, for Brazil." → `mp-integrate`
- "Set up a webhook with HMAC signature validation." → `mp-webhooks`
- "Create a test user and load funds." → `mp-test-setup`
- "Review my Mercado Pago integration." → `mp-review`

For Checkout Pro, `mp-integrate` asks a couple of questions (country, product),
pulls the current docs live from the MCP, and returns a ready-to-paste bundle
(server + client snippets, env vars, and gotchas).

## Install (local development)

Add the marketplace and install the plugin, then connect the MCP:

```
codex
/plugins            # add this marketplace, install "mercadopago"
codex mcp add mercadopago --url https://mcp.mercadopago.com/mcp
codex mcp login mercadopago
```

## License

Apache-2.0. Copyright (c) 2026 Mercado Pago (MercadoLibre S.R.L.).
