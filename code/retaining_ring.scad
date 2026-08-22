// Baton Glow-Stick Retaining Ring
// Units: Millimeters (mm)

$fn = 72;

// ==========================================
// User-Editable Parameters
// ==========================================

// Internal Thread Parameters (M22 x 2.0 Printable Trapezoidal Profile)
thread_major_d = 22.0;
thread_pitch = 2.0;
thread_length = 10;
thread_clearance_radial = 0.40; // 0.40 mm radial clearance (0.80 mm diametral clearance for smooth FDM threading)

ring_outer_diameter = 26.5;
ring_inner_opening_id = 13.0;
ring_lip_thickness = 1.75;
axial_free_play = 0.30;

// Calculated internal geometry
// Optimized 0.65 mm thread depth: wide, self-supporting 45-degree flank ramps with wide flat crests/roots
thread_depth = 0.65;

// Helper function for 3D-printable trapezoidal thread profile with 45-degree self-supporting flanks
function thread_radius(angle, r_max, depth) =
  let (a = ( (angle % 360) + 360) % 360) (a < 60) ? (r_max - depth)
  : (a < 120) ? ( (r_max - depth) + depth * (a - 60) / 60)
  : (a < 240) ? r_max
  : (a < 300) ? (r_max - depth * (a - 240) / 60)
  : (r_max - depth);

// Module: Internal Thread Cutter (Right-Handed Internal Thread: positive twist)
module internal_thread_cutter(d_major, pitch, length, depth, clearance = 0) {
  r_max = (d_major / 2) + clearance;
  n_pts = 72;

  // Positive twist (+360) creates a right-handed internal thread matching the external right-handed thread
  linear_extrude(height=length, twist=360 * (length / pitch), slices=ceil(length * 8), convexity=10)
    polygon([for (i = [0:n_pts - 1]) let (ang = i * 360 / n_pts, r = thread_radius(ang, r_max, depth)) [r * cos(ang), r * sin(ang)]]);
}

// Module: Retaining Ring
module retaining_ring() {
  h_thread_cavity = thread_length + axial_free_play;
  ring_height = h_thread_cavity + ring_lip_thickness;
  n_ribs = 6;

  difference() {
    // Outer Ring Body
    cylinder(d=ring_outer_diameter, h=ring_height);

    // 1. Internal M22 x 2 Thread Cutter with 0.40 mm radial clearance
    translate([0, 0, -0.1])
      internal_thread_cutter(
        d_major=thread_major_d,
        pitch=thread_pitch,
        length=h_thread_cavity + 0.2,
        depth=thread_depth,
        clearance=thread_clearance_radial
      );

    // 2. Thread Entrance Conical Lead-in Chamfer
    translate([0, 0, -0.01])
      cylinder(
        r1=(thread_major_d / 2) + thread_clearance_radial + 0.8,
        r2=(thread_major_d / 2) - thread_depth + thread_clearance_radial,
        h=1.2
      );

    // 3. Centered Retaining Lip Opening (13.0 mm ID)
    translate([0, 0, h_thread_cavity - 0.1])
      cylinder(d=ring_inner_opening_id, h=ring_lip_thickness + 0.3);

    // 4. Smooth Chamfers on Lip Opening
    translate([0, 0, ring_height - 0.5])
      cylinder(r1=ring_inner_opening_id / 2, r2=(ring_inner_opening_id / 2) + 0.5, h=0.51);
    translate([0, 0, h_thread_cavity - 0.01])
      cylinder(r1=(ring_inner_opening_id / 2) + 0.5, r2=ring_inner_opening_id / 2, h=0.51);

    // 5. Six Evenly Spaced Shallow Vertical Grip Flutes / Ribs
    for (i = [0:n_ribs - 1]) {
      rotate([0, 0, i * 360 / n_ribs])
        translate([ring_outer_diameter / 2 + 1.2, 0, -0.1])
          cylinder(r=2.4, h=ring_height + 0.2);
    }

    // 6. Outer Exposed Edge Chamfers (top and bottom)
    // Top outer chamfer
    translate([0, 0, ring_height - 1.0])
      difference() {
        cylinder(r=ring_outer_diameter + 1, h=1.1);
        cylinder(r1=ring_outer_diameter / 2, r2=(ring_outer_diameter / 2) - 1.0, h=1.0);
      }
    // Bottom outer chamfer
    translate([0, 0, -0.1])
      difference() {
        cylinder(r=ring_outer_diameter + 1, h=0.9);
        cylinder(r1=(ring_outer_diameter / 2) - 0.8, r2=ring_outer_diameter / 2, h=0.8);
      }
  }
}

// Render retaining ring
retaining_ring();
