# P4P Concept CAD: folder index

Source: `P4P Shared/P4P Concept CAD/` (168 files, ~50 MB). Mostly Autodesk Inventor (.ipt/.iam), STEP/STL exports, DWG/PDF drawings and 3D-print gcode. Paths are relative to that folder. Dates are last-modified. Descriptions are inferred from filenames, folder context, STEP product names and one rendered image, so treat them as likely, not confirmed.

## Overview

- **Likely current top-level assembly:** `FINAL_ASSEMBLY.iam` (modified 12 Oct 2026; PNG render dated 7 Oct). The render shows an orange base plate, three dark L-brackets, a white square top plate with a centre hole, three bottom posts on cylindrical bases, and three thin wires running from the top plate to the brackets. This looks like a 3-stinger reaction-wheel mount.
- **Other recent assemblies:** `MasterAssembly.iam` (11 Oct), `R_Stinger_1mm_grubs.iam` (11 Oct), `A_Stinger_1.5mm.iam` (23 Sep). `RWA.ipt` (8 Oct) is probably the reaction-wheel model.
- **Recent key parts:** `Stinger Concept V3.ipt` (11 Oct), `MountingPlateV3.ipt` (9 Oct), `MountingPlateV3.stp` (4 Oct), `NEW_BASE_PLATE.ipt` (25 Sep), `BRACKET1.ipt` (25 Sep), `PCB_FT.ipt` (11 Oct), `TAS510-10kg.ipt` (25 Sep).
- **Naming:** `OldVersions/` folders hold numbered snapshots (`.0001`, `.0034` etc.). Treat them as superseded.

## Root (top-level files)

**Assemblies**
- `FINAL_ASSEMBLY.iam`, `FINAL_ASSEMBLY.png`: likely current full rig (keywords: final, assembly, base plate, brackets, stingers, top plate).
- `MasterAssembly.iam`: earlier master assembly (keywords: master, assembly).
- `R_Stinger_1mm.iam`, `R_Stinger_1mm_grubs.iam`: stinger sub-assemblies, 1 mm wire, with grub-screw variant (keywords: stinger, R, grubs, 1mm).
- `A_Stinger_1.5mm.iam`: stinger sub-assembly, 1.5 mm variant (keywords: stinger, A, 1.5mm).

**Stingers**
- `Stinger Concept V3.ipt`, `Stinger Concept V3_copy.stp`: current stinger concept, V3 (keywords: stinger, concept, V3).
- `Stinger.ipt`, `Stinger_V2.ipt`: earlier stinger models (keywords: stinger, V2).
- `Stinger_for_manufacture.ipt`, `A_Stinger_for_manufacture.ipt`, `R_Stinger_for_manufacture.ipt`: manufacturing versions (keywords: stinger, manufacture).
- `R_Stinger_1mm.dwg`, `R_Stinger_1mm_grubs.dwg`, `R_Stinger_1mm_grubs.pdf`, `A_Stinger_1.5mm.dwg`, `A_Stinger_1.5mm.pdf`: stinger drawings (keywords: drawing, stinger).
- `UoA_Inventor_235_2023_A4.dwg`: A4 drawing template (keywords: template, drawing).

**Base and mounting**
- `NEW_BASE_PLATE.ipt`, `Base Plate_old.ipt`: base plate, current and old (keywords: base plate, orange plate).
- `MountingPlateV3.ipt`, `MountingPlateV3.stp`, `MountingPlateV3.pdf`, `MountingPlateV3.dwg`, `MountingPlateV3_15mm.ipt`: V3 mounting plate and 15 mm variant (keywords: mounting plate, V3, 15mm).
- `MountingPlate_Printed.ipt`: version for printing (keywords: mounting plate, print).
- `BRACKET1.ipt`, `BRACKET1.dwg`, `BRACKET1.pdf`: main L-bracket family, as seen in the render (keywords: bracket, L-bracket).
- `PrintingBracket.ipt`, `Test CNC Bracket.ipt`, `B65_Bracket.ipt`, `B65_Bracket_INV.ipt`: other bracket variants; B65 purpose unclear (keywords: bracket, CNC, B65, INV).

