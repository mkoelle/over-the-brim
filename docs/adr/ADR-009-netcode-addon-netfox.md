# ADR-009: Netcode Addon Selection — netfox

**Status:** Accepted (adoption deferred to Tier 2 implementation)

**Date:** 2026-09-14

---

### Context

[overview.md §3](file:///docs/architecture/overview.md) specifies Tier 2
(Networked Grid) requirements: 20-30Hz transform replication, client-side
Hermite/cubic interpolation, and position/yaw quantization, built on the
[ADR-004](file:///docs/adr/ADR-004-network-peer-and-car-decoupling.md)
peer/vehicle decoupling. Hand-rolling this is a well-solved, undifferentiated
problem — exactly the shape of Trap 1 in
[critique-and-risks.md](file:///docs/design/critique-and-risks.md)
("Architecture Before Fun"): weeks of interpolation/quantization code before
`VehicleController` feel is proven.

---

### Decision

Adopt **netfox** (foxssake) — a rollback/state-sync netcode framework for
Godot 4 — for Tier 2 networked-grid replication, when that work starts.

**Do not vendor before Tier 2 begins.** Phase A/B stay fully local
(splitscreen only, per STATE.md's explicit out-of-scope list); pulling
netfox in earlier gains nothing and adds dependency surface against
unfinished vehicle/input code.

Re-evaluate this specific choice at Tier 2 kickoff — this ADR does not lock
netfox in as untouchable, only as the current best candidate against
today's known requirements.

---

### Consequences

**Positive:**
- Replication/interpolation/quantization arrives pre-built and maintained,
  matching the ADR-004 peer-owns-N-vehicles model without a rewrite.
- Time saved goes to handling-feel iteration instead.

**Negative / Tradeoffs:**
- External dependency with its own upgrade cadence and API surface to
  track (same class of maintenance burden as gdUnit4 under ADR-007).
- If netfox's rollback model doesn't fit the arcade `CharacterBody3D`
  controller cleanly at integration time, some custom glue (or a fallback
  to hand-rolled interpolation) may still be needed — this ADR is a
  starting bet, not a guarantee.

---

### Alternatives Considered

1. **Hand-roll interpolation/quantization directly per overview.md §3**:
   Rejected for now — matches Trap 1. Becomes the fallback if netfox
   proves unfit at Tier 2 integration time.
2. **No addon, defer networking indefinitely**: Rejected — Tier 2 is a
   committed scaling tier in the architecture, not speculative; a decision
   is needed before that milestone, just not before Phase A.
