# 2026-10-12 — RWA rig: mass, stinger and stiffness corrections

- **Asked:** correct the supported mass (the mounting plate is on top of the 807.1 g, and the driver board isn't on the platform), and record the stinger sizes (axial Ø1.2 mm, radial Ø0.8 mm, both 95 mm long). Steel brackets are coming; this is conceptual testing.
- **Did:** updated `knowledge/10_experimental_results.md`: supported mass ~1.0 kg, CoM ~175 mm, lateral stiffness ~20–25 kN/m (about 180–225 times softer than the FEA). The wires on their own would give ~165–230 Hz, so the PLA brackets and joints are the soft part. Added a stinger buckling table: radial SF 0.84 pinned / 3.4 fixed; axial SF 2.4 / 9.6.
- **Notes:** need the driver board's mass to subtract. Avoid ~1300–1600 rpm until the steel brackets are fitted. Even with stiff brackets, the 0.8 mm radial wires cap the lateral mode at ~165–230 Hz, below the 500 Hz target.
