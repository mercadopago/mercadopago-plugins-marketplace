# Contributing

Thanks for improving the Mercado Pago Plugins Marketplace.

## Scope

This repository hosts plugins for more than one runtime. Keep runtime-specific
code, manifests, skills, hooks, and user documentation inside the relevant
`plugins/<plugin-id>` directory. Do not add one runtime's instructions or
configuration to another plugin.

## Before opening a pull request

Run the repository validation gate:

```sh
sh scripts/validate_repository.sh
```

Also run any validation documented by the plugin you changed.

Do not add credentials, local `.env` files, user profiles, smoke-test
artifacts, absolute personal paths, private registry URLs, or cached plugin
copies. Never include real payment, buyer, account, or OAuth data in fixtures
or documentation.

## Adding a runtime or plugin

- Keep each plugin self-contained under `plugins/<plugin-id>`.
- Add it only to the appropriate marketplace metadata.
- Keep root documentation runtime-neutral.
- Document runtime-specific installation and security requirements alongside
  the plugin.

## Code of Conduct

By participating, you agree to uphold our [Code of Conduct](./CODE_OF_CONDUCT.md).
