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
  `analysis_output_zr0/` (first run, zr = 0; reruns go to `analysis_output/`). The older `LogFile_2026-09-21*` and `LogFile_2026-10-09*` files are not used.

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

## Finding 3: the moments check out against the bolt height

Measured on the rig, from the base plate (the bottom of the axial sensors): the radial stingers are
at **zr = 140 mm** and the wheel's top face is at **230 mm**. The added bolt is screwed in from the
top, so its centre of mass is roughly at the top face.

For a point imbalance, the moment divided by the radial force is the height at which the force
acts. Combining the axial-only moment from the zr = 0 run with zr × F gives:

| rpm | Mx/Fy (m) | My/Fx (m) |
|---|---|---|
| 300 | 0.246 | 0.236 |
| 450 | 0.238 | 0.228 |
| 600 | 0.233 | 0.224 |
| 750 | 0.226 | 0.219 |

This is 0.22–0.25 m against about 0.23 m expected, so within about 7%. The other sign combination
would put the force about 0.04 m above the base plate, which is physically impossible. This
confirms the **radial piezo signs** are consistent with the axial gauges (tension positive), so
`cfg.sensorSign = +1` everywhere is correct. The ratio falls slightly with speed, possibly because
the ~24 Hz mode rocks the setup and adds inertial moments.

## Rig as built (photo: `P4P Shared/DAQ/Testing_rig.jpeg`)

- **Base:** a clear acrylic base plate on a steel table. Three TAS510 10 kg load cells sit on it
  (37 mm tall overall, Ø25.4 mm, M5 studs; drawing in `P4P Shared/DAQ/tas510_10kg.webp`). Long,
  thin wire stingers run up from them to a grey 3D-printed (PLA) mounting plate.
- **Radial stingers:** horizontal wires from the plate edge (zr = 140 mm) to 3D-printed (PLA)
  triangular brackets bolted to the base plate through slotted holes. The Rx pair shares one
  bracket.
- **RWA:** a 3D-printed frame on the mounting plate, with four long threaded rods up to a top plate.
  The stepper motor hangs below the mounting plate and drives the flywheel through a slotted
  flexible coupling and an 8 mm stainless shaft, 105 mm long.
- **The stingers in the rig are thinner and longer than the FEA's Ø2 × 50 mm**
  ([[07_finite_element_analysis]]), and the FEA treats the stinger ends as rigidly grounded. Here
  they're held by PLA brackets.

**Stingers:** all steel wire, 95 mm long bolt head to bolt head. Axial stingers are Ø1.2 mm and
radial stingers Ø0.8 mm. The design and FEA used Ø2 mm × 50 mm ([[06_stinger_design_analysis]]).

**Supported mass:** **~1.0 kg** = 807.1 g (RWA with wiring) + 192.6 g (mounting plate). The 807.1 g
weighing included the driver board, which is **not** on the platform, so the true moving mass is a
little lower. Subtract the board's mass when known.

| Part | Mass (g) | CoM height above base plate (mm) |
|---|---|---|
| mounting plate | 192.6 (weighed) | ~140 |
| stepper motor | ~240 (230–250) | ~125 (mounted at 145, body hangs below) |
| flywheel + 16 bolts | 258.9 (+9.56 for 1A) | 217.5 |
| shaft (8 × 105 mm, stainless steel) | ~42 (calculated) | ~210 |
| remainder (frame, rods, coupling, wiring, board) | ~266 (by difference) | ~200 (guess) |
| **total** | **~1000** | **~175** |

The heights are estimates and the CAD masses aren't realistic, so treat the ~175 mm centre of
mass as approximate.

## Finding 4: the whole platform resonates at ~24 Hz on very soft lateral supports

- **The whole assembly is moving, not just the wheel.** As the speed rises, the moment/force height
  falls from 0.24 to 0.22 m (Finding 3). A simple model gives the measured height as
  (h_bolt × F_imb + h_moving × F_inertial) / (F_imb + F_inertial), where F_inertial is the extra
  force from the resonance. Fitting it to the 300 and 750 rpm points gives h_bolt ≈ 0.245 m
  (the top face is 0.23 m) and h_moving ≈ **0.166 m**, close to the whole assembly's estimated
  centre of mass (~0.175 m). If only the wheel and shaft were whirling, h_moving would be about
  0.21 m. This is consistent evidence, not proof.
