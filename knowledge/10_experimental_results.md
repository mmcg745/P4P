# Experimental Results: First Spin Tests (2026-10-11)

Part of [[00_project_overview]]. First validation of the stinger platform against a known imbalance
(task 5 in [[08_next_steps]]). Uses the imbalance theory in [[02_literature_review_imbalance]] and
the wrench model in [[05_mathematical_model]].

## Setup

- **Wheel:** a 3D-printed PLA test flywheel, 105.97 g. It is Ø150 mm and 25 mm thick, with a spoked
  centre (pocket R55) and a rim with 24 M8×1.25 tapped holes through its full 25 mm thickness.
  Drawing: `P4P Shared/flywheel_test.pdf`. CAD: `P4P Shared/P4P Concept CAD/3D Prints/flywheel_*`.
- **Bolts:** M8 socket-head cap screws, **9.56 g** each, in the rim holes on the 65 mm pitch radius
  (the holes are 15° apart). Bolt positions are marked on `flywheel_test.pdf` (red = balanced set,
  blue = added bolt).
  - `balanced`: 16 bolts, 8 screwed in from the top and 8 from the bottom, in the same 8 holes. The
    8 positions are 15°, 75°, 105°, 165°, 195°, 255°, 285° and 345°, measured from the 3 o'clock
    hole. That's a pair either side of each of 0°, 90°, 180° and 270°, so the set is balanced.
    The wheel plus bolts is about 259 g.
  - `imbalanced_1A`: the balanced set plus **one** bolt, screwed in from the **top side only**, in
    the 3 o'clock hole (0°, between the right-hand pair). This adds a static imbalance of
    9.56 g × 65 mm = 621 g·mm. Because the bolt is near the top face, not the wheel's mid-plane,
    it also adds a small couple (dynamic imbalance), which is outside the scope of this analysis.
- **Runs:** 300, 450, 600 and 750 rpm, 3 trials each. Each run starts at rest, ramps at 37.5 rpm/s,
  holds, then stops. There is no tach or encoder, so speed comes from the ramp rate and the motor
  start time.
- **DAQ:** NI cDAQ under FlexLogger at 10 kHz (checked from the CSV timestamps). The radial sensors
  Rx1/Rx2/Ry1 are PCB 208C01/208C01/208C02 piezo (IEPE, AC-coupled) on an NI 9232. The axial
  sensors Az1–3 are TAS510 10 kg strain gauges on an NI 9237.
- **Data and script:** `P4P Shared/DAQ/P4P NI DAQ/11_10_26_tests/`, analysed with
  `analyze_rwa_campbell.m`. Output, including `summary.csv` and the figures, is in
  `analysis_output/`. The older `LogFile_2026-09-21*` and `LogFile_2026-10-09*` files are not used.

## Results

Static imbalance is U = F₁ₓ / ω², where F₁ₓ = √((Ax² + Ay²)/2) is the radial force amplitude at
the spin frequency. Values below are means of 3 trials:

| U (g·mm) | 300 rpm | 450 rpm | 600 rpm | 750 rpm |
|---|---|---|---|---|
| imbalanced_1A | 646 | 682 | 744 | 858 |
| balanced (residual) | 20.6 | 23.6 | 25.3 | 28.2 |

- **Repeatability:** the imbalanced trials agree within about 0.2% at every speed.
- **Spin frequency** matches the commanded speed to 0.01%, except at 600 rpm, which reads 601.6 rpm
  every time. The motor probably runs about 0.3% fast at that speed.
- **Fz and Mz at the spin frequency** are small: Fz is about 3% of the radial force. Mz is the
  dynamic part only, because the IEPE channels can't see a steady torque.

## Finding 1: the platform measures the bolt's imbalance correctly

Expected bolt imbalance = 9.56 g × 65 mm (hole pitch radius, from `flywheel_test.pdf`) =
**621 g·mm**.

Fitting U(f) = U₀ / (1 − (f/fₙ)²) to the imbalanced means gives **U₀ = 613 g·mm**, which is within
about 1.3% of the expected value. The fit residuals are all within 0.8%. The balanced residual of
about 20 g·mm (3% of the bolt) is within the uncertainty from how the residual and the bolt add as
vectors. The force calibration and the imbalance method therefore check out.

## Finding 2: a resonance near 24 Hz (~1420 rpm) amplifies the readings

U is not flat with speed. It rises by about 33% from 300 to 750 rpm, which a purely static
imbalance would not do. The single-resonance fit above matches well:

| Fit to | U₀ (g·mm) | fₙ |
|---|---|---|
| imbalanced, combined | 613 | 23.5 Hz (1410 rpm) |
| balanced, combined | 20.6 | 23.7 Hz (1424 rpm) |
| imbalanced, x only | 648 | 24.9 Hz |
| imbalanced, y only | 577 | 22.2 Hz |

- The balanced and imbalanced data give the same fₙ independently, which points to a real resonance
  rather than an artefact of the fit.
- **It is not in the FEA** ([[07_finite_element_analysis]]). The lowest platform modes there are
  334 and 397 Hz, which would add less than 0.2% at 12.5 Hz. The cause must be something softer
  outside the FEA model, such as the wheel shaft or motor mount (shaft whirl), or the base or bench
  the rig sits on.
- **It falls inside the planned measurement range** of 500–3000 rpm (8–50 Hz). Until it is moved or
  corrected for, imbalance readings above about 300 rpm are inflated. At 300 rpm the reading is
  about 5% high.

## Other observations

- **x and y disagree.** Even after removing the resonance, U₀ is 648 g·mm in x and 577 g·mm in y,
  about 12% apart. If the true value is 621 g·mm, Fx reads about 4% high and Fy about 7% low. Check
  the sensitivity of Ry1 (the 208C02, whose sensitivity was changed to 0.011241 V/N) and the
  spacing used for the Rx pair. The x and y resonance frequencies also differ (24.9 vs 22.2 Hz).
- **Campbell plots** (0–1000 Hz) are dominated by steep, high-order lines (orders in the low
  hundreds) that look the same balanced or imbalanced. They come from the motor or drive, possibly
  stepper step-rate harmonics. Horizontal bands at about 250–300 Hz (Fx/Fy) and 450–550 Hz look
  like structural modes and may be the FEA lateral modes coming out lower in the real rig. The 1×
  to 3× orders are crushed below 40 Hz in this view.
- **The axial-only moment divided by the radial force is about 0.10 m.** This first run had zr = 0,
  so the moments came from the axial sensors only. With zr = 150 mm now set, the rerun's Mx/Fy
  gives the height of the imbalance force above the axial plane: about 0.05 m or 0.25 m, depending
  on sign. Compare this with the real height of the **added bolt** (near the wheel's top face, not
  its mid-plane). An impossible value means a sensor sign is flipped.

## Open items

- Geometry now set in the script: zr = 150 mm, xRy = 0 (Ry1 is in the middle of the mounting
  plate), Rx spacing = 105 mm. Still to check: whether Rx1/Rx2 are centred on the spin axis, and
  the sign of the radial piezo sensors.
- Rerun the script with this geometry to get correct Mx/My.
- Rerun with `cfg.fMax = 100` and `cfg.campWinSec = 2` to see the 1× to 3× orders and any band
  near 24 Hz.
- Tap-test the wheel, shaft and platform to find the ~24 Hz mode, then stiffen it or correct for it.
- Find out where the high-order motor lines come from (motor type and step count).
