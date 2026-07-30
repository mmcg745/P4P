# Literature Review — Torque Measurement

Part of [[00_project_overview]]. References in [[09_references]]. See also
[[01_literature_review_microvibrations]], [[02_literature_review_imbalance]].

## Direct and Indirect Torque Measurement Methods

Liu et al. (2019) — comprehensive review of contactless torque measurement, two fundamental
categories:

- **Tension-based methods**: derive torque from surface strain/stress on the rotating shaft
  (strain gauge bridges, magnetostrictive sensors, fibre Bragg grating sensors).
- **Twist-angle-based methods**: derive torque from relative angular displacement between two
  axially separated points (magnetic pulse wheel systems, optical encoder pairs, zebra tape
  optical method).

### Zappalá et al. (2018) — zebra tape torque measurement

- Two zebra tapes (striped reflective tape) on the rotating shaft, two stationary optical sensors
  detect phase shift between pulse trains.
- Torque derived from shaft twist angle using known torsional stiffness between measurement points.
- Two signal processing approaches compared: rising edge detection (±0.30% expanded uncertainty)
  vs. cross-correlation (±0.86%).
- No shaft-mounted electronics, no physical contact, validated under static and variable speed.
- Directly relevant as a non-intrusive, practical method applicable to RWA test configurations.

### Indirect approach used in this project: T = Iα

- Torque derived from angular acceleration measured by a tachometer, rather than transmission
  torque between two shaft locations — measures **net drive torque from the motor** during
  spin-up/deceleration.
- **Bosgra and Prins (1982)** used a closely related method: coupled the analyser time base
  directly to the tachometer signal ("order mode") to synchronise measurements with wheel speed
  during run-down tests. Their rundown/speed-reversal measurements quantified Coulomb friction,
  viscous friction, and stiction — the three friction torque components that must be understood
  to interpret T = Iα measurements accurately.

## Friction Torque and Measurement Challenges

- T = Iα requires accurately known rotor moment of inertia I, and proper accounting of friction
  torque.
- Bosgra and Prins (1982) friction model (6 European reaction wheels): stiction + Coulomb friction +
  speed-dependent viscous friction.
  - Ball-bearing wheels: viscous friction is a nonlinear function of wheel speed.
  - Magnetic-bearing wheels: near-zero Coulomb friction and stiction.
  - Zero-speed crossing (ball bearing wheels) is particularly complex — Coulomb friction changes by
    *twice* its value at the zero-speed crossing during a speed reversal. This region is the
    greatest challenge for tachometer-based torque measurement.
- DC motor commutation generates torque ripple at (motor pole pairs × wheel speed), superimposed
  on mean drive torque — increases with motor current (Bosgra and Prins, 1982). AC motor drives
  have no commutation switching → lower torque noise baseline.
- **Implication for this project:** motor type of the RWA under test affects interpretation of
  tachometer-based torque measurements; the device needs sufficient signal-processing capability to
  separate drive torque from commutation noise.

## Gap

Tachometer-based indirect torque measurement has not been found integrated into any existing RWA
characterisation platform, despite being a practically achievable approach that adds significant
diagnostic capability — one of the three gaps this project addresses.

## Current Implementation (Mid-Year Report)

- Spin-axis torque `Mz` is derived from the radial sensor equations (see [[05_mathematical_model]],
  eq. 4).
- Torque may alternatively be obtained from the motor controller via `T = Kt · I` — an independent
  verification channel.
