# CLAUDE.md

This repo is the working store for the P4P research project (development of a unified
microvibration and torque measurement device for reaction wheel assemblies). It holds project
knowledge, analysis code, and design data — not just one deliverable — so treat it as a general
project workspace rather than a single-purpose codebase.

## Main P4P folder (outside this repo)

Pretty much all P4P project information (reports, data, CAD, test results, admin, etc.) lives in
`C:\Users\matth\OneDrive - The University of Auckland\Part IV\P4P`. Look there when something
isn't in this repo.

To navigate it, read the `INDEX.md` in the folder's root first. Every folder and subfolder has its
own `INDEX.md`, which describes the files there and links down to the child folders' indexes.
Descend through these instead of listing or opening files blindly. When files are added or moved
there, update the affected `INDEX.md`. An older flat overview also exists in
`knowledge/p4p-folder-index/`.

## What's here

- `knowledge/` — distilled project notes (scope, literature review, math model, design analysis,
  FEA results, next steps). Start with `knowledge/README.md` for the index. These are the
  everyday reference for context — short, linked, and safe to read whenever relevant.
- `knowledge/readings/` — the underlying source PDFs (papers, theses, reports) that the notes in
  `knowledge/` were distilled from. **Don't read these by default.** They're long and mostly
  redundant with the notes above. Check `knowledge/readings/INDEX.md` first — it's a
  quick-reference dictionary summarizing what each paper covers, so you can decide whether a full
  PDF is worth opening before reading it. Only open specific files here when:
  - the distilled notes don't have enough detail to answer a question,
  - you need an exact citation, figure, or equation from the original source,
  - the task involves future outlook / what's next for the project, or
  - a difficult or consequential design decision needs grounding in the original literature.
- `*.m` — MATLAB scripts for the stinger design calculations and parametric/optimisation sweeps
  (`stinger_design_V3.m` is the current version; earlier `V2`/base versions are kept for history).
- `modal_plots.m` / `plots.py` — plotting scripts for FEA and analytical parametric study results.
- `daq_analysis/` — version-controlled snapshots of the rig-test MATLAB scripts
  (`analyze_rwa_campbell.m`, `analyze_tap_test.m`). The working copies and the test data live in
  the shared OneDrive DAQ folder; see `daq_analysis/README.md`.
- `excel data/` — raw ANSYS modal analysis exports (tab-delimited, `.xls` in name only) used by
  the plotting scripts.
- Loose `.png` files — figures generated from the above.
- `log/` — dated session log of what's been asked for and done in this repo. See
  `log/README.md` for format.

## Working with this repo

- Prefer the distilled `knowledge/*.md` notes over the raw readings or PDFs for routine
  questions, summaries, and everyday design/analysis work.
- Treat this as a living project store: new scripts, data, notes, and readings may be added over
  time as the project progresses, not just at the start.
