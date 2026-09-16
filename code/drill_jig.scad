// Bottle Cap Screw-On Centering Drill Jig (GPI 22-410 Mandrel Finish)
// Units: Millimeters (mm)
// Compatible with standard off-the-shelf 22-410 plastic bottle caps
// Guides an 11 mm shank drill bit with a wider cutting head (up to 14.5 mm)
// Cap screws directly onto the jig's GPI 22-410 male neck for secure retention

$fn = 72;

// ==========================================
// User-Editable Parameters
// ==========================================

// Drill Bit Dimensions
drill_shank_od = 11.0;            // Main body / shank diameter of drill bit (11.0 mm)
drill_guide_clearance = 0.25;     // Diametral clearance for smooth rotation and axial slide
drill_head_pocket_id = 14.85;     // Pocket ID accommodating wider cutting heads (13.0 mm, 1/2", up to 14.5 mm)
drill_head_pocket_depth = 14.0;   // Depth of the head clearance pocket

// Elongated Guide Neck
neck_length = 35.0;               // Elongated guide neck to align drill shank and prevent tilt
neck_wall_thickness = 3.5;        // Sturdy sleeve wall thickness
taper_height = 4.0;               // Transition taper height to collar
shoulder_thickness = 6.0;         // Solid stop collar thickness

// Standard GPI 22-410 Bottle Neck Finish Parameters (Matching end_cap.scad)
thread_major_d = 21.80;           // T dimension (nominal 21.84 mm with smooth clearance fit)
neck_minor_d = 19.80;             // E dimension (neck wall diameter)
neck_height = 9.0;                // Standard neck height matching cap internal depth
thread_pitch = 3.175;             // Standard 8 TPI continuous thread pitch
thread_start_offset = 1.20;       // Distance from top lip down to start of thread
cap_collar_od = 25.80;            // Outer stop collar diameter matching 22-410 cap skirt

// ==========================================
// Calculated Dimensions
// ==========================================

guide_id = drill_shank_od + drill_guide_clearance; // 11.25 mm
neck_od = guide_id + 2 * neck_wall_thickness;      // 18.25 mm
thread_depth = (thread_major_d - neck_minor_d) / 2; // 1.00 mm
thread_length = neck_height - thread_start_offset; // 7.80 mm

// Helper function for rounded/trapezoidal bottle thread bead profile
function bottle_thread_radius(angle, r_max, depth) =
  let (a = ( (angle % 360) + 360) % 360) (a < 120) ? (r_max - depth)
  : (a < 180) ? ( (r_max - depth) + depth * (a - 120) / 60)
  : (a < 300) ? r_max
  : (a < 360) ? (r_max - depth * (a - 300) / 60)
  : (r_max - depth);

// Module: External GPI Bottle Thread Generator
module gpi_bottle_thread(d_major, pitch, length, depth) {
  r_max = d_major / 2;
  n_pts = 72;

  linear_extrude(height=length, twist=-360 * (length / pitch), slices=ceil(length * 8), convexity=10)
    polygon([for (i = [0:n_pts - 1]) let (ang = i * 360 / n_pts, r = bottle_thread_radius(ang, r_max, depth)) [r * cos(ang), r * sin(ang)]]);
}

// Module: Drill Jig Body
module drill_jig() {
  z_neck_end = neck_length;
  z_taper_end = z_neck_end + taper_height;
  z_collar_top = z_taper_end + shoulder_thickness;
  z_body_top = z_collar_top + neck_height;
  z_thread_start = z_collar_top;

  difference() {
    union() {
      // 1. Elongated Guide Neck (guides 11 mm drill bit shank)
      cylinder(d=neck_od, h=z_neck_end);

      // 2. Smooth Transition Taper from Guide Neck to Collar
      translate([0, 0, z_neck_end])
        cylinder(r1=neck_od / 2, r2=cap_collar_od / 2, h=taper_height);

      // 3. Stop Collar (provides solid register plane for cap skirt)
      translate([0, 0, z_taper_end])
        cylinder(d=cap_collar_od, h=shoulder_thickness + 0.05);

      // 4. GPI 22-410 Neck Cylinder
      translate([0, 0, z_collar_top])
        cylinder(d=neck_minor_d, h=neck_height);

      // 5. Helical External Threads running down to collar shoulder
      translate([0, 0, z_thread_start])
        gpi_bottle_thread(
          d_major=thread_major_d,
          pitch=thread_pitch,
          length=thread_length,
          depth=thread_depth
        );
    }

    // 1. Continuous 11.25 mm Guide Bore from bottom through neck
    translate([0, 0, -0.5])
      cylinder(d=guide_id, h=z_body_top + 1.0);

    // Shank insertion bottom lead-in funnel chamfer
    translate([0, 0, -0.01])
      cylinder(r1=(guide_id / 2) + 0.8, r2=guide_id / 2, h=0.8);

    // 2. Head Clearance Pocket (14.85 mm ID x 14.0 mm depth from top)
    translate([0, 0, z_body_top - drill_head_pocket_depth])
      cylinder(d=drill_head_pocket_id, h=drill_head_pocket_depth + 0.5);

    // Conical transition from 11.25 mm guide bore to 14.85 mm head pocket
    translate([0, 0, z_body_top - drill_head_pocket_depth - 1.0])
      cylinder(r1=guide_id / 2, r2=drill_head_pocket_id / 2, h=1.01);

    // Top lip lead-in chamfer for pocket mouth
    translate([0, 0, z_body_top - 0.6])
      cylinder(r1=drill_head_pocket_id / 2, r2=(drill_head_pocket_id / 2) + 0.6, h=0.61);

    // 3. Bottom Outer Neck Chamfer
    translate([0, 0, -0.1])
      difference() {
        cylinder(r=neck_od + 1, h=0.9);
        cylinder(r1=(neck_od / 2) - 0.8, r2=neck_od / 2, h=0.8);
      }

    // 4. Top Thread Neck Outer Lip Chamfer
    translate([0, 0, z_body_top - 0.8])
      difference() {
        cylinder(r=(neck_minor_d / 2) + 2, h=0.85);
        cylinder(r1=neck_minor_d / 2, r2=(neck_minor_d / 2) - 0.8, h=0.8);
      }
  }
}

// Render drill jig
drill_jig();
