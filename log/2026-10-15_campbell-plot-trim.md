# 2026-10-15 — Campbell plots: fewer figures, no blank speed strip

- **Asked:** make the analysis produce only the necessary Campbell plots, with the x-axis correct
  (no white space).
- **Did:** `analyze_rwa_campbell.m` (working copy and `daq_analysis/` snapshot). New settings
  `cfg.campbellConditions = {'baseline','balanced','imbalanced_1W'}` and
  `cfg.campbellKinds = {'sweep'}`, so the combined Campbells are now the baseline and 1W sweeps
  only (0–1000 Hz and 0–100 Hz: 4 PNGs instead of 20). `plotCampbell` crops the speed axis to the
  bins that hold data, so the grid no longer runs to 1800 rpm past a 1500 rpm ramp. Checked on
  synthetic data in MATLAB with figures hidden; not re-run on the real data.
- **Notes:** the imbalance-vs-speed
  figure still uses `xlim([0 1800])`.
- **Later:** re-ran on the 15 Oct data (figures hidden, exit 0). New Campbells:
  `campbell[_low]_{baseline,imbalanced_1W}_sweep.png`. The old 20 were moved to
  `analysis_output/old_campbell/`. Messaged the poster and final-report chats about the new files.
