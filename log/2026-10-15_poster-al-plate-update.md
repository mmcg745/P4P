# 2026-10-15 — Poster updated with 15 Oct (aluminium plate) results and RWA-housing photo

- **Asked:** the DAQ session asked for the poster to be updated from `knowledge/10` Findings 7–11 (commit e7e6259). Mid-update, the user asked to use the new photos with a real RWA housing as the main rig image.
- **Did:**
  - **Data:** all poster data and plots now come from `15_10_26_tests` only (scratchpad `figs3`–`figs5`):
    - imbalance vs speed (1.48 g at 6 o'clock plus baseline wheel; model U₀ = 119 g·mm, fₙ = 39.8 Hz);
    - a new polar plot of the added imbalance vector after subtracting the residual (per-run points match Finding 9);
    - a new reaction-torque spin-up plot, refitted from the .mat files (T1–T3 = 35.0/35.7/34.0 mN·m, matching 34.9 ± 0.6);
    - Campbell maps of the two 1W sweeps.
    - The Fx/Mz PSD was dropped for space.
  - **Main rig photo:** now `RWA_front1` (brass RWA housing on the aluminium plate), with 8 labels and a note that it shows the housing used for tap tests, the spin tests used the 3D-printed wheel, and the rig sits on a vibration isolation table.
  - **Text:** How It Works, Results (angle results box, torque, static calibration), Next Steps ("Stiffen the system" rewritten from Finding 11; encoder card) and What We Achieved all updated.
  - Re-exported the HTML, PDF and preview, and republished the canvas.
- **Notes:** "~1.35 kg supported mass" comes from Finding 7 (plate 551 g + ~800 g RWA). The Intro still says "upwards of NZ$100k"; `knowledge/11` has an alternative wording if wanted. The unused new photos (DAQ/NI close-ups, PCB cases, other RWA views) are not on the poster, and `RWA_testing_rig_photos/INDEX.md` does not list them yet.
