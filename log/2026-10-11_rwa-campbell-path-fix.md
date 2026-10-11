# 2026-10-11 — RWA Campbell script: data path fix

- **Asked:** look over the shared DAQ folder (`OneDrive - The University of Auckland\Part IV\P4P\P4P Shared\DAQ\P4P NI DAQ`), review the new `analyze_rwa_campbell.m`, pick up the handoff from another chat, and fix the script's data path.
- **Did:** changed `cfg.dataFolder` in `analyze_rwa_campbell.m` (shared folder, not this repo) from Brodi's hard-coded path to `fullfile(<script folder>, '11_10_26_tests')`, falling back to `pwd`. Checked the CSV timestamps: the sample rate is 10 kHz, so `cfg.Fs = 10000` is right.
- **Notes:** the script still hasn't been run in MATLAB. Still open: `geo.zr`, `geo.xRy`, whether Rx1/Rx2 are centred on the origin, the 0.105 m Rx spacing, the radial piezo signs, and the screw mass/radius. Ignore the old logs (`LogFile_2026-09-21*`, `LogFile_2026-10-09*`). The 750 rpm steady-speed windows are only about 4–6 s, and `RPM600_imbalanced_1A_T1` is short (26 s).
