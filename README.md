# Baton Glow-Stick End-Cap Assembly

A two-piece, 3D-printable end-cap system for majorette-style batons featuring an integrated glow-stick retention mechanism with an internal through-hole for an 8.0 mm carbon-fiber shaft.

---

## 1. Directory Structure & Files

* **`code/`** (OpenSCAD Models):
  * **[end_cap.scad](file:///c:/workspaces/Baton/code/end_cap.scad)**: End-cap body with M22×2 external threads, continuous shaft through-hole, and 26.5 mm collar.
  * **[retaining_ring.scad](file:///c:/workspaces/Baton/code/retaining_ring.scad)**: Retaining ring with internal M22×2 thread (+0.25 mm radial clearance), 11.7 mm retention lip, and 6 grip flutes.

* **`exports/`** (Printable 3D Meshes):
  * **[end_cap.stl](file:///c:/workspaces/Baton/exports/end_cap.stl)**: Exported STL ready for slicing.
  * **[retaining_ring.stl](file:///c:/workspaces/Baton/exports/retaining_ring.stl)**: Exported STL ready for slicing.

* **`print/`** (Slicer Project & Settings):
  * **`baton.3mf`**: Original Creality Print project archive containing plate layout and slicer settings.
  * **[print_analysis.md](file:///c:/workspaces/Baton/print/print_analysis.md)**: Detailed mechanical, thermal, and printability analysis of the slicing parameters.

---

## 2. Wall Thickness & Structural Analysis

Batons experience high centrifugal forces during twirling and high shock loads during floor drops. The wall thickness at the **thread root (valleys)** is the critical load-bearing section.

### Dimension Comparison Table

| Parameter | M20 × 2 (Original) | **M22 × 2 (Current Default)** | M24 × 2 (Heavy Duty) |
| :--- | :--- | :--- | :--- |
| **Pocket ID** | $14.85\text{ mm}$ | **$14.85\text{ mm}$** | $14.85\text{ mm}$ |
| **Thread Major OD (Crest)** | $20.00\text{ mm}$ | **$22.00\text{ mm}$** | $24.00\text{ mm}$ |
| **Thread Minor OD (Root)** | $18.27\text{ mm}$ | **$20.27\text{ mm}$** | $22.27\text{ mm}$ |
| **End-Cap Root Wall Thickness** | $1.71\text{ mm}$ (~4 perimeters) | **$2.71\text{ mm}$ (~6 perimeters)** | $3.71\text{ mm}$ (~8 perimeters) |
| **End-Cap Crest Wall Thickness** | $2.58\text{ mm}$ | **$3.58\text{ mm}$** | $4.58\text{ mm}$ |
| **Retaining Ring OD** | $25.50\text{ mm}$ | **$26.50\text{ mm}$** | $28.50\text{ mm}$ |
| **Ring Wall Thickness (Root)** | $1.75\text{ mm}$ | **$2.05\text{ mm}$** | $2.05\text{ mm}$ |
| **Drop / Impact Durability** | Moderate (prone to notch stress) | **High (optimal strength/weight)** | Maximum (bulky) |

---

## 3. How to Adjust Thread Size in the Future

If you want to scale the threads up or down, update the following parameters at the top of each file:

### To change in [end_cap.scad](file:///c:/workspaces/Baton/code/end_cap.scad):
```openscad
thread_major_d = 22.0;       // Set to 20.0 for M20, 22.0 for M22, 24.0 for M24
ring_outer_diameter = 26.5;  // Match to retaining ring OD (e.g., 25.5 for M20, 26.5 for M22, 28.5 for M24)
```

### To change in [retaining_ring.scad](file:///c:/workspaces/Baton/code/retaining_ring.scad):
```openscad
thread_major_d = 22.0;       // Match thread_major_d in end_cap.scad
ring_outer_diameter = 26.5;  // Match ring_outer_diameter in end_cap.scad
```

---

## 4. Recommended 3D Print Settings

| Setting | Recommendation | Rationale |
| :--- | :--- | :--- |
| **Material** | **PETG, ASA, ABS, or Nylon (PA-CF)** | High impact strength and interlayer bonding. Avoid standard brittle PLA for drop-resistance. |
| **Orientation** | Print both parts standing upright (Z-axis vertical). | Eliminates supports; thread profiles print cleanly without overhang artifacts. |
| **Layer Height** | **$0.16\text{ mm}$** ($0.20\text{ mm}$ first layer) | Fine layer height produces smooth, accurate 60° thread flanks. |
| **Perimeters / Walls** | **$5\text{ walls}$** | Ensures the threaded sections are 100% solid plastic for maximum hoop strength. |
| **Infill** | **$100\%$ (`zig-zag`)** | Solid core prevents compression under impact. |
| **Seam Position** | **`back`** *(Creality Print)* | Relocates seam start/stop points away from mating thread flanks. |
| **Supports** | **`tree(auto)` (Enabled)** | Enabled to satisfy slicer pre-conditions. |

---

## 5. Assembly Instructions

1. **Shaft Bonding**: Apply epoxy or polyurethane adhesive inside the 8.30 mm socket of `end_cap.scad` and slide it over the 8.0 mm carbon shaft until seated against the internal stop.
2. **Glow Stick Insertion**: Drop the standard 14.5 mm glow stick into the upper pocket until it rests against the stop shoulder.
3. **Securing**: Thread `retaining_ring.scad` onto the body until it bottoms out against the 26.5 mm collar. The glow stick will be locked in place with 0.30 mm of axial free play.
