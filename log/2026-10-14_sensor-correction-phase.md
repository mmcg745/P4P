# 2026-10-14 — Ry1 sensor correction, phase without a tach, script snapshot

- **Asked:** use the technician-calibrated X sensors as the reference. Driver board ~7 g. Nothing
  known changed between sessions (outliers can be excluded if needed). Then do the agreed
  improvements: per-run tracked plot, phase repeatability check, scripts into the repo.
- **Did:**
  - Fx/Fy, corrected for the different x/y resonance amplification, is 1.11 at 300–600 rpm in both
    the 11 Oct (PLA, bolt) and 13 Oct (steel, 1.48 g) runs, so Ry1 (208C02) reads ~11% low. Set
    `cfg.sensorScale(3) = 1.11` in `analyze_rwa_campbell.m`.
  - Re-analysed both test folders with figures hidden. Bolt U₀ is now 650 g·mm (+4.6% vs 621);
    the 1.48 g mass U₀ is 108.5 (+13% vs 96.2) with fₙ = 39.0 Hz.
  - Step ramps in the tracked-U plot are now drawn per run instead of averaged.
  - Regenerated `approach_to_resonance_2000rpm.png` with the correction: 310 vs 319 g·mm at 1900 rpm.
  - New phase analysis demodulates against the ramp angle and extrapolates to 0 rpm. Imbalance angle
    at start = −79.6° ± 9.7° over 12 runs, vs −90° expected; the wheel spins CW in top view.
  - Supported mass is now 993 g.
  - Snapshotted the scripts into `daq_analysis/` with a README, and added a pointer in `CLAUDE.md`.
  - Updated `knowledge/10_experimental_results.md`: corrected Finding 5, a new "Sensor correction"
    section, a new Finding 6 (phase), and updated poster-section numbers.
- **Notes:**
  - **The poster chat must update its numbers:** 108.5 g·mm (+13%) instead of 103.2 (+7%), fₙ 39.0 Hz,
    the 1900 rpm point 310/319, and the low-speed reading 110. The phase result is a new possible
    poster point.
  - `P4P Shared/PCB FT/INDEX.md` wrongly says the 208C02 is on the axial stingers (it's Ry1, radial).
    Left unchanged; it's outside the repo.
- **Later, prep for the 15 Oct test session (new aluminium mounting plate, ~575 g vs 192.6 g PLA):**
  - Advised keeping the 8 top + 8 bottom bolt ring unchanged: the plate already adds ~380 g, so the
    supported mass goes to ~1375 g, and on mass alone fₙ would drop 39 → ~33 Hz unless the plate
    adds stiffness. Change one variable at a time. Geometry is unchanged per the user.
  - Session plan: tap tests first to set a safe top speed (1800 rpm = 30 Hz may be too close to
    fₙ); baseline, then washer at 6 o'clock, then washer at 3 o'clock (90° check), then baseline
    again, all from the same start mark.
  - `analyze_rwa_campbell.m`: `cfg.testFolder = '15_10_26_tests'`; conditions balanced/baseline/
    imbalanced_1A/1W/1W_90deg/baseline_end with per-condition added mass, angle and reference
    condition; 1800 rpm steps and sweeps; built-in start angle (`startAngle`), with new summary
    columns SpinDir/Angle0_deg/ULow_gmm/tStartErr_s; vector subtraction of the residual; optional
    resonance correction `cfg.phaseFnHz`; missing-file messages collapsed to a count.
  - Synthetic test: the washer was recovered at 96.3 g·mm, −90.0° and 96.2 g·mm, −0.1° (true 96.2
    at −90/0), and the residual at 20.0 g·mm, 30.4° (true 20, 30°).
  - Tap script pointed at `15_10_26_tests`; created the empty folder. Snapshots refreshed in
    `daq_analysis/`.
- **Sign note:** the user saw that the PCB radial piezos read positive in compression (the axial gauges read positive in tension). I kept `sensorSign = +1`, because the net signs are validated by the moment-height and start-angle checks. Documented this in the script comment and the knowledge note.