**Sensors, mechanisms and fasteners**
- `RWA.ipt`: reaction-wheel assembly model (keywords: RWA, reaction wheel).
- `PCB_FT.ipt`: PCB for force/torque (keywords: PCB, FT, force torque).
- `TAS510-10kg.ipt`: likely a 10 kg load cell (keywords: TAS510, 10kg, load cell).
- `M4x10mm Hex.ipt`, `M6x10mm Hex.ipt`, `10-32 Hex Nut.ipt`, `M5 Washer.ipt`, `M5x0.8 x 15mm coupling nut.ipt`: hardware models (keywords: M4, M5, M6, nut, washer, coupling nut).

**Other**
- `P4P Initial Concept.ipj`: Inventor project file (keywords: project).

## OldVersions/ (root)

About 40 superseded files, grouped:
- **Stingers:** `Stinger Concept V3.0034.ipt`, `Stinger Concept V2.0025.ipt`, `Stinger Concept.0013.ipt`, `Stinger.0010.ipt`, `Stinger_V2.0001.ipt`, `R_Stinger_1mm.0003.iam`, `R_Stinger_1mm_grubs.0005.iam`, `A_Stinger_1.5mm.0003.iam`, plus stinger drawings.
- **Plates and bases:** `MountingPlateV3.0017.ipt`, `MountingPlateV3.0007.dwg`, `Mounting Plate.0002.ipt`, `MountingPlate_Printed.0001.ipt`, `NEW_BASE_PLATE.0007.ipt`, `Base Plate.0011.ipt`, `Base Plate.0001.dwg`.
- **Brackets:** `BRACKET1.0028.ipt`, `BRACKET1.0002.dwg`, `B65_Bracket.0003.ipt`, `B65_Bracket_INV.0001.ipt`.
- **Concepts:** `RWA CONCEPT 1 MM.0002.ipt`, `RWA CONCEPT 2 MM.0005.ipt`, `RWA.0001.ipt`, `Ball Bearing Concept.0004.ipt`, `Ball Bearing Concept V2.0008.ipt`, `Concept Idea 1.0005.ipt`.
- **Assemblies:** `FINAL_ASSEMBLY.0021.iam`, `MasterAssembly.0034.iam`.
- **Hardware and sensors:** `TAS510-10kg.0004.ipt`, `PCB_FT.0005.ipt`, `M6x10mm Hex.0002.ipt`, `M5x0.8 x 15mm coupling nut.0004.ipt`, `M5x0.8 x 20mm coupling nut.0003.ipt`, `10-32 Hex Nut.0003.ipt`, `2632110.0001.ipt` (unidentified part number).
- **Misc:** `UoA_Inventor_235_2023_A4.0006.dwg`, `P4P Initial Concept.ipj.bak`.

## 3D Prints/

Parts intended for 3D printing, plus print files and STEP exports.

**Flywheel (current, top level of 3D Prints/)**
- `flywheel_assembly.iam`: flywheel assembly (keywords: flywheel, assembly).
- `flywheel_base.ipt`, `flywheel_top.ipt`, `flywheel_shaft.ipt`: flywheel body parts (keywords: flywheel, base, top, shaft).
- `shaft_coupling.ipt`: coupling between shaft and motor (keywords: coupling, shaft).
- `stepper_motor.ipt`: stepper motor model (keywords: stepper, motor).
- `698RS_ball_bearing.ipt`: 698RS bearing, a standard 8 x 19 x 6 mm sealed bearing (keywords: bearing, 698RS).
- `supports.ipt`: supports (keywords: supports, flywheel).
- `flywheel_test.ipt`, `flywheel_test.dwg`: test flywheel and drawing (keywords: flywheel test).
- `flywheel_prints/`: STL and STP exports for printing, dated 9 Oct: `NEW_flywheel_base.stl`, `flywheel_base.stp`, `flywheel_test.stp`, `flywheel_top.stp`.

**Mounting plates**
- `Mounting Plates/MountingPlateV3_new.stl` (9 Oct, newest STL), `V3_Mounting Plate_10mm.stp`, `V3_Mounting Plate_15mm.stp`, `V3_Mounting Plate_10mm(2).stp`: V3 plate variants by thickness (keywords: mounting plate, 10mm, 15mm).
- `Mounting Plates/Mounting Plate.stp`, `Mounting Plate_10mm.stp`, `Mounting Plate_15mm.stp`: earlier versions.
- `Mounting Plates/15mmMount_6_50x2mmStinger_pruscaMini.bgcode`, `Mounting Plate_10mm_0.2mm_PLA_MINI_5h2m.gcode`: Prusa Mini print files (keywords: gcode, Prusa, print).

