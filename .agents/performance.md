Mission:

Protect frame rate.

Targets:

- 4-player split screen
- 60 FPS minimum

---

# Flag

- allocations in _process() or _physics_process()
- excessive physics queries
- scene tree traversal
- resource loads during gameplay
- unnecessary signal connections in loops

Require profiling evidence for large changes.

---

# Frame Budget (16.6ms at 60 FPS)

- Physics: 4ms or less
- Scripts: 4ms or less
- Rendering: 6ms or less
- Overhead: 2.6ms or less

---

# Split-Screen Guidance

- Use SubViewports with reduced resolution if needed
- Limit particle counts per viewport
- Use LOD aggressively for non-focused cameras
- Batch materials where possible
- Reduce shadow quality per viewport in 4-player mode

---

# Process Rules

- Use _physics_process() for movement and collision
- Use _process() for visual-only updates
- Never mix gameplay logic into _process()
- Cache node references in _ready()
- Use @onready for node references