# mercadopago

Mercado Pago full-product integration toolkit for Codex. (v1.0.1)

> **Code scaffolding works without MCP authentication** using bundled references and the official per-country `llms.txt` when it is accessible. MCP is never a prerequisite for scaffold: if a live detail is unavailable, the plugin generates the safe supported structure and labels the limitation rather than inventing it. Credential lookup (`get_credentials`), test-user creation, webhook registration, real-resource operations, and commercial/private-kit access require the authenticated Mercado Pago MCP server — run `codex mcp login mercadopago` only for those selected actions.

## Quick Start

After installing the plugin, connect it to your Mercado Pago account via OAuth — no Access Token required.

**Codex:** run `codex mcp login mercadopago` (or enable the `mercadopago` server in `~/.codex/config.toml`). The first time a skill needs the MCP, Codex walks you through the OAuth flow. The plugin hooks require `[features] codex_hooks = true` in `~/.codex/config.toml`.

**Other IDEs (Cursor, VS Code, Windsurf, etc.):** add the HTTP server via your IDE's MCP settings panel with URL `https://mcp.mercadopago.com/mcp`, then complete the OAuth flow your IDE prompts.

## Architecture

`AGENTS.md` router, six skills, one MCP. The plugin is an **orchestrator**, not a documentation container. All product knowledge lives in the MCP, the official per-country `llms.txt`, and the bundled `references/`; the skills translate developer intent into the right MCP queries and assemble the response.

In Codex the routing logic lives in `AGENTS.md` (there is no separate bundled "router agent" file as in the Claude plugin) plus each skill's own `description`.

```
┌────────────────────────────────────────────────────────┐
│  AGENTS.md  (router)                                   │
│  - product/country detection from the message          │
│  - mode detection (Orders API vs legacy)               │
│  - MCP-gate every interaction (states A/B/C)           │
│  - delegates to one of six skills                      │
└──────────────────────────┬─────────────────────────────┘
                           │
     ┌──────────────┬──────┴───────┬──────────────┬──────────────┐
     ▼              ▼              ▼              ▼              ▼
mp-integrate   mp-webhooks    mp-test-setup    mp-review      mp-migrate
(wizard)       (HMAC + MCP    (create_test_    (quality_      (Instore QR/
               webhook tools)  user + add_      checklist +    Point → Orders
                               money; test      security       API; offline
                               cards offline)   floor)         WebFetch docs)
     │              │              │              │              │
     └──────────────┴──────────────┴──────────────┴──────────────┘
                           │
                      mp-connect (MCP OAuth)
                           │
                           ▼
              ┌───────────────────────────┐
              │  Mercado Pago MCP server  │
              │  (mcp.mercadopago.com)    │
              │                           │
              │  search_documentation     │
              │  quality_checklist        │
              │  quality_evaluation       │
              │  save_webhook             │
              │  notifications_history_…  │
              │  create_test_user         │
              │  add_money_test_user      │
              │  application_list         │
              └───────────────────────────┘
```

## Skills

| Skill | What it does | Backed by |
|-------|--------------|-----------|
| `mp-integrate` | Wizard that scaffolds a complete integration for any product (Checkout Pro, Checkout API, Bricks, QR, Point, Subscriptions, Marketplace, Wallet Connect, Money Out, SmartApps). Asks the minimum questions, resolves docs (llms.txt → `references/products.md` → MCP), returns a ready-to-paste bundle. | `search_documentation` |
| `mp-webhooks` | Receiver pattern with HMAC-SHA256 validation; configures and diagnoses webhooks. | `save_webhook`, `notifications_history` |
| `mp-test-setup` | Creates test users and loads funds (needs MCP); also returns test cards per country (no MCP needed). Credentials come in `APP_USR-` (Orders API, Checkout Pro, Point, QR) and `TEST-` (Checkout API, Bricks) formats — both valid and actively issued. | `create_test_user`, `add_money_test_user` |
| `mp-review` | Runs the official quality checklist live + a fixed cross-cutting security floor. Suggests `quality_evaluation` when the integration produced a compatible payment/order id. | `quality_checklist`, `quality_evaluation` |
| `mp-migrate` | Migrates legacy Instore integrations (QR Code and Point) from legacy APIs to the Orders API. Scans the project, proposes a diff, and applies only after confirmation. Works offline via WebFetch of the official migration docs. Lives at `skills/mp-integrate/SKILL-migrate.md`. | WebFetch (official migration docs); `save_webhook` when updating the topic |
| `mp-connect` | Verifies or starts the OAuth connection to the Mercado Pago MCP. | `application_list`, `authenticate` |

## Invoking the plugin

Codex has no slash commands. You invoke the plugin by describing what you want in plain language; `AGENTS.md` routes the request to the right skill:

| You ask for… | Routes to |
|--------------|-----------|
| add / build / scaffold / implement a Mercado Pago flow | `mp-integrate` |
| set up, simulate, or debug webhooks (IPN, signature, notifications) | `mp-webhooks` |
| create a test user, load funds, or get test cards for a country | `mp-test-setup` |
| audit / review / score an existing integration (scopes: `security`, `webhooks`, `checkout`, `qr`, `subscriptions`, `marketplace`, `quality`, `full`) | `mp-review` |
| migrate an existing QR/Point (Instore) integration to the Orders API | `mp-migrate` |
| connect, authenticate, log in, or verify the Mercado Pago MCP | `mp-connect` |

MCP connection is managed with `codex mcp login mercadopago`; Codex plugins use
natural-language requests instead of slash commands.

## Hook: Credential Leak Prevention

Scans **shell (Bash) commands** for hardcoded Mercado Pago credentials (Access tokens, client secrets, bearer headers, webhook secrets) and blocks them before they run. Note: Codex's `PreToolUse` only intercepts the `Bash` tool today, so credentials written directly to files or sent via MCP are **not** caught by this hook — those are covered by `mp-review` and CI. Requires `[features] codex_hooks = true` in `~/.codex/config.toml`.

A second hook (`check_version.py`, `UserPromptSubmit`) prints a one-line notice when the installed plugin version changes.

## MCP: Mercado Pago API

Connects to the official Mercado Pago MCP server (`https://mcp.mercadopago.com/mcp`) via HTTP transport. OAuth-based auth — run `codex mcp login mercadopago` for setup. Scaffolding works without it; live docs, credential lookup, test-user creation, and webhook registration require an authenticated MCP.

## Configuration

Per-project configuration lives in `.codex/mercadopago.local.md` (YAML frontmatter). Currently supported:

```markdown
---
enabled: false
---
```

`enabled: false` disables the credential-leak hook for that project (useful for repos that have nothing to do with Mercado Pago). The default is `true`.

## Resources

Replace `{DOMAIN}` with your country's domain (e.g. `www.mercadopago.com.ar` for Argentina, `www.mercadopago.com.br` for Brazil) and `{LANG}` with `es`, `pt` (Brazil), or `en`. See the full country list in `mp-integrate`.

- [Mercado Pago Developer Docs](https://{DOMAIN}/developers/{LANG}/docs)
- [API Reference](https://{DOMAIN}/developers/{LANG}/reference)
- [SDKs](https://{DOMAIN}/developers/{LANG}/docs/sdks-library/landing)
- [Credentials Dashboard](https://{DOMAIN}/developers/panel/app)
