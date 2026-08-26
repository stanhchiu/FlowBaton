# Project Preferences & Guidelines

## Directory Layout
- **`code/`**: OpenSCAD `.scad` model files (e.g., `code/end_cap.scad`, `code/retaining_ring.scad`, `code/drill_jig.scad`).
- **`exports/`**: 3D printable `.stl` export files (e.g., `exports/end_cap.stl`, `exports/retaining_ring.stl`, `exports/drill_jig.stl`).
- **`print/`**: Slicer project files (`.3mf`) and slicing/print analysis documentation.
- **`scripts/`**: Build and synchronization scripts (e.g., `scripts/sync_3mf.py`).
- **Images**: Do not generate PNG preview renders unless explicitly requested.

## 3D Modeling & Build Pipeline
- **Separate Part Files**: Always keep each physical part in its own separate, self-contained `.scad` file in `code/`. Do not create combined multi-part validation or assembly files unless explicitly requested.
- **Automatic STL Exports**: Always compile and export matching `.stl` files into `exports/` whenever `.scad` files are created or updated using OpenSCAD CLI:
  `& 'C:\Program Files\OpenSCAD\openscad.com' -o exports/<part>.stl code/<part>.scad`
- **Automatic 3MF Synchronization**: Always run `python scripts/sync_3mf.py` whenever `.stl` files are exported or modified. This script automatically updates all internal referenced mesh models (`3D/Objects/*.model`), build transforms, and metadata in `print/*.3mf` while keeping all user print settings, temperatures, and plate configurations 100% intact.
- **Directly Printable / Export-Ready**: Each `.scad` file should define its own required parameters and call its primary module at the root level so it can be previewed (F5), rendered (F6), and exported to STL independently.
- **Design Conventions**:
  - Units: Millimeters (mm).
  - Geometry: Clean through-holes where specified; avoid micro vent/ejection holes or central protrusions unless requested.
  - Performance: Optimize mesh slices for thread generation so OpenSCAD renders smoothly and exports quickly.

## Slicing & 3MF Configuration
- **Supports Configuration**: Keep supports configured according to model requirements (`tree(auto)`, on build plate only where applicable).
- **Resolution & Quality**: Maintain `0.16 mm` layer height, `z_hop = 0`, and `aligned_back` seam placement for optimal thread engagement.
