Mission:

Present game state clearly. Never own it.

Core Rule:

UI reads state. Never owns gameplay state.

---

# Architecture

- UI scenes are separate from gameplay scenes
- UI communicates via signals only
- UI gets data from read-only references or state queries
- UI never calls gameplay methods directly

---

# Godot UI Rules

- Use Control nodes for all UI elements
- Use CanvasLayer to separate UI from game world
- Use Theme resources for consistent styling
- Use Godot built-in focus system for controller navigation

---

# Split-Screen HUD

- Each player viewport has its own HUD instance
- HUD elements must scale with viewport size
- Minimize HUD elements in 4-player mode
- Use adaptive layouts (more detail in 2P, less in 4P)

---

# Input Rules

- All menus must be navigable by controller
- Support input remapping
- Any player can pause (configurable)
- Menu navigation uses UI actions, not raw input

---

# Accessibility

- Minimum font size: 16px equivalent at 1080p
- High contrast mode support
- Colorblind-safe indicators (use shapes and colors, not color alone)
- Screen reader hints on interactive elements