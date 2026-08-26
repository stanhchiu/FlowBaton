#!/usr/bin/env python3
"""
Robust 3MF Mesh Synchronization Tool for Creality Print / Bambu Studio 3MF Projects.
Synchronizes 3D mesh geometry in print/*.3mf directly from exports/*.stl while keeping
all user print settings, temperatures, and plate configurations 100% intact.
"""

import os
import re
import shutil
import tempfile
import zipfile

WORKSPACE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
EXPORTS_DIR = os.path.join(WORKSPACE_DIR, "exports")
PRINT_DIR = os.path.join(WORKSPACE_DIR, "print")


def parse_ascii_stl(stl_path):
    triangles = []
    current_tri = []
    with open(stl_path, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if line.startswith("vertex"):
                parts = line.split()
                if len(parts) >= 4:
                    x, y, z = float(parts[1]), float(parts[2]), float(parts[3])
                    current_tri.append((x, y, z))
                    if len(current_tri) == 3:
                        triangles.append(tuple(current_tri))
                        current_tri = []
    return triangles


def build_3mf_object_xml(triangles, object_id, uuid_str):
    all_x = [v[0] for tri in triangles for v in tri]
    all_y = [v[1] for tri in triangles for v in tri]
    all_z = [v[2] for tri in triangles for v in tri]

    min_x, max_x = min(all_x), max(all_x)
    min_y, max_y = min(all_y), max(all_y)
    min_z, max_z = min(all_z), max(all_z)

    cx = (min_x + max_x) / 2.0
    cy = (min_y + max_y) / 2.0
    cz = (min_z + max_z) / 2.0

    vertex_map = {}
    vertices = []
    tri_indices = []

    for tri in triangles:
        indices = []
        for v in tri:
            shifted = (round(v[0] - cx, 4), round(v[1] - cy, 4), round(v[2] - cz, 4))
            if shifted not in vertex_map:
                vertex_map[shifted] = len(vertices)
                vertices.append(shifted)
            indices.append(vertex_map[shifted])
        tri_indices.append(indices)

    xml = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        '<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" xmlns:BambuStudio="http://schemas.bambulab.com/package/2021" xmlns:p="http://schemas.microsoft.com/3dmanufacturing/production/2015/06" requiredextensions="p">',
        ' <metadata name="BambuStudio:3mfVersion">1</metadata>',
        ' <resources>',
        f'  <object id="{object_id}" p:UUID="{uuid_str}" type="model">',
        '   <mesh>',
        '    <vertices>',
    ]

    for v in vertices:
        xml.append(f'     <vertex x="{v[0]}" y="{v[1]}" z="{v[2]}"/>')

    xml.append('    </vertices>')
    xml.append('    <triangles>')

    for t in tri_indices:
        xml.append(f'     <triangle v1="{t[0]}" v2="{t[1]}" v3="{t[2]}"/>')

    xml.extend([
        '    </triangles>',
        '   </mesh>',
        '  </object>',
        ' </resources>',
        '</model>',
    ])

    half_h = (max_z - min_z) / 2.0
    return (
        "\n".join(xml),
        half_h,
        (max_x - min_x),
        (max_y - min_y),
        (max_z - min_z),
    )


def sync_single_3mf(stl_name, file_3mf_name):
    stl_path = os.path.join(EXPORTS_DIR, stl_name)
    file_3mf = os.path.join(PRINT_DIR, file_3mf_name)

    if not os.path.exists(stl_path):
        print(f"Warning: STL file {stl_path} does not exist, skipping.")
        return False
    if not os.path.exists(file_3mf):
        print(f"Warning: 3MF file {file_3mf} does not exist, skipping.")
        return False

    triangles = parse_ascii_stl(stl_path)
    if not triangles:
        print(f"Error: No triangles parsed from {stl_path}.")
        return False

    temp_dir = tempfile.mkdtemp()
    try:
        with zipfile.ZipFile(file_3mf, "r") as z:
            z.extractall(temp_dir)

        # Update all referenced .model files inside 3D/Objects/
        obj_dir = os.path.join(temp_dir, "3D", "Objects")
        half_h = 0.0
        dx = dy = dz = 0.0
        if os.path.exists(obj_dir):
            for f in os.listdir(obj_dir):
                if f.endswith(".model"):
                    f_path = os.path.join(obj_dir, f)
                    with open(f_path, "r", encoding="utf-8") as file:
                        c = file.read()
                    uuid_match = re.search(r'p:UUID="([^"]*)"', c)
                    uuid_str = (
                        uuid_match.group(1)
                        if uuid_match
                        else "00010000-81cb-4c03-9d28-80fed5dfa1dc"
                    )

                    id_match = re.search(r'<object id="([^"]*)"', c)
                    obj_id = id_match.group(1) if id_match else "1"

                    obj_xml, half_h, dx, dy, dz = build_3mf_object_xml(
                        triangles, obj_id, uuid_str
                    )
                    with open(f_path, "w", encoding="utf-8") as file:
                        file.write(obj_xml)

        # Update 3D/3dmodel.model build transforms (ground flat on bed)
        d3_path = os.path.join(temp_dir, "3D", "3dmodel.model")
        if os.path.exists(d3_path):
            with open(d3_path, "r", encoding="utf-8") as f:
                d3 = f.read()
            d3 = re.sub(
                r'(transform="1 0 0 0 1 0 0 0 1 [^"]* [^"]* )[^"]*"',
                rf"\g<1>{round(half_h, 4)}\"",
                d3,
            )
            with open(d3_path, "w", encoding="utf-8") as f:
                f.write(d3)

        # Update Metadata/model_settings.config source offsets
        ms_path = os.path.join(temp_dir, "Metadata", "model_settings.config")
        if os.path.exists(ms_path):
            with open(ms_path, "r", encoding="utf-8") as f:
                ms = f.read()
            ms = re.sub(
                r'source_offset_z" value="[^"]*"',
                f'source_offset_z" value="{round(half_h, 4)}"',
                ms,
            )
            ms = re.sub(
                r'(transform="1 0 0 0 1 0 0 0 1 0 0 )[^"]*"',
                rf"\g<1>{round(half_h, 4)}\"",
                ms,
            )
            with open(ms_path, "w", encoding="utf-8") as f:
                f.write(ms)

        # Re-pack 3MF archive
        with zipfile.ZipFile(file_3mf, "w", compression=zipfile.ZIP_DEFLATED) as z:
            for root, dirs, files in os.walk(temp_dir):
                for file in files:
                    full_path = os.path.join(root, file)
                    rel_path = os.path.relpath(full_path, temp_dir)
                    z.write(full_path, rel_path)

        print(
            f"Successfully synchronized {file_3mf_name}: {dx:.2f} x {dy:.2f} x"
            f" {dz:.2f} mm ({len(triangles)} triangles)"
        )
        return True
    finally:
        shutil.rmtree(temp_dir)


def main():
    mappings = [
        ("end_cap.stl", "end_cap.3mf"),
        ("retaining_ring.stl", "retaining_ring.3mf"),
        ("drill_jig.stl", "drill_jig.3mf"),
    ]
    for stl_name, mf_name in mappings:
        sync_single_3mf(stl_name, mf_name)


if __name__ == "__main__":
    main()
