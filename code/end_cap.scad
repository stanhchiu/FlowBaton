// Baton Glow-Stick End-Cap Body
// Units: Millimeters (mm)

$fn = 72;

// ==========================================
// User-Editable Parameters
// ==========================================

shaft_od = 8.0;
shaft_socket_id = 8.30;
shaft_socket_depth = 30;

glowstick_base_od = 14.5;
glowstick_pocket_id = 14.85;
glowstick_pocket_depth = 13.1;

body_wall = 2.75;

// External Thread Parameters (M22 x 2.0 Printable Trapezoidal Profile)
thread_major_d = 22.0;
thread_pitch = 2.0;
thread_length = 10;

ring_outer_diameter = 26.5;

// Calculated internal geometry
shoulder_thickness = 4.0;
body_shaft_od = shaft_socket_id + 2 * body_wall; // 13.80 mm
body_base_od = glowstick_pocket_id + 2 * body_wall; // 20.35 mm
body_collar_od = ring_outer_diameter; // 26.5 mm

// Optimized 0.65 mm thread depth: wide, self-supporting 45-degree flank ramps with wide flat crests/roots
thread_depth = 0.65;

// Helper function for 3D-printable trapezoidal thread profile with 45-degree self-supporting flanks
function thread_radius(angle, r_max, depth) =
  let (a = ( (angle % 360) + 360) % 360) 
  (a < 60) ? (r_max - depth)
  : (a < 120) ? ( (r_max - depth) + depth * (a - 60) / 60)
  : (a < 240) ? r_max
  : (a < 300) ? (r_max - depth * (a - 240) / 60)
  : (r_max - depth);

// Module: External Thread Generator
module external_thread(d_major, pitch, length, depth, clearance = 0) {
  r_max = (d_major / 2) - clearance;
  n_pts = 72;

  linear_extrude(height=length, twist=-360 * (length / pitch), slices=ceil(length * 8), convexity=10)
    polygon([for (i = [0:n_pts - 1]) let (ang = i * 360 / n_pts, r = thread_radius(ang, r_max, depth)) [r * cos(ang), r * sin(ang)]]);
}

// Module: End Cap Body
module end_cap() {
  z_socket_top = shaft_socket_depth;
  z_pocket_bottom = z_socket_top + shoulder_thickness;
  z_body_top = z_pocket_bottom + glowstick_pocket_depth;
  z_thread_start = z_body_top - thread_length;
  h_collar = shoulder_thickness + (glowstick_pocket_depth - thread_length);

  difference() {
    union() {
      // Lower sleeve over carbon shaft
      cylinder(d=body_shaft_od, h=z_socket_top - 4);

      // Ergonomic transition taper from shaft sleeve to main body collar
      translate([0, 0, z_socket_top - 4])
        cylinder(r1=body_shaft_od / 2, r2=body_collar_od / 2, h=4);

      // Base collar cylinder below thread (26.5 mm OD flat stop shoulder for retaining ring)
      translate([0, 0, z_socket_top])
        cylinder(d=body_collar_od, h=h_collar + 0.05);

      // External M22 x 2 printable helical thread
      translate([0, 0, z_thread_start])
        external_thread(
          d_major=thread_major_d,
          pitch=thread_pitch,
          length=thread_length,
          depth=thread_depth,
          clearance=0
        );
    }

    // 1. Shaft Socket / Through-Hole (ID 8.30 mm) through into the glow-stick pocket
    translate([0, 0, -0.1])
      cylinder(d=shaft_socket_id, h=z_pocket_bottom + 0.2);
    translate([0, 0, -0.01])
      cylinder(r1=(shaft_socket_id / 2) + 0.5, r2=shaft_socket_id / 2, h=0.5);

    // 2. Glow-Stick Pocket (ID 14.85 mm, Depth 13.1 mm) with top entry chamfer
    translate([0, 0, z_pocket_bottom])
      cylinder(d=glowstick_pocket_id, h=glowstick_pocket_depth + 0.5);
    translate([0, 0, z_body_top - 0.6])
      cylinder(r1=glowstick_pocket_id / 2, r2=(glowstick_pocket_id / 2) + 0.6, h=0.61);

    // 3. Exposed edge chamfer at shaft entry
    translate([0, 0, -0.1])
      difference() {
        cylinder(r=body_shaft_od + 1, h=0.9);
        cylinder(r1=(body_shaft_od / 2) - 0.8, r2=body_shaft_od / 2, h=0.8);
      }

    // 4. Thread top entry lead-in chamfer
    translate([0, 0, z_body_top - 0.8])
      difference() {
        cylinder(r=(thread_major_d / 2) + 2, h=0.85);
        cylinder(r1=thread_major_d / 2, r2=(thread_major_d / 2) - 0.8, h=0.8);
      }
  }
}

// Render end cap
end_cap();
