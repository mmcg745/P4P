**Asked:** More/better plots representing the stinger design data, ideas for further
optimisation, push the plotting code into the repo, add a general `CLAUDE.md`, and set up
mandatory logging.

**Did:**
- Wrote `plots.py`: 7 plots combining the ANSYS FEA modal exports (`excel data/*.xls`) with the
  analytical model ported from `stinger_design_V3.m` — ranked comparison, margin-to-target,
  sensitivity tornado, modal fingerprints, design-space contour, feasible-region Pareto plot,
  and FEA-vs-analytical validation.
- Suggested further optimisation directions: non-circular flexure cross-sections, local
  stiffening vs. global, mass reduction, gradient/surrogate optimisation, DOE instead of
  brute-force grid, tolerance/robustness study, material substitution.
- Pushed `plots.py` to `main` (needed a token with Contents:write — first token lacked it).
- Added `CLAUDE.md` at repo root describing the repo as a general project workspace and marking
  `knowledge/readings/` as read-on-demand rather than routine reading.
- Added this `log/` folder with a mandatory logging convention.

**Notes:** Generated PNGs were shared with the user but not pushed to the repo (only asked for
the code). Could add a `plots/` folder for outputs later if wanted.
