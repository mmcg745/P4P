# 2026-10-16 — Stinger script updated to the final piano-wire geometry

- **Asked:** Update the stinger analysis code with new geometry, material and design targets
  (500 Hz best case, 300 Hz acceptable case), and change the checks to fit the final stinger
  geometry while staying in line with the poster and report.
- **Did:** Rewrote `MATLAB/stinger_design_V3.m` (header now "v3"):
  - Added a `design_case` switch. `'final'` (the default) uses 1.2/0.8 mm × 95 mm piano wire,
    1.0 kg, z_r = 140 mm, h_CoM = 217.5 mm, R = 50 mm, s = 105 mm and r = 65 mm. `'midyear'` keeps
    the old 2 × 50 mm rod inputs.
  - Frequency checks now report PASS (> 500 Hz) / ACCEPTABLE (> 300 Hz) / FAIL. They use the
    report's fₙ = √(nEA/L/m)/2π, with n = 3 for axial bounce, n = 2 for x and n = 1 for y, and
    include the PCB 208C stiffness (1.05 kN/µm) in series.
  - Buckling is printed for pinned and fixed ends, and under the design load, static-only and
    measured loads. Pass/fail uses `K_end = 1` (pinned).
  - The yield check now uses axial stress. The old cantilever tip-load bending is kept as INFO.
  - New sections: imbalance amplification at 3000 rpm, and an as-built comparison of the tap-test
    modes against the wire-only stiffness.
  - Sensor/DAQ inputs come from the 208C01 datasheet: 0.45 mN resolution, 112.4 mV/N, 44.5 N
    range, 22.7 g. The NI 9232 range is ±30 V. The TAS510 axial resolution is ±0.29 N. New
    check: force within the sensor range.
  - The optimisation sweep counts best and acceptable cases. The d range now starts at 0.6 mm
    so the wires are inside it, and the feasibility map marks the design point.
  - **Bug fix:** the helper functions sat in the middle of the script, which MATLAB rejects. They
    are now at the end.
- **Verified** with `matlab -batch` (figures hidden), both cases:
  - Final case: matches report Table 3 and Appendix B. That covers 425/232/164 Hz,
    ratios 33 426/75 208 (fixed 8 356/18 802), buckling 6.8/27 axial static and 1.7/6.9 radial,
    stresses 8.2/10.4 MPa at the measured loads, 2.4/9.6 axial at 9.3 N, 10.3% amplification at
    50 Hz, and 87×/12–36× softer than the wires. Overall: axial bounce ACCEPTABLE; radial
    frequency and both buckling checks (pinned) FAIL.
  - Mid-year case: 892/515 Hz, ratio 3333 and buckling 101/242, matching the mid-year table.
- **Notes / not aligned with the report:**
  - Radial buckling at 5.2 N prints 0.85; the report's appendix gives 0.84 (4.40/5.2 = 0.846).
  - Yield SFs no longer match the mid-year table (6.4/4670) because the check changed. Piano-wire
    σy = 1500 MPa is an **assumption**; the report gives no σy for the wire.
  - Optimisation counts (final: 41 440 best / 91 584 acceptable of 291 600; mid-year: 28 325
    best) differ from the report's "23 310 of 230 400", which came from the old checks and range.
  - Axial bounce with sensor in series ignores the TAS510 stiffness (unknown, set to Inf).
  - `m_transducer` values are still assumptions: half of 22.7 g for the 208C, and a 5 g
    placeholder for the TAS510.
  - The report never mentions 300 Hz; it uses 500 Hz only. 300 Hz is the poster's next-step
    target.
