# 2026-10-15 — Final report: campaign C (aluminium plate) results

- **Asked (via the DAQ session, commits 1174a8e/e7e6259, plus cost note 305e7b7/947dad3):** update the report from Findings 7–11 and the commercial cost note.
- **Did:**
  - **Method:** aluminium plate (551 g, ~1.35 kg supported); stingers are 100 mm piano wire with ends welded into bolts (95 mm free), not grub-screw clamped; brackets are cut-down off-the-shelf gusseted L-brackets; campaign C row in the conditions table; static calibration and torque-step procedures; vector residual subtraction in processing.
  - **Design:** fittings text, plus a note that with both ends fixed the stiffness ratio is (4/3)(L/d)², four times lower (wires still 8,400/18,800).
  - **Results:** campaign C and rigid-case rows in the stiffness table and the diagnosis (plate not limiting; frame limited y; x is a rigid-body sway with My/Fx = CoM height, compliance below the stingers, likely the acrylic base). New sections: static calibration (Fz within ~1%, moments 2–6%, <1 mm), campaign C vectors (table plus new `imbalance_vectors_polar.png`: 1W 110.7 at −85.6°, 2W 194.3 at −87.2°, 3 o'clock +10.9°; end-baseline values too) and the torque step (new `torque_step.png`, 0.0349 ± 0.0006 vs Jα 0.0324). The residual shift when bolts are handled is in the residual section.
  - **Discussion, conclusions, future work and abstract** updated. The abstract is 281 words. The future-work stiffening item was rewritten from Finding 11 point 3.
  - **Cost CHECK markers resolved** with new bib entries DeMunter2018, Totis2025, Kistler9236A and ESA2016. The rig cost is framed as "not cleanly definable; the saving is in the sensing chain".
  - **Page count:** moved the concept table, the parametric figure, the mid-year check table, the FEA sweep table, the tap spectra, the imbalance-vs-speed figure and the 1× Mz figure into new appendices A–B (`sections/09a_supplementary.tex`), and unpinned the body floats ([H] to [htbp]). Builds cleanly.
- **Notes:** the body (Introduction to Future Work) is pages 1–35, so ~5 pages over the 30-page limit. Prose is ~11.4k words. Prose cuts were proposed to the user rather than made, because the user is reviewing the PDF.

- Campbell plots regenerated in 15_10_26_tests (peer session): no report change needed. The report uses only `fig_campbell` (campaign B, 1.48 g washer poster plot), not the 15 Oct Campbell PNGs.
