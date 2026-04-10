# Phase 1: Land of Darkness - Static Components (Godot 4)

## Context

We're building a 3D first-person game set in the **Land of Darkness** from Pajama Sam. The world layout follows the **Spatial Bible and Room Registry** (49 rooms, 9 biomes, 12 streaming zones). The visual style is **dark base + rich accents** — faithful to Pajama Sam's nighttime ambiance with modern quality inspired by High on Life (minimalist stylized geometry, clean surfaces, atmospheric lighting, post-processing).

Phase 1 focuses on the **house and its immediate surroundings** — streaming zones Z03, Z10, Z11, Z12 — plus the FPS controller and environment system.

**Engine**: Godot 4 (forward_plus renderer)
**Geometry**: CSG nodes only (no external 3D models)
**Textures**: Procedural shaders only (no external images)
**Camera**: First-person (FPS-style)

### Design Documents (in `design/`)
- `Land_of_Darkness_Biome_and_Systems_Supplement.docx` — Spatial Bible reference
- `Land_of_Darkness_Continuation_Plan_v2.txt` — Status and next steps
- `land_of_darkness_room_registry_enriched.csv` — All 49 rooms with biome/zone assignments
- `land_of_darkness_biome_matrix.csv` — 9 biome families with mood/lighting/material specs
- `land_of_darkness_streaming_zones.csv` — 12 zones with load/unload rules

### Key Design Decisions (from docs)
- **Dual-label naming**: Stable IDs (LOD_R37_ENTRY_HALL) for production, source-faithful labels for reference
- **The house is a TREE-HOUSE** (B09: Tree-House Interior) — elevated, accessed by pulley lift
- **Z03 is the persistent anchor** — Central Hub always loaded
- **House progresses from domestic to surreal** — Entry Hall feels normal, Weird Hallway breaks expectations, Bedroom is intimate

---

## Phase 1 Scope: Rooms to Build

### Z03 — Central Hub and House Base (B03: Crossroads Clearing)
| Room ID | Name | Editor Name | Role |
|---------|------|-------------|------|
| R07 | Central Crossroads | LOD_R07_CENTRAL_CROSSROADS | Main orientation hub, forked paths |
| R08 | House Lift Base | LOD_R08_HOUSE_LIFT_BASE | Ground-level arrival, pulley basket |

### Z10 — House Platform and Lower Domestic Floor (B08/B09)
| Room ID | Name | Editor Name | Role |
|---------|------|-------------|------|
| R36 | House Exterior Lift Top | LOD_R36_HOUSE_EXTERIOR_LIFT_TOP | Tree-house platform, moonlit overlook |
| R37 | Entry Hall | LOD_R37_ENTRY_HALL | First interior hub (kitchen, living room, stairs) |
| R38 | Kitchen | LOD_R38_KITCHEN | Domestic work room, oversized fridge, dumbwaiter |
| R39 | Living Room | LOD_R39_LIVING_ROOM | Social room, couch focus, dance-floor energy |
| R40 | Stair Landing / Doors of Knowledge | LOD_R40_STAIR_LANDING_DOORS_OF_KNOWLEDGE | Mid-house junction, Wink & Blink threshold |

### Z11 — House Mid Stack and Service Spine (B09)
| Room ID | Name | Editor Name | Role |
|---------|------|-------------|------|
| R41 | Weird Hallway | LOD_R41_WEIRD_HALLWAY | Surreal back corridor, skewed geometry |
| R42 | Music Room | LOD_R42_MUSIC_ROOM | Organ, bust, chandelier, theatrical blue tone |
| R43 | Library | LOD_R43_LIBRARY | Tall shelves, book wall, secret mechanism |
| R44 | Secret Bookcase Passage | LOD_R44_SECRET_BOOKCASE_PASSAGE | Hidden connector, narrow, exposed back-of-house |
| R45 | Lower Junction | LOD_R45_LOWER_JUNCTION | Service hub linking library passage, lab, mines |
| R46 | Laboratory | LOD_R46_LABORATORY | Potion setup, colored bottles, dumbwaiter shaft |

