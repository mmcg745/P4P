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

Fitting U(f) = U₀ / (1 − (f/fₙ)²) to the imbalanced means gives **U₀ = 613 g·mm** (650 g·mm after the 14 Oct Ry1 sensor correction, see below), which is within
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

**Supported mass:** **~993 g** = 807.1 g (RWA with wiring and driver board) + 192.6 g (mounting
plate) − ~7 g (driver board, which is **not** on the platform).

| Part | Mass (g) | CoM height above base plate (mm) |
|---|---|---|
| mounting plate | 192.6 (weighed) | ~140 |
| stepper motor | ~240 (230–250) | ~125 (mounted at 145, body hangs below) |
| flywheel + 16 bolts | 258.9 (+9.56 for 1A) | 217.5 |
| shaft (8 × 105 mm, stainless steel) | ~42 (calculated) | ~210 |
| remainder (frame, rods, coupling, wiring) | ~259 (by difference, board excluded) | ~200 (guess) |
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
- **Lateral stiffness:** treating it as ~0.99 kg on a spring, k = m(2πfₙ)² gives about **24 kN/m in x
  (24.9 Hz) and 19 kN/m in y (22.2 Hz)**. With the steel brackets (38.8 / 47.9 Hz) it is about
  59 / 90 kN/m. The FEA's 334 Hz with 1 kg implies about 4.4 MN/m, so the
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

## Finding 5: steel brackets, washer imbalance to 1900 rpm (12–13 Oct)

Data: `12_10_26_tests/`, output in `analysis_output/`. Steel radial brackets fitted, Tic at 1/2 step,
37.5 rpm/s steps and 15 rpm/s sweeps. The washer is one M8 washer, **1.48 g**, under an existing
top bolt head at r = 65 mm, so expected **96.2 g·mm**. Every run started with the washer at
6 o'clock (−Y).

- **Tap tests:** the lowest modes are now **38.8 Hz** (Fx/My), **47.9 Hz** (Fy/Mx) and 41.4 Hz
  (Mz), up from 24.9/22.2 Hz with the PLA brackets. Tapping the top plate excites mainly
  39/47 Hz, so these modes involve large motion at the top of the RWA. Noise at the spin
  frequency is equivalent to only 0.02–0.2 g·mm. Fz has 50 Hz mains pickup.
- **Washer, mean of 2 trials** (trials agree within ~1.5%; values **with the Ry1 sensor
  correction**, see the next section; the uncorrected values were about 5% lower):

| rpm | 300 | 450 | 600 | 1000 | 1500 |
|---|---|---|---|---|---|
| U (g·mm) | 110.2 | 111.4 | 115.3 | 131.7 | 189.0 (sweep hold: 188.5) |

- **Resonance fit to the 1500 rpm sweeps:** **U₀ = 108.5 g·mm** (expected 96.2, +13%) and
  **fₙ = 39.0 Hz**. That's the same frequency as the tap-test x-mode (38.8 Hz), so two
  independent methods agree. The +13% is within what the residual imbalance (4–18 g·mm, see
  below) can add as a vector at an unknown angle (96.2 ± 18 → 78–114 g·mm). Uncorrected, it was
  103.2 g·mm (+7%) with fₙ = 38.8 Hz.
- **Approach to resonance:** the 2000 rpm run (full step, 75 rpm/s, cut at about 1860–1900 rpm)
  follows the model from the 1500 rpm sweeps: measured/model U = 130/133 at 1000 rpm, 184/184 at
  1500, and 310/319 at 1900 rpm. That's about 3× amplification at 1900 rpm (31.7 Hz).
  Figure: `analysis_output/approach_to_resonance_2000rpm.png` (regenerated 14 Oct with the
  correction).
- **The balanced residual is not stable between sessions:** about 20 g·mm (11 Oct), 37–41
  (12 Oct evening), 4–5 (13 Oct, 1000/1500 rpm steps at ~09:25) and 17–18 (13 Oct sweeps at
  ~10:10). Ramp tracking shows each session's value is roughly constant with speed, so the wheel or
  bolt assembly itself is shifting between sessions. The rig resolves changes of a few g·mm. The
  assembly's repeatability, not the sensor noise, limits the calibration.
- **Amplification with steel brackets:** about 1.02× at 300 rpm, 1.07× at 600, 1.21× at 1000 and
  1.74× at 1500 rpm (from the U₀ fit).
