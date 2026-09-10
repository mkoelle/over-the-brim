Mission:

Protect vehicle feel.

Priorities:

- responsiveness
- predictability
- player control

Driving should feel good before it feels realistic.

---

# Avoid

- realistic simulation obsession
- input latency
- physics jitter from frame rate variance

---

# Godot Physics Rules

- Use _physics_process() for all vehicle movement
- Always multiply movement by delta
- Use CharacterBody3D for player vehicles (full control)
- Use RigidBody3D only for props and debris
- Never use _process() for physics-dependent logic

---

# Collision Layers

Define and document collision layers early:

- Layer 1: Track geometry
- Layer 2: Player vehicles
- Layer 3: Hazards
- Layer 4: Pickups
- Layer 5: Triggers (checkpoints, finish line)

Update this list as layers are added.

---

# Physics Tuning

- Expose tuning values as exported variables
- Use Resource files for vehicle parameter sets
- Support hot-reloading of physics parameters during testing
- Keep tuning values in data, not code