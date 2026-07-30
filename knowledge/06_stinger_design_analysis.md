# Stinger Design Analysis (Mid-Year Technical Report, Section 3)

Part of [[00_project_overview]]. See also [[04_concept_design]], [[07_finite_element_analysis]].
Related code: [plots.py](../plots.py), [stinger_design_V3.m](../stinger_design_V3.m).

## Design Requirements — Four Checks Per Stinger

| Check | Target | Reasoning |
|---|---|---|
| `fn` | > 500 Hz | Flat response below measurement range (one-third rule: fn > 3 × max measurement frequency) |
| `kax/klat` | > 3000 | Cross-axis error < 0.03% |
| `SFbuckle` | > 5 | Sudden catastrophic failure margin |
| `SFyield` | > 3 | Fatigue endurance limit |

## Analytical Framework

For diameter d, length L, modulus E, yield strength σy:

```
fn = (1/2π) · sqrt(3EA/L / mtotal)
kax/klat = 16L² / (3d²)
Fcrit = π²EI / L²                    (buckling)
σmax = 32·Flat·L / (πd³)             (bending stress)
```

Transducer stiffness `ksensor` acts in series with the stinger, modifying effective axial
stiffness:

```
kcombined = (kstinger · ksensor) / (kstinger + ksensor)
```

Substituted into `fn` once sensor specs are confirmed.

## Parametric Study and Selected Dimensions

- Study performed over stinger diameter for L = 50 mm, steel (E = 200 GPa, σy = 350 MPa),
  mtotal = 1.2 kg.
- **Selected: d = 2 mm, L = 50 mm** for both axial and radial stinger types.
- See figure: [Stinger Design parametric plots.png](../Stinger%20Design%20parametric%20plots.png).

## Design Check Results (d = 2 mm, L = 50 mm, steel)

| Check | Target | Axial | Radial |
|---|---|---|---|
| fn [Hz] | > 500 | 892.1 ✓ | 515.0 ✓ |
| kax/klat | > 3000 | 3333 ✓ | 3333 ✓ |
| SFbuckle | > 5 | 100.9 ✓ | 241.7 ✓ |
| SFyield | > 3 | 6.4 ✓ | 4671.6 ✓ |

- The high radial yield safety factor reflects negligible out-of-plane bending on the radial
  stingers — axial stingers carry virtually all vertical load due to their much higher axial
  stiffness.
- All four checks pass for both stinger types at the selected dimensions.