- **Operating issues:** a loud whine at ~750 rpm with the Tic T500 (also with the balanced wheel,
  so it's motor or drive, not structure); 750 rpm was skipped. Deceleration caused "VIN too low"
  cut-outs; the runs used de-energise and coast instead. Since 14 Oct, the step ramps in
  `imbalance_vs_speed_tracked.png` are drawn per run rather than averaged (averaging runs with
  different top speeds and sessions caused false jumps). The sweep curves are the cleanest.

## Sensor correction: Ry1 (208C02) reads ~11% low (applied 14 Oct)

- Rx1/Rx2 (208C01) were calibrated by a technician and are the reference. Ry1 (208C02) uses a
  non-professionally set sensitivity of 0.011241 V/N. The spec sheets give only nominal values
  (±15%), with no serial-specific certificate.
- **Evidence:** a rotating imbalance force must give |Fx| = |Fy| well below resonance. After
  removing the different x/y resonance amplification, Fx/Fy = **1.11** at 300–600 rpm in both the
  11 Oct runs (PLA brackets, bolt) and the 13 Oct runs (steel brackets, 1.48 g mass), with
  n = 15 and sd 0.02. Because it is the same on two different structures, it is the sensor, not
  the rig.
- **Applied** as `cfg.sensorScale = [1 1 1.11 1 1 1]` in `analyze_rwa_campbell.m`. Both test folders
  were re-analysed; Fx/Fy is now 0.97–1.03 for the imbalance runs at 300–600 rpm.
- **Independent check** (found by the report chat, 14 Oct): with the correction, the x and y
  moment/force heights (Mx/Fy, My/Fx) agree within 1 mm, at 0.218–0.236 m against ~0.23 m expected
  for the added mass at the wheel's top face. Without the correction they differed by several
  percent.
- **Effect:** U rises by about 5%. Bolt (11 Oct, PLA): **U₀ = 650 g·mm vs 621 expected (+4.6%)**,
  fₙ = 23.9 Hz (uncorrected 613, −1.3%). Known 1.48 g mass (13 Oct, steel): **U₀ = 108.5 vs 96.2
  (+13%)**, fₙ = 39.0 Hz (uncorrected 103.2, +7%). The bolt result is the cleaner calibration check
  because its residual is only ~3% of the bolt. It suggests absolute accuracy of about ±5%, set by
  the Rx calibration and the residual imbalance.

## Sensor sign conventions (14 Oct)

The axial TAS510 gauges read positive in tension. The radial PCB 208C piezos read positive in
**compression** (PCB convention, confirmed in FlexLogger 14 Oct). The script keeps
`cfg.sensorSign = +1` for all six, because the **net** signs of the mapping (sensor sign × stinger
direction × force-on-platform convention) are validated empirically:
1. The moment/force heights (0.22–0.25 m) match the added mass at the wheel top face (~0.23 m). A
   radial-vs-axial flip would give ~0.04 m.
2. The imbalance angle (−80°) matches a mass placed at −90°. An overall radial flip would give ~+90°.

Don't change the signs unless sensors or stingers are re-mounted, and then repeat both checks.

## Finding 6: the imbalance angle is recoverable without a tach (14 Oct)

- All 13 Oct known-mass runs started with the mass at 6 o'clock (−Y, −90°). The Tic stepper is
  open-loop, so the wheel angle follows from the start time and the constant ramp:
  θ(t) = π(α/60)(t − t₀)². The 1× force phasor (Fx + iFy) is demodulated against θ in 1 s windows
  at 150–450 rpm during the ramp.
- **The wheel spins clockwise in top view** (all runs).
- A start-time error δ adds ω·δ to the phase, i.e. a term proportional to rpm. Fitting phase
  against rpm and taking the **0 rpm intercept** removes it. The implied start-time errors are
  0.002–0.045 s.
- **Result (12 runs, 300–1500 rpm steps plus 2 sweeps): imbalance angle at start = −79.6° ± 9.7°
  (circular std), against −90° expected.** The ~10° offset is consistent with the residual
  imbalance (up to ±11° for 18 g·mm against 96 g·mm; e.g. a residual of 20 g·mm at +30° gives
  exactly −79° in a synthetic test) and with aligning the start position by eye.
- Script: `daq_analysis/phase_check.m` (snapshot of the scratch analysis). Since 14 Oct this is
  built into `analyze_rwa_campbell.m`: every run reports its start angle, and each added-mass
  condition has the reference (baseline) vector subtracted. Verified on synthetic data: the added
  mass was recovered at 96.3 g·mm, −90.0° and 96.2 g·mm, −0.1° (true 96.2 g·mm at −90° and 0°), with
  `cfg.phaseFnHz` set to the true fₙ. Note for future work:
  a once-per-rev tach would give the phase directly and allow vector subtraction of the residual
  imbalance.

## Finding 7: the aluminium mounting plate barely moves the lowest modes (15 Oct taps)

New aluminium mounting plate, **551.05 g** (weighed; PLA plate 192.6 g), so the supported mass is
~1351 g (plate + ~800 g RWA with wiring); the bolt ring is unchanged. Tap tests: 3 files per direction (X, Y, Z, TOP), radial peaks 0.3–2.8 N.

| Mode | PLA plate, steel brackets (12 Oct) | Al plate (15 Oct) | Shows in |
|---|---|---|---|
| Lowest X sway | 38.8 Hz | **39.5–40.0 Hz** | Fx, My, Mz |
| Lowest Y sway | 47.9 Hz | **48.5–48.7 Hz** | Fy, Mx |
| Twist | 41.4 Hz | 40.0–40.6 Hz (couples with X) | Mz |
| Rocking | 63–64 Hz | 62–63 Hz | Mx/My/Fz |
| Fy/Mx mode | ~91 Hz | ~84 Hz | Fy, Mx |
| Axial | ~128 Hz | **122.7 and 154.1 Hz** | Fz |
| Higher X | 166–171, 228, 292 Hz | 263.5, 317.5, 427.3 Hz | Fx, My, Mz |

- **The lowest modes rose only 2–3% even though the supported mass rose ~38%.** If those modes were
  the whole platform swaying on its supports, the extra mass alone would have dropped them ~15%
  (39 → ~33 Hz). Either the plate added stiffness that exactly offsets the mass, or, more likely,
  the 40/49 Hz modes are dominated by the **RWA's own frame** (threaded rods holding the top plate
  and wheel) swaying relative to the mounting plate. TAP_TOP again excites mainly 39.8/48.5 Hz.
  The next stiffening target is the RWA frame, not the mounting plate.
