# 2026-10-15 — Report: FEA compared with the rigid-case tap tests

- **Asked:** "the fea can be compared with the rigid tap tests as they have similar mass". Base the final-geometry FEA comparison on the rigid-case taps instead of the 13 Oct campaign B rig (0.99 kg).
- **Did:**
  - Edited the report (`final_report/Overleaf_FinalReport/sections/`):
    - `03_design.tex` §3.5: the mass sentence now points to the rigid-case comparison.
    - `06_discussion.tex`: was "16 and 6 times stiffer, scaled 155/117 Hz vs 39/48 Hz". Now 10× (x) and 2.3× (y) too stiff, at 940/530 vs 91/228 kN/m, with no mass scaling. The frame reason was dropped.
    - `07_conclusions.tex`: "two to four times" became "2.3 to 10 times (stiffness) even with a rigid payload".
    - `09a_supplementary.tex`, Table A4: the tap column is now the rigid case (46.3, 73.1, 43, 114/174, 60^b).
    - `05_results.tex`: cut the design-stage "70 to 320 times" sentence to stay at 30 pages.
  - Rebuilt: 0 undefined references. The body still ends on p. 30 (an interim build spilled about five lines onto p. 31).
  - Updated `knowledge/final_report_intent.md` (§2 RQ3 and §3 FEA comparison).
- **Notes:** the Results stiffness table is unchanged; it already had the rigid-case row. The masses are 1.5 vs 1.08 kg, so the comparison is made on stiffness, k = m(2πf)², which removes the mass difference.
