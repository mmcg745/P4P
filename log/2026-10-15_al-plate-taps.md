# 2026-10-15 — Aluminium plate: tap and noise tests

- **Asked:** analyse the 15 Oct tap (X/Y/Z/TOP × 3) and noise (OFF/ON) files for the new
  aluminium mounting plate (~575 g), ahead of spin tests the next morning.
- **Did:** ran `analyze_tap_test.m` (15_10_26_tests, figures hidden) and the scratch noise check.
  Lowest modes: X 39.5–40.0 Hz, Y 48.5–48.7 Hz, Mz 40–40.6 Hz, axial 122.7/154.1 Hz. That's only
  +2–3% on 12 Oct despite +38% mass, which points to the RWA frame as the limiting component. Motor
  energised: 0.115 N RMS at 325 Hz on Rx (stepper hum), 1× noise unaffected. Set
  `cfg.phaseFnHz = 44` in `analyze_rwa_campbell.m` and refreshed the snapshot. Added Finding 7 to
  `knowledge/10_experimental_results.md`. Assessed 1800 rpm as safe (Ry1 ~6.6 N, Rx ~4.7 N each).
- **Notes:** spin tests are tomorrow (baseline → 1W at 6 o'clock → 1W_90deg → baseline_end).
  Supported mass is still to be weighed (~1375 g expected). Tap file names are `TAP_X1` (no
  underscore before the number); fine for the `TAP_*` pattern.
- **Spin session (in progress):** the Tic T500 cuts out at ~1600 rpm ("motor driver error", then
  safe start violation), at 1/2 step and at full step. The user dropped to 1500 rpm as the top
  speed (`SWEEP_1500_*` with a hold for every condition). The two cut-out sweeps are kept as
  extras, named `SWEEP_1800_baseline_T1/T2` (commanded 1800).
  - `analyze_rwa_campbell.m`: added `findRampCut`. It finds a cut-out during the ramp (power on
    the 1× ramp line drops 30 dB), ends the ramp 1 s before it, and takes the "hold" values from
    the last 2 s of the ramp. Also a guard: if a run has no usable hold (e.g. a mis-named cut-out
    file) it uses the end of the ramp instead of crashing.
  - Synthetic test: a cut at 1580 rpm was detected at ~1594 rpm with the `SWEEP_1800` name; the
    `SWEEP_1600` name is caught by the guard. Normal runs are unchanged. Lint clean, snapshot
    refreshed.
  - Gave the user a lab checklist with Tic settings, plus extras: a torque step at 300 rpm/s
    (accel 200000 at 1/2 step), a static known-mass check of Fz/Mx/My, and a two-washer
    linearity test.
- **Static known-mass test (301.5 g, offsets ±56.87 mm in x and y, plus centre):** analysed in
  Python (axial channels only, FlexLogger still running). Fz within −1.1 to +0.7% of 2.958 N;
  moments within −2 to +6% of 0.168 N·m with correct signs. Confirms R = 50 mm, the sensor angles,
  the axes and the axial signs. Added Finding 8. The user first quoted 67.5 mm (a measuring slip).
- **Axial zero drift check (ai2):** after washer runs the zero shifts by −0.015 to −0.043 N
  (~0.04% FS), within the TAS510 spec, and removed by the per-run tare. Files named
  `imbalance_1W` (no "d"): the script now accepts naming variants via `findRunFile`, and 1600 was
  added to the sweep speeds. MATLAB lint is deferred until logging is finished.
- **STATIC_CENTRE_T2** (carefully centred, window 61–69 s): Fz −2.938 N (−0.7%); the three sensors −0.986/−0.984/−0.968 N; implied position (+0.1, −0.3) mm. Added to Finding 8.
- **Full spin analysis (15 Oct, 31 runs):** the first pass crashed. Fixes: (1) fall back to the
  coarse start when the 1× ridge fit is unreliable (scatter > 1 s and > 0.5 s from coarse;
  happened on weak-residual 300 rpm baselines); (2) a run whose motor stops before the ramp end
  (`SWEEP_1500_imbalanced_2W_T1`, ~1418 rpm) is treated as a cut-out. Added the `imbalanced_2W`
  condition (2.96 g at −90°). Results recorded as Findings 9 and 10 in the knowledge note:
  - 1W measures 110.7 g·mm at −85.6° with the start baseline subtracted, or 92.5 at −85.6° with
    the end baseline; expected 96.2 at −90°.
  - 2W measures 194.3 at −87.2° (expected 192.4 at −90°). The 3 o'clock washer moved the measured
    angle by ~96°.
  - The residual changed 21→27 g·mm (−20→−57°) during the session (bolt handling), which limits
    small-mass accuracy to about ±15%.
  - fₙ from the sweeps is 39.8–39.9 Hz, matching the tap test; the aluminium plate made no
    measurable difference.
  - Torque step: 0.0349 ± 0.0006 N·m against J·α = 0.0324 (+8%). Script:
    `daq_analysis/torque_step.py`.
- **Recovered the complete `SWEEP_1500_imbalanced_2W_T1`:** the CSV in the folder (10:57:28 run)
  stopped at exactly 100.0 s (1,000,001 rows) while still ramping, probably renamed or moved while
  still being written. Found the run's TDMS (63.1 MB) in the Windows Recycle Bin (the user had
  cleared all `.tdms` at 11:02), copied it out (the bin is untouched) and read it with `tdmsread`.
  It is 1,378,293 samples at **10,240 Hz** = 134.6 s, holding 1500 rpm. **FlexLogger's TDMS rate
  is 10,240 Hz; its CSV export resamples to 10 kHz.** Converted to a 10 kHz CSV in the same format
  (`daq_analysis/tdms_to_csv.m`) and verified: same samples at the start, 982 rpm at 70 s as in the
  cut CSV, 25.00 Hz at the hold. Placed it as `SWEEP_1500_imbalanced_2W_T1.csv` with the TDMS; the
  cut export is in `15_10_26_tests/superseded/` with a README. The other bin items for that run are
  an aborted start (10:54) and the run that cut out at ~1420 rpm (10:55–10:57). Re-running the full
  analysis.