- **Noise:** with the motor off, the noise at the spin frequency is unchanged (0.03–0.2 g·mm
  equivalent). **With the motor energised (1/2 step, holding), the Rx sensors show ~0.115 N RMS,
  mostly a 325 Hz line** (12 Oct at 1/8 step: ~0.004 N). That's stepper/driver hum transmitted
  through the plate. It doesn't affect 1× results (1× noise is still 0.01–0.1 g·mm) but will show
  as a 325 Hz line in PSDs and Campbell plots. Mains 50/150/350 Hz is still on Fz.
- **Safe top speed:** 1800 rpm = 30 Hz → amplification ~2.3× in x and ~1.6× in y. With the 1.48 g
  mass plus residual (~115 g·mm), that's ~9.5 N on the Rx pair (~4.7 N each) and ~6.6 N on Ry1,
  below the ~12 N Ry1 survived in the 13 Oct ~1900 rpm run. **1800 rpm is OK** for baseline and
  washer, steps and sweeps.
- `cfg.phaseFnHz = 44` (effective x/y: 39.8/48.6 Hz) for the low-speed angle and vector analysis.

## Finding 8: static known-mass check of the axial channels (15 Oct)

Motor off, axial gauges re-tared, a **301.5 g** weight (W = 2.958 N) on the aluminium mounting
plate, analysed over an 8 s untouched window per file (`STATIC_*_T1.csv`):

| Placement (x, y) mm | Fz (exp. −2.958 N) | Moment (exp. 0.168 N·m) | Position implied by the moments (mm) |
|---|---|---|---|
| centre (0, 0), T1 | −2.933 | Mx −0.011, My +0.002 | (+0.6, +3.7) |
| centre (0, 0), **T2 (carefully centred)** | −2.938 | Mx +0.0008, My +0.0003 | **(+0.1, −0.3)** |
| (+56.9, 0) | −2.941 | My **+0.175** (1.04×) | (+59.6, +4.0) |
| (−56.9, 0) | −2.938 | My **−0.165** (0.98×) | (−56.2, −0.8) |
| (0, +56.9) | −2.926 | Mx **−0.178** (1.06×) | (+2.3, +60.9) |
| (0, −56.9) | −2.979 | Mx **+0.171** (1.02×) | (−0.9, −57.5) |

