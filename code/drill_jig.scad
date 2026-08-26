// Bottle Cap Centering Drill Jig (For 22-410 / 25.6 mm OD Caps)
// Units: Millimeters (mm)
// Designed to hold a 25.6 mm OD x 12.35 mm tall bottle cap firmly centered for drilling a 13.0 mm (1/2") hole

$fn = 72;

// ==========================================
// User-Editable Parameters
// ==========================================

cap_od = 25.60;              // Outer diameter of the bottle cap
cap_height = 12.35;          // Total height of the bottle cap

target_drill_diameter = 13.0; // Desired through-hole diameter (e.g. 13.0 mm or 1/2" / 12.7 mm)

drill_guide_clearance = 0.25; // Radial/diametral clearance for drill bit rotation
cap_pocket_clearance = 0.30;  // Slip-fit clearance for inserting/removing cap

jig_wall_thickness = 4.0;    // Sturdy outer wall thickness
guide_bushing_height = 12.0; // Tall guide bushing to prevent drill bit tilt/wandering

// ==========================================
// Calculated Dimensions
// ==========================================

pocket_id = cap_od + cap_pocket_clearance; // ~25.90 mm
guide_id = target_drill_diameter + drill_guide_clearance; // ~13.25 mm

jig_od = pocket_id + 2 * jig_wall_thickness; // ~33.90 mm
total_jig_height = cap_height + guide_bushing_height; // ~24.35 mm

// Module: Drill Jig
module drill_jig() {
  difference() {
    // 1. Main Octagonal / Ergonomic Clampable Body
    // Octagonal outer profile allows easy hand gripping or solid clamping in a bench vise
    cylinder(d = jig_od, h = total_jig_height, $fn = 8);

    // 2. Cap Socket Pocket (from bottom up)
    // The cap inserts from the bottom until its top face seats flat against the guide stop ceiling
    translate([0, 0, -0.1])
      cylinder(d = pocket_id, h = cap_height + 0.1);

    // Cap insertion bottom lead-in chamfer
    translate([0, 0, -0.01])
      cylinder(r1 = (pocket_id / 2) + 0.8, r2 = pocket_id / 2, h = 0.8);

    // 3. Precision Drill Guide Bushing Hole (through the upper guide ceiling)
    translate([0, 0, cap_height - 0.1])
      cylinder(d = guide_id, h = guide_bushing_height + 0.5);

    // Drill bit entry funnel / chamfer at the top
    translate([0, 0, total_jig_height - 1.5])
      cylinder(r1 = guide_id / 2, r2 = (guide_id / 2) + 1.5, h = 1.51);

    // 4. Dual Side Ejection & Chip Windows
    // Allows chip evacuation while drilling and lets you push the cap out easily with your finger
    for (ang = [0, 180]) {
      rotate([0, 0, ang])
        translate([0, 0, cap_height / 2])
          cube([jig_od + 2, 12, cap_height], center = true);
    }
  }
}

// Render Drill Jig
drill_jig();
