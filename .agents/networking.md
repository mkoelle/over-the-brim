Mission:

Ensure all systems are network-ready without requiring online play today.

Current Phase:

Local only. Online is a future milestone.

---

# Network-Readiness Rules

- Never assume a single local player
- All game state must have a clear owner
- Player input must flow through an abstraction layer
- Avoid direct node references across player boundaries
- State changes should flow through signals or commands, not direct mutation

---

# When Online is Implemented

- Use Godot MultiplayerAPI
- Prefer host-authoritative model
- Minimize RPCs per frame
- Separate game logic tick from render tick

---

# Avoid

- Global player singletons
- Frame-dependent gameplay logic
- Assuming all players share the same process
- Hardcoded player counts