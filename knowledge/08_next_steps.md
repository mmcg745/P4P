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

## Design Iteration Workflow (Stinger Analysis → CAD → FEA → Validation)

A repeatable loop to run every time stinger geometry changes (not just once), bridging
[[06_stinger_design_analysis]] and [[07_finite_element_analysis]]:

1. **Run `stinger_design_V3.m`** with the candidate geometry until all five checks (`fn`,
   `kax/klat`, `SFbuckle`, `SFyield`, `fn_combined`) pass for both axial and radial stingers.
2. **Update CAD geometry** — apply the passing stinger diameter(s)/length(s) (and any radial
   support wall-thickness change) to the assembly.
3. **Re-export STEP and re-import to ANSYS** — re-run "Form New Part" to restore shared-node
   topology at all interfaces (per the setup in [[07_finite_element_analysis]]).
4. **Re-run modal analysis** — same fixed-support boundary condition and point-mass RWA
   representation; extract the first 10 natural frequencies.
5. **Compare FEA vs. analytical** — check the FEA mode corresponding to axial bounce against
   `stinger_design_V3.m`'s analytical `fn` prediction; a large disagreement (>10-15%) flags a
   modelling assumption to revisit (boundary conditions, point-mass placement, stinger fixity
   idealisation).
6. **Validate against design targets** — confirm all six lowest modes (lateral translation ×2,
   torsion, axial bounce, rocking ×2) clear the 500 Hz stinger design target; if not, iterate
   geometry and repeat from step 2.
7. **Log the outcome** — record the final passing geometry and FEA mode frequencies in
   [[07_finite_element_analysis]], and update [[06_stinger_design_analysis]] if the selected
   dimensions change.

## Other Open Items Flagged Elsewhere

- **Dynamic imbalance measurement** currently unresolved with the single-plane stinger
  configuration — requires a second axially separated sensor plane (see
  [[05_mathematical_model]], "Dynamic Imbalance — Limitation").
- **Modes 1 and 2** (lateral translation, 334/397 Hz) fall below the 500 Hz target — plan is to
  stiffen radial stinger supports via increased wall thickness (see
  [[07_finite_element_analysis]]).
- **Ball bearing plate concept** remains a viable fallback candidate if the stinger platform proves
  infeasible (see [[04_concept_design]]) — less developed at this stage.
