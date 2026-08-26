// Baton Glow-Stick End-Cap Body (GPI 22-410 Bottle Neck Finish)
// Units: Millimeters (mm)
// Compatible with standard off-the-shelf 22-410 plastic bottle caps (drilled with a 13 mm hole)

$fn = 72;

// ==========================================
// User-Editable Parameters
// ==========================================

// Carbon shaft socket
shaft_od = 8.0;
shaft_socket_id = 8.30;
shaft_socket_depth = 10.0;

// Glow-stick pocket
glowstick_base_od = 14.5;
glowstick_pocket_id = 14.85;
glowstick_pocket_depth = 13;

body_wall = 2.75;

// Standard GPI 22-410 Bottle Neck Finish Parameters
thread_major_d = 21.80; // T dimension (nominal 21.84 mm with smooth clearance fit)
neck_minor_d = 19.80; // E dimension (neck wall diameter)
neck_height = 9; // Shortened neck height (9.5 mm) matching cap internal depth
thread_pitch = 3.175; // Standard 8 TPI continuous thread pitch
thread_start_offset = 1.20; // Distance from top lip down to start of thread

cap_collar_od = 25.80; // Outer stop collar diameter matching 22-410 cap skirt (increased +1.0mm)

// Calculated internal geometry
shoulder_thickness = 8.0; // Raised shoulder (+4.0 mm) to meet the shorter cap skirt
body_shaft_od = shaft_socket_id + 2 * body_wall; // 13.80 mm
thread_depth = (thread_major_d - neck_minor_d) / 2; // 1.00 mm

// Full-length thread extending down to the raised stop collar
thread_length = neck_height - thread_start_offset; // 9.30 mm (~2.9 full helical turns)

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

// Module: End Cap Body
module end_cap() {
  z_socket_top = shaft_socket_depth;
  z_collar_top = z_socket_top + shoulder_thickness;
  z_body_top = z_collar_top + neck_height;
  z_thread_start = z_collar_top; // Threads run all the way down to the raised collar shoulder

  difference() {
    union() {
      // 1. Lower sleeve over carbon shaft
      cylinder(d=body_shaft_od, h=z_socket_top - 4);

      // 2. Ergonomic transition taper from shaft sleeve to main body collar
      translate([0, 0, z_socket_top - 4])
        cylinder(r1=body_shaft_od / 2, r2=cap_collar_od / 2, h=4);

      // 3. Base collar cylinder (24.8 mm OD flat stop shoulder raised by 3mm)
      translate([0, 0, z_socket_top])
        cylinder(d=cap_collar_od, h=shoulder_thickness + 0.05);

      // 4. GPI 22-410 Neck Cylinder (E dimension = 19.80 mm, 10.5 mm height)
      translate([0, 0, z_collar_top])
        cylinder(d=neck_minor_d, h=neck_height);

      // 5. Shortened Helical Threads running down to raised collar shoulder
      translate([0, 0, z_thread_start])
        gpi_bottle_thread(
          d_major=thread_major_d,
          pitch=thread_pitch,
          length=thread_length,
          depth=thread_depth
        );
    }

    // 1. Full Continuous 8.30 mm Through-Hole from bottom all the way through to top
    // Allows the 8.0 mm carbon shaft to extend directly into the hollow glow-stick base
    translate([0, 0, -0.5])
      cylinder(d=shaft_socket_id, h=z_body_top + 1.0);
    translate([0, 0, -0.01])
      cylinder(r1=(shaft_socket_id / 2) + 0.5, r2=shaft_socket_id / 2, h=0.5);

    // 2. Glow-Stick Pocket (ID 14.85 mm, Depth 13.1 mm)
    // Leaves a 3.28 mm radial annular stop shoulder at the floor for the glow stick base rim
    translate([0, 0, z_body_top - glowstick_pocket_depth])
      cylinder(d=glowstick_pocket_id, h=glowstick_pocket_depth + 0.5);
    translate([0, 0, z_body_top - 0.6])
      cylinder(r1=glowstick_pocket_id / 2, r2=(glowstick_pocket_id / 2) + 0.6, h=0.61);

    // 3. Exposed edge chamfer at shaft entry
    translate([0, 0, -0.1])
      difference() {
        cylinder(r=body_shaft_od + 1, h=0.9);
        cylinder(r1=(body_shaft_od / 2) - 0.8, r2=body_shaft_od / 2, h=0.8);
      }

    // 4. Top sealing lip chamfer
    translate([0, 0, z_body_top - 0.8])
      difference() {
        cylinder(r=(neck_minor_d / 2) + 2, h=0.85);
        cylinder(r1=neck_minor_d / 2, r2=(neck_minor_d / 2) - 0.8, h=0.8);
      }
  }
}

// Render end cap
end_cap();