- **OneDrive storage:** the run CSVs were 7.4 GB of the 9.4 GB P4P folder. Wrote
  `convert_csv_to_mat.m` (compressed single-precision `.mat`, ~7× smaller, rounding ≤ 5.6e-8 of
  full scale, checks for a uniform 10 kHz time base) and `export_run_csv.m`. Both scripts now read
  `.mat` first (`readRunFile` / `loadSensors`), and run ids strip `.mat`. Converted all 116 run
  CSVs in 11/12/15_10_26_tests. Verified: the 15 Oct analysis from `.mat` matches the CSV-based
  `summary.csv` to ≤ 4.7e-8 relative on every column (angles 1.4e-5°). With the user's approval,
  sent the 116 CSVs and the recovered TDMS to the Windows Recycle Bin, freeing **7.29 GB**. The
  user still needs to empty the OneDrive online recycle bin for the quota to drop. Re-running the
  15 Oct tap and main analysis from `.mat` only. Updated the DAQ `INDEX.md`, `daq_analysis/README.md`
  and the snapshots.
- **Rigid-case tap tests** (`15_10_26_rigid_case`, case 526.73 g + plate 551.05 g = 1077.8 g):
  X 46.1–46.5 Hz (+8% stiffness, i.e. mass effect only), Y 72.8–73.4 Hz (+81% stiffness), twist
  43 Hz, axial 114/174 Hz. The plastic RWA frame limited Y; X is limited by the Rx support. After
  tightening the Rx bracket bolts (`TAP_X4–6`), X stayed at 45.9–46.1 Hz, the higher modes rose
  259→272 Hz, and a 60 Hz mode appeared. The user judges the acrylic base plate to be the limit.
  Added Finding 11 with future improvements; corrected the plate mass to 551.05 g in Finding 7.
  Tap script now points at `15_10_26_rigid_case`. Not committed (user asked to hold); CoM estimate
  pending.
- Expanded Finding 11 point 3: ways to raise fₙ without losing decoupling (fix the larger compliances first, high-E stinger materials, flexure/notched stingers, scaling L and d together, lighter plate, pre-tension, end fittings, axial load-cell stiffness), following the user's point that thicker stingers worsen decoupling.
