# ADR-010: Input Prompt Glyph Addon — Controller Icons

**Status:** Accepted (adoption deferred to first input-prompt UI)

**Date:** 2026-09-14

---

### Context

Architecture Decision 01 in
[overview.md](file:///docs/architecture/overview.md) and
[ADR-004](file:///docs/adr/ADR-004-network-peer-and-car-decoupling.md) commit
this game to per-slot, mixed input devices (keyboard + N gamepads,
couch-first). Any menu, slot-assignment screen, or HUD prompt that says
"press X" needs to render the *correct* glyph for whatever device that slot
is actually bound to (Xbox/PlayStation/Switch/keyboard), and update live if
the device changes. This is a solved, undifferentiated UI problem with no
bearing on driving feel or spectator chaos.

---

### Decision

Adopt **Controller Icons** (ExpressoBits) for input-prompt glyph rendering.

Adopt it when the first real input-prompt UI is built (slot-assignment
screen, pause menu, or HUD prompts) — not before. Nothing in Phase A's
"1-Car Fun" scope needs it (F3 debug overlay reads raw values, not prompts).

---

### Consequences

**Positive:**
- Correct per-device glyphs "for free," maintained against new controller
  types without in-house icon-mapping tables.
- Matches Architecture Decision 01's per-device input model directly —
  no adapter layer needed beyond wiring it to the existing `input_source`
  device ID.

**Negative / Tradeoffs:**
- Menu/HUD code couples to this addon's glyph asset set and API; swapping
  later means re-theming prompt assets across every UI scene that uses it.

---

### Alternatives Considered

1. **Hand-roll a device-type → icon-set mapping**: Rejected — this is
   exactly the kind of undifferentiated plumbing this addon already
   solves well; no gameplay or identity value in owning it.