- **Axial force calibration: within −1.1% to +0.7%** of the known weight (compression reads
  negative, as expected for tension-positive gauges).
- **Moments: within −2% to +6%** (mean +2.5%), with correct signs (+x → +My, +y → −Mx) and
  cross-terms ≤ 0.012 N·m. This independently confirms the axial sensor geometry (R = 50 mm,
  240/0/120°), the axis orientation and the axial signs. The ± asymmetry suggests the weight
  centres were ~1–2 mm off the nominal points (the user noted the placement wasn't clean),
  consistent with the first centre test reading (+0.6, +3.7) mm. The carefully centred repeat (T2) reads
  (+0.1, −0.3) mm with the three sensors equal within 0.02 N (−0.986/−0.984/−0.968 N against −0.986
  expected each), so the position resolution is better than 1 mm.
- (The first analysis assumed 67.5 mm, which was a measuring slip; the actual offset was 56.87 mm.)

## Finding 9: aluminium-plate spin tests with known angles (15 Oct)

Data: `15_10_26_tests/`, output in `analysis_output/`. 1/2 step, 37.5 rpm/s steps and 15 rpm/s
sweeps to 1500 rpm (the Tic T500 cuts out at ~1600 rpm with "motor driver error"), every run
started from the same wheel mark. 1W = one 1.48 g washer (96.2 g·mm). 2W = two stacked washers
(192.4 g·mm). Ry1 ×1.11 applied.

**Low-speed imbalance vector from each ramp** (200–450 rpm, resonance-corrected with fₙ = 44 Hz
effective):

| Condition | U (g·mm), per run | Angle at start (°), per run |
|---|---|---|
| baseline (12 runs) | 14–26 | 1000/1500 rpm and sweeps: −3 to −40; 300/600 rpm: scattered |
| 1W at 6 o'clock (10 runs) | **114.9–118.2** | **−67 to −86** (steps −78 to −86) |
| 1W at 3 o'clock (3 runs) | 118.3–120.2 | **+6, +6, +11** |
| 2W at 6 o'clock (3 runs) | **199.3–199.9** | **−83 to −85** |
| baseline_end (3 runs) | 26.3–27.2 | −16 to −63 |

**Added imbalance after subtracting the wheel's own residual as a vector:**

| | Using the start baseline (13.6 g·mm, −18.5°) | Using the end baseline (26.7 g·mm, −57.5°) | Expected |
|---|---|---|---|
| 1W, 6 o'clock | 110.7 g·mm (+15%) at −85.6° | 92.5 (−4%) at −85.6° | 96.2 at −90° |
| 2W, 6 o'clock | 194.3 (+1%) at −87.2° | 176.1 (−8%) at −87.4° | 192.4 at −90° |
| 1W, 3 o'clock | 107.1 (+11%) at +10.9° | 110.6 (+15%) at +20.3° | 96.2 at 0° |

- **The angle is recovered within 3–5° at 6 o'clock** for both 1W and 2W, with either baseline.
  Moving the washer to 3 o'clock moves the measured angle by **~96°** (expected 90°; the 3 o'clock
  alignment was done by eye).
- **Size: within about ±15% for 96 g·mm and about ±8% for 192 g·mm.** The limit is the wheel's own
  residual, which **changed during the session**: 21 g·mm at about −20° before the washer was
  fitted, 27 g·mm at about −57° after it was removed. Fitting the washer means loosening and
  re-tightening a bolt, which shifts the residual by ~15 g·mm. That is the main uncertainty for
  small test masses. (Solving 1W and 2W together gives 84 g·mm per washer, with a 37 g·mm residual
  at −56°, close to the end baseline.)
- **Repeatability within a condition is excellent:** low-speed U agrees within 0.1–2% and angles
  within ±4° (steps).
- **Resonance from the spin data:** fₙ = 39.8–39.9 Hz (1W, 1W_90deg, 2W sweeps), matching the
  tap-test X-mode (39.5–40.0 Hz). Amplification at 1500 rpm is ~1.70 (1W: 200.7 hold vs 117.6 low
  speed), essentially the same as with the PLA plate. **The aluminium plate did not change the
  imbalance measurement**, consistent with Finding 7.
