# DAQ analysis scripts (snapshot)

Version-controlled copies of the MATLAB scripts used to analyse the RWA test-rig data. The
**working copies live in the shared OneDrive folder**
`OneDrive - The University of Auckland\Part IV\P4P\P4P Shared\DAQ\P4P NI DAQ\`, next to the data.
Run them from there: they find their data relative to their own location (`cfg.testFolder`).
Refresh these snapshots whenever the working copies change.

| Script | What it does |
|---|---|
| `analyze_rwa_campbell.m` | Main spin-test analysis. It reads `RPM<rpm>_<cond>_T<n>.csv` step runs and `SWEEP<rpm>_<cond>_T<n>.csv` slow sweeps (`RPM_`/`SWEEP_` names also accepted). For each run it detects the motor start (coarse, then fitted to the 1× ridge) and the end of the steady hold (deceleration), and converts the 6 sensors to the wrench Fx Fy Fz Mx My Mz. It reports the 1× amplitudes and static imbalance U per run, builds Campbell plots per condition and run type (0–1000 Hz and 0–100 Hz), tracks U through every ramp, and fits U = U₀/(1−(f/fₙ)²). |
| `convert_csv_to_mat.m` / `export_run_csv.m` | Storage: convert run CSVs to compressed `.mat` (~7× smaller, results identical to 4e-8), and recreate a CSV from a `.mat`. Since 15 Oct the test folders hold `.mat` only. |
| `tdms_to_csv.m` | One-off (15 Oct): recovers a run from its FlexLogger TDMS (10,240 Hz) as a 10 kHz CSV. |
| `torque_step.py` | Torque-step fit (15 Oct). It reads the CSVs, so export them first with `export_run_csv`, or port it to read the `.mat`. |
| `analyze_tap_test.m` | Tap (impact) tests. It finds the taps in `TAP_*.csv`, averages the ring-down spectra per wrench component, lists the natural frequencies with a prominence test, and warns if a radial sensor exceeds 4 N. |
| `phase_check.m` | One-off (14 Oct): the imbalance angle of the 13 Oct known-mass runs without a tach. It demodulates Fx + iFy against the ramp angle θ = π(α/60)(t−t₀)² and extrapolates the phase to 0 rpm to remove the start-time error. Paths are absolute, and it reads `summary.csv` for tStart. |
| `approach_to_resonance_2000rpm.m` | One-off (13–14 Oct): tracks U through the 75 rpm/s ramp of `RPM_2000_imbalanced_1W_T1` (cut at about 1900 rpm) against the resonance model from the 1500 rpm sweeps, and saves `approach_to_resonance_2000rpm.png`. |

**Key settings** (top of `analyze_rwa_campbell.m`):
- **Sampling and ramps:** `cfg.Fs = 10000`. `cfg.accelRPMperS = 37.5` (Tic accel 100000 at 1/8 step, 25000 at 1/2 step). `cfg.sweepAccelRPMperS = 15`.
- **Geometry:** R = 50 mm, Rx spacing 105 mm (centred), zr = 140 mm above the base plate, xRy = 0.
- **Sensor scaling:** `cfg.sensorScale(3) = 1.11`. Ry1 (208C02) reads about 11% low against the technician-calibrated Rx 208C01s. See `knowledge/10_experimental_results.md`.
- **Overrides:** per-run values in `cfg.override.<runId>` for `tStart`, `window` or `accel`.

Results and interpretation: [knowledge/10_experimental_results.md](../knowledge/10_experimental_results.md).
Session history: `log/2026-10-11_*` to `log/2026-10-14_*`.