- **Lateral stiffness:** treating it as ~1.0 kg on a spring, k = m(2πfₙ)² gives about **25 kN/m in x
  (24.9 Hz) and 20 kN/m in y (22.2 Hz)**. The FEA's 334 Hz with 1 kg implies about 4.4 MN/m, so the
  real rig is roughly **180–225 times softer** than modelled.
- **The wire stingers are not the soft part.** Their axial stiffness is EA/L ≈ 1.06 MN/m for each
  radial stinger and 2.38 MN/m for each axial one. On their own, the radial wires would put the
  lateral mode at about 230 Hz (x, two wires) and 165 Hz (y, one wire). Nearly all the compliance
  must be in series with them: the **PLA radial brackets** and their slotted bolted joints to the
  acrylic base, and possibly the acrylic plate itself.
- **Fix in progress:** steel brackets. Once the brackets are stiff, the 0.8 mm × 95 mm radial wires
  become the limit at ~165–230 Hz, still below the 500 Hz target. Reaching it needs about
  10 MN/m per direction for 1 kg, which is roughly the design's Ø2 × 50 mm stingers (12.6 MN/m).
- **Correction:** with fₙ known, the transmitted force can be corrected using
  F_imb = F_meas × (1 − (f/fₙ)²), which is what the U₀ fit does.

## Stinger buckling margins (current rig, steel, E = 200 GPa)

Using Fcrit = π²EI/L², as in [[06_stinger_design_analysis]] (target SF > 5). The pinned case is the
design convention; fixed ends give 4× more.

| Stinger | Fcrit pinned / fixed | Worst compression seen (750 rpm, 1A) | SF pinned / fixed |
|---|---|---|---|
| radial Ø0.8 × 95 | 4.4 / 17.6 N | ~5.2 N (Ry1 carries all of Fy) | **0.84** / 3.4 |
| axial Ø1.2 × 95 | 22.3 / 89 N | ~9.3 N (3.3 N static + ~6 N from the moment) | 2.4 / 9.6 |

- Ry1 has no margin under the design convention. The clean, repeatable, linear data shows it didn't
  buckle, so the clamped bolt-head ends probably act closer to fixed. It is still below SF 5.
- **The force grows with speed².** With the 1A bolt, 1500 rpm would give about 4 times the 750 rpm
  force even before any resonance.
- **Do not run near ~1300–1600 rpm** with the PLA brackets: that crosses the ~24 Hz mode, where
  amplification could overload the radial wires.
- **Note on TAS510 accuracy:** the TAS510 rated combined error is ±0.3% of full scale, about
  ±0.29 N static. The Fz amplitudes at the spin frequency (0.02–0.19 N) are below that, so Fz at
  1× is near the limit of what these sensors can resolve.

## Open items

- Geometry is now complete in the script: zr = 140 mm (from the base plate), xRy = 0 (Ry1 is in the
  middle of the mounting plate), Rx spacing = 105 mm (Rx1/Rx2 centred 52.5 mm either side of the
  spin axis). Sensor signs are confirmed.
- Supported mass recorded (~1.0 kg). Still to get: the driver board's mass, to subtract it from
  the total.
- Steel radial brackets are being sourced (this is conceptual testing). Rerun the same speeds after
  fitting them and check that U flattens toward 621 g·mm.
- Find the soft spot: brace or clamp the PLA radial brackets and rerun 750 rpm. If U drops toward
  621 g·mm, the brackets are the cause. A phone accelerometer FFT (e.g. phyphox) while tapping the
  mounting plate sideways should show the ~22–25 Hz mode.
- Update the FEA with the real stinger lengths and the PLA brackets.
- Rerun with `cfg.fMax = 100` and `cfg.campWinSec = 2` to see the 1× to 3× orders and any band
  near 24 Hz.
- Tap-test the wheel, shaft and platform to find the ~24 Hz mode, then stiffen it or correct for it.
- Find out where the high-order motor lines come from (motor type and step count).
