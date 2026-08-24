# Marketplace repository guidance

This repository hosts Mercado Pago plugins for multiple runtimes.

- Keep runtime-specific behavior inside `plugins/<plugin-id>`.
- Read the instructions and documentation in the plugin being changed before
  modifying it.
- Do not copy manifests, commands, hooks, or runtime assumptions between
  plugins without adapting them to the destination runtime.
- Preserve public-repository safety: no credentials, personal paths, private
  registries, local profiles, or smoke-test artifacts.
- Run the repository validation gate and relevant plugin validation before
  submitting changes.
