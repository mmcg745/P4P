# Mathematical Model (Mid-Year Technical Report, Section 2)

Part of [[00_project_overview]]. See also [[04_concept_design]], [[06_stinger_design_analysis]].

## Coordinate System and Sensor Geometry

- Right-handed coordinate system, origin at the axial sensor triangle centroid.
- Z-axis along the spin axis; X, Y in the sensor plane.
- Axial sensors (Az1, Az2, Az3) at circumradius R, 120° intervals.
- Radial sensors Rx1, Rx2 on one face, separated by `s`; Ry1 on the adjacent face at 90°; all at
  height `zr` above the axial plane.

## Force and Moment Derivation

From vertical equilibrium and moment equations about X and Y, the axial sensor readings give:

```
Fz = Az1 + Az2 + Az3
Mx = R (Az1 − (Az2 + Az3)/2)
My = (R√3/2)(Az3 − Az2)
```

In matrix form (geometry matrix A):

```
[Fz]   [ 1     1      1   ] [Az1]
[Mx] = [ R   -R/2   -R/2  ] [Az2]
[My]   [ 0  -R√3/2  R√3/2 ] [Az3]
```

Radial sensors give directly:

```
Fx = Rx1 + Rx2
Fy = Ry1
Mz = (Rx1 − Rx2) · s/2
```

→ The six sensors provide all six force/moment components {Fx, Fy, Fz, Mx, My, Mz} simultaneously.

## Static Imbalance

Static imbalance `Us` [g·mm] generates a centrifugal force rotating in the XY plane at spin
frequency Ω:

```
Fradial = Us · Ω²
```

An FFT of the radial sensor signals extracts the complex amplitude at Ω, isolating the imbalance
signal from bearing/motor harmonics:

```
Us = sqrt(F̂x² + F̂y²) / Ω²
φ  = arctan(F̂y / F̂x)     (heavy spot direction)
```

## Torque

Spin-axis torque `Mz` derived from the radial sensor equation above. Alternative/independent
verification channel: `T = Kt · I` from the motor controller (Kt = motor torque constant, I = motor
current).

## Dynamic Imbalance — Current Limitation

- Dynamic imbalance `Ud` [g·mm²] generates a rotating couple with **no net radial force** — requires
  measurements at **two axially separated planes** to resolve.
- The current **single-plane configuration cannot cleanly separate static and dynamic
  contributions** from the axial sensor moments Mx and My.
- Within the space industry, dynamic imbalance is generally of secondary concern relative to static
  imbalance (dominant disturbance forces scale with `Us · Ω²`).
- **Full dynamic imbalance measurement is identified as a future development requiring a second
  sensor plane** — see [[08_next_steps]].
