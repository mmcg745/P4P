# Finite Element Analysis (Mid-Year Technical Report, Section 4)

Part of [[00_project_overview]]. See also [[06_stinger_design_analysis]], [[08_next_steps]].

## Setup

- Modal analysis in **ANSYS Mechanical 2025 R2**, full 17-body assembly.
- Imported as STEP file, combined into a single part via "Form New Part" for shared node topology
  at all interfaces.
- Fixed support boundary condition applied to the bottom face of the base plate.

### Material Assignments

| Component | Material | E [GPa] |
|---|---|---|
| Base plate, mounting plate, frame | Aluminium Alloy | 71 |
| Stingers, radial supports | Structural Steel | 200 |
| Transducers | Piezoelectric | 70 |

- Transducer cylinders assigned E = 70 GPa, representative of PZT (lead zirconate titanate), the
  active sensing element in typical piezoelectric force transducers. Accounts for transducer
  compliance in series with the stinger (per the `kcombined` equation in
  [[06_stinger_design_analysis]]), so the modal analysis reflects a physically realistic load path
  rather than assuming rigid sensor bodies.

## RWA Mass Representation

- RWA not yet physically available — represented via an ANSYS point mass on the top face of the
  mounting plate.
- Point mass positioned at the estimated RWA rotor centre of mass (CoM) height — approximated as
  half the casing height. This ensures rotational inertia contributes correctly to the rocking
  modes (Modes 5, 6) at the physically correct axial location, not at the mounting interface.
- **Total mass: 1.0 kg** (RWA 0.8 kg + interface plate 0.2 kg).
- Moments of inertia: `Ixx = Iyy = 76 kg·mm²`, `Izz = 144 kg·mm²` (Izz ≈ 2·Ixx, consistent with a
  disc-shaped flywheel rotor).
- Mounting plate mass: 0.42 kg (confirmed from CAD geometry).
- **These parameters are directly substitutable with measured values once the RWA datasheet is
  available** — no geometry changes required.

## Results — First 10 Natural Frequencies (point mass setup, m = 1.0 kg, d = 2 mm, L = 50 mm stingers)

| Mode | Description | Frequency [Hz] |
|---|---|---|
| 1 | Lateral translation — X | 334.46 |
| 2 | Lateral translation — Y | 396.77 |
| 3 | Torsion about Z | 696.38 |
| 4 | Axial bounce — Z | 892.71 |
| 5 | Rocking about X | 965.74 |
| 6 | Rocking about Y | 998.81 |
| 7–10 | Higher order frame modes | > 1900 |

## Interpretation

- Primary measurement function: imbalance characterisation at **500–3000 rpm (8–50 Hz)**. The
  platform operates well within its flat response region at this range.
- Modes 1 and 2 (334 Hz, 397 Hz) are **below the 500 Hz stinger design target** — these are
  lateral translation modes.
- **Planned fix:** stiffen the radial stinger supports (increased wall thickness) to raise Modes 1
  and 2 above 500 Hz — identified as the primary design improvement, part of next steps
  ([[08_next_steps]]).
