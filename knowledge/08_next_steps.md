# Next Steps (as of Mid-Year Report, 2026-07-26)

Part of [[00_project_overview]]. Planned tasks to progress the device from concept to
proof-of-concept hardware:

1. **Sensor selection and procurement** — confirm force transducer type, range, and sensitivity
   with supervisor (Dr Guglielmo Aglietti); procure sensors and signal conditioning hardware.
2. **Static structural FEA** — stress and deflection analysis under maximum expected loading to
   verify structural integrity prior to fabrication.
3. **Detailed design** — finalise stinger dimensions, sensor mounting geometry, and frame wall
   thickness based on confirmed RWA specs and available sensor hardware.
4. **Fabrication** — machine structural components in the university workshop; assemble and
   instrument the platform.
5. **Experimental validation** — spin the RWA on the platform, compare measured imbalance values
   against a known reference to validate the mathematical model and signal processing pipeline.

## Other Open Items Flagged Elsewhere

- **Dynamic imbalance measurement** currently unresolved with the single-plane stinger
  configuration — requires a second axially separated sensor plane (see
  [[05_mathematical_model]], "Dynamic Imbalance — Limitation").
- **Modes 1 and 2** (lateral translation, 334/397 Hz) fall below the 500 Hz target — plan is to
  stiffen radial stinger supports via increased wall thickness (see
  [[07_finite_element_analysis]]).
- **Ball bearing plate concept** remains a viable fallback candidate if the stinger platform proves
  infeasible (see [[04_concept_design]]) — less developed at this stage.
