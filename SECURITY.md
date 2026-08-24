# Security Policy

## Scope

This policy covers code, marketplace metadata, documentation, automation, and
all plugins shipped by this repository.

## Report a vulnerability privately

Do not open a public issue for a suspected vulnerability, exposed credential,
OAuth problem, or payment-data leak. Use the repository's private
[GitHub Security Advisory form](https://github.com/mercadopago/mercadopago-plugins-marketplace/security/advisories/new).

Include the affected plugin, runtime, version, reproduction steps, expected and
actual behavior, and a redacted proof of concept. Do not include live tokens,
client secrets, webhook secrets, buyer data, or full payment payloads.

## Exposed credentials

If a credential may have been exposed, revoke or rotate it immediately and
remove it from all reachable history. Treat copied values as compromised and
report the incident through the private advisory form.

Plugin-specific security guidance is maintained inside the relevant plugin
directory.
