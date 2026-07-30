# 2026-07-30 — Readings index

**Asked:** Create a dictionary/index file for `knowledge/readings/` (20 source PDFs) so their
content can be understood without opening the PDFs, with cross-references to the existing
`knowledge/0X_*.md` distilled notes and `knowledge/09_references.md` where applicable.

**Did:**
- Created `knowledge/readings/INDEX.md` — dictionary entries (title, authors/year, topic tags,
  summary, P4P relevance) for all 20 PDFs, ordered alphabetically, plus a "Quick topic map"
  grouping filenames by topic (imbalance, bearing harmonics, torque measurement,
  stinger/transducer design, disturbance modeling, cantilevered wheel dynamics, etc.).
  Cross-referenced the 9 papers already cited in `knowledge/09_references.md` to their distilling
  notes; flagged the remaining 11 as "not yet distilled into knowledge/ notes."
- Updated `knowledge/README.md` with a bullet pointing to `readings/INDEX.md`.
- Updated `CLAUDE.md`'s description of `knowledge/readings/` to mention checking `INDEX.md`
  first before opening a full PDF.

**Notes:**
- `Hughes-2025-thesis .pdf` exceeds the 20MB PDF-read limit available this session — its INDEX.md
  entry is a placeholder based on filename only (title/authors/content unverified). Worth a
  manual read/follow-up since it appears to be the most recent source in the folder.
- `TRANSDUCER INERTIA AND STINGER STIFFNESS.pdf` (McConnell & Cappa, 2000, MSSP) is highly
  relevant to the project's own stinger design (quantifies how stinger stiffness/transducer
  inertia contaminate force/moment FRF measurements) but isn't yet folded into
  `06_stinger_design_analysis.md` — flagged as a follow-up in the index entry.
- A few citation years show minor discrepancies between the reading filenames and confirmed
  in-paper publication years (e.g. "addari-et-al-2016..." is actually AIAA J. 2017); noted in the
  relevant entries.
