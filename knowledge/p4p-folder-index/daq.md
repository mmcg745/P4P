# P4P folder index: DAQ

Rough search index for `P4P Shared\DAQ\` (ROOT = `C:\Users\matth\OneDrive - The University of Auckland\Part IV\P4P`). 481 files, about 3.7 GB. Most of the size is raw FlexLogger CSV exports, so the `.tdms`, `.tdms_index`, `.zip` and large `.csv` files were only indexed by name and size, not opened. Paths are relative to `P4P Shared\DAQ\` unless shown otherwise. Descriptions come from filenames, script headers and small summary CSVs, so treat them as pointers.

## Overview

- `P4P Shared\DAQ\` holds the NI DAQ setup (FlexLogger project plus MATLAB analysis) and two test-day folders, `11_10_26_tests` (11 Oct 2026) and `12_10_26_tests` (12 Oct 2026).
- `P4P NI DAQ\` is the working FlexLogger project folder. The test-day folders sit inside it. Scripts there analyse whichever `*_tests` folder is set in `cfg.testFolder`.
- Units in the exports: forces in N, torques in N m, imbalance U in g mm. Sample rate 10 kHz (`cfg.Fs`).
- Sensors: Mod1 (NI 9232, slot 1, radial) has Rx1, Rx2, Ry1. Mod2 (NI 9237, slot 2, axial) has Az1, Az2, Az3. Two Rx stingers are 105 mm apart (`geo.s`). The Az stingers sit at 240, 0 and 120 degrees on a 50 mm radius. The Ry1 stinger is a 0.8 mm wire, so it has a buckling risk.

## Root of DAQ\

- `DAQ.m` — 1.9 KB MATLAB snippet, early DAQ bring-up. Discovers the NI card, sets 4096 Hz scan rate, reads ai0 as IEPE (AC coupled, 4 mA excitation), scales by 1/0.1054 V per N, plots 5 s, and has commented-out tachometer RPM and live-plot code (keywords: daqlist, NI card, IEPE, tachometer, RPM, bring-up, sensitivity 0.1054)
- `Testing_rig.jpeg` — JPEG photo of the test rig, dated 12 Oct (keywords: rig photo, test rig, setup, stinger, reaction wheel)
- `tas510_10kg.webp` — WebP image, product photo of a 10 kg load cell or sensor, from the name (keywords: TAS510, 10 kg, load cell, calibration, product photo)

## FlexLogger config files (`P4P NI DAQ\`)

FlexLogger 26.5 (build 9.21) project. XML `.flx*` files.

- `P4P.flxproj` — 6 KB FlexLogger project file. Lists the four `.flx*` specs below and the NI system references (keywords: FlexLogger project, project file, ProjectRunNumber, NI 9237, NI 9232, cDAQ-9174)
- `Channel Specification.flxio` — 31 KB, channel config for cDAQ1 (cDAQ-9174 chassis). Channels cDAQ1Mod1/ai0-ai2 (NI 9232, slot 1, 3 radial stingers Rx1, Rx2, Ry1) and cDAQ1Mod2/ai0-ai2 (NI 9237, slot 2, 3 axial Az1-Az3). Each is IEPE, 0.004 A excitation, 0.1054 V/N sensitivity on two channels and 0.01124 on one. Also has `_Intermediate` channels for each. Last edited 13 Oct (keywords: channel spec, IEPE, sensitivity, NI 9237, NI 9232, cDAQ-9174, Mod1, Mod2, excitation, V/N)
- `Logging Specification.flxcfg` — 2 KB, TDMS logging config. CSV export on, decimated to 10 kHz, log base path set to `12_10_26_tests`. Metadata fields: Operator and DUT. Last edited 13 Oct (keywords: logging, TDMS, CSV export, decimate, metadata, operator, log file name, RPM_2000_imbalanced_1W_T1)
- `Screen.flxscr` — 23 KB, FlexLogger live screen layout (graph and controls) (keywords: screen, live display, graph, FlexLogger UI)
- `Test Specification.flxtest` — 1 KB, empty test spec (no event config beyond the default) (keywords: test spec, FlexLogger, empty)
- `.cache\` — FlexLogger and LabVIEW build cache (`P4P.flxprojcache`, `P4P-lappy.flxprojcache`, `P4P.lvcodedb`). Machine-generated, not for editing (keywords: cache, flxprojcache, lvcodedb, lappy)

## Analysis scripts (`P4P NI DAQ\`)

- `analyze_rwa_campbell.m` — 38 KB, latest RWA analysis, updated 13 Oct. Sets `cfg.testFolder` (currently `12_10_26_tests`) and runs every RPM<speed>_<condition>_T<n>.csv step test and optional SWEEP<speed>_... slow sweep. Steps: (1) find motor on/off by fitting the 1x ridge, with a quiet pre-start noise floor; (2) build speed from the constant spin-up acceleration (37.5 rpm/s for steps, 15 rpm/s for sweeps); (3) convert the 6 sensor readings to the wrench Fx, Fy, Fz, Mx, My, Mz using stinger geometry; (4) plot raw sensors, wrench, PSDs vs noise floor; (5) compute 1x amplitudes and static imbalance U; (6) Smet-style Campbell plots (PSD vs speed vs frequency) per condition; (7) track U vs speed through each ramp and fit U = U0 / (1 - (f/fn)^2). Conditions: balanced, imbalanced_1A (M8 cap screw, 9.56 g at r = 65 mm), imbalanced_1W (M8 washer, 1.48 g at r = 65 mm). Writes to `<test>\analysis_output\` and writes `summary.csv`. Needs the Signal Processing Toolbox (keywords: campbell, wrench, imbalance U, 1x, spin frequency, PSD, sweep, step, Smet, resonance fit, tach-free speed, stinger geometry)
- `analyze_rwa_test.m` — 15 KB, earlier single-run analysis (11 Oct). Plots axial (Mod2) and radial (Mod1) channels and all 6 overlaid. Computes reaction torque Mz from the two Fx sensors (`fxSeparation_m = 0.105`, with `torqueSign` to flip). Computes static imbalance from radial force at the spin frequency. Butterworth smoothing for plots only (cutoff = 2.5 x spin frequency). Written without MATLAB access, so the header says to report errors. Superseded by `analyze_rwa_campbell.m` (keywords: torque from Fx pair, Mz, imbalance, axial, radial, smoothing, Butterworth, legacy, superseded)
- `analyze_tap_test.m` — 12 KB, rig modal tap test (12 Oct). Reads `TAP_*.csv` in the chosen test folder, detects each tap (channel jump of 20 baseline std devs), takes the free ring-down spectrum after each tap, averages per wrench component (Fx to Mz), lists peaks, and plots. Output in `<test>\tap_output\`. Protocol: motor off, about 3 s quiet, then about 5 taps about 3 s apart. Keep taps light (keywords: tap test, modal, natural frequency, ring-down, peaks, impact, TAP_X, TAP_TOP, buckling warning, Ry1)

## Test folder: `11_10_26_tests\` (11 Oct 2026, 282 files, 896 MB)

Naming: `RPM<speed>_<condition>_T<test>.csv` (step tests, spin-up ramp then hold). Each run has a `.tdms` and `.tdms_index` alongside. Test number is T1 to T3. Condition is `balanced` or `imbalanced_1A`.

Tests logged (each with T1, T2, T3):
- `balanced` at 300, 450, 600 and 750 rpm (12 runs)
- `imbalanced_1A` (cap screw) at 300, 450, 600 and 750 rpm (12 runs)

Top-level files:
- `RPM<speed>_<cond>_T<n>.csv` — 24 files, 29 to 44 MB each, raw FlexLogger CSV exports (keywords: raw data, CSV, step test, RPM300 to RPM750)
- `RPM<speed>_<cond>_T<n>.tdms` — 24 files, 10 to 16 MB each, native FlexLogger binary logs (keywords: TDMS, raw log)
- `RPM<speed>_<cond>_T<n>.tdms_index` — 24 index files, 14 to 20 KB (keywords: TDMS index)
- `Balanced_all_six.png`, `Balanced_axial.png`, `Balanced_radial.png`, `Balanced_radial_spectrum.png`, `Balanced_torque.png` — 5 PNG figures of the balanced runs, from an early plotting pass (keywords: balanced, all six, axial, radial, spectrum, torque)
- `Imbalanced_all_six.png`, `Imbalanced_axial.png`, `Imbalanced_radial.png`, `Imbalanced_radial_spectrum.png`, `Imbalanced_torque.png` — same 5 figures for the imbalanced_1A runs (keywords: imbalanced, cap screw, all six)

### `11_10_26_tests\analysis_output\` (99 PNG + summary.csv)

Output of `analyze_rwa_campbell.m` for the 11 Oct data. Per run, 4 PNGs: `_raw.png` (raw sensors), `_wrench.png` (wrench time history), `_psd.png` (hold-speed PSD vs noise floor), `_start_fit.png` (motor-on fit).
- Run figures: `RPM300_balanced_T1` through `RPM750_imbalanced_1A_T3` (24 runs x 4 = 96 PNG)
- Summary PNGs: `campbell_balanced.png`, `campbell_imbalanced_1A.png`, `imbalance_vs_speed.png` (3 PNG)
- `summary.csv` — per-run table: tStart, fSpin, Fx, Fy, Fz, Mx, My, Mz, Fe, U_gmm, MzRampMean, tStop. Balanced U is about 20 to 29 g mm. Imbalanced_1A U is about 646 g mm at 300 rpm and 859 g mm at 750 rpm (keywords: summary, U_gmm, imbalance, 1x, cap screw, results table)

### `11_10_26_tests\analysis_output_zr0\` (99 PNG + summary.csv)

Second run of the same 11 Oct analysis with the same figure set and `summary.csv`. The only numbers that differ are Mx and My for the balanced runs (for example, RPM300_balanced_T1 My is 0.00664 in the main output and 0.00396 here). The `zr0` label probably means a zero-reference or zero-offset variant, but this is not confirmed. Check the script history before using either set (keywords: zr0, zero offset, zero reference, Mx My, variant, comparison)

## Test folder: `12_10_26_tests\` (12 Oct 2026, 182 files, 2.6 GB)

Two naming styles are in use. Older files have no underscore (`RPM450_imbalanced_1W_T1.csv`). Newer files have an underscore (`RPM_450_balanced_T1.csv`). Both appear in the summary. Condition `imbalanced_1W` is one M8 washer (1.48 g) at r = 65 mm. Test numbers T1 and T2 (T3 not used). The `.tdms` files are not in this folder. There are only `.csv` exports and `.tdms_index` files.

Tests logged:
- `balanced` step at 300 (T2 only), 450, 600, 1000 and 1500 rpm (T1 and T2 each)
- `imbalanced_1W` step at 300, 450, 600, 1000 and 1500 rpm (T1 and T2 each)
- `RPM_2000_imbalanced_1W_T1` — one 2000 rpm approach run (full step, Tic accel 25000 = 75 rpm/s, per script note)
- Slow sweeps `SWEEP_1500_balanced_T1/T2` and `SWEEP_1500_imbalanced_1W_T1/T2`, at 37.5 / 15 rpm/s, sweep up to 1500 rpm. These are 130 MB to 186 MB each.
- `NOISE_on.csv`, `NOISE_off.csv` — 44 MB each, noise-floor check with the motor on and off (keywords: noise floor, motor on, motor off, baseline)
- `TAP_X_1..3.csv`, `TAP_Y_1..3.csv`, `TAP_Z_1..3.csv`, `TAP_TOP_1..3.csv` — 12 tap-test CSVs, 27 to 45 MB each, for `analyze_tap_test.m` (keywords: tap, modal, TAP_TOP, impact, ring-down)

CSV sizes by type: step runs 30 to 135 MB, sweeps 130 to 186 MB, tap files 27 to 45 MB. The largest file is `SWEEP_1500_balanced_T2.csv` at about 186 MB.

### `12_10_26_tests\analysis_output\` (103 PNG + summary.csv)

Output of `analyze_rwa_campbell.m` for the 12 Oct data, including the sweeps.
- Run figures: 19 step runs and 4 sweeps, 4 PNG each (`_raw`, `_wrench`, `_psd`, `_start_fit`), giving 92 PNG
- Campbell plots: `campbell_balanced`, `campbell_imbalanced_1W`, `campbell_low_balanced`, `campbell_low_imbalanced_1W` (the `low` versions are the 0 to `cfg.fMaxLow` Hz zoom), each with a `_sweep` variant (8 PNG)
- Other: `approach_to_resonance_2000rpm.png`, `imbalance_vs_speed.png`, `imbalance_vs_speed_tracked.png` (speed vs U, with the tracked 1x force) (3 PNG)
- `summary.csv` — per run, with a `Kind` column for step or sweep. Step U values (g mm): balanced about 37 to 41 at 300 to 600 rpm, about 4 to 5 at 1000 rpm, about 7 to 8 at 1500 rpm (the drop at 1000 rpm is unexplained, so check it). Imbalanced_1W about 104 at 300 rpm, 106 at 450, 110 at 600, 126 at 1000, 180 at 1500 (keywords: summary, U_gmm, washer, 1W, step, sweep, Kind, results table)

### `12_10_26_tests\tap_output\` (25 PNG + tap_summary.csv)

Output of `analyze_tap_test.m` for the 12 Oct tap tests.
- `TAP_<dir>_<n>_time.png` and `TAP_<dir>_<n>_spectrum.png` — 12 time-history and 12 spectrum plots, one pair per tap file (TAP_X, TAP_Y, TAP_Z, TAP_TOP; tests 1 to 3)
- `tap_comparison.png` — comparison across tap directions (1 PNG)
- `tap_summary.csv` — peak frequencies per file and wrench component (File, Component, Peaks_Hz). Recurring peaks are at about 38 to 40 Hz (Fx, Mz, My), about 47 to 48 Hz (Mx, Fy), about 50 Hz (Fz), and about 89 to 91 Hz and 128 to 135 Hz in some files. Peaks at 150, 250, 350, 450 Hz in Fz look like harmonics of a 50 Hz line, so treat them with caution (keywords: natural frequency, modal, peaks, 38 Hz, 47 Hz, 50 Hz, mode, tap summary)

## Archive: `LogFile_2026-10-09-11-55-06.zip` (in `P4P NI DAQ\`, 139 MB)

Zipped earlier logs, not opened. Contents, from the zip listing only:
- `LogFile_2026-10-09-11-55-06.tdms` and `.tdms_index` — 12 MB, log from 9 Oct
- `RPM120_imbalanced_T1..3` and `RPM300_imbalanced_T1..3` — 9 files each (`.csv`, `.tdms`, `.tdms_index`), dated 10 Oct. Pre-naming-convention runs (no `_1A`/`_1W` tag)
- `Test_axial.csv` — axial test export
- `LogFile_2026-09-21-12-06-12.csv` and `.xlsx` — 21 Sep log exported as CSV and Excel (same run as the loose 21 Sep `.tdms` in `P4P NI DAQ\`)

## Loose files in `P4P NI DAQ\` (not in a test folder)

- `LogFile_2026-09-21-12-06-12.tdms` — 420 KB, earliest DAQ log (21 Sep 2026). Small, so probably a bring-up or checkout run (keywords: 21 Sep, first log, bring-up, TDMS)
- `LogFile_2026-09-21-12-06-12.tdms_index` — 2 KB, index for the above

## Notes for next time

- Output folders are generated, so re-running the scripts overwrites them. `analysis_output_zr0` is a separate copy, so it does not get overwritten.
- `analyze_rwa_campbell.m` uses `RPM%d_%s_T%d.csv` (no underscore), but the 12 Oct data also has underscored files (`RPM_450_...`). The override and file-format settings need to match whichever style a test folder uses.
- The 12 Oct folder has no `.tdms` files. Only the CSV exports and indexes are present, so that data cannot be re-exported from TDMS here.
- `analyze_rwa_test.m` is the older single-run script. Use `analyze_rwa_campbell.m` for new work.
