# 2026-10-14 — Poster numbers updated for the Ry1 correction and the phase result

- **Asked:** another Claude session (DAQ file exploration) asked for the poster to use the 14 Oct results: the Ry1 (208C02) ×1.11 sensor correction, the updated Finding 5 and the new Finding 6 (phase). See commit 83307a5 and `knowledge/10_experimental_results.md`.
- **Checked:** `knowledge/10` matches the request. The 12_10 `summary.csv` (re-run 14 Oct) has the corrected known-mass means 110.2/111.4/115.3/131.7/189.0 g·mm. Fx, Mz and the Campbell maps (Fx, Fz, Mz) don't use Ry1, and the PSD check reproduces 4.693 N as before, so those plots are unchanged.
- **Did:** regenerated the imbalance plot (scratchpad `figs2/make_figs2.py`) with the corrected points, model U₀ = 108.5 g·mm, fₙ = 39.0 Hz, and the 1900 rpm ramp point at 310. Poster text changes:
  - supported mass is now 993 g;
  - evidence box: spin fit 39.0 Hz against tap test 38.8 Hz, ramp 310 vs 319 g·mm, U₀ 108.5 vs 96.2 (+13%, within residual);
  - "What We Achieved" now includes the imbalance angle, −79.6° ± 9.7° vs −90°, recovered without a tach;
  - the encoder Next Step now builds on that result.
  Re-exported the HTML, PDF and preview and republished the canvas.
- **Notes:** the bolt result (U₀ 650 vs 621, +4.6%, the cleanest calibration check, ~±5% accuracy) comes from 11 Oct PLA-bracket data. It was not added, because the user asked to keep the poster to 12_10 data. The baseline residual varying between sessions (≈40, 5, 18 g·mm) was not added either. Ask the user whether to include either.
