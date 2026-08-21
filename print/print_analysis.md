# 3D Print Settings & Strength Analysis (`baton.3mf`)

This document provides a detailed mechanical and printability analysis of the slicing parameters configured in **`print/baton.3mf`** (configured for a Creality Ender-3 V2 with a 0.4 mm nozzle).

---

## 1. Summary of Slicer Parameters in `baton.3mf`

| Parameter Category | Setting in `baton.3mf` | Status / Effect |
| :--- | :--- | :--- |
| **3D Models** | Updated to latest **M22×2** | Includes gap fix and removed vent holes |
| **Nozzle Diameter** | `0.4 mm` (Brass) | Standard resolution |
| **Layer Height** | **`0.16 mm`** (First layer: `0.20 mm`) | **Optimized for silky-smooth 60° thread flanks** |
| **Seam Position** | **`back`** *(Creality Print)* | **Prevents vertical ridge interference on threads** |
| **Supports** | **`Enabled (1)`** (`tree(auto)`) | **Enabled to satisfy slicer requirements** |
| **Wall Loops / Count** | `5 perimeters` (Outer: `0.42 mm` width) | High hoop strength (100% solid concentric rings) |
| **Wall Generator** | `Arachne` | Adaptive extrusion width |
| **Wall Print Sequence** | `Inner wall / Outer wall` | High dimensional accuracy |
| **Infill Density & Pattern** | `100%` (`zig-zag`) | Solid core / Maximum density |
| **Top & Bottom Shells** | `4 layers` top / `4 layers` bottom | Solid enclosing shells |
| **Nozzle Temperature** | `270 °C` (Initial: `270 °C`, Range: `260 - 270 °C`) | Maximum interlayer thermal bonding |
| **Bed Temperature (PEI)** | `85 °C` (Initial: `95 °C`) | Strong bed adhesion |
| **Part Cooling Fan** | `0%` (Fan OFF across all layers) | Maximum interlayer fusion (PETG/ASA/Nylon) |

---

## 2. Mechanical & Strength Evaluation

### A. Hoop Strength & Thread Torque Resistance: **Exceptional**
* **5 Solid Perimeters (`wall_loops = 5`)**: With an extrusion width of $0.42\text{ mm}$, 5 perimeters yield approximately **$2.1\text{ mm}$ of pure concentric perimeter loops**.
* For the M22×2 end-cap with a root wall thickness of **$2.71\text{ mm}$**, having 5 outer walls and 5 inner walls means the **entire threaded cylinder is composed of 100% concentric extruded rings**.
* **Mechanical Benefit**: Concentric loops align the plastic polymer chains along the circumferential direction—exactly where tensile hoop stresses act when the retaining ring is torqued down. This virtually eliminates thread stripping.

### B. Interlayer Adhesion & Z-Axis Tensile Strength: **Maximum Possible for FDM**
* **Extrusion Temperature at $270\text{ °C}$**: High thermal energy allows maximum polymer chain entanglement across layer boundaries, significantly raising Z-axis layer adhesion.
* **Part Cooling Fan at $0\%$**: Completely disabling part cooling ensures the newly deposited molten bead stays above its glass transition temperature long enough to fuse with the previous layer, yielding nearly **isotropic strength** (approaching injection-molded durability in high-temp materials like PETG, ASA, ABS, or Nylon).

### C. Core Impact & Drop Resistance: **Maximum (100% Solid Infill)**
* **100% Solid Density**: Zero internal voids prevent point-load crushing when the baton strikes hard ground.
* Under heavy baton drops, solid infill distributes impact shock waves evenly into the carbon-fiber shaft rather than buckling internal infill cells.

---

## 3. Printability & Applied Optimizations

### A. Thread Flank Resolution (Layer Height: `0.16 mm`)
* Lowered from $0.20\text{ mm}$ to **$0.16\text{ mm}$**, dividing the $2.0\text{ mm}$ thread pitch into **$12.5\text{ layers per turn}$** (a 25% increase in resolution).
* **Result**: Produces significantly smoother 60° thread flanks, drastically lowering rotational friction when threading the retaining ring on and off.

### B. Support Material (Enabled: `enable_support = 1`, `tree(auto)`)
* Tree supports are enabled to satisfy slicer pre-conditions. Because the geometry uses $\le 45^\circ$ self-supporting internal chamfers, tree supports will only generate minimal lightweight branches where strictly required.

### C. Z-Seam Placement (`seam_position = "back"`)
* Set to **`back`** (Creality Print equivalent of rear) to distribute/relocate seam starts away from the front thread mating crests.
* **Tip**: Any tiny residual micro-burr from the seam will be automatically burnished smooth by a single full rotation of the retaining ring upon first assembly.
