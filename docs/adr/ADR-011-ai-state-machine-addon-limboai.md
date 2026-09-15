# ADR-011: AI / State Machine Addon — LimboAI

**Status:** Accepted (adoption deferred to first manager state machine or AI bot)

**Date:** 2026-09-14

---

### Context

[overview.md §1](file:///docs/architecture/overview.md) defines
`RaceManager` (countdown/racing/paused/finished/sudden-death) and
`TournamentManager` (heats/brackets) as explicit state machines, and
STATE.md's next milestone will eventually need AI bot drivers and ambient
traffic (per
[race-modes.md](file:///docs/design/race-modes.md)). Both are the
"generic infrastructure" half of the problem — state transition bookkeeping
and behavior-tree evaluation are solved problems; the *content* of each
state (what `RaceManager` actually does in "racing," what a bot decides at
a fork) is game-specific and stays self-implemented regardless.

---

### Decision

Adopt **LimboAI** (behavior trees + state machines for Godot 4) as the
backing framework for:
1. `RaceManager` / `TournamentManager` phase state machines, when either is
   first implemented.
2. AI bot driver decision-making and ambient traffic behavior, when that
   work starts.

Both are explicitly out of scope for the current Phase A milestone per
STATE.md ("no `RaceManager` state machine... Add these only once one car on
one track is confirmed fun"). Do not vendor before then.

---

### Consequences

**Positive:**
- Transition/tree bookkeeping (state history, guard conditions, tree
  ticking) arrives tested and editor-integrated instead of hand-rolled.
- Godot-editor visual debugging of trees/states helps tune AI bot behavior
  without custom tooling.

**Negative / Tradeoffs:**
- Couples two of the most central systems (`RaceManager`,
  `TournamentManager`) to a third-party framework's control flow — a poor
  fit discovered late would be expensive to unwind. Prototype the
  `RaceManager` state machine with it early in that milestone to validate
  fit before `TournamentManager` and AI bots also depend on it.

---

### Alternatives Considered

1. **Hand-roll a simple enum + match state machine**: Viable fallback if
   LimboAI's behavior-tree model proves awkward for `RaceManager`'s
   comparatively simple linear phases — reconsider per-manager rather than
   forcing LimboAI everywhere it isn't a clean fit.
2. **Hand-roll AI bot decision logic**: Rejected as the default — behavior
   trees are the standard tool for exactly this problem, and LimboAI's
   editor integration outweighs a bespoke bot decision system.
