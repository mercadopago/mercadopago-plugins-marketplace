# Security Policy

## Supported versions

Security fixes are provided for the current `1.0.0` release line. Users should
upgrade before reporting an issue that has already been fixed in a newer patch.

## Report a vulnerability privately

Do not open a public issue for a suspected vulnerability, exposed credential,
OAuth problem, or payment-data leak. Use the repository's private
[GitHub Security Advisory form](https://github.com/mercadopago/mercadopago-plugins-marketplace/security/advisories/new).

Include, when available:

- affected plugin and Codex versions;
- operating system and installation method;
- reproduction steps and expected/actual behavior;
- affected files, skills, hooks, or MCP tools;
- impact assessment and a minimal proof of concept;
- whether any credential or real account may have been exposed.

Do not include live access tokens, client secrets, webhook secrets, buyer data,
or full payment payloads. Use redacted values.

Reports are triaged through the private advisory. Response timing depends on
severity, reproducibility, and any coordinated-disclosure requirements; the
maintainers will keep the reporter informed in that private channel.

## Exposed credentials

If a Mercado Pago credential may have been exposed:

1. Revoke or rotate it immediately in the Mercado Pago Developer Dashboard.
2. Stop any affected deployment and replace the secret in its secret manager.
3. Do not rely on deleting a Git commit; remove the value from reachable history
   and treat every copied value as compromised.
4. Report the incident privately using the advisory form above.

The `MP_PUBLIC_KEY` is designed to be client-visible. Access tokens, client
secrets, webhook secrets, OAuth tokens, test-user passwords, and buyer/payment
data are not public.

## Scope

This policy covers code shipped by this repository: plugin instructions,
skills, hooks, MCP configuration, validators, and public CI/release
automation. Vulnerabilities in Mercado Pago APIs or accounts should also be
reported through Mercado Pago's official security channels.
