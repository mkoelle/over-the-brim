# ADR-008: LLM Delegation Model Selection (OpenRouter)

**Status:** Accepted

**Date:** 2026-09-14

---

### Context

Development on this project uses Claude Code as the primary agentic harness. Not all work needs Claude-tier reasoning — mechanical refactors, boilerplate GDScript, and bulk documentation tasks can be delegated to cheaper models to reduce cost, while Claude Code remains the orchestrator for architecture, hard bugs, and anything touching gameplay feel.

An OpenRouter MCP server (`stabgan/openrouter-mcp-multimodal`) was integrated (`.mcp.json`, gitignored — holds `OPENROUTER_API_KEY`) to give Claude Code direct tool access to third-party models for this delegated work.

OpenRouter hosts 400+ models. Selecting among them requires a proxy for "how good is this model at Godot/GDScript work," since no comprehensive Godot-specific benchmark exists. Two data sources were evaluated:

1. **Godot-specific evidence** — Design Arena's `agents/godotgamedev` category (crowd-voted Elo, large N), GameDevBench (Godot-specific % pass rate), and Ziva's hands-on single-prompt build benchmarks (small N, real playtesting).
2. **General coding benchmarks** — Artificial Analysis `coding_index` (composite of DeepSWE v1.1, Terminal-Bench 4.0, SWE-Atlas-QnA; Python/JS-oriented, no Godot coverage), used as a fallback proxy where Godot-specific data doesn't exist.

A key finding during evaluation: general coding benchmark scores do not reliably predict real Godot output quality. GPT-5.6 Terra scored a strong 76.7 on `coding_index` but scored only 2/10 "World Score" in Ziva's hands-on Godot build test — the worst of the three models tested there. This means general-benchmark-only picks (the secondary list below) carry real risk and should be spot-checked against actual project code before trusting at volume.

xAI/Grok models are excluded from consideration per explicit direction — no evaluation performed.

---

### Decision

Maintain a two-list model selection, re-evaluated periodically as OpenRouter pricing/catalog changes:

**Primary list** (has direct Godot-specific evidence — preferred):

| Model | Evidence | Godot rank/score | $/M prompt | $/M completion |
|---|---|---|---|---|
| `moonshotai/kimi-k2.5` | Design Arena godotgamedev, rank 8, elo 1219, 59.8% win | — | $0.45 | $2.25 |
| `z-ai/glm-4.6` | Design Arena godotgamedev, rank 12, elo 1180 | — | $0.43 | $1.75 |
| `z-ai/glm-4.7` | Design Arena godotgamedev, rank 27, elo 1058 | — | $0.40 | $1.75 |
| `openai/gpt-5.6-sol` | GameDevBench #2 (63.7%), Ziva hands-on (5/10, playable) | — | $2.00 | $10.00 |

**Default: `moonshotai/kimi-k2.5`** — best Godot-arena rank at sustainable cost (~1,600 delegated tasks per $5 spend cap). `glm-4.6` / `glm-4.7` serve as a cheaper bulk floor for high-volume mechanical work (~1,900 tasks per $5).

**Secondary list** (no Godot-specific data — general `coding_index` proxy only, use with more caution):

| Model | coding_index | $/M prompt | $/M completion |
|---|---|---|---|
| `z-ai/glm-5.3-flash` | 71.5 | $0.15 | $0.50 |
| `deepseek/deepseek-v4-flash-0731` | 69.1 | $0.06 | $0.12 |

**Secondary default: `z-ai/glm-5.3-flash`** — best balance of quality and volume (~6,250 tasks per $5) among untested-on-Godot options. `deepseek-v4-flash-0731` reserved for pure bulk/mechanical work where volume matters more than per-task quality (~20,800 tasks per $5).

**Explicitly excluded:** `openai/gpt-5.6-terra` — despite a strong 76.7 `coding_index`, real hands-on Godot testing (Ziva) scored it 2/10. Not to be used for delegated Godot work regardless of its general benchmark standing.

**Explicitly out of scope:** all xAI/Grok models, per direction — not evaluated, not to be selected without revisiting this ADR.

A $5 spend cap is set on the OpenRouter API key as a budget guardrail.

---

### Consequences

**Positive:**
- Delegating mechanical/bulk work off Claude Code reduces per-task cost by roughly 2-3 orders of magnitude versus using Claude for everything.
- Two-list structure keeps the Godot-unverified models clearly flagged, preventing silent trust in benchmark numbers that don't transfer to this project's domain (GDScript/Godot 4).
- Spend cap on the API key bounds the blast radius of a runaway or misconfigured delegation loop.

**Negative / Tradeoffs:**
- Delegated models are weaker than Claude at GDScript nuance and require more review overhead on their output.
- Godot-specific benchmark coverage is thin (small N on hands-on tests, missing entries for some strong general models like Grok-4.6 and GPT-5.6 Sol/Luna in the Design Arena category), so primary-list rankings carry real uncertainty.
- Model catalog and pricing on OpenRouter change frequently; this selection will drift out of date and needs periodic re-verification, not one-time trust.
- OpenRouter itself carries an external service reliability risk (1.7/5 Trustpilot at evaluation time, complaints about support delays and unexpected agentic costs) — mitigated by the spend cap, not eliminated.

---

### Alternatives Considered

1. **Rank purely by general `coding_index`, ignore Godot-specific arenas:**
   Rejected — the GPT-5.6 Terra case shows general coding benchmarks can diverge sharply from real Godot output quality. Using Godot-specific evidence as the primary signal, with general benchmarks only as a clearly-labeled fallback, reduces this risk.

2. **Single default model instead of a two-list/tiered approach:**
   Rejected — no single model dominates on both Godot-specific proof and cost-efficiency across all delegated task types (bulk mechanical vs. harder Godot-aware work). Tiering lets cheap/high-volume models absorb bulk work while a Godot-validated model handles anything where output quality on this domain matters more.

3. **Official Anthropic-via-OpenRouter proxy (`ANTHROPIC_BASE_URL`) for provider failover/budget management:**
   Rejected as the delegation mechanism — that path only proxies Claude models themselves (for failover/team budget controls) and explicitly is not guaranteed to work correctly with non-Anthropic models, so it doesn't serve the goal of delegating to cheaper third-party models.

4. **Include Grok models in the evaluation:**
   Rejected per explicit direction — excluded from all consideration without further evaluation.
