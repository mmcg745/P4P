# 2026-10-13 — Display Day poster from PosterTemplate4

- **Asked:** make the Display Day poster in `P4P Shared/P4P Display-day poster/final_poster` from the template, using the project brief and resources. Haiku sub-agents were to share the reading.
- **Did:** four Haiku agents read the template, the brief and handbook, `knowledge/` plus the October logs, and the image folders. Built an A1 landscape poster (3178 × 2246 px = 84.1 × 59.4 cm) matching PosterTemplate4's geometry: six cyan panels, navy Inter type, UoA logo top-right, booth/project box top-left. Published it as a Design canvas (https://claude.ai/artifact/J6RDx5nry4oxH4g8hwDx4R). Saved `P4P_Poster_final.html`, `.pdf` (A1) and `_preview.png`, plus `poster_assets/`, in `final_poster/`. Content comes from the 11–13 Oct rig results (bolt −1.3%, washer +7%, 38.8 Hz mode), the stinger design and FEA, the rig photo and the CAD render.
- **Notes:** placeholders and checks for the user: booth/project number ([No.]); supervisor title (used "Prof."; the draft said "Dr"); title kept from the draft, "Low-Cost RWA Test Platform". The handbook puts the poster deadline at 9 Oct, which has passed. Check that the rig-photo labels (bracket, sensor positions) are right.

## Revision 2 (same day)

- **Asked:** smaller figures sized for A1, remove the CAD render, use the new `RWA_testing_rig_photos`, add microvibration and torque results, follow `2026IndustryJudgingCriteria.pdf`. Use Haiku agents at low/medium effort.
- **Did:** the hero photo is now `side_view2` (steel brackets and PCB sensors, 8 labels), with `iso_view1` as a supporting view; the CAD render is gone. Redrew three print-size plots in matplotlib: imbalance (bolt and washer with fits), Fx/Mz PSD at 1500 rpm against the noise floor (rebuilt in Python from the raw CSV), and 1× Mz against speed. Added a "What we did" strip (design → build → problem → fix) and a key-numbers panel, plus a commercial-potential line, for the judging criteria. Re-exported the HTML, PDF and preview, and replaced `poster_assets/`.
- **Notes:** the Python rebuild of the 1500 rpm washer run gives a 1× Fx of 3.4–3.75 N, but `summary.csv` says 4.695 N, a factor of about 1.37. It is probably the RMS/peak (√2) normalisation in `analyze_rwa_campbell.m`. Check this before quoting absolute 1× amplitudes; the PSD levels match. Steady spin-up torque is not measured because the IEPE channels are AC-coupled and there is no encoder.

## Revision 3 (same day)

- **Asked:** check the 1.37× scaling issue, add Campbell plots from the 1500 rpm washer sweeps, and use only 12_10_26_tests data (drop the PLA-bracket bolt results). Set booth 114 and project 116, a "Development of …" title and "Prof. G.S. Aglietti". Rework "What we did" as overall achievements, shrink things and add a Next Steps panel.
- **Scaling check:** `analyze_rwa_campbell.m` is correct. The phasor gives peak amplitude, and Fe = sqrt((Ax²+Ay²)/2) is the rotating-force magnitude. The 1.37× gap came from the Haiku Python replica, whose window ran to tStop − 1 s (69 s) and so averaged in ~9 s of coast-down; the 1500 rpm hold ends at ~59 s. With the window corrected, the 1× Fx is 4.693 N, against 4.695 N in summary.csv. Low-speed U (105 vs 96.2 g·mm) also rules out a script error.
- **Did:** regenerated all plots from 12_10 data only (scratchpad `figs2/make_figs2.py`): washer U against speed with the resonance model, the Fx/Mz PSD at 1500 rpm with the corrected window, 1× Mz for balanced and washer runs, and Campbell maps (Fx, Fz, Mz; 0–500 Hz plus a 0–100 Hz zoom) from the two SWEEP_1500_imbalanced_1W runs. New layout: How It Works plus Campbell in the middle column, Next Steps placeholders, "What We Achieved". Re-exported the HTML, PDF and preview.
- **Notes:** the 1900 rpm / 297 g·mm point comes from the 13 Oct 2000 rpm run analysis (`approach_to_resonance_2000rpm.png`), not summary.csv. The Next Steps items are still to come from the user.

## Revision 4 (same day)

- **Asked:** fill the Next Steps panel: stiffen the frame, test a commercial RWA, add an encoder (imbalance phase and torque), research and possibly add dynamic imbalance, plus anything else that could plausibly come next.
- **Did:** the Next Steps panel is now six cards (2 × 3). The user's four, plus two of mine: "Calibrate and repeat" (known-force sensor calibration, run-to-run repeatability) and "Correct and balance" (correct readings for platform resonance, demonstrate trim balancing). Re-exported the HTML, PDF and preview and republished the canvas.

