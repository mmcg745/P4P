# Literature Review — Satellite Microvibrations & RWA Disturbance Characterisation

Part of [[00_project_overview]]. References in [[09_references]].

## Satellite Microvibrations and the Role of RWAs

- Microvibrations: low-level mechanical disturbances, roughly a few Hz to 1 kHz, micro-g amplitudes
  (Zhang et al., 2014).
- Three principal RWA disturbance sources: **flywheel mass imbalance**, **bearing irregularities**,
  **motor torque ripple** (Smet et al., 2013).
- Flywheel imbalance is the dominant contributor — disturbance forces/torques at wheel spin frequency
  and harmonics, amplitude ∝ wheel speed squared (Masterson et al., 2002).
- Bosgra and Prins (1982) — earliest systematic studies (6 European reaction wheels); identified
  discrete spectral peaks from imbalance and bearing noise; framework still used 40+ years later.
- ADCS bandwidth is typically only 0.1–1 Hz, so disturbances above this pass straight through the
  spacecraft structure to the payload (De Munter et al., 2020).
- De Munter et al. (2020): a wheel at ~2100 rpm exciting a 30 Hz structural eigenmode caused 3
  arcsecond RMS pointing error; reducing rotor imbalance reduces this error proportionally.
- Smet et al. (2013): SSTL 300 S1 spacecraft (1m resolution camera) showed visible-image artifacts
  and MTF degradation attributed to RWA microvibrations between 50–250 Hz.
- Industrial qualification precedent: Rocket Lab requires static imbalance < 26 g·mm and dynamic
  imbalance < 800 g·mm² as mandatory flight specs (Wade et al., 2023) — concrete measurement
  targets for any RWA test device.

## The Empirical Disturbance Model (Masterson, Miller & Grogan, 2002)

Builds on Hubble Space Telescope work. RWA disturbances modelled as discrete harmonics, frequency
linear with wheel speed, amplitude ∝ wheel speed squared:

```
m(t) = Σ Ci · Ω² · sin(2π hi Ω t + αi),  i = 1..n
```

- `Ci` = amplitude coefficient of ith harmonic
- `Ω` = wheel speed
- `hi` = harmonic number (ratio of disturbance frequency to spin rate)
- `αi` = random phase

- Validated with a hard-mounted Kistler force/torque table, 4 three-axis load cells, 5 channels
  (Fx, Fy radial; Fz axial; Tx, Ty radial torques). This configuration (piezoelectric dynamometer +
  hard-mounted BCs) became the field standard and is directly applicable to this project.
- **Key finding:** harmonic numbers/amplitude coefficients are wheel-specific (bearing geometry,
  manufacturing tolerances, motor design) — no predefined model substitutes for direct measurement;
  each wheel must be individually characterised.
- Model underpredicts disturbances when harmonics coincide with RWA structural resonances — up to
  77% underprediction reported at affected speeds. Later work incorporated structural mode
  interactions to address this.

## Further Microvibration Signature Work

- **Hahn and Seiler (2011)**, ESA perspective: primary excitation sources = rotor imbalance, bearing
  mechanics, motor operation; secondary features from non-linear mixing of bearing harmonics with
  wheel speed harmonics. Rosetta RWA waterfall plots: structural resonances = horizontal features
  (independent of wheel speed); harmonic disturbances = diagonal ridges. Fundamental for interpreting
  any RWA measurement device output.

## Measurement Approaches and Boundary Conditions

- **Hard-mounted**: RWA rigid to platform, forces measured directly at interface.
- **Soft-mounted**: RWA suspended on compliant system (e.g. seismic mass + soft suspension), coupled
  dynamic response measured.
- **Zhang, Aglietti, Ren (2012)**: soft-suspension platform for cantilevered RWA, energy-method
  disturbance model; found nonlinearity and high damping peculiar to cantilevered configuration
  (vs. mid-span RWAs).
- **Zhang et al. (2014)**: extended to model broadband noise (often ignored) — omitting it
  significantly underestimates total disturbance; broadband noise found to be the *largest single
  contributor* to pointing degradation (consistent with De Munter et al., 2020).
- Test method matters: steady-state (cleaner spectral data per speed, but longer tests + speed
  stabilisation) vs. free-run-down (motor off, natural deceleration — better friction modelling,
  better rejection of imbalance noise, suited to RSS peak evaluation).
- **Smet et al. (2013)**: industrial application at SSTL — used Campbell/waterfall plots to
  characterise the 100SP-O reaction wheel and guide structural redesign, moving structural modes
  away from the sensitive 50–250 Hz band. Demonstrates direct measurement → characterisation →
  design-optimisation link.

## Gaps Identified (motivating this project)

1. No existing platform simultaneously measures microvibration forces, rotor imbalance, and
   actuation torque in one integrated device.
2. Dynamic imbalance measurement accuracy in existing research platforms is limited by speed
   control / phase measurement resolution issues (identified but unresolved).
3. Tachometer-based indirect torque measurement has not been integrated into any existing RWA
   characterisation platform, despite being practically achievable.

See [[02_literature_review_imbalance]] and [[03_literature_review_torque]] for the other two
literature review pillars.