### Z12 — House Upper Private Rooms (B09)
| Room ID | Name | Editor Name | Role |
|---------|------|-------------|------|
| R47 | Bedroom Landing | LOD_R47_BEDROOM_LANDING | Quiet transition, strong bedroom door read |
| R48 | Darkness's Bedroom | LOD_R48_DARKNESSS_BEDROOM | Private bedroom, gentle mood, closet door focus |
| R49 | Darkness's Closet | LOD_R49_DARKNESSS_CLOSET | Tiny finale room, intimate final reveal |

**Total: 15 rooms** (2 exterior hub + 1 platform + 12 interior)

---

## Project Structure

```
project.godot
.gitignore
design/                                 # Design documents (reference only)
  Land_of_Darkness_Biome_and_Systems_Supplement.docx
  Land_of_Darkness_Continuation_Plan_v2.txt
  land_of_darkness_room_registry_enriched.csv
  land_of_darkness_biome_matrix.csv
  land_of_darkness_streaming_zones.csv
scenes/
  main.tscn                             # Entry point
  main.gd                              # Mouse capture, escape toggle
  player/
    player.tscn                         # FPS CharacterBody3D
    player.gd                           # WASD + mouse look + jump
  zones/
    z03_central_hub/
      r07_central_crossroads.tscn       # Forked paths, path signs
      r08_house_lift_base.tscn          # Pulley basket, rock counterweight
    z10_house_lower/
      r36_house_exterior_lift_top.tscn  # Platform, rope, moonlit overlook
      r37_entry_hall.tscn               # Foyer hub linking kitchen/living/stairs
      r38_kitchen.tscn                  # Oversized fridge, counters, dumbwaiter
      r39_living_room.tscn              # Couch, open central floor, dance energy
      r40_stair_landing.tscn            # Doors of Knowledge, stair split
    z11_house_mid/
      r41_weird_hallway.tscn            # Skewed geometry, off-kilter layout
      r42_music_room.tscn               # Organ wall, bust, chandelier
      r43_library.tscn                  # Tall shelves, book wall, secret spot
      r44_secret_bookcase_passage.tscn  # Narrow hidden connector
      r45_lower_junction.tscn           # Service hub, dual-door landing
      r46_laboratory.tscn               # Potions, bottles, machinery
    z12_house_upper/
      r47_bedroom_landing.tscn          # Narrow upper landing
      r48_darknesss_bedroom.tscn        # Gentle bedroom, closet door
      r49_darknesss_closet.tscn         # Tiny finale chamber
  assembly/
    house_of_darkness.tscn              # Instances all house rooms at correct positions
    central_hub.tscn                    # Instances Z03 rooms
shaders/
  stylized_pbr.gdshader                 # Main toon-PBR shader (DONE)
  emissive_glow.gdshader                # Emissive accents (DONE)
  sky_night.gdshader                    # Procedural night sky (DONE)
materials/
  biome_b03/                            # Crossroads Clearing materials
    ground_packed_earth.tres
    path_dirt.tres
    root_wood.tres
    sign_post.tres
    lift_hardware.tres
  biome_b08/                            # Canopy House Exterior materials
    bark_surface.tres
    rope.tres
    plank_platform.tres
    exterior_lamp.tres
  biome_b09/                            # Tree-House Interior materials
    interior_wood.tres
    rug_carpet.tres
    furniture_wood.tres
    furniture_fabric.tres
    brass_hardware.tres
    book_surface.tres
    laboratory_glass.tres
    organ_pipe.tres
    curtain.tres
  emissive/
    emissive_warm.tres                  # Fireplaces, lamps, candles
    emissive_cool.tres                  # Ethereal blue-purple, globe, lab glow
    emissive_fire.tres                  # Fireplace orange
    emissive_window_spill.tres          # Warm window light
```

---

## Biome Material Specs (from biome_matrix.csv)

### B03 — Crossroads Clearing
- **Mood**: Orientation and decision-making; open, legible, slightly theatrical
- **Lighting**: Balanced moonlit key with soft fill to preserve silhouettes
- **Materials**: Packed earth, roots, sign-like path forks, lift hardware, mailbox details
- **Landmark rule**: Darkness's house must dominate the skyline from nearly every angle

