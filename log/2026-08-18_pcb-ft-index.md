# 2026-08-18 — PCB force transducer index

**Asked:** Pull latest repo changes, then update `knowledge/PCB FT/INDEX.md` to include the new
readings that came in with the pull (PCB Piezotronics force transducer datasheets/brochures) and
log the session.

**Did:**
- Pulled latest changes (fast-forward `06024b2` → `6f02f50`), which added `PCB transducer
  drawing.pdf` at the repo root and six files under `knowledge/PCB FT/` (208c01.pdf, 208c01_k.pdf,
  208c02.pdf, 208c02_k.pdf, TM-FRC-208C_Lowres.pdf, TM-FRC-PosterBook_Lowres.pdf).
- Created `knowledge/PCB FT/INDEX.md` (didn't exist before) summarizing the four distinct
  documents in that folder: the 208C01 and 208C02 ICP® force sensor datasheets, the 208C series
  brochure (comparison table across 208C01-208C05), and the "Force & Strain Fundamentals" poster
  book (piezoelectric theory, ICP® vs charge mode, installation practice, DTC/frequency response,
  strain sensors, force sensor vs load cell, multi-sensor array summation).

**Notes:**
- None of this is distilled into the numbered `knowledge/0X_*.md` notes yet — flagged in the new
  INDEX.md as a follow-up to fold into `06_stinger_design_analysis` when selecting/mounting a
  force transducer for the stinger rig.
- `PCB transducer drawing.pdf` at the repo root was left out of this index since it's outside
  `knowledge/PCB FT/`.
