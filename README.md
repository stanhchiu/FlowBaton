# Baton Glow-Stick End-Cap Assembly

A 3D-printable end-cap system for majorette-style batons featuring an integrated glow-stick pocket, continuous carbon-fiber shaft through-hole, and a standardized **GPI 22-410 bottle neck finish** compatible with off-the-shelf commercial plastic bottle caps.

---

## 1. Directory Structure & Files

* **`code/`** (OpenSCAD Models):
  * **[end_cap.scad](file:///c:/workspaces/Baton/code/end_cap.scad)**: End-cap body with standard GPI 22-410 external threads ($T = 21.80\text{ mm}$, $E = 19.80\text{ mm}$, $\text{pitch} = 3.175\text{ mm}$, $\text{height} = 9.0\text{ mm}$), $8.30\text{ mm}$ continuous through-hole, $10.0\text{ mm}$ socket, and $25.8\text{ mm}$ collar.
  * **[drill_jig.scad](file:///c:/workspaces/Baton/code/drill_jig.scad)**: Screw-on centering drill jig featuring standard GPI 22-410 external threads, an elongated $35.0\text{ mm}$ guide neck for $11.0\text{ mm}$ shank bits, and a $14.85\text{ mm}$ head clearance pocket.
  * **[retaining_ring.scad](file:///c:/workspaces/Baton/code/retaining_ring.scad)**: 3D-printable retaining ring reference.

* **`exports/`** (Printable 3D Meshes):
  * **[end_cap.stl](file:///c:/workspaces/Baton/exports/end_cap.stl)**: Exported end-cap STL.
  * **[drill_jig.stl](file:///c:/workspaces/Baton/exports/drill_jig.stl)**: Exported drill jig STL.
  * **[retaining_ring.stl](file:///c:/workspaces/Baton/exports/retaining_ring.stl)**: Printable ring STL.

* **`print/`** (Slicer Projects & Settings):
  * **`end_cap.3mf`**: Creality Print project configured for printing the end-cap body in PETG.
  * **`drill_jig.3mf`**: Creality Print project for the screw-on drill jig.
  * **`retaining_ring.3mf`**: Slicer project for the retaining ring.
  * **[print_analysis.md](file:///c:/workspaces/Baton/print/print_analysis.md)**: Detailed mechanical, thermal, and printability analysis of the slicing parameters.

* **`scripts/`** (Automation & Synchronization):
  * **`scripts/sync_3mf.py`**: Automated pipeline tool that synchronizes 3D meshes in `print/*.3mf` directly from `exports/*.stl` while preserving all manual print settings.

---

## 2. Standard GPI 22-410 Specifications

| Parameter | Value | Description |
| :--- | :--- | :--- |
| **Finish Standard** | **GPI 22-410** | Glass Packaging Institute continuous thread standard |
| **Thread Major OD ($T$)** | **$21.80\text{ mm}$** | Nominal $21.84\text{ mm}$ with $0.04\text{ mm}$ clearance fit |
| **Neck Minor OD ($E$)** | **$19.80\text{ mm}$** | Neck wall diameter |
| **Neck Height** | **$9.00\text{ mm}$** | Clamps glow-stick flange firmly before cap bottoms out |
| **Thread Pitch** | **$3.175\text{ mm}$** ($8\text{ TPI}$) | Standard continuous thread pitch |
| **Collar Stop Diameter** | **$25.80\text{ mm}$** | Matches typical 22-410 cap outer skirt diameter |
| **Shaft Socket Depth** | **$10.00\text{ mm}$** | Compact, agile swing weight with continuous spine support |
| **Glow Stick Pocket ID** | **$14.85\text{ mm}$** | Clear diameter for $14.5\text{ mm}$ glow sticks |
| **Continuous Bore** | **$8.30\text{ mm}$** | Through-hole allows carbon rod to reinforce core into pocket |
| **Total Body Height** | **$27.00\text{ mm}$** | Sleek, compact profile |

---

## 3. Retaining Ring: Off-The-Shelf Bottle Cap Preparation

Using an injection-molded **22-410 Polypropylene (PP)** screw cap eliminates 3D-printed internal thread stringing and provides virtually indestructible impact resistance against concrete floor drops:

1. **Source a 22-410 Cap**: Available from travel bottles, 1 oz / 2 oz bottles, or in packs on Amazon / BottleStore.
2. **Drill Centering with [drill_jig.stl](file:///c:/workspaces/Baton/exports/drill_jig.stl)**:
   * Slide the jig over your drill bit shank ($11.0\text{ mm}$ body) so the wider cutting head ($13.0\text{ mm}$ to $14.5\text{ mm}$) rests inside the top clearance pocket.
   * Chuck the exposed bit shank into your hand drill or drill press.
   * Screw the un-drilled 22-410 cap firmly onto the jig's threaded male neck until seated against the collar.
   * Drill forward: clockwise rotation naturally tightens the cap against the shoulder stop while the long guide neck prevents bit wandering.
   * Unscrew the drilled cap from the jig.

---

## 4. Build & Synchronization Commands

Whenever modifying `.scad` files, compile STLs and synchronize the 3MF projects:

```powershell
# 1. Export STL meshes
& 'C:\Program Files\OpenSCAD\openscad.com' -o exports/end_cap.stl code/end_cap.scad
& 'C:\Program Files\OpenSCAD\openscad.com' -o exports/drill_jig.stl code/drill_jig.scad

# 2. Synchronize 3MF project archives
python scripts/sync_3mf.py
```
