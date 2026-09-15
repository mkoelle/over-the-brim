# ADR-012: Self-Implementation Boundary

**Status:** Accepted

**Date:** 2026-09-14

---

### Context

[ADR-009](file:///docs/adr/ADR-009-netcode-addon-netfox.md),
[ADR-010](file:///docs/adr/ADR-010-input-glyph-addon-controller-icons.md), and
[ADR-011](file:///docs/adr/ADR-011-ai-state-machine-addon-limboai.md) each
adopt a third-party addon for a well-solved, undifferentiated problem. That
pattern needs a counterpart: a standing list of systems that must **never**
be delegated to an addon, regardless of what becomes available on the Godot
Asset Library, because per
[critique-and-risks.md](file:///docs/design/critique-and-risks.md)'s Bull
Case these systems *are* the product, not infrastructure around it. This
ADR is the reference future addon-adoption ADRs check against before
proposing a dependency.

---

### Decision

The following stay self-implemented, no exceptions without a new ADR that
explicitly overrides this one:

- **`VehicleController` arcade handling** (accel/brake/steer/drift/boost) —
  the "1-Car Fun" rule (Guardrail 3) is the entire bet; a generic vehicle
  physics addon reintroduces the "slippery soap car" Miss condition from
  the Hit/Miss rubric.
- **Spectator hazard system + telegraph rules** (Trap 2) — no existing
  addon models "avoidable chaos triggered by a phone-holding spectator";
  this is the Jackbox-hook differentiator itself.
- **`PresenterDirector`** smart-camera heuristics, rolling replay buffer,
  highlight reel — the broadcast/Twitch differentiator described in
  [overview.md §4](file:///docs/architecture/overview.md); bespoke by
  definition.
- **Hat-car customization** (stacking, ribbons, damage/pop) — visual IP
  identity per [vehicles.md](file:///docs/design/vehicles.md).
- **Race mode logic** (circuit, cat & mouse, capture the chicken, battle
  royale, ambient traffic) — unique rulesets per
  [race-modes.md](file:///docs/design/race-modes.md).
- **Event Director / role delegation**
  ([ADR-006](file:///docs/adr/ADR-006-role-based-event-direction-and-multi-window.md)) —
  bespoke session-flow authority model, not a generic session/lobby
  pattern.
- **Tournament/bracket flow** — mechanically generic-looking, but must
  match the party/mutator format; off-shelf bracket UIs assume a strictly
  competitive format and would fight the design.

This list is a floor, not a ceiling — infrastructure *around* these systems
(state machine bookkeeping per ADR-011, network transport per ADR-009) may
still use an addon; the game-specific *content* inside each item above does
not.

---

### Consequences

**Positive:**
- Gives every future per-topic addon ADR a shared test: "does this touch
  something on the list?" — if yes, the addon can only ever be
  infrastructure underneath a self-implemented layer, never a replacement
  for it.
- Prevents scope creep where a convenient asset-store package quietly
  becomes the game's core loop.

**Negative / Tradeoffs:**
- Slower for these specific systems than grabbing an off-shelf solution —
  accepted deliberately, since speed here is not the risk this project
  is managing against (per Trap 1, the risk is the opposite: too much
  infrastructure, not enough proven fun).

---

### Alternatives Considered

1. **Case-by-case evaluation with no standing list**: Rejected — the
   project has already produced one combined addon/self-implement ADR
   that had to be split apart (this document's own predecessor); a
   standing reference avoids re-deriving the same reasoning per addon
   proposal.
