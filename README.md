# Mercado Pago Plugins Marketplace

Official marketplace repository for Mercado Pago developer plugins.

This repository is intentionally runtime-neutral: each plugin lives in
`plugins/<plugin-id>` and owns its runtime-specific manifests, skills, hooks,
documentation, and release notes. Marketplace metadata at the repository root
exposes the plugins to the runtimes that support it.

## Available plugins

| Plugin | Runtime | Location |
|---|---|---|
| Mercado Pago | Codex | [`plugins/mercadopago`](./plugins/mercadopago) |

## Repository layout

```
mercadopago-plugins-marketplace/
├── .agents/plugins/marketplace.json  # Codex marketplace metadata
├── plugins/
│   └── <plugin-id>/                  # self-contained plugin package
├── docs/                             # marketplace documentation
└── scripts/                          # repository-level validation tooling
```

## Adding a plugin

1. Create a self-contained directory under `plugins/<plugin-id>`.
2. Add the manifest required by its runtime.
3. Register it only in the marketplace metadata for that runtime.
4. Include plugin-specific documentation and deterministic validation.
5. Run the repository validation gate before opening a pull request.

See the documentation inside each plugin directory for installation and runtime
requirements.

## License

Apache-2.0. Copyright (c) 2026 Mercado Pago (MercadoLibre S.R.L.).
