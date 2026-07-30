# Concept Design (Mid-Year Technical Report, Section 1)

Part of [[00_project_overview]]. See also [[05_mathematical_model]], [[06_stinger_design_analysis]].

## Concept 1 — Floating Ring Plate (Rejected)

- A floating circular ring plate as an intermediate element between RWA and base plate.
- Three axial sensors in an equilateral triangle → statically determinate vertical support.
- Three radial sensors contact the ring's outer edge at 120° intervals → measure lateral forces.
- **Rejected reason:** the three radial sensors apply unequal preload forces due to manufacturing
  tolerances, producing a net lateral force on the ring plate. Because the measurement is dynamic
  (not quasi-static), this preload imbalance cannot be zeroed out and corrupts the radial force
  measurement.

## Evolved Concepts (respond to the preload problem)

Both eliminate the preload issue by using **flexible transmission elements** instead of rigidly
preloaded radial sensors.

### Ball Bearing Plate Concept

- Square floating plate, supported axially by ball bearings on the base plate (free radial
  movement).
- Three axial sensors mounted on the plate measure transmitted forces.
- Eliminates the ring-plate preload imbalance; remains a viable candidate for further development,
  but less developed than the stinger concept.

### Stinger Platform (Selected / Preferred Concept)

Thin flexible steel rods ("stingers") connect the floating mounting plate to the fixed frame,
transmitting forces to sensors at their ends with **no static preload**.

## Stinger Platform — Selected Design Detail

- **Six-stinger measurement platform**: RWA mounting plate connected to a rigid fixed frame by six
  thin steel rods.
  - **3 axial stingers** (vertically oriented) — Az1, Az2, Az3, positioned at 120° intervals on a
    circumscribed circle of radius R beneath the mounting plate. Carry RWA weight, transmit axial
    forces and rocking moments.
  - **3 radial stingers** (horizontally oriented):
    - Rx1, Rx2 mounted on the same face of the mounting plate, separated by distance `s`.
    - Ry1 mounted on the adjacent face, at 90°.
    - All radial stingers connect the floating plate to rigid supports fixed to the base frame,
      carry **no static preload** — attached at both ends, measuring tension/compression through the
      full imbalance rotation cycle.
- Each stinger designed to be highly stiff along its own axis (transmits force in measurement
  direction) but highly compliant perpendicular to its axis — via the large ratio of axial to
  lateral bending stiffness of a slender rod:

  ```
  kax / klat = (EA/L) / (3EI/L³) = 16L² / (3d²)
  ```

  Depends only on geometry; maximised by long, thin rods. For d = 2 mm, L = 50 mm (steel), ratio
  exceeds 3000 — cross-axis force transmission negligible.

- **Result:** statically determinate constraint of all six DOF of the mounting plate with exactly
  six independent sensor readings.
- Rigid base frame uses **triangular gusset ribs** to maximise bending stiffness while minimising
  mass — keeps the frame effectively rigid relative to the stinger elements across the measurement
  frequency range.

See [[06_stinger_design_analysis]] for the detailed sizing/parametric study, and
[[05_mathematical_model]] for the force/moment/imbalance/torque derivation from the six sensor
readings.
