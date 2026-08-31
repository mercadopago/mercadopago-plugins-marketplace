---
name: mp-connect
description: Connect or verify Mercado Pago MCP authentication. Use when the developer asks to connect, authenticate, log in, or verify access to Mercado Pago tools.
license: Apache-2.0
copyright: "Copyright (c) 2026 Mercado Pago (MercadoLibre S.R.L.)"
metadata:
  version: "1.0.0"
  author: "Mercado Pago Developer Experience"
  category: "development"
  tags: "mercadopago, mcp, oauth, authentication, connect"
---

# mp-connect

Connect the active Codex session to the bundled Mercado Pago MCP server. This
OAuth connection is for plugin tools; it is not seller OAuth for a Marketplace
application.

## Step 1 — Verify without false signals

Never use MCP resources as a connection test: this server has tools, not
resources. The bootstrap tools `authenticate` and `complete_authentication`
being visible also does not prove authentication.

Attempt `application_list` directly when it is callable.

- If it returns one or more applications, answer in the developer's language:
  `✓ Mercado Pago conectado e pronto para uso.` Then stop.
- If it is unavailable or returns an authentication error, continue to Step 2.

## Step 2 — Start OAuth

Call `authenticate` and present its authorization URL as a clickable link in
the developer's language. Explain that they should open it normally, complete
authorization, return after seeing “Authentication Successful”, and never send
an OAuth callback URL in chat because it contains a sensitive code.

When the developer returns, call `application_list` directly. Do **not** call
`complete_authentication` first: the callback may already have been consumed.
Only if `application_list` still fails *and* the browser showed an error rather
than success, offer a fresh authentication attempt.

## Step 3 — MCP unavailable

If neither `application_list` nor `authenticate` is callable, explain that the
Mercado Pago MCP is not loaded in the current Codex environment. Ask the
developer to enable the `mercadopago` server or run `codex mcp login
mercadopago`, then retry this connection flow. Never copy the plugin `.mcp.json`
into the developer's project and never request a personal access token.