### B08 — Canopy House Exterior
- **Mood**: Perched threshold between open landscape and tree-house interior
- **Lighting**: Moonlit exterior platform with warm window spill from inside
- **Materials**: Bark, rope, pulley hardware, plank platform, exterior lamp details
- **Landmark rule**: Platform is a reveal vantage; house facade dominant

### B09 — Tree-House Interior
- **Mood**: Starts domestic, becomes whimsical-surreal, ends intimate/private
- **Lighting**: Warm interior pools against dark negative space; upper rooms get stranger selective color
- **Materials**: Interior wood, rugs, furniture, books, brass, laboratory glass, organ pipes, curtains
- **Landmark rule**: Every floor needs one anchor object that reads from the entry sightline

---

## House Vertical Layout (Tree-House)

The house is built INSIDE and AROUND a giant tree. Rooms stack vertically.

```
                    Z12: UPPER PRIVATE (y=12m)
                    ┌─────────────────┐
                    │ R49 Closet      │ ← Tiny, intimate
                    │ R48 Bedroom     │ ← Gentle, personal
                    │ R47 Landing     │ ← Quiet threshold
                    └────────┬────────┘
                             │ stairs
                    Z11: MID STACK (y=8m)
                    ┌────────┴────────┐
                    │ R46 Laboratory  │ ← Technical, potions
                    │ R45 Lower Junct │ ← Service hub (→mines)
                    │ R44 Secret Pass │ ← Narrow, hidden
                    │ R43 Library     │ ← Tall shelves, secrets
                    │ R42 Music Room  │ ← Theatrical blue tone
                    │ R41 Weird Hall  │ ← Surreal, skewed
                    └────────┬────────┘
                             │ Doors of Knowledge
                    Z10: LOWER DOMESTIC (y=0)
                    ┌────────┴────────┐
        Lift → R36  │ R40 Stair Land  │
        Platform    │ R39 Living Room │ ← Open, dance floor
                    │ R38 Kitchen     │ ← Oversized, domestic
                    │ R37 Entry Hall  │ ← Hub, dollhouse-clear
                    └────────┬────────┘
                             │ lift down
                    Z03: GROUND LEVEL (y=-15m)
                    ┌────────┴────────┐
                    │ R08 Lift Base   │ ← Pulley, counterweight
                    │ R07 Crossroads  │ ← Main hub, path forks
                    └─────────────────┘
```

### Room Dimensions (interior-compressed per registry)
- **R07 Central Crossroads**: 20m x 20m open clearing (exterior)
- **R08 House Lift Base**: 8m x 8m area around the tree trunk base
- **R36 Lift Top Platform**: 6m x 6m bark platform
- **R37 Entry Hall**: 6m x 5m, ceiling 3.5m — "dollhouse-clear" circulation
- **R38 Kitchen**: 5m x 5m, ceiling 3.5m — oversized fridge, counters
- **R39 Living Room**: 6m x 5m, ceiling 3.5m — open central floor
- **R40 Stair Landing**: 4m x 4m, ceiling 4m — junction with doors
- **R41 Weird Hallway**: 3m x 8m, ceiling varies (2.5-4m) — skewed geometry
- **R42 Music Room**: 5m x 5m, ceiling 5m — taller for organ wall
- **R43 Library**: 5m x 6m, ceiling 5m — tall shelves
- **R44 Secret Passage**: 1.5m x 4m, ceiling 2.5m — narrow, compressed
- **R45 Lower Junction**: 3m x 3m, ceiling 3m — compact dual-door landing
- **R46 Laboratory**: 5m x 5m, ceiling 3.5m — potion workspace
- **R47 Bedroom Landing**: 2m x 3m, ceiling 3m — narrow threshold
- **R48 Darkness's Bedroom**: 5m x 5m, ceiling 3.5m — gentle, personal
- **R49 Darkness's Closet**: 2m x 2m, ceiling 2.5m — intentionally tiny

Wall height: 3-5m per room, wall thickness: 0.3m, tree-house feel: slightly organic shapes where possible.

---

## CSG Construction Pattern

Same as before — CSGCombiner3D with use_collision=true per room. For the tree-house feel:
- Walls can be slightly non-rectangular (rotated 1-2 degrees) in surreal rooms
- Use CSGCylinder3D for the central tree trunk visible in some rooms
- Bark/wood textures via the B09 materials