## Revision 5 (same day)

- **Asked:** update `final_poster/INDEX.md`.
- **Did:** rewrote `final_poster/INDEX.md` for the current poster: new title, project 116 and booth 114, panel list, 12_10-only data, file sizes, and a note on the scaling check. Recreated `final_poster/poster_assets/INDEX.md`, which my export script had deleted when it cleared `poster_assets/` on an earlier re-export. The script now removes only image files.
- **Notes:** the parent `P4P Display-day poster/INDEX.md` does not list `2026IndustryJudgingCriteria.pdf` and was left unchanged.

## Revision 6 (same day)

- **Asked:** stop calling it the "washer" — use "known / induced / 1.48 g imbalance" — and add more explanation to the plots.
- **Did:** merged onto the user's own canvas edits (wire diameters Ø1.20 mm axial and Ø0.80 mm radial, 10 kg load cells, "off-the-shelf parts"). Replaced every "washer" on the poster and in the plot labels (`figs2/make_figs2.py`, re-run). Rewrote the four figure captions to say what was measured, how to read each plot and what it shows. Shrank the plots slightly (~9%) to make room. Re-exported the HTML, PDF and preview and republished. `poster_assets/INDEX.md` survived the export because of the script fix.

## Revision 7 (same day)

- **Asked:** make it clear that the "balanced" wheel was never actually balanced. It is a 3D-printed wheel with bolts on the outer ring for mass and inertia.
- **Did:** renamed it the "baseline wheel" everywhere. The method bullet now says it is a 3D-printed flywheel with a symmetric bolt ring, not precision-balanced, so it carries a small residual imbalance, and that the known 1.48 g mass is added on top. The Mz plot legend reads "baseline wheel (no added mass)", and its caption was updated to match. Shrank the Campbell figure (540 → 478 px tall) so the extra text fits. Re-exported the HTML, PDF and preview and republished.

## Revision 8 (same day)

- **Asked:** use the new "Why the measured imbalance rises with speed" section of `knowledge/10_experimental_results.md` to explain on the poster that the rise in U with rpm comes from the 38.8 Hz lateral mode (U_meas = U_true/(1−(f/fₙ)²)), not the wheel changing. Use its evidence points and one-sentence caption, and keep the existing terminology.
- **Did:** merged onto the user's latest canvas version. The imbalance caption is now the one-sentence version from the note. Replaced the three stat tiles in Results with a box headed "Why measured U rises with speed: U_meas = U_true/(1 − (f/fₙ)²)": the mechanism (the stingers carry the force that accelerates the swaying ~1 kg assembly; ×1.02 / ×1.71 / ×3.0 at 300 / 1500 / 1900 rpm) plus evidence points 1, 2 and 4. Shortened the microvibration and torque captions and the three plots slightly to fit. The 36 mN·m figure stays in the torque caption. Re-exported the HTML, PDF and preview and republished.
- **Notes:** evidence point 3 (PLA brackets fₙ ≈ 24 Hz, ~40% rise by 750 rpm, against ~12% with steel) was left out because it relies on 11_10 data, which the user asked to keep off the poster. Ask whether to add it.

## Revision 9 (same day)

- **Asked:** remove the "Calibrate and repeat" and "Correct and balance" next steps, and expand the frame-stiffening and commercial RWA ones.
- **Did:** Next Steps is now four cards (2 × 2). "Stiffen the system": the 38.8 Hz mode limits accuracy above ~1000 rpm; tap tests point to the RWA frame's threaded rods as the next soft part; stiffen it, re-run FEA on the as-built parts, aim for the 500 Hz target so no correction is needed. "Test a commercial RWA": swap the 3D-printed wheel for a flight-representative small-sat RWA and compare microvibration, imbalance and torque with published data and flight specs (static < 26 g·mm [2]). The encoder and dynamic imbalance cards are unchanged. Re-exported the HTML, PDF and preview and republished.

## Revision 10 (same day)

- **Asked:** update the PDF.
- **Did:** pulled the latest canvas version, which has the user's own edits (reworded "Stiffen the system" card, "Add an encoder/tachometer"), and re-exported `P4P_Poster_final.pdf`, `.html` and `_preview.png` from it in `final_poster/`.

## Revision 11 (same day)

- **Asked:** move the Campbell plots out of "How It Works" and connect them to the Results section.
- **Did:** split the middle-column top panel. "How It Works" (268–908 px) is now its own panel, with its paragraph and bullets 2 px smaller. The Campbell maps are in a new panel below it (942–1683 px, image 535 px tall). A same-colour bridge across the column gap joins that panel to the Results panel, so Results reads as one L-shaped bubble. The Campbell caption was shortened to three lines. Re-exported the HTML, PDF and preview and republished.