- Two 300 rpm baseline runs used the coarse start, because the 1× ridge fit is unreliable for a
  weak residual at low speed. `SWEEP_1500_imbalanced_2W_T1` stopped at ~1418 rpm, so the ramp is
  used up to there.

## Finding 10: dynamic torque measured directly (15 Oct)

`TORQUE_600_T1–T3`: no added mass, 0 → 600 rpm at **300 rpm/s** (Tic accel 200000 at 1/2 step,
α = 31.4 rad/s²), 2 s ramp. The motor's reaction torque on the platform is J·α; bearing
friction is internal to the rotor and stator, so it isn't transmitted. Mz = s/2 · (Rx1 − Rx2).
The AC-coupled piezos turn the torque step into a jump that decays. The model A·[h(t − ts) −
h(t − ts − 2 s)], with h = exp(−t/τ), was fitted to the 3 Hz low-passed Mz
(`daq_analysis/torque_step.py`).

| Run | Step A (N·m) | Decay τ (s) | Fit R² |
|---|---|---|---|
| T1 | 0.0344 | 1.5 | 0.995 |
| T2 | 0.0355 | 1.0 | 0.920 |
| T3 | 0.0346 | 1.5 | 0.999 |
| **Mean** | **0.0349 ± 0.0006** | | |

- **Expected J·α = 0.0324 N·m**, from an estimated J = 1.03×10⁻³ kg·m²: 16 bolts at 65 mm give
  6.5×10⁻⁴, the PLA wheel ~3.8×10⁻⁴, the rotor and coupling ~6×10⁻⁶. **The measurement is 8%
  higher**, within the ±15% uncertainty of the inertia estimate (PLA mass distribution). The
  implied J is 1.11×10⁻³ kg·m².