### Doorway cutting approach
Each wall is a CSGCombiner3D with operation=SUBTRACTION. First child is solid wall, subsequent children are cutout shapes positioned where doors should be.

---

## Lighting Strategy (per biome spec)

### B03 Exterior (Crossroads, Lift Base)
- DirectionalLight3D: Moonlight `Color(0.6, 0.65, 0.9)`, energy 0.3
- "Balanced moonlit key with soft fill to preserve silhouettes"
- Soft ambient fill `Color(0.05, 0.04, 0.08)`, energy 0.2

### B08 Exterior Platform (Lift Top)
- Moonlit key + warm window spill from house interior
- OmniLight3D near windows: warm `Color(0.9, 0.7, 0.4)`, energy 0.6

### B09 Interior — Lower Domestic (R37-R40)
- "Warm interior pools against dark negative space"
- Per-room OmniLight3D: warm `Color(0.95, 0.8, 0.6)`, energy 0.8-1.2
- Kitchen brighter, Entry Hall welcoming, Living Room social/warm

### B09 Interior — Mid Stack Surreal (R41-R46)
- "Upper rooms get stranger selective color"
- R41 Weird Hallway: off-angle SpotLights, slight purple tint
- R42 Music Room: theatrical blue `Color(0.3, 0.4, 0.8)`, energy 0.6
- R43 Library: warm desk lamp + ambient
- R46 Laboratory: colored bottle glow, emissive accents `Color(0.2, 0.8, 0.5)`

### B09 Interior — Upper Private (R47-R49)
- "Quietest acoustic zone; minimal prop density"
- Softer, gentler lighting: `Color(0.9, 0.8, 0.7)`, energy 0.5
- R48 Bedroom: intimate warmth, NOT villainous
- R49 Closet: single soft light, safe feeling

### Post-Processing (WorldEnvironment)
- Bloom: threshold 0.6, intensity 0.5
- Tonemap: ACES, exposure 0.8 (slightly underexposed for moodiness)
- SSAO: radius 1.0, intensity 2.0
- Volumetric fog: `Color(0.03, 0.02, 0.06)`, density 0.015
- Ambient: `Color(0.05, 0.04, 0.08)` very low

---

## Implementation Order

| Step | Files | Description |
|------|-------|-------------|
| 1 | `project.godot`, `.gitignore` | DONE |
| 2 | Shaders (3 files) | DONE |
| 3 | Move design files to `design/`, add `.vs/` to `.gitignore` | Organize repo |
| 4 | Biome materials (B03, B08, B09 + emissives) | ~18 material .tres files |
| 5 | `player.tscn` + `player.gd` | FPS controller |
| 6 | `main.tscn` + `main.gd` | WorldEnvironment, moonlight, player spawn |
| 7 | R37 Entry Hall | First room — validates CSG pattern + tree-house feel |
| 8 | R38 Kitchen, R39 Living Room | Lower domestic rooms |
| 9 | R40 Stair Landing | Junction connecting lower to mid |
| 10 | R41 Weird Hallway, R42 Music Room | Surreal transition |
| 11 | R43 Library, R44 Secret Passage | Knowledge wing |
| 12 | R45 Lower Junction, R46 Laboratory | Service spine |
| 13 | R47 Bedroom Landing, R48 Bedroom, R49 Closet | Upper private rooms |
| 14 | R36 House Exterior Lift Top | Platform and tree exterior |
| 15 | R07 Central Crossroads, R08 House Lift Base | Ground-level hub |
| 16 | `house_of_darkness.tscn`, `central_hub.tscn` | Assembly scenes |
| 17 | Lighting pass across all scenes | Tune per biome specs |

---

## Verification

1. Open in Godot 4.3+, press F5 — spawn at Entry Hall
2. Navigate all 15 rooms — verify doorway connectivity
3. Visual progression: domestic (lower) → surreal (mid) → intimate (upper)
4. Climb stairs through all three house floors
5. Exit to platform, ride lift concept to crossroads
6. Biome mood check: each zone should feel distinct
7. Performance: smooth 60fps with CSG geometry
8. Every floor has one anchor object readable from entry sightline (per B09 rule)
