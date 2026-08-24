# Baton Glow-Stick End-Cap Assembly

A 3D-printable end-cap system for majorette-style batons featuring an integrated glow-stick pocket, continuous carbon-fiber shaft through-hole, and a standardized **GPI 22-410 bottle neck finish** compatible with off-the-shelf commercial plastic bottle caps.

---

## 1. Directory Structure & Files

* **`code/`** (OpenSCAD Models):
  * **[end_cap.scad](file:///c:/workspaces/Baton/code/end_cap.scad)**: End-cap body with standard GPI 22-410 external bottle threads ($T = 21.80\text{ mm}$, $E = 19.80\text{ mm}$, $\text{pitch} = 3.175\text{ mm}$), $8.30\text{ mm}$ shaft through-hole, and $24.8\text{ mm}$ collar.
  * **[retaining_ring.scad](file:///c:/workspaces/Baton/code/retaining_ring.scad)**: Printable retaining ring reference.

* **`exports/`** (Printable 3D Meshes):
  * **[end_cap.stl](file:///c:/workspaces/Baton/exports/end_cap.stl)**: Exported STL ready for slicing.
  * **[retaining_ring.stl](file:///c:/workspaces/Baton/exports/retaining_ring.stl)**: Printable ring STL.

* **`print/`** (Slicer Projects & Analysis):
  * **`end_cap.3mf`**: Creality Print project configured for printing the end-cap body in PETG.
  * **`retaining_ring.3mf`**: Slicer project for the retaining ring.
  * **[print_analysis.md](file:///c:/workspaces/Baton/print/print_analysis.md)**: Detailed mechanical, thermal, and printability analysis of the slicing parameters.

---

## 2. Standard GPI 22-410 Specifications

| Parameter | Value | Description |
| :--- | :--- | :--- |
| **Finish Standard** | **GPI 22-410** | Glass Packaging Institute continuous thread standard |
| **Thread Major OD ($T$)** | **$21.80\text{ mm}$** | Nominal $21.84\text{ mm}$ with $0.04\text{ mm}$ clearance fit |
| **Neck Minor OD ($E$)** | **$19.80\text{ mm}$** | Neck wall diameter |
| **Finish Height ($H$)** | **$14.50\text{ mm}$** | Standard 410 skirt depth |
| **Thread Pitch** | **$3.175\text{ mm}$** ($8\text{ TPI}$) | Standard continuous thread pitch |
| **Thread Turns** | **$1.5\text{ turns}$** ($540^\circ$) | Total thread helix engagement ($\approx 4.76\text{ mm}$ axial height) |
| **Thread Start Offset ($S$)** | **$1.50\text{ mm}$** | Distance from top sealing lip down to thread start |
| **Collar Stop Diameter** | **$24.80\text{ mm}$** | Matches typical 22-410 cap outer skirt diameter |
| **Glow Stick Pocket ID** | **$14.85\text{ mm}$** | Clear diameter for $14.5\text{ mm}$ glow sticks |
| **Root Wall Thickness** | **$2.48\text{ mm}$** | Minimum wall thickness at thread root ($\approx 6$ solid perimeters) |

---

## 3. Retaining Ring: Off-The-Shelf Bottle Cap Preparation

Using an injection-molded **22-410 Polypropylene (PP)** screw cap completely eliminates 3D-printed internal thread stringing and provides virtually indestructible impact resistance against concrete floor drops:

1. **Source a 22-410 Cap**:
   * Available from travel bottles, 1 oz / 2 oz bottles, or in packs on Amazon / BottleStore.
2. **Drill Retaining Hole**:
   * Using a **Step Drill Bit (Unibit)** or a sharp **$1/2\text{ inch}$ ($12.7 - 13.0\text{ mm}$)** drill bit, drill straight through the center top of the cap.
   * This leaves a sturdy $3.5\text{ mm}$ annular shoulder inside the cap that captures the glow-stick base flange while letting the glowing tube extend through.

---

## 4. Recommended 3D Print Settings (`end_cap.3mf`)

| Setting | Recommendation | Rationale |
| :--- | :--- | :--- |
| **Material** | **PETG** | High impact strength and interlayer bonding. |
| **Orientation** | Standing upright (Z-axis vertical). | Eliminates supports; bottle threads print cleanly without overhang artifacts. |
| **Layer Height** | **$0.16\text{ mm}$** ($0.20\text{ mm}$ first layer) | Smooth bottle thread bead surface. |
| **Nozzle Temperature** | **$240\text{ °C} - 245\text{ °C}$** | Optimal melt viscosity without excessive drooling. |
| **Bed Temperature** | **$85\text{ °C}$** (PEI) | Reliable bed adhesion. |
| **Part Cooling Fan** | **$35\%$** (Overhangs: $50\%$) | Freezes external thread beads cleanly. |
| **Z-Hop (Retract Lift)**| **`0 mm` (Disabled)** | Eliminates PETG stringing across perimeters. |
| **Seam Position** | **`aligned_back`** | Aligns seam neatly at the rear. |
| **Wall Loops** | **$5\text{ walls}$** | 100% solid concentric rings for drop durability. |

---

## 5. Assembly Instructions

1. **Shaft Bonding**: Apply 2-part epoxy or industrial adhesive inside the $8.30\text{ mm}$ socket of `end_cap` and slide it over the $8.0\text{ mm}$ carbon shaft until seated against the internal stop shoulder.
2. **Glow Stick Insertion**: Drop the standard $14.5\text{ mm}$ glow stick into the upper $14.85\text{ mm}$ pocket.
3. **Securing**: Screw the drilled 22-410 cap onto the body until it bottoms out against the $24.8\text{ mm}$ collar shoulder. The glow stick is securely locked in place with $0.30\text{ mm}$ of axial free play.
