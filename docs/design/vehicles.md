# Vehicle Design & Customization

This document outlines the visual aesthetic, vehicle archetypes, customization system, and handling/damage mechanics for vehicles in **Over The Brim**.

---

## Visual Concept: Wheeled Haberdashery

Vehicles in *Over The Brim* are **sentient, wheeled Victorian/steampunk headwear**. They are goofy, expressive, and immediately readable on split-screen displays.

```text
       [=======]          <-- Stacked Topper / Mini-Hat
      /         \
     |   (o) (o) |        <-- Expressive Animated Eyes
  0_|___________|_        <-- Tail light / Hat Brim / Chassis
   (O)           (O)      <-- Hot-Rod Wheels
```

### Visual Features
- **The Chassis**: Classic hats acting as the vehicle body and structural chassis.
- **Wheels**: Chunky hot-rod / cartoon wheels mounted directly under or flanking the brim.
- **Expressive Eyes**: Animated cartoon eyes mounted on the front brim:
  - Normal idle: wide open, looking around.
  - Accelerating / Boosting: eyes widen with shock and excitement.
  - Drifting / Turning: eyes dart toward the corner apex.
  - High Impact / Crash: eyes roll or spin comically.
- **Steam & Smoke Exhaust**:
  - Puffs out from the top crown or side exhaust pipes based on throttle and boost state.
- **The "Hat-on-a-Hat"**:
  - The crown of the main hat acts as a mount point for unlockable stacked toppers (mini-derbies, tiny sombreros, propeller beanies, monocles).

---

## Vehicle Archetypes: The Haberdashery Grand Prix

Different hat silhouettes represent distinct vehicle handling classes and racing personalities:

| Archetype | Hat Style | Weight & Handling Profile | Visual Signature |
|---|---|---|---|
| **The Speedster** | **Classic Stovepipe Top-Hat** | **Balanced All-Rounder**: Good top speed, moderate drift grip, responsive acceleration. | Tall stovepipe silhouette, crisp ribbon band, puffs clean white steam. |
| **The Heavy Bruiser** | **Bowler Hat / Derby** | **Heavy Ramming Tank**: High collision mass, resists spin-outs, slower acceleration but punches through traffic. | Rounded dome, low center of gravity, bulldog-like squinting eyes. |
| **The Nimble Drifter** | **Fez with Tassel** | **Agile Drift Specialist**: Lightweight, sharp turn-in, rapid boost recharge during long slides. | Conical silhouette, dynamic physics-driven tassel that whips around corners. |
| **The Defensive Brawler** | **Sombrero / Cowboy Hat** | **Area Control**: Wide brim acts as a physical shield against side-swipes and blocks narrow alleys. | Wide sweeping brim, braided cord, side-pipe exhausts. |
| **The High-RPM Scrapper** | **Flat Cap (Peaky Cap)** | **Agile Corner-Cutter**: Low-profile, tight turning radius, excels in dense urban alleyways. | Slanted low-drag roof, aggressive angled brows, dual copper zoomie pipes. |

---

## Customization & Personalization

Before races or in tournament lobbies, players personalize their racer:

| Element | Customization Options |
|---|---|
| **Hat Body Color** | Primary felt color (velvet red, midnight black, royal purple, tweed, houndstooth, etc.). |
| **Ribbon / Band Color** | Secondary accent color for the fabric ribbon around the crown. |
| **Eyewear & Eyes** | Classic googly eyes, monocle, aviator goggles, cartoon wink, angry brows. |
| **Topper Accessory** | Stackable mini-tophat, candle, feather plume, teacup, party horn. |
| **Steam Trail** | Color and style of exhaust particles (soot, rainbow steam, confetti, bubbles). |

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
  - A fresh, pristine hat drops down from the sky with a cartoon squeak or "plop".
  - Wheels pop out, and the player instantly regains control with brief invulnerability.

---

## Technical Implementation

Following [.agents/physics.md](file:///.agents/physics.md):
- **Node Type**: `CharacterBody3D` for tight, responsive arcade feel.
- **Center of Mass**: Artificially anchored to the ground plane below the brim to ensure tall hats drift cleanly without tipping over.
- **Physics Tuning**: Exposed as exported variables in a custom `VehicleStats.tres` Resource for live-tuning acceleration, grip, drift slip, and top speed without recompiling scripts.
