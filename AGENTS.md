# Project Preferences & Guidelines

## Directory Layout
- **`code/`**: OpenSCAD `.scad` model files (e.g., `code/end_cap.scad`, `code/retaining_ring.scad`).
- **`exports/`**: 3D printable `.stl` export files (e.g., `exports/end_cap.stl`, `exports/retaining_ring.stl`).
- **`print/`**: Slicer project files (`.3mf`) and slicing/print analysis documentation.
- **Images**: Do not generate PNG preview renders unless explicitly requested.

## 3D Modeling & Build Pipeline
- **Separate Part Files**: Always keep each physical part in its own separate, self-contained `.scad` file in `code/`. Do not create combined multi-part validation or assembly files unless explicitly requested.
- **Automatic STL Exports**: Always compile and export matching `.stl` files into `exports/` whenever `.scad` files are created or updated.
- **Automatic 3MF Synchronization**: Always update the embedded 3D mesh models inside `print/*.3mf` whenever the exported STL files are updated or modified.
- **Directly Printable / Export-Ready**: Each `.scad` file should define its own required parameters and call its primary module at the root level so it can be previewed (F5), rendered (F6), and exported to STL independently.
- **Design Conventions**:
  - Units: Millimeters (mm).
  - Geometry: Clean through-holes where specified; avoid micro vent/ejection holes or central protrusions unless requested.
  - Performance: Optimize mesh slices for thread generation so OpenSCAD renders smoothly and exports quickly.

## Slicing & 3MF Configuration
- **Supports Enabled**: Always keep support generation enabled (`enable_support = 1`, `tree(auto)`) in `print/*.3mf` project settings to satisfy slicing software requirements.
- **Resolution & Quality**: Maintain `0.16 mm` layer height and `rear` seam placement for optimal thread engagement.