**Stingers**
- `Stingers/`: STP files named by effective length and thickness, e.g. `Stinger_EffL_50mmx2mm.stp`, `Stinger_EffL_60mmx2.5mm.stp`, `Stinger_EffL_75mmx4mm.stp`, `Stingers_50mm_2mm.stp`. Lengths 50 to 75 mm, thicknesses 2 to 4 mm (keywords: stinger, effective length, parametric).
- `Stinger_EffL_100mmx4mm.stp` (top level): longest variant (keywords: stinger, 100mm).

**Brackets**
- `Brackets/BRACKET1.stp`, `BRACKET2.stp`, `BRACKET3.stp`: bracket options (keywords: bracket).
- `Brackets/BRACKET1_X1_wSLOTS.stp`, `BRACKET1_X2_wSLOTS.stp`, `BRACKET1_Y_wSLOTS.stp`: BRACKET1 with slots in X and Y (keywords: slots, bracket).
- `Brackets/BRACKET2_0.2mm_PLA_MK3S_4h38m.gcode`: MK3S print file, 4 h 38 min (keywords: gcode, MK3S).
- `Brackets/Mounting.ipt`: mounting model (keywords: mounting).

**Other**
- `PCB_FT.stp`: PCB export (keywords: PCB, FT).

**OldVersions/** (superseded, about 9 files): `flywheel_assembly.0006.iam`, `flywheel_base.0005.ipt`, `flywheel_top.0004.ipt`, `flywheel_shaft.0002.ipt`, `flywheel_test.0005.ipt`, `flywheel_test.0001.dwg`, `698RS_ball_bearing.0001.ipt`, `stepper_motor.0002.ipt`, `supports.0001.ipt`.

## Initial Concepts/

Early concept models from July and August 2026.
- `RWA CONCEPT 1 MM.ipt`, `RWA CONCEPT 2 MM.ipt` (+ PNG): reaction-wheel concepts (keywords: RWA, concept, 1mm, 2mm).
- `Stinger Concept.ipt`, `Stinger Concept V2.ipt` (+ PNG views: iso, side, top): stinger concepts (keywords: stinger, concept, V2).
- `Ball Bearing Concept.ipt`, `Ball Bearing Concept V2.ipt` (+ PNG): bearing-based concepts (keywords: bearing, concept).
- `Concept Idea 1.ipt`: first concept sketch (keywords: concept).
- `Mounting Plate.ipt`: early mounting plate (keywords: mounting plate).

## 31520-SSF-10-32-3-8-A2/

Vendor part family, stainless (A2), 10-32 thread, 3/8 in length (from the name). The STEP product is named "SSN SCRIPT", which suggests a catalogue download. Likely a stainless 10-32 standoff or socket-head screw. Identity unconfirmed.
- `31520-SSF-10-32-3-8-A2.ipt`: main model (keywords: 10-32, 3/8, stainless).
- `31520-SSF-10-32-3.5mm-A2.ipt`, `31520-SSF-10-32-5mm-A2.ipt` (5mm in OldVersions): variants (keywords: 3.5mm, 5mm).
- Root: `31520-SSF-10-32-3-8-A2.stl`, `.stp`.

## 32166-SEBF-10-32-3_4-A2/

Vendor part family, stainless (A2), 10-32, 3/4 in length. The STEP product is named "SEBF BASE v6", so it is likely a base or spacer fastener.
- `32166-SEBF-10-32-3_4-A2.ipt`: main model, last changed 20 Aug (keywords: SEBF, 10-32, 3/4).
- `32166-SEBF-10-32-3.5mm-A2.ipt`, `32166-SEBF-10-32-5mm-A2.ipt`: variants (keywords: 3.5mm, 5mm).
- `OldVersions/`: 3 earlier versions.
- Root: `32166-SEBF-10-32-3_4-A2.stp`.

## 4838269/

Vendor part, TraceParts STEP download (2025). The number alone does not identify it. Likely a catalogue component such as a fastener or bearing.
- `4838269.ipt`, `4838269_5mm.ipt`: main model and 5 mm variant (keywords: 4838269, 5mm).
- `OldVersions/`: 2 earlier versions.
- Root: `4838269.stl`, `4838269.stp`.

## Open questions

- Confirm `FINAL_ASSEMBLY.iam` is the current rig and retire `MasterAssembly.iam`.
- Identify the vendor part numbers (31520, 32166, 4838269) from their catalogues.
- Confirm the roles of the R and A stinger variants and what the B65 bracket is for.
