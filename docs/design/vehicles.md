# Vehicle Design & Customization

This document outlines the visual aesthetic, customization system, and handling/damage mechanics for vehicles in **Competitive Racing Arena Party (CRAP)**.

---

## Visual Concept: The Top-Hat Racer

Vehicles in CRAP are **sentient, wheeled Victorian/steampunk top-hats**. They are goofy, expressive, and immediately readable on split-screen displays.

```text
       [=======]          <-- Stacked Topper / Mini-Hat
      /         \
     |   (o) (o) |        <-- Expressive Animated Eyes
  0_|___________|_      <-- Tail light / Hat Brim / Chassis
   (O)           (O)      <-- Hot-Rod Wheels
```

### Visual Features
- **The Chassis**: A classic stovepipe top-hat acting as the vehicle body.
- **Wheels**: Chunky hot-rod / cartoon wheels mounted directly under or flanking the brim.
- **Expressive Eyes**: Animated cartoon eyes mounted on the front brim:
  - Normal idle: wide open, looking around.
  - Accelerating / Boosting: eyes widen with shock and excitement.
  - Drifting / Turning: eyes dart toward the corner apex.
  - High Impact / Crash: eyes roll or spin comically.
- **Steam & Smoke Exhaust**:
  - Puffs out from the top crown or side exhaust pipes based on throttle and boost state.
- **The "Top-Hat on a Top-Hat"**:
  - The crown of the main hat acts as a mount point for unlockable stacked toppers (mini-derbies, tiny sombreros, propeller beanies, monocles).

---

## Customization & Personalization

Before races or in tournament lobbies, players personalize their racer:

| Element | Customization Options |
|---|---|
| **Hat Body Color** | Primary felt color (velvet red, midnight black, royal purple, tweed, etc.). |
| **Ribbon / Band Color** | Secondary accent color for the fabric ribbon around the crown. |
| **Eyewear & Eyes** | Classic googly eyes, monocle, aviator goggles, cartoon wink. |
| **Topper Accessory** | Mini-tophat, candle, feather, tea cup, party horn. |
| **Steam Trail** | Color and style of exhaust particles (soot, rainbow steam, confetti). |

---

## Damage, Destruction & Respawn

### 1. Cumulative Visual Damage
- Minor collisions dent, crumple, or bend the hat brim and crown.
- Fabric tears reveal comical inner spring mechanisms or clockwork gears.

### 2. Catastrophic Destruction (Explosion)
- Upon reaching 0 HP or colliding with train/hazard at high speed:
  - The vehicle pops like an overinflated balloon with a blast of steam, springs, and confetti.
  - A slapstick sound effect plays (balloon pop + party horn).

### 3. Comic Respawn
- Respawning takes $\le 1.5$ seconds to keep couch gameplay fast-paced:
  - A fresh, pristine top-hat drops down from the sky with a cartoon squeak or "plop".
  - Wheels pop out, and the player instantly regains control with brief invulnerability.

---

## Technical Implementation

Following [.agents/physics.md](file:///.agents/physics.md):
- **Node Type**: `CharacterBody3D` for tight, responsive arcade feel.
- **Physics Tuning**: Exposed as exported variables in a custom `VehicleStats.tres` Resource for live-tuning acceleration, grip, drift slip, and top speed without recompiling scripts.