- **Inertia breakdown** (16 Oct, scaled from Inventor's `flywheel_test` mass properties). Inventor
  gives V = 233.47 cm³ and Iyy (spin) = 890.9 kg·mm², Ixx = Izz = 458.4 kg·mm² for solid ABS
  (1.06 g/cm³). The weighed 105.97 g wheel gives an effective density of 0.454 g/cm³, about 37% of
  solid PLA (1.24 g/cm³), which is consistent with 30–40% infill. Values are about the wheel centre:

  | Part | Iyy, spin (kg·mm²) | Ixx = Izz (kg·mm²) |
  |---|---|---|
  | PLA wheel (uniform density) | 381.5 | 196.3 |
  | 16 bolts as point masses, 16 × 9.56 g at r = 65 mm | 646.2 | 349 |
  | bolts' own inertia | ~2 | ~5 |
  | **wheel + bolts** | **≈ 1030** | **≈ 550** |

  - Moving bolts along the spin axis (8 from the top, 8 from the bottom) doesn't change Iyy.
  - The transverse terms use m(r²/2 + h²), with the bolt CoM at h ≈ 13 mm from the mid-plane
    (estimated; bolt length not recorded), so they are uncertain by ~±10 kg·mm². The 8 positions
    are symmetric about 0/90/180/270°, so Ixx = Izz. The mirrored top/bottom sets add no couple.
  - Mass check: 105.97 + 16 × 9.56 = 258.9 g, matching the weighed wheel plus bolts.
  - With the motor rotor (~6 kg·mm²): J ≈ 1.03×10⁻³ kg·m², J·α = 32.4 mN·m, so the measured
    value is +8%.
  - For uniform 30% / 40% infill, the wheel Iyy would be 313 / 417 kg·mm², and the measured
    value would be +15% / +3.5%.
  - Explaining the whole 8% from the wheel needs ~455 kg·mm², which means nearly all its mass in
    the rim (upper bound ~460). Printed walls push mass outward, so this covers part of the gap.
    Some of the rest is probably elsewhere, e.g. Mz scaling or the sensor spacing s.
- The rig measures **dynamic (changing) torque** with ~2% repeatability. Steady torque is not
  measurable with the AC-coupled piezos. The ~1–1.5 s decay is the coupling time constant (it
  should be checked against the NI 9232 spec).

## Finding 11: rigid case instead of the plastic RWA, which shows where the compliance is (15 Oct)

The plastic RWA (frame, motor and wheel) was replaced by a rigid case of the same footprint:
**526.73 g + 551.05 g aluminium plate = 1077.8 g supported** (RWA configuration ~1351 g). Taps
only, no spin (`15_10_26_rigid_case/`). `TAP_TOP` files contain 3 X taps then 3 Y taps at the top
of the case.

| Mode | Plastic RWA, 1351 g | Rigid case, 1078 g | Mass-only prediction (×1.12) | Stiffness k = m(2πf)² |
|---|---|---|---|---|
| X sway (Fx/My) | 39.8 Hz | **46.1–46.5 Hz** | 44.6 Hz | 84 → 91 kN/m (**+8%**) |
| Y sway (Fy/Mx) | 48.6 Hz | **72.8–73.4 Hz** | 54.4 Hz | 126 → 228 kN/m (**+81%**) |
| Twist (Mz) | 40.3 Hz | 42.9–44.3 Hz | | |
| Axial (Fz) | 123 / 154 Hz | 114 / 174 Hz | | |

- **Y was limited by the plastic RWA frame:** with the rigid case the Y stiffness nearly doubles.
- **X was not:** X barely changes beyond the mass effect. Even with one 0.8 mm wire, Y is now 2.5×
  stiffer than X (two wires), so the X compliance is not in the wires (~2.1 MN/m) but in the **Rx
  support**. The twist mode (43 Hz) sits next to X (46 Hz), consistent with that, because the Rx
  pair also resists twist.
- **Tightening the Rx bracket bolts** (`TAP_X4–6`, gentler and centred taps): the lowest X mode
  stays at **45.9–46.1 Hz**, while the higher X modes move 259 → 272 Hz, 317 → 323 Hz and
  435 → 437 Hz, and a 60 Hz mode (probably rocking) appears. So the bracket joints affect the higher
  modes but not the lowest one.
- **Mode shape check:** the case CoM is ~50 mm above the plate's top surface, so the supported CoM
  is ~164 mm above the base plate (plate at ~140 mm, case at ~190 mm). At the 46 Hz X mode,
  My/Fx = **0.164–0.167 m** (phase ≤ 2°) in `TAP_X4–6`, which is the CoM height. So the mode is a
  **rigid-body sway of the whole supported mass**: not rocking or bending of the case, and not a
  stinger mode. The compliance is below the stingers.
- **Most likely limiting element: the clear acrylic base plate** under the Rx bracket (user's
  assessment; consistent with all of the above). Not yet isolated by a direct test (e.g. clamping
  the base plate or tapping the bracket on its own).

**Future improvements (for the report):**
1. Replace the acrylic base plate with steel/aluminium, or bolt the brackets directly to the steel
   table or a rigid baseplate.
2. Stiffen the RWA mounting (the plastic frame halved the Y stiffness), or test a rigid commercial
   RWA housing.
3. **Raising fₙ without losing stinger decoupling.** Simply making the stingers thicker raises
   fₙ but increases bending stiffness, so each sensor picks up off-axis loads (worse decoupling).
   The axial-to-lateral stiffness ratio of a uniform stinger is (EA/L)/(12EI/L³) = (4/3)(L/d)²: it
   depends only on slenderness L/d, not on the material. Better routes, roughly in order of
   payoff:
   - **Fix the larger compliances first.** The measured lateral stiffness in X (~91 kN/m) is ~20×
     below the Rx wires' axial stiffness (~2.1 MN/m), so the stingers are not yet the limit. The
     acrylic base, bracket mounting and RWA frame are. Stiffening those has no decoupling cost.
   - **Higher-modulus stinger material** (same geometry, so same decoupling): steel ~200 GPa →
     molybdenum ~330 (1.65×), tungsten ~410 (2×), tungsten carbide ~600 GPa (3×, brittle).
   - **Flexure (notched) stingers:** a thick, stiff body with short thin necks near each end acting
     as hinges. High axial stiffness from the body, low bending and lateral stiffness from the necks.
     This is the standard design for force platforms and modal-test stingers.
   - **Scale L and d together:** at constant L/d, axial stiffness ∝ d and buckling load ∝ d², with
     unchanged decoupling, at the cost of a larger rig.
   - **Reduce the moving mass** (fₙ ∝ √(k/m)): the 551 g aluminium plate could be replaced by a
     ribbed or pocketed plate of similar stiffness but much lower mass.
   - **Pre-tension the wire stingers:** removes the compression-buckling risk (Ry1 was marginal,
     SF 0.84 pinned) and slack, so thin wires can be used safely.
   - **Stiffer end fittings** (collets or threaded ends instead of clamped bolt heads), since every
     joint adds series compliance.
   - **Axial load-cell stiffness:** the TAS510 strain-gauge cells are much softer than the PCB
     piezos (~1 GN/m) and limit the axial and rocking modes. Piezo or higher-capacity axial sensors
     would raise them.
   The design target stays fₙ > 500 Hz. With stiff supports, the current 0.8 mm × 95 mm wires
   alone would cap the lateral modes at ~160–220 Hz.
4. Repeat the tap tests after each change to track the X/Y modes and the twist mode (diagnostic
   method: lighter or rigid payload + tap, compare against the mass-only scaling).

## Predicted fₙ after stiffening (estimate, 16 Oct; report/poster-ready)

**Question:** what would the lowest lateral modes be if the acrylic base plate were removed or
replaced by a much stiffer (and heavier) base?

**Method:** a lumped single-mass, series-spring model per direction, with k = m(2πf)², using the
15 Oct tap tests (Findings 7 and 11). The support stiffness is backed out as
1/k_support = 1/k_measured − 1/k_wires.

| Direction | Element | Stiffness | Source |
|---|---|---|---|
| X | measured, rigid case (1.078 kg, 46.3 Hz) | 91 kN/m | Finding 11 |
| X | Rx wires, 2 × Ø0.8 × 95 mm steel, EA/L | 2.12 MN/m | E = 200 GPa |
| X | **support (acrylic base + bracket mounting)** | **~95 kN/m, the weak link** | difference |
| X | plastic RWA frame | ~1.2 MN/m | RWA (84.5 kN/m) vs rigid case (91 kN/m) |
| Y | measured, rigid case (73 Hz) | 228 kN/m | Finding 11 |
| Y | Ry wire, 1 × Ø0.8 × 95 mm | 1.06 MN/m | EA/L |
| Y | support | ~290 kN/m | difference |
| Y | **plastic RWA frame** | **~280 kN/m, the weak link** | RWA (126 kN/m) vs rigid case (228 kN/m) |

**Assumptions:**
- Replacing the acrylic leaves the steel brackets as the support. Their stiffness was not
  measured, so **0.5–1 MN/m** is assumed.
- The masses are 1.351 kg with the RWA and 1.078 kg with the rigid case.
- The modes are treated as uncoupled. In reality X couples with twist, and Y with Mx rocking.

**Predictions:**

| Setup | X sway | Y sway | Lowest mode | Amplification at 1500 rpm (25 Hz) |
|---|---|---|---|---|
| Now (acrylic, plastic RWA) | 39.8 Hz (measured) | 48.6 Hz (measured) | ~40 Hz | ×1.65 |
| Acrylic replaced, plastic RWA kept | ~90–120 Hz | **~64 Hz** (frame-limited) | **~60–65 Hz** | ×1.18 |
| Acrylic replaced + rigid RWA housing | ~100–125 Hz | up to ~160 Hz | **~100–125 Hz** | ×1.04–1.07 |
| Perfectly rigid supports (wires only) | ~200–220 Hz | ~160 Hz | ~160 Hz | ×1.02 |

**Takeaways:**
- Replacing the acrylic roughly doubles the X mode. Y then becomes the limit unless the RWA frame
  is also stiffened.
- With both fixed, the speed-dependent rise in measured U mostly disappears in the 0–1500 rpm
  range.
- Even with ideal supports, the current 0.8 mm wires cap the platform at ~160–220 Hz. Reaching
  the 250 Hz (poster) or 500 Hz (design) target therefore also needs stinger changes:
  higher-modulus or notched-flexure stingers, a lighter plate, or scaling L and d together.
- **Stiffness matters, not mass.** A heavier base doesn't hurt, and on the isolation table it acts
  as a better ground. The gain comes from the base not flexing under the brackets.

**Caveats:**
- These are estimates, not test results.
- The support figure lumps the acrylic and the bracket joints together. That the acrylic is the
  culprit is the user's assessment and has not been isolated yet.
- **Cheap check:** clamp or stiffen the base plate under the Rx bracket and re-tap, then compare
  with the 46 Hz X mode from the rigid case.

## Why the measured imbalance rises with speed (poster-ready explanation)

Terminology used on the poster: **"baseline wheel"** = the `balanced` condition (3D-printed
flywheel with a symmetric bolt ring, not precision-balanced, so it has a small residual
imbalance). **"Known / induced 1.48 g imbalance"** = the `imbalanced_1W` washer condition.

**The true static imbalance does not change with speed.** The *measured* U = F₁ₓ/ω² rises
because the sensors measure the force carried by the stingers, not the imbalance force itself,
and the structure they support can move.

- The imbalance produces a rotating force F₀ = U·ω² on the ~1 kg supported assembly (wheel,
  motor, frame, mounting plate). The stingers and brackets act as springs, so the assembly is a
  mass on a spring with a lateral natural frequency **fₙ = 38.8 Hz** (steel brackets).
- Well below fₙ the platform barely moves, and the stingers carry exactly F₀.
- As the spin frequency approaches fₙ, the assembly sways in phase with the rotating force. The
  stingers must also supply the force that accelerates this moving mass, so they carry more than
  F₀. The sensors read the force transmitted through the structure, not the imbalance force alone.
- Single-degree-of-freedom model (light damping):
  **U_measured = U_true / (1 − (f/fₙ)²)**

| Speed | f (Hz) | f/fₙ | Amplification 1/(1−(f/fₙ)²) |
|---|---|---|---|
| 300 rpm | 5.0 | 0.13 | 1.02 |
| 600 rpm | 10.0 | 0.26 | 1.07 |
| 1000 rpm | 16.7 | 0.43 | 1.23 |
| 1500 rpm | 25.0 | 0.64 | 1.71 |
| 1900 rpm | 31.7 | 0.82 | 3.0 |
| 2330 rpm | 38.8 | 1.00 | very large (limited only by damping) |

**Evidence that this is the cause, not a calibration or analysis error:**
1. The fₙ fitted from the spin data (39.0 Hz, 1500 rpm sweeps with the known 1.48 g mass) matches
   the platform's X-mode from the independent tap test (38.8 Hz).
2. The same model, fitted only up to 1500 rpm, predicts the separate 75 rpm/s ramp to ~1900 rpm:
   310 g·mm measured vs 319 predicted at 1900 rpm.
3. Softer supports gave a faster rise. With the original PLA brackets (fₙ ≈ 24 Hz), U rose about
   40% by 750 rpm; with steel brackets (38.8 Hz) the rise at 750 rpm is only about 12%.
4. With the resonance removed, U₀ = 108.5 g·mm against the expected 96.2 g·mm (+13%, within the
   wheel's residual imbalance of up to ~18 g·mm). At low speed, where amplification is ~2%, the raw
   reading is already 110 g·mm. These values use the Ry1 sensor correction (+11% on Fy).

**Implication for the device:** a force platform only reads true forces well below its first
natural frequency (rule of thumb: fₙ ≥ 3× the highest measurement frequency, hence the 500 Hz
design target in [[06_stinger_design_analysis]]). Two remedies:
- correct the readings, U_true = U_measured × (1 − (f/fₙ)²), which is what the U₀ fit does; or
- stiffen the structure so fₙ is far above the speed range. The tap tests point to the RWA's own
  frame (threaded rods holding the top plate) as the next soft part.

One-sentence poster version: *"The rise in measured imbalance with speed is not the wheel
changing; it is the test structure's 38.8 Hz lateral mode amplifying the transmitted force as
1/(1−(f/fₙ)²), which is confirmed independently by tap testing and corrected for in the
fitted U₀."*

## Open items

- Geometry is now complete in the script: zr = 140 mm (from the base plate), xRy = 0 (Ry1 is in the
  middle of the mounting plate), Rx spacing = 105 mm (Rx1/Rx2 centred 52.5 mm either side of the
  spin axis). Sensor signs are confirmed.
- Supported mass recorded: ~993 g, with the ~7 g driver board subtracted.
- Steel radial brackets fitted 12 Oct; results are in Finding 5. The next soft part appears to be
  the RWA frame (threaded rods and top plate).
- Find the soft spot: brace or clamp the PLA radial brackets and rerun 750 rpm. If U drops toward
  621 g·mm, the brackets are the cause. A phone accelerometer FFT (e.g. phyphox) while tapping the
  mounting plate sideways should show the ~22–25 Hz mode.
- Update the FEA with the real stinger lengths and the PLA brackets.
- Rerun with `cfg.fMax = 100` and `cfg.campWinSec = 2` to see the 1× to 3× orders and any band
  near 24 Hz.
- Tap-test the wheel, shaft and platform to find the ~24 Hz mode, then stiffen it or correct for it.
- Find out where the high-order motor lines come from (motor type and step count).
