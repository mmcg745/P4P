# CLAUDE.md

This repo is the working store for the P4P research project (development of a unified
microvibration and torque measurement device for reaction wheel assemblies). It holds project
knowledge, analysis code, and design data — not just one deliverable — so treat it as a general
project workspace rather than a single-purpose codebase.

## What's here

- `knowledge/` — distilled project notes (scope, literature review, math model, design analysis,
  FEA results, next steps). Start with `knowledge/README.md` for the index. These are the
  everyday reference for context — short, linked, and safe to read whenever relevant.
- `knowledge/readings/` — the underlying source PDFs (papers, theses, reports) that the notes in
  `knowledge/` were distilled from. **Don't read these by default.** They're long and mostly
  redundant with the notes above. Only open specific files here when:
  - the distilled notes don't have enough detail to answer a question,
  - you need an exact citation, figure, or equation from the original source,
  - the task involves future outlook / what's next for the project, or
  - a difficult or consequential design decision needs grounding in the original literature.
- `*.m` — MATLAB scripts for the stinger design calculations and parametric/optimisation sweeps
  (`stinger_design_V3.m` is the current version; earlier `V2`/base versions are kept for history).
- `modal_plots.m` / `plots.py` — plotting scripts for FEA and analytical parametric study results.
- `excel data/` — raw ANSYS modal analysis exports (tab-delimited, `.xls` in name only) used by
  the plotting scripts.
- Loose `.png` files — figures generated from the above.

## Working with this repo

- Prefer the distilled `knowledge/*.md` notes over the raw readings or PDFs for routine
  questions, summaries, and everyday design/analysis work.
- Treat this as a living project store: new scripts, data, notes, and readings may be added over
  time as the project progresses, not just at the start.
