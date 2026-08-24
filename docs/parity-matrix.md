# Matriz de paridade — referência 4.3.1 para Codex 1.0.0

Referência analisada: `82bf0b0..1e051d1` no marketplace equivalente. Esta matriz
registra a decisão por capacidade, e não replica formatos de outra plataforma.

| Alteração de referência | Finalidade | Destino Codex | Decisão | Justificativa |
|---|---|---|---|---|
| Regras de roteamento e limite de MCP | Não autenticar em preflight; manter offline | `AGENTS.md`, quatro skills | Adaptar | Codex roteia por `AGENTS.md`, sem agente empacotado. |
| Produtos, modos e contratos atuais | Cobrir Pro, API, Bricks, QR, Point, assinaturas, marketplace, Wallet Connect, Payouts e Smart Apps | `mp-integrate`, guias e `products.md` | Portar | Mantida a taxonomia nativa do plugin. |
| Resolver genérico de CTA | Localizar CTA em HTML/JS/TS/JSX/TSX/Vue e handlers externos | `detect/resolve/validate-checkout-cta.mjs` | Portar | Sem regras específicas de aplicação de teste. |
| Checkout Pro | Botão visível e `/checkout/preferences` | guia Pro, validador e testes | Portar | Valida também `auto_return` apenas para URL pública HTTPS. |
| Checkout API | Nova tela, CTA navegável e CardForm seguro | guia API, `validate-checkout-screen.mjs` | Portar | Runtime config, labels, lifecycle selects e campos interativos são verificados. |
| Runtime public-key config | Proibir placeholder no HTML cacheado | guia API e validador de tela | Portar | Exige endpoint `/api/mp-config` sem cache. |
| Validadores de produto | Detectar fluxos inseguros e contratos inválidos | `scripts/validate-*.mjs` | Portar | Todos são independentes de runtime Claude. |
| Suites de regressão | Cobrir CTA e todos os produtos | `scripts/test-*.mjs` | Portar | Sem `tests/smoke`, perfis ou artefatos privados. |
| Segurança de credenciais | Bloquear segredos e leitura perigosa de `.env` | hook Python + testes unitários | Adaptar | O hook Codex recebe Bash; saída usa a decisão JSON do hook. |
| Docs, segurança e privacidade | Tornar o repositório público auditável | `README`, `CONTRIBUTING`, `SECURITY`, `PRIVACY` | Adaptar | Textos e links apontam para Codex e este repositório. |
| Catálogo de componentes | Publicar skills e hooks reais | `scripts/generate_catalog.py`, `docs/components.json` | Adaptar | Não há comandos ou agentes empacotados no Codex. |
| Gate de CI/pre-commit | Validar scripts, manifests, catálogo e segurança | `scripts/validate_repository.sh`, workflow e hook | Adaptar | Não existe comando de validação de plugin equivalente a outra CLI. |
| Templates de issue e PR | Coletar reproduções seguras e padronizar revisão | `.github/ISSUE_TEMPLATE`, `.github/PULL_REQUEST_TEMPLATE.md` | Adaptar | Referências a Claude foram substituídas por Codex e pela URL deste repositório. |
| Workflow de catálogo | Impedir catálogo desatualizado | `.github/workflows/generate-catalog.yml` | Adaptar | Executa o gerador nativo do Codex em modo de verificação. |
| Manifest e marketplace | Metadados, MCP e versão | `.codex-plugin`, `.agents`, `.mcp.json` | Manter/adaptar | Já eram nativos do Codex e permanecem em `1.0.0`. |
| Agente dedicado | Router separado | — | Não aplicar | O roteamento nativo é `AGENTS.md`. |
| Slash commands | Entradas `/mp-*` | — | Não aplicar | Codex usa linguagem natural e descrição de skills. |
| Manifests/variáveis exclusivos | Paths de cache e variáveis de outra plataforma | — | Não aplicar | Seriam incompatíveis e poderiam vazar paths locais. |
| Smoke tests externos e perfis | Testes privados de aplicação | — | Não aplicar | Explicitamente fora do escopo público. |
