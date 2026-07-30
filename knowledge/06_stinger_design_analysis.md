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

## Literature Grounding: Transducer Mass/Inertia and Practical Setup

Two readings (`knowledge/readings/`) inform the stinger design and its use beyond the analytical
checks above:

- **TRANSDUCER INERTIA AND STINGER STIFFNESS.pdf** (McConnell & Cappa, 2000, *Mechanical Systems
  and Signal Processing* 14(4), pp. 625-636) — quantifies how force-transducer mass/inertia and
  stinger stiffness distort measured FRFs, using a free-free beam test article. Even a stinger
  resonance well above the frequencies of interest (~675 Hz in their test) can still shift and
  corrupt measured natural frequencies. Demonstrates a correction method that removes the
  transducer/stinger contamination to recover true driving-point FRFs, and finds chirp excitation
  gives the best overall coherence. Recommends measuring angular acceleration directly rather than
  differencing two closely-spaced linear FRFs, which amplifies noise — relevant if the P4P rig
  ever needs rotational/moment FRFs from linear channels.
- **isma2010_0687.pdf** (Peres, Bono & Brown, 2010, *Proceedings of ISMA2010 including USD2010*,
  pp. 2539-2550, "Practical Aspects of Shaker Measurements for Modal Testing") — practical
  companion covering correct transducer mounting orientation and ordering (force transducer must
  sit directly on the test article, between it and the stinger — mounting it on the exciter side
  folds stinger dynamics into the measured FRF), shaker/stinger alignment procedure, and stinger
  theory of operation. Confirms the same design intent as the analytical checks above (stiff
  axially, compliant laterally) and adds two points not covered analytically:
  - **Thin-rod vs. piano-wire stingers:** a pretensioned piano wire gives near-zero lateral
    stiffness but requires preload (3-4× the applied load range) and buckles/clips if exceeded; a
    thin rigid rod (the P4P approach) needs no pretensioning and is the more common
    ease-of-use/performance compromise.
  - **Empirical misalignment/error check:** vary stinger length by ±10% and observe the change in
    measured driving-point FRF — a simple experimental diagnostic for stinger-induced lateral/
    rotational measurement error, worth running once the physical rig is built, independent of
    the analytical `kax/klat` margin already satisfied above.
