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
