# Guia rápido — plugin Mercado Pago para Codex

Guia curto pra instalar, conectar e usar o plugin.

## O que é
Um assistente de integração do Mercado Pago dentro do Codex. O `AGENTS.md`
encaminha o pedido para uma de 5 skills. O scaffold de código e a consulta de
cartões de teste funcionam **sem MCP** (a partir do `llms.txt` oficial por país
e das referências em `references/`); o servidor MCP é usado para docs ao vivo,
credenciais, criação de usuário de teste e webhooks.

## Instalar (desenvolvimento local)

**1. No Codex CLI:**

```
codex
/plugins        # adicione este marketplace e instale o "mercadopago"
```

**2. Conecte o MCP** (adicione o servidor e faça o OAuth):

```
codex mcp add mercadopago --url https://mcp.mercadopago.com/mcp
codex mcp login mercadopago
```

## As 5 skills e quando cada uma entra
| Skill | Use quando você quer… |
|-------|------------------------|
| `mp-integrate` | criar/adicionar uma integração (Checkout Pro, Bricks, QR, etc.) |
| `mp-webhooks` | configurar, simular ou validar webhooks (assinatura HMAC) |
| `mp-test-setup` | criar usuário de teste e carregar saldo (e consultar cartões de teste) |
| `mp-review` | revisar/auditar uma integração (qualidade + segurança) |
| `mp-migrate` | migrar integrações Instore legadas (QR Code e Point) para a Orders API |

Você não precisa decorar nomes: descreva o que quer e o Codex escolhe a skill.
Para chamar uma específica, use `@` (ex.: `@mp-integrate`).

## Exemplos de pedido
- "Adiciona um Checkout Pro no meu projeto (Brasil)."
- "Configura o webhook e valida a assinatura."
- "Cria um usuário de teste comprador na Argentina com saldo."
- "Revisa minha integração e me diz se posso subir pra produção."

## Como saber se está funcionando
Três checagens rápidas, qualquer pessoa consegue:
1. **Cartões de teste (sem MCP):** peça "me dá os cartões de teste do Brasil" —
   deve responder com os números na hora, sem pedir conexão com o MCP.
2. **Roteamento:** peça algo simples como "adiciona um Checkout Pro" — a skill
   `mp-integrate` deve assumir e começar a perguntar o mínimo necessário.
3. **Review:** com uma integração no projeto, peça "revisa minha integração" —
   a `mp-review` roda o checklist (para isso precisa do MCP conectado).

## Regras importantes (o plugin já segue)
- Sem sandbox: use sempre `init_point`, nunca `sandbox_init_point`.
- Credenciais de teste e de produção usam o prefixo `APP_USR-` (não existe mais `TEST-`).
- Tokens sempre em variável de ambiente — nunca no código.
- Sem MCP conectado, o scaffold de código e os cartões de teste ainda funcionam
  (via `llms.txt` + `references/`). Já `mp-review` e a criação de usuário de teste
  (`mp-test-setup`) precisam do MCP e pedem pra conectar.

## Segurança
Um hook (`PreToolUse`) bloqueia tokens do Mercado Pago colados direto em
comandos de terminal. Obs.: hoje ele cobre só comandos Bash — o resto é coberto
pela skill `mp-review` e pelo CI.
